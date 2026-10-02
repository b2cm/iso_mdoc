import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:cbor/cbor.dart';
import 'package:convert/convert.dart';
import 'package:pointycastle/export.dart' as pc;

import 'cose_objects.dart';
import 'crypto_generator.dart';
import 'mdoc_datastructure.dart';
import 'mdoc_request.dart';
import 'mdoc_response.dart';
import 'private_util.dart';

/// Search requested Data in [data]
Map<String, List<IssuerSignedItem>> getDataToReveal(
    ItemsRequest requestedData, IssuerSignedObject data) {
  if (MobileSecurityObject.fromCbor(data.issuerAuth.payload).docType !=
      requestedData.docType) {
    throw Exception('DocType does not match. No chance to find requested Data');
  }
  var toReveal = <String, List<IssuerSignedItem>>{};
  for (var nameSpace in requestedData.nameSpaces.keys) {
    var requestPerNameSpace = requestedData.nameSpaces[nameSpace];
    var dataPerNameSpace = data.items[nameSpace];
    if (dataPerNameSpace == null || dataPerNameSpace.isEmpty) {
      continue;
    }
    var valuesFound = <IssuerSignedItem>[];
    for (var property in requestPerNameSpace!.keys) {
      IssuerSignedItem? found;
      try {
        found = dataPerNameSpace
            .firstWhere((element) => element.dataElementIdentifier == property);
      } catch (_) {}

      if (found != null) {
        valuesFound.add(found);
      }
    }

    if (valuesFound.isNotEmpty) {
      toReveal[nameSpace] = valuesFound;
    }
  }
  return toReveal;
}

/// verify Mobile Security Object signed by an Issuer
///
/// This verifications includes checking the hashes of the data items,
/// but not the verification of the issuer certificate.
FutureOr<bool> verifyMso(IssuerSignedObject signed) {
  var mso = MobileSecurityObject.fromCbor(signed.issuerAuth.payload);
  pc.Digest hasher;
  var hashAlg = mso.digestAlgorithm;

  if (hashAlg.toLowerCase() == 'sha-256') {
    hasher = pc.SHA256Digest();
  } else if (hashAlg.toLowerCase() == 'sha-384') {
    hasher = pc.SHA384Digest();
  } else if (hashAlg.toLowerCase() == 'sha-512') {
    hasher = pc.SHA512Digest();
  } else {
    hasher = pc.SHA256Digest();
  }

  // Every disclosed item must have a digest committed by the signed MSO.
  for (var entry in signed.items.entries) {
    for (var item in entry.value) {
      var expectedHash = mso.valueDigest[entry.key]?[item.digestId];
      if (expectedHash == null) {
        return false;
      }
      var hash = hasher.process(
          Uint8List.fromList(cborEncode(item.toIssuerSignedItemBytes())));
      if (!listEquals(expectedHash, hash.toList())) {
        return false;
      }
    }
  }

  var issuerPublicKey = CoseKey.fromCertificate(
      base64Encode(signed.issuerAuth.unprotected.x509chain!.first));

  var verifier = SignatureGenerator.get(issuerPublicKey);

  return signed.issuerAuth.verify(verifier);
}

/// Build and sign mobile security object
///
/// Allowed Strings for [hashAlg] are:
/// - sha-256
/// - sha-384
/// - sha-512
/// Default is sha-256.
///
/// [deviceKey] is the public key of the holder.
/// If [validUntil] is null, the  validUntil Date is set to now + 1 year
Future<IssuerSignedObject> buildMso(
    SignatureGenerator signer,
    String issuerCert,
    Map<String, List<IssuerSignedItem>> inputData,
    String hashAlg,
    CoseKey deviceKey,
    String docType,
    {DateTime? validUntil}) async {
  pc.Digest hasher;

  if (hashAlg.toLowerCase() == 'sha-256') {
    hasher = pc.SHA256Digest();
  } else if (hashAlg.toLowerCase() == 'sha-384') {
    hasher = pc.SHA384Digest();
  } else if (hashAlg.toLowerCase() == 'sha-512') {
    hasher = pc.SHA512Digest();
  } else {
    hasher = pc.SHA256Digest();
  }

  Map<String, Map<int, List<int>>> valueDigest = inputData.map((key, value) =>
      MapEntry(
          key,
          value.asMap().map((key, value) => MapEntry(
              value.digestId,
              hasher
                  .process(Uint8List.fromList(
                      cborEncode(value.toIssuerSignedItemBytes())))
                  .toList()))));

  var mso = MobileSecurityObject(
      version: '1.0',
      digestAlgorithm: hashAlg,
      valueDigest: valueDigest,
      deviceKeyInfo: DeviceKeyInfo(deviceKey: deviceKey),
      docType: docType,
      validityInfo: ValidityInfo(
          signed: DateTime.now(),
          validFrom: DateTime.now(),
          validUntil: validUntil ?? DateTime.now().add(Duration(days: 356))));

  var msoBytes = mso.toMobileSecurityObjectBytes();

  var unprotected = CoseHeader(x509chain: [base64Decode(issuerCert)]);
  var protected = CoseHeader(algorithm: signer.supportedCoseAlgorithm);

  var cs = CoseSign1(
      protected: protected,
      unprotected: unprotected,
      payload: hex.decode(msoBytes));
  await cs.sign(signer);

  var issAuth = IssuerSignedObject(issuerAuth: cs, items: inputData);

  return issAuth;
}

/// Verify the data send by the holder.
///
/// Include verification of the contained issuer-signed data.
/// If [response] is secured with a MAC, [readerPrivateKey] must not be null.
Future<bool> verifyDeviceResponse(
    DeviceResponse response, SessionTranscript sessionTranscript,
    {CoseKey? readerPrivateKey}) async {
  bool valid = true;
  for (var document in response.documents!) {
    var msoValid = await verifyMso(document.issuerSigned);
    if (!msoValid) {
      throw Exception('Invalid Mobile Security Object (Issuer Signed)');
    }

    var mso =
        MobileSecurityObject.fromCbor(document.issuerSigned.issuerAuth.payload);
    var sDeviceKey = mso.deviceKeyInfo.deviceKey;

    var deviceMac = document.deviceSigned.deviceMac;
    var deviceAuth = DeviceAuth(
        sessionTranscript: sessionTranscript,
        docType: document.docType,
        nameSpaceBytes: document.deviceSigned.nameSpaceBytes);

    var encDevAuth = cborEncode(deviceAuth.toDeviceAuthBytes());
    if (deviceMac != null) {
      if (readerPrivateKey == null) {
        throw Exception('Reader-Private Key needed to verify Mac');
      }

      var keyAgreement =
          KeyAgreement.get(privateKey: readerPrivateKey, publicKey: sDeviceKey);
      var macSecret = await keyAgreement.generateSymmetricKey();

      var hkdf = pc.HKDFKeyDerivator(pc.SHA256Digest());
      hkdf.init(pc.HkdfParameters(
          Uint8List.fromList(macSecret),
          32,
          Uint8List.fromList(
              cborEncode(sessionTranscript.toSessionTranscriptBytes())),
          utf8.encode('EMacKey')));
      var macKey = hkdf.process(Uint8List.fromList([]));

      valid = deviceMac.verify(
          MacGenerator.get(deviceMac.protected.algorithm!, macKey),
          externalPayload: encDevAuth);
      if (!valid) {
        return false;
      }
    } else {
      valid = await document.deviceSigned.deviceSignature!.verify(
          SignatureGenerator.get(sDeviceKey),
          externalPayload: encDevAuth);
      if (!valid) {
        return false;
      }
    }
  }
  return valid;
}

/// Generate DeviceSigned Object
///
/// If [keyAgreement] is not null, a MAC is generated.
/// If [signer] is not null, a signature is generated
Future<DeviceSignedObject> generateDeviceSignature(
    Map<String, Map<String, dynamic>> revealedData,
    String docType,
    SessionTranscript transcript,
    {SignatureGenerator? signer,
    KeyAgreement? keyAgreement}) async {
  var signedData = DeviceSignedObject(nameSpaces: revealedData);
  var deviceAuth = DeviceAuth(
      sessionTranscript: transcript,
      docType: docType,
      nameSpaceBytes: signedData.nameSpaceBytes);

  var encDevAuth = cborEncode(deviceAuth.toDeviceAuthBytes());

  if (keyAgreement != null) {
    // we assume, we should generate Mac
    var macSecret = await keyAgreement.generateSymmetricKey();

    var hkdf = pc.HKDFKeyDerivator(pc.SHA256Digest());
    hkdf.init(pc.HkdfParameters(
        Uint8List.fromList(macSecret),
        32,
        Uint8List.fromList(cborEncode(transcript.toSessionTranscriptBytes())),
        utf8.encode('EMacKey')));
    var macKey = hkdf.process(Uint8List.fromList([]));

    var mac = CoseMac0(
      protected: CoseHeader(algorithm: CoseAlgorithm.hmac256),
      unprotected: CoseHeader(),
    );
    var macGenerator = MacGenerator.get(mac.protected.algorithm!, macKey);
    mac.generateMac(macGenerator, externalPayload: encDevAuth);

    signedData.deviceMac = mac;

    return signedData;
  } else if (signer != null) {
    var sig = CoseSign1(
        protected: CoseHeader(algorithm: signer.supportedCoseAlgorithm),
        unprotected: CoseHeader(),
        payload: null);
    await sig.sign(signer, externalPayload: encDevAuth);
    signedData.deviceSignature = sig;
    return signedData;
  } else {
    throw Exception(
        'signer and keyAgreement null. Cannot perform any operation');
  }
}

/// Verify signature of mdoc-reader
///
/// returns null, if no signature is included
/// Verification of reader-certificate is not included.
FutureOr<bool?> verifyDocRequestSignature(
    DocRequest docRequest, SessionTranscript sessionTranscript) {
  var readerAuth = ReaderAuth(
      sessionTranscript: sessionTranscript,
      itemsRequestBytes: docRequest.itemsRequest.toItemsRequestBytes());

  var enc = CborBytes(cborEncode(readerAuth.toReaderAuthBytes()));
  if (docRequest.readerAuthSignature == null) {
    return null;
  }

  var issuerPublicKey = CoseKey.fromCertificate(base64Encode(
      docRequest.readerAuthSignature!.unprotected.x509chain!.first));

  return docRequest.readerAuthSignature!
      .verify(SignatureGenerator.get(issuerPublicKey), externalPayload: enc);
}
