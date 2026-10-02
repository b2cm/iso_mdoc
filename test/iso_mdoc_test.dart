import 'dart:convert';
import 'dart:typed_data';

import 'package:cbor/cbor.dart';
import 'package:convert/convert.dart';
import 'package:iso_mdoc/iso_mdoc.dart';
import 'package:test/test.dart';

import '../example/example_keys.dart';
import 'data.dart';

void main() {
  group('private key to public', () {
    test('Ed25519', () {
      var private = CoseKey(
        kty: CoseKeyType.octetKeyPair,
        crv: CoseCurve.ed25519,
        d: hex.decode(
            '07B2B8AFCB7C61AE38C9533BAD63839EED59E9C1D966DE6AD8DF17A3EB056687'),
      );

      var public = private.toPublicKey();

      expect(public.x, readerKeyEd25519.x);
    });
    test('P256', () {
      var private = CoseKey(
        kty: CoseKeyType.ec2,
        crv: CoseCurve.p256,
        d: hex.decode(
            '7624CF7F053B0A6815090671F3483C6B62AA62AE94097B25C2434E743B359FB6'),
      );

      var public = private.toPublicKey();

      expect(public.x, readerKeyP256.x);
      expect(public.y, readerKeyP256.y);
    });

    test('P384', () {
      var private = CoseKey(
        kty: CoseKeyType.ec2,
        crv: CoseCurve.p384,
        d: hex.decode(
            'FDCED5B41882E12B7B232D07B771F169409F3598E24DA8754F0E772E23897DE171AF1A65215B95C63323164F670506A5'),
      );

      var public = private.toPublicKey();

      expect(public.x, readerKeyP384.x);
      expect(public.y, readerKeyP384.y);
    });

    test('P521', () {
      var private = CoseKey(
        kty: CoseKeyType.ec2,
        crv: CoseCurve.p521,
        d: hex.decode(
            '012BA816A9E245373E22006D96C49313C67382F118220C2D0E7CF112DF4956E3B59991FD5D749FC1D223180AF0488040A2E16BD62A9EF84FD7DB4C2E9FF41AA46CF6'),
      );

      var public = private.toPublicKey();

      expect(public.x, readerKeyP521.x);
      expect(public.y, readerKeyP521.y);
    });

    test('brainpoolp256r1', () {
      var private = CoseKey(
        kty: CoseKeyType.ec2,
        crv: CoseCurve.brainpoolP256r1,
        d: hex.decode(
            '9B231A0FB0AB80348620053B2E1057A084D1FEFF1DFF781D5F3B8B4B6F7D524D'),
      );

      var public = private.toPublicKey();

      expect(public.x, readerKeyBrainpoolP256r1.x);
      expect(public.y, readerKeyBrainpoolP256r1.y);
    });

    test('brainpoolP320r1', () {
      var private = CoseKey(
        kty: CoseKeyType.ec2,
        crv: CoseCurve.brainpoolP320r1,
        d: hex.decode(
            '02AE26E0DDB46EE4300E6DFF3460B55855DAAC5B42C094B05811407B27F0226A621764F2FA14F12A'),
      );

      var public = private.toPublicKey();

      expect(public.x, readerKeyBrainpoolP320r1.x);
      expect(public.y, readerKeyBrainpoolP320r1.y);
    });

    test('brainpoolP384r1', () {
      var private = CoseKey(
        kty: CoseKeyType.ec2,
        crv: CoseCurve.brainpoolP384r1,
        d: hex.decode(
            '71A2F5562562963C96E7998BD9EF60FE5F270E86C88C1B19BCCEE484C71A31CECBD845860D8851A5654BE88A84DAF3E6'),
      );

      var public = private.toPublicKey();

      expect(public.x, readerKeyBrainpoolP384r1.x);
      expect(public.y, readerKeyBrainpoolP384r1.y);
    });

    test('brainpoolP512r1', () {
      var private = CoseKey(
        kty: CoseKeyType.ec2,
        crv: CoseCurve.brainpoolP512r1,
        d: hex.decode(
            '59697464B7F8D1B8CF43A7FA60C9D48FF441C4999E20700DA78087BFA73ABDE2BAD227FDEC3BE5848034C11D40B601EA80A181AD3936DBA248EFB9949787EA94'),
      );

      var public = private.toPublicKey();

      expect(public.x, readerKeyBrainpoolP512r1.x);
      expect(public.y, readerKeyBrainpoolP512r1.y);
    });
  });
  test('generate SessionTranscript', () {
    var stb = cborDecode(hex.decode(sessionTranscriptBytes)) as CborBytes;
    var stbEnc = cborDecode(stb.bytes) as CborList;
    var devEng = DeviceEngagement.fromCbor((stbEnc.first as CborBytes).bytes);
    var se = SessionEstablishment.fromCbor(sessionEsrablishment);

    var st = SessionTranscript(
        deviceEngagementBytes: devEng.toDeviceEngagementBytes(),
        keyBytes: se.eReaderKey.toCoseKeyBytes(),
        handover: NFCHandover(
            handoverSelectMessage: hex.decode(handoverSelect),
            handoverRequestMessage: hex.decode(handoverRequest)));

    var gen = hex
        .encode(Uint8List.fromList(cborEncode(st.toSessionTranscriptBytes())));
    expect(gen.toLowerCase(), sessionTranscriptBytes);
  });

  test('parse Session transcript', () {
    var st = SessionTranscript.fromCbor(oid4vpSessionTranscript);
    print(st);

    var handover = Handover.fromCbor(oid4vpHandover);
    print(handover);
  });

  test('encrypt/Decrypt with example Data', () async {
    var deviceEncryptor = SessionEncryptor(
        mdocRole: MdocRole.mdocHolder,
        myPrivateKey: device,
        otherPublicKey: reader);
    await deviceEncryptor.generateKeys(hex.decode(sessionTranscriptBytes));
    expect(deviceEncryptor.decryptionKey, isNotNull);
    expect(deviceEncryptor.encryptionKey, isNotNull);

    var readerEncryptor = SessionEncryptor(
        mdocRole: MdocRole.mdocReader,
        myPrivateKey: reader,
        otherPublicKey: device);
    await readerEncryptor.generateKeys(hex.decode(sessionTranscriptBytes));
    expect(readerEncryptor.decryptionKey, isNotNull);
    expect(readerEncryptor.encryptionKey, isNotNull);

    var dataToEncrypt = hex.decode(mdocRequestHex);

    var selfEncryptedRequest = await readerEncryptor.encrypt(dataToEncrypt);
    var cleartext = await deviceEncryptor.decrypt(selfEncryptedRequest);
    expect(dataToEncrypt, cleartext);

    var request = DeviceRequest.fromCbor(cleartext);
    expect(
        verifyDocRequestSignature(request.docRequests.first,
            SessionTranscript.fromCbor(sessionTranscriptBytes)),
        isTrue);

    var selfEncryptedResponse =
        await deviceEncryptor.encrypt(hex.decode(response));
    var data = SessionData.fromCbor(hex.decode(sessionData));
    expect(selfEncryptedResponse, data.encryptedData);

    var cleartext2 = await readerEncryptor.decrypt(data.encryptedData!);

    expect(
        await verifyDeviceResponse(DeviceResponse.fromCbor(cleartext2),
            SessionTranscript.fromCbor(sessionTranscriptBytes),
            readerPrivateKey: reader),
        isTrue);
  });
  test('mobile drivers license class', () async {
    var mdl = MobileDriversLicense(
        expiryDate: FullDate(2015, 12, 31),
        issueDate: FullDate.fromDateTime(DateTime.now()),
        weight: 80,
        unDistinguishingSign: 'abhufwjbf',
        signatureUsualMark: Uint8List.fromList([34, 78, 67]),
        sex: 1,
        residentState: 'DE',
        residentPostalCode: '09648',
        residentCountry: 'Germany',
        residentCity: 'Mittweida',
        residentAddress: 'Am Markt 1',
        portraitCaptureDate: DateTime(2024, 2, 4),
        portrait: Uint8List.fromList([89, 90, 78]),
        nationality: 'DE',
        issuingJurisdiction: 'Saxony',
        issuingCountry: 'Germany',
        issuingAuthority: 'Mittweida',
        height: 180,
        hairColour: HairColour.blond,
        givenNameNationalCharacter: 'Max',
        familyNameNationalCharacter: 'Mustermann',
        eyeColour: EyeColour.dichromatic,
        drivingPrivileges: [
          DrivingPrivilege(
              vehicleCategoryCode: 'B',
              issueDate: FullDate(2017, 4, 13),
              codes: [DrivingPrivilegeCode(code: '32')])
        ],
        documentNumber: 'abcdef',
        birthPlace: 'Berlin',
        birthDate: FullDate(1997, 5, 24),
        ageBirthYear: 1997,
        ageInYears: 27,
        administrativeNumber: 'ghbg',
        givenName: 'Max',
        familyName: 'Mustermann');

    mdl.generateAgeOverNN([16, 18, 21, 65, 67]);

    expect(mdl.ageOverNN, {16: true, 18: true, 21: true, 65: false, 67: false});

    var asItems = mdl.generateIssuerSignedItems();

    var fromItems = MobileDriversLicense.fromIssuerSignedItems(asItems);

    expect(asItems.keys, [MobileDriversLicense.namespace]);
    expect(mdl.givenName, fromItems.givenName);
    expect(mdl.signatureUsualMark, fromItems.signatureUsualMark);
    expect(fromItems.ageOverNN,
        {16: true, 18: true, 21: true, 65: false, 67: false});

    var signed = await mdl.generateIssuerSignedObject(
        SignatureGenerator.get(issuerP521Key),
        issuerP521Cert,
        CoseKey.generate(CoseCurve.p256));

    var encoded = signed.toEncodedCbor();
    var decoded = IssuerSignedObject.fromCbor(encoded);
    var mso = MobileSecurityObject.fromCbor(decoded.issuerAuth.payload);

    expect(mso.docType, MobileDriversLicense.docType);

    var fromItems2 = MobileDriversLicense.fromIssuerSignedItems(decoded.items);
    expect(mdl.givenName, fromItems2.givenName);
    expect(mdl.signatureUsualMark, fromItems2.signatureUsualMark);
    expect(fromItems2.ageOverNN,
        {16: true, 18: true, 21: true, 65: false, 67: false});
  });

  test('eu pid class', () async {
    var pid = EuPiData(
        familyName: 'Mustermann',
        issuingJurisdiction: 'Mittweida',
        administrativeNumber: 'abcdefg1234',
        documentNumber: 'xyz9876',
        issuingCountry: 'DE',
        issuingAuthority: 'Stadtverwaltung Mittweida',
        expiryDate: FullDate(2025, 7, 9),
        issuanceDate: FullDate(2024, 4, 18),
        nationality: 'DE',
        residentHouseNumber: '32',
        residentStreet: 'Hauptstraße',
        residentPostalCode: '09648',
        residentCity: 'Mittweida',
        residentState: 'Sachsen',
        residentCountry: 'DE',
        residentAddress: 'Hauptstraße 32, 09648 Mittweida',
        birthCity: 'Mittweida',
        birthCountry: 'DE',
        birthState: 'Sachsen',
        birthPlace: 'Mittweida',
        givenNameBirth: 'Max',
        familyNameBirth: 'Mustermann',
        gender: 1,
        ageBirthYear: 1997,
        ageInYears: 27,
        ageOver18: true,
        birthDate: FullDate(1997, 3, 18),
        givenName: 'Max');

    pid.generateAgeOverNN([16, 18, 21, 65, 67]);

    expect(pid.ageOverNN, {16: true, 21: true, 65: false, 67: false});
    expect(pid.ageOverNN!.length, 4);

    var asItems = pid.generateIssuerSignedItems();

    var fromItems = EuPiData.fromIssuerSignedItems(asItems);

    expect(asItems.keys, [EuPiData.namespace]);
    expect(pid.givenName, fromItems.givenName);
    expect(pid.issuingAuthority, fromItems.issuingAuthority);
    expect(fromItems.ageOverNN, {16: true, 21: true, 65: false, 67: false});

    var signed = await pid.generateIssuerSignedObject(
        SignatureGenerator.get(issuerP521Key),
        issuerP521Cert,
        CoseKey.generate(CoseCurve.p256));

    var encoded = signed.toEncodedCbor();
    var decoded = IssuerSignedObject.fromCbor(encoded);
    var mso = MobileSecurityObject.fromCbor(decoded.issuerAuth.payload);

    expect(mso.docType, EuPiData.docType);

    var fromItems2 = EuPiData.fromIssuerSignedItems(decoded.items);
    expect(pid.givenName, fromItems2.givenName);
    expect(fromItems2.ageOverNN, {16: true, 21: true, 65: false, 67: false});
  });

  test('verify given mso', () {
    var decoded = hex.decode(response);
    var asMap = cbor.decode(decoded);

    var doc = (((asMap as CborMap)[CborValue('documents')] as CborList).first
        as CborMap)[CborValue('issuerSigned')];
    var iss = IssuerSignedObject.fromCbor(doc);

    var mdl = MobileDriversLicense.fromIssuerSignedItems(iss.items);
    print(mdl);

    expect(verifyMso(iss), isTrue);
  });

  group('verifyMso digest binding', () {
    IssuerSignedObject signedFromResponse() {
      var parsed = DeviceResponse.fromCbor(hex.decode(response));
      return parsed.documents!.first.issuerSigned;
    }

    test('rejects an altered disclosed value', () {
      var signed = signedFromResponse();
      var namespace = signed.items.keys.first;
      var original = signed.items[namespace]!.first;
      signed.items[namespace]![0] = IssuerSignedItem(
        digestId: original.digestId,
        random: original.random,
        dataElementIdentifier: original.dataElementIdentifier,
        dataElementValue: 'forged value',
      );

      var received = IssuerSignedObject.fromCbor(signed.toEncodedCbor());
      expect(verifyMso(received), isFalse);
    });

    test('rejects a disclosed item with an uncommitted digest ID', () {
      var signed = signedFromResponse();
      var namespace = signed.items.keys.first;
      var original = signed.items[namespace]!.first;
      var mso = MobileSecurityObject.fromCbor(signed.issuerAuth.payload);
      var unusedDigestId = 0;
      while (mso.valueDigest[namespace]!.containsKey(unusedDigestId)) {
        unusedDigestId++;
      }
      signed.items[namespace]![0] = IssuerSignedItem(
        digestId: unusedDigestId,
        random: original.random,
        dataElementIdentifier: original.dataElementIdentifier,
        dataElementValue: 'forged value',
      );

      var received = IssuerSignedObject.fromCbor(signed.toEncodedCbor());
      expect(verifyMso(received), isFalse);
    });

    test('rejects a disclosed item in an uncommitted namespace', () {
      var signed = signedFromResponse();
      var original = signed.items.values.first.first;
      signed.items['uncommitted.namespace'] = [
        IssuerSignedItem(
          digestId: original.digestId,
          random: original.random,
          dataElementIdentifier: original.dataElementIdentifier,
          dataElementValue: 'forged value',
        ),
      ];

      var received = IssuerSignedObject.fromCbor(signed.toEncodedCbor());
      expect(verifyMso(received), isFalse);
    });
  });

  test('issuance all certs', () async {
    var certs = [
      readerCertEd25519,
      readerCertP256,
      readerCertP384,
      readerCertP521,
      readerCertBrainpoolP256r1,
      readerCertBrainpoolP320r1,
      readerCertBrainpollP384r1,
      readerCertBrainpoolP512r1
    ];
    var keys = <CoseKey>[
      readerKeyEd25519,
      readerKeyP256,
      readerKeyP384,
      readerKeyP521,
      readerKeyBrainpoolP256r1,
      readerKeyBrainpoolP320r1,
      readerKeyBrainpoolP384r1,
      readerKeyBrainpoolP512r1
    ];

    for (int i = 0; i < certs.length; i++) {
      var givenName = IssuerSignedItem(
          digestId: 1,
          dataElementIdentifier: 'given_name',
          dataElementValue: 'Max');
      var familyName = IssuerSignedItem(
          digestId: 2,
          dataElementIdentifier: 'family_name',
          dataElementValue: 'Mustermann');
      var birthDate = IssuerSignedItem(
          digestId: 3,
          dataElementIdentifier: 'birth_date',
          dataElementValue: DateTime(1992, 3, 15).toUtc());
      var issueDate = IssuerSignedItem(
          digestId: 4,
          dataElementIdentifier: 'issue_date',
          dataElementValue: DateTime.now().toUtc());
      var expiryDate = IssuerSignedItem(
          digestId: 5,
          dataElementIdentifier: 'expiry_date',
          dataElementValue: DateTime.now().add(Duration(days: 365)).toUtc());

      var holderKey = CoseKey.generate(CoseCurve.p384);

      var sig = await buildMso(
          SignatureGenerator.get(keys[i]),
          certs[i],
          {
            'org.iso.18013.5.1': [
              givenName,
              familyName,
              birthDate,
              issueDate,
              expiryDate
            ]
          },
          'SHA-256',
          holderKey.toPublicKey(),
          'docType');

      expect(verifyMso(sig), isTrue);
    }
  });

  test('whole Process with signature, fixed Holder curve', () async {
    var curves = [
      CoseCurve.p256,
      CoseCurve.p384,
      CoseCurve.p521,
      CoseCurve.brainpoolP256r1,
      CoseCurve.brainpoolP320r1,
      CoseCurve.brainpoolP384r1,
      CoseCurve.brainpoolP512r1
    ];

    for (var c in curves) {
      await _runPresentationProcess(c, CoseCurve.p256, false);
    }
  });

  test('whole Process with signature, varying Holder curve', () async {
    var curves = [
      CoseCurve.p256,
      CoseCurve.p384,
      CoseCurve.p521,
      CoseCurve.ed25519,
      CoseCurve.brainpoolP256r1,
      CoseCurve.brainpoolP384r1,
      CoseCurve.brainpoolP320r1,
      CoseCurve.brainpoolP512r1
    ];

    for (var c in curves) {
      await _runPresentationProcess(CoseCurve.p256, c, false);
    }
  });

  test('whole Process with mac', () async {
    var curves = [
      CoseCurve.p256,
      CoseCurve.p384,
      CoseCurve.p521,
      CoseCurve.x25519,
      CoseCurve.brainpoolP256r1,
      CoseCurve.brainpoolP320r1,
      CoseCurve.brainpoolP384r1,
      CoseCurve.brainpoolP512r1
    ];

    for (var c in curves) {
      await _runPresentationProcess(c, c, true);
    }
  });
}

_runPresentationProcess(
    int curveEphemeral, int curveHolder, bool useMac) async {
  // ----- MDoc-Holder -------
  // Generate Ephemeral Key. Feel free to experiment with the used curve
  var deviceEphemeralCosePriv = CoseKey.generate(curveEphemeral);
  var deviceEphemeralCosePub = deviceEphemeralCosePriv.toPublicKey();

  // Generate DeviceEngagement
  var bleEngagement = DeviceEngagement(
      security: Security(
          deviceKeyBytes: deviceEphemeralCosePub.toCoseKeyBytes().bytes),
      deviceRetrievalMethods: [
        DeviceRetrievalMethod(
            type: 2,
            options: BLEOptions(
                supportPeripheralServerMode: false,
                supportCentralClientMode: true,
                centralClientModeId: [1, 4, 8, 0]))
      ]);

  // Encode for Qr-Code
  var qrData = bleEngagement.toUri();

  // ----- MDOC - Reader ------

  // decode Engagement
  var decodedEngagement = DeviceEngagement.fromUri(qrData);

  // check used Curve and generate Ephemeral Key
  var readerEphemeralCosePriv =
      CoseKey.generate(decodedEngagement.security.deviceKey!.crv!);
  var readerEphemeralCosePub = readerEphemeralCosePriv.toPublicKey();

  // Generate SessionTranscript
  var transcript = SessionTranscript(
      deviceEngagementBytes: decodedEngagement.toDeviceEngagementBytes(),
      keyBytes: readerEphemeralCosePub.toCoseKeyBytes());

  // Generate ItemsRequest
  var items = ItemsRequest(docType: 'docType', nameSpaces: {
    'org.iso.18013.5.1': {'family_name': true}
  });

  // Generate Reader-Auth. Feel free to also use the other provided certificates
  var unprotected = CoseHeader(x509chain: [base64Decode(readerCertEd25519)]);
  var protected = CoseHeader(algorithm: CoseAlgorithm.edDSA);

  var cs = CoseSign1(
    protected: protected,
    unprotected: unprotected,
    payload: null,
  );

  var readerAuth = ReaderAuth(
      sessionTranscript: transcript,
      itemsRequestBytes: items.toItemsRequestBytes());

  var enc = CborBytes(cborEncode(readerAuth.toReaderAuthBytes()));
  // If you try other certificates, change the used key according to used certificate
  cs.sign(SignatureGenerator.get(readerKeyEd25519), externalPayload: enc);

  // Generate Request
  var request = DeviceRequest(
      docRequests: [DocRequest(itemsRequest: items, readerAuthSignature: cs)]);

  // Encrypt Request
  var readerEncryptor = SessionEncryptor(
      mdocRole: MdocRole.mdocReader,
      myPrivateKey: readerEphemeralCosePriv,
      otherPublicKey: decodedEngagement.security.deviceKey!);
  await readerEncryptor
      .generateKeys(cborEncode(transcript.toSessionTranscriptBytes()));
  var requestCipher = await readerEncryptor.encrypt(request.toEncodedCbor());

  // Generate SessionEstablishment
  var establishment = SessionEstablishment(
      eReaderKey: readerEphemeralCosePub, encryptedRequest: requestCipher);
  var encodedEstablishment = establishment.toCbor();

  // ---- MDoc - Holder

  // Decrypt Request
  var decodedEstablishment =
      SessionEstablishment.fromCbor(encodedEstablishment);
  var transcriptHolder = SessionTranscript(
      deviceEngagementBytes: bleEngagement.toDeviceEngagementBytes(),
      keyBytes: decodedEstablishment.eReaderKey.toCoseKeyBytes());
  var holderEncryptor = SessionEncryptor(
      mdocRole: MdocRole.mdocHolder,
      myPrivateKey: deviceEphemeralCosePriv,
      otherPublicKey: decodedEstablishment.eReaderKey);
  await holderEncryptor
      .generateKeys(cborEncode(transcriptHolder.toSessionTranscriptBytes()));

  var decryptedRequest =
      await holderEncryptor.decrypt(decodedEstablishment.encryptedRequest);
  var decodedRequest = DeviceRequest.fromCbor(decryptedRequest);

  // Check Signature
  expect(
      verifyDocRequestSignature(
          decodedRequest.docRequests.first, transcriptHolder),
      isTrue);

  // Search Credential (or generate ;) )
  var givenName = IssuerSignedItem(
      digestId: 1,
      dataElementIdentifier: 'given_name',
      dataElementValue: 'Max');
  var familyName = IssuerSignedItem(
      digestId: 2,
      dataElementIdentifier: 'family_name',
      dataElementValue: 'Mustermann');
  var birthDate = IssuerSignedItem(
      digestId: 3,
      dataElementIdentifier: 'birth_date',
      dataElementValue: DateTime(1992, 3, 15).toUtc());
  var issueDate = IssuerSignedItem(
      digestId: 4,
      dataElementIdentifier: 'issue_date',
      dataElementValue: DateTime.now().toUtc());
  var expiryDate = IssuerSignedItem(
      digestId: 5,
      dataElementIdentifier: 'expiry_date',
      dataElementValue: DateTime.now().add(Duration(days: 365)).toUtc());

  var holderKey = CoseKey.generate(curveHolder);

  var sig = await buildMso(
      SignatureGenerator.get(issuerP521Key),
      issuerP521Cert,
      {
        'org.iso.18013.5.1': [
          givenName,
          familyName,
          birthDate,
          issueDate,
          expiryDate
        ]
      },
      'SHA-256',
      holderKey.toPublicKey(),
      'docType');

  expect(verifyMso(sig), isTrue);
  var c = sig.toCbor();

  var i = IssuerSignedObject.fromCbor(c);
  var m = MobileSecurityObject.fromCbor(i.issuerAuth.payload);

  Map<String, List<IssuerSignedItem>> revealedData =
      getDataToReveal(decodedRequest.docRequests.first.itemsRequest, i);

  i.items = revealedData;

  // Generate DeviceAuth (Mac / Signature)
  var signedData = await generateDeviceSignature({},
      decodedRequest.docRequests.first.itemsRequest.docType, transcriptHolder,
      signer: !useMac ? SignatureGenerator.get(holderKey) : null,
      keyAgreement: useMac
          ? KeyAgreement.get(
              publicKey: decodedEstablishment.eReaderKey, privateKey: holderKey)
          : null);
  var docToSend =
      Document(docType: m.docType, issuerSigned: i, deviceSigned: signedData);

  // Generate Response
  var response = DeviceResponse(status: 1, documents: [docToSend]);

  // Encrypt Response
  var encryptedResponse =
      await holderEncryptor.encrypt(response.toEncodedCbor());
  var responseToSend = SessionData(encryptedData: encryptedResponse).toCbor();

  // ---- MDoc - Reader -----
  // Decrypt Response
  var responseData = SessionData.fromCbor(responseToSend);
  var decryptedResponse =
      await readerEncryptor.decrypt(responseData.encryptedData!);
  var decodedResponse = DeviceResponse.fromCbor(decryptedResponse);

  // Verify Response
  expect(
      await verifyDeviceResponse(decodedResponse, transcript,
          readerPrivateKey: readerEphemeralCosePriv),
      isTrue);
}
