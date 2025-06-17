import 'dart:math';
import 'dart:typed_data';

import 'package:iso_mdoc/iso_mdoc.dart';

/// Mobile Drivers License as per ISO/IEC 18013-5
class MobileDriversLicense {
  static const String docType = 'org.iso.18013.5.1.mDL';
  static const String namespace = 'org.iso.18013.5.1';

  // DataElementIdentifier
  static const familyNameIdentifier = 'family_name';
  static const givenNameIdentifier = 'given_name';
  static const issuingCountryIdentifier = 'issuing_country';
  static const issuingAuthorityIdentifier = 'issuing_authority';
  static const documentNumberIdentifier = 'document_number';
  static const unDistinguishingSignIdentifier = 'un_distinguishing_sign';
  static const birthDateIdentifier = 'birth_date';
  static const issueDateIdentifier = 'issue_date';
  static const expiryDateIdentifier = 'expiry_date';
  static const portraitIdentifier = 'portrait';
  static const drivingPrivilegesIdentifier = 'driving_privileges';
  static const administrativeNumberIdentifier = 'administrative_number';
  static const birthPlaceIdentifier = 'birth_place';
  static const residentAddressIdentifier = 'resident_address';
  static const issuingJurisdictionIdentifier = 'issuing_jurisdiction';
  static const nationalityIdentifier = 'nationality';
  static const residentCityIdentifier = 'resident_city';
  static const residentStateIdentifier = 'resident_state';
  static const residentPostalCodeIdentifier = 'resident_postal_code';
  static const residentCountryIdentifier = 'resident_country';
  static const familyNameNationalCharacterIdentifier =
      'family_name_national_character';
  static const givenNameNationalCharacterIdentifier =
      'given_name_national_character';
  static const sexIdentifier = 'sex';
  static const heightIdentifier = 'height';
  static const weightIdentifier = 'weight';
  static const ageInYearsIdentifier = 'age_in_years';
  static const ageBirthYearIdentifier = 'age_birth_year';
  static const eyeColourIdentifier = 'eye_colour';
  static const hairColourIdentifier = 'hair_colour';
  static const portraitCaptureDateIdentifier = 'portrait_capture_date';
  static const signatureUsualMarkIdentifier = 'signature_usual_mark';
  static String ageOverNNIdentifier(int nn) => 'age_over_$nn';
  static String biometricTemplateXXIdentifier(String xx) =>
      'biometric_template_$xx';

  // Mandatory attributes
  String? familyName,
      givenName,
      issuingCountry,
      issuingAuthority,
      documentNumber,
      unDistinguishingSign;
  FullDate? birthDate, issueDate, expiryDate;
  Uint8List? portrait;
  List<DrivingPrivilege>? drivingPrivileges;

  // optional attributes
  String? administrativeNumber,
      birthPlace,
      residentAddress,
      issuingJurisdiction,
      nationality,
      residentCity,
      residentState,
      residentPostalCode,
      residentCountry,
      familyNameNationalCharacter,
      givenNameNationalCharacter;
  int? sex, height, weight, ageInYears, ageBirthYear;
  EyeColour? eyeColour;
  HairColour? hairColour;
  DateTime? portraitCaptureDate;
  Uint8List? signatureUsualMark;
  Map<int, bool>? ageOverNN;
  Map<String, Uint8List>? biometricTemplateXX;

  MobileDriversLicense(
      {this.familyName,
      this.givenName,
      this.issuingCountry,
      this.issuingAuthority,
      this.documentNumber,
      this.unDistinguishingSign,
      this.birthDate,
      this.issueDate,
      this.expiryDate,
      this.portrait,
      this.drivingPrivileges,
      this.administrativeNumber,
      this.birthPlace,
      this.residentAddress,
      this.issuingJurisdiction,
      this.nationality,
      this.residentCity,
      this.residentState,
      this.residentPostalCode,
      this.residentCountry,
      this.familyNameNationalCharacter,
      this.givenNameNationalCharacter,
      this.sex,
      this.height,
      this.weight,
      this.ageInYears,
      this.ageBirthYear,
      this.eyeColour,
      this.hairColour,
      this.portraitCaptureDate,
      this.signatureUsualMark,
      this.ageOverNN,
      this.biometricTemplateXX});

  factory MobileDriversLicense.fromIssuerSignedItems(
      Map<String, List<IssuerSignedItem>> data) {
    var items = data[namespace];
    if (items == null) {
      throw Exception('cannot find data of a mobile drivers license');
    }

    // Mandatory attributes
    String? familyName,
        givenName,
        issuingCountry,
        issuingAuthority,
        documentNumber,
        unDistinguishingSign;
    FullDate? birthDate, issueDate, expiryDate;
    Uint8List? portrait;
    List<DrivingPrivilege>? drivingPrivileges;

    // optional attributes
    String? administrativeNumber,
        birthPlace,
        residentAddress,
        issuingJurisdiction,
        nationality,
        residentCity,
        residentState,
        residentPostalCode,
        residentCountry,
        familyNameNationalCharacter,
        givenNameNationalCharacter;
    int? sex, height, weight, ageInYears, ageBirthYear;
    EyeColour? eyeColour;
    HairColour? hairColour;
    DateTime? portraitCaptureDate;
    Uint8List? signatureUsualMark;
    Map<int, bool>? ageOverNN;
    Map<String, Uint8List>? biometricTemplateXX;

    for (var item in items) {
      if (item.dataElementIdentifier == familyNameIdentifier) {
        familyName = item.dataElementValue;
      }
      if (item.dataElementIdentifier == givenNameIdentifier) {
        givenName = item.dataElementValue;
      }
      if (item.dataElementIdentifier == issuingCountryIdentifier) {
        issuingCountry = item.dataElementValue;
      }
      if (item.dataElementIdentifier == issuingAuthorityIdentifier) {
        issuingAuthority = item.dataElementValue;
      }
      if (item.dataElementIdentifier == documentNumberIdentifier) {
        documentNumber = item.dataElementValue;
      }
      if (item.dataElementIdentifier == unDistinguishingSignIdentifier) {
        unDistinguishingSign = item.dataElementValue;
      }
      if (item.dataElementIdentifier == birthDateIdentifier) {
        birthDate = item.dataElementValue is FullDate
            ? item.dataElementValue
            : (item.dataElementValue is DateTime
                ? FullDate.fromDateTime(item.dataElementValue)
                : FullDate.fromString(item.dataElementValue));
      }
      if (item.dataElementIdentifier == expiryDateIdentifier) {
        expiryDate = item.dataElementValue is FullDate
            ? item.dataElementValue
            : (item.dataElementValue is DateTime
                ? FullDate.fromDateTime(item.dataElementValue)
                : FullDate.fromString(item.dataElementValue));
      }
      if (item.dataElementIdentifier == issueDateIdentifier) {
        issueDate = item.dataElementValue is FullDate
            ? item.dataElementValue
            : (item.dataElementValue is DateTime
                ? FullDate.fromDateTime(item.dataElementValue)
                : FullDate.fromString(item.dataElementValue));
      }
      if (item.dataElementIdentifier == portraitIdentifier) {
        portrait = Uint8List.fromList(item.dataElementValue);
      }
      if (item.dataElementIdentifier == drivingPrivilegesIdentifier) {
        var privList = item.dataElementValue;
        drivingPrivileges = [];
        for (var entry in privList) {
          drivingPrivileges.add(DrivingPrivilege.fromMap(entry));
        }
      }
      if (item.dataElementIdentifier == administrativeNumberIdentifier) {
        administrativeNumber = item.dataElementValue;
      }
      if (item.dataElementIdentifier == birthPlaceIdentifier) {
        birthPlace = item.dataElementValue;
      }
      if (item.dataElementIdentifier == residentAddressIdentifier) {
        residentAddress = item.dataElementValue;
      }
      if (item.dataElementIdentifier == issuingJurisdictionIdentifier) {
        issuingJurisdiction = item.dataElementValue;
      }
      if (item.dataElementIdentifier == nationalityIdentifier) {
        nationality = item.dataElementValue;
      }
      if (item.dataElementIdentifier == residentCityIdentifier) {
        residentCity = item.dataElementValue;
      }
      if (item.dataElementIdentifier == residentStateIdentifier) {
        residentState = item.dataElementValue;
      }
      if (item.dataElementIdentifier == residentPostalCodeIdentifier) {
        residentPostalCode = item.dataElementValue;
      }
      if (item.dataElementIdentifier == residentCountryIdentifier) {
        residentCountry = item.dataElementValue;
      }
      if (item.dataElementIdentifier == familyNameNationalCharacterIdentifier) {
        familyNameNationalCharacter = item.dataElementValue;
      }
      if (item.dataElementIdentifier == givenNameNationalCharacterIdentifier) {
        givenNameNationalCharacter = item.dataElementValue;
      }
      if (item.dataElementIdentifier == sexIdentifier) {
        sex = item.dataElementValue;
      }
      if (item.dataElementIdentifier == heightIdentifier) {
        height = item.dataElementValue;
      }
      if (item.dataElementIdentifier == weightIdentifier) {
        weight = item.dataElementValue;
      }
      if (item.dataElementIdentifier == ageInYearsIdentifier) {
        ageInYears = item.dataElementValue;
      }
      if (item.dataElementIdentifier == ageBirthYearIdentifier) {
        ageBirthYear = item.dataElementValue;
      }
      if (item.dataElementIdentifier == eyeColourIdentifier) {
        eyeColour = EyeColour.values.asNameMap()[item.dataElementValue];
      }
      if (item.dataElementIdentifier == hairColourIdentifier) {
        hairColour = HairColour.values.asNameMap()[item.dataElementValue];
      }
      if (item.dataElementIdentifier == portraitCaptureDateIdentifier) {
        portraitCaptureDate = item.dataElementValue;
      }
      if (item.dataElementIdentifier == signatureUsualMarkIdentifier) {
        signatureUsualMark = Uint8List.fromList(item.dataElementValue);
      }
      if (item.dataElementIdentifier.startsWith('age_over_')) {
        ageOverNN ??= <int, bool>{};
        int age = int.parse(item.dataElementIdentifier.split('_')[2]);
        ageOverNN[age] = item.dataElementValue;
      }
      if (item.dataElementIdentifier.startsWith('biometric_template_')) {
        biometricTemplateXX ??= <String, Uint8List>{};
        String xx = item.dataElementIdentifier.split('_')[2];
        biometricTemplateXX[xx] = Uint8List.fromList(item.dataElementValue);
      }
    }

    return MobileDriversLicense(
        familyName: familyName,
        givenName: givenName,
        administrativeNumber: administrativeNumber,
        ageBirthYear: ageBirthYear,
        ageInYears: ageInYears,
        ageOverNN: ageOverNN,
        biometricTemplateXX: biometricTemplateXX,
        birthDate: birthDate,
        birthPlace: birthPlace,
        documentNumber: documentNumber,
        drivingPrivileges: drivingPrivileges,
        expiryDate: expiryDate,
        eyeColour: eyeColour,
        familyNameNationalCharacter: familyNameNationalCharacter,
        givenNameNationalCharacter: givenNameNationalCharacter,
        hairColour: hairColour,
        height: height,
        issueDate: issueDate,
        issuingAuthority: issuingAuthority,
        issuingCountry: issuingCountry,
        issuingJurisdiction: issuingJurisdiction,
        nationality: nationality,
        portrait: portrait,
        portraitCaptureDate: portraitCaptureDate,
        residentAddress: residentAddress,
        residentCity: residentCity,
        residentCountry: residentCountry,
        residentPostalCode: residentPostalCode,
        residentState: residentState,
        sex: sex,
        signatureUsualMark: signatureUsualMark,
        unDistinguishingSign: unDistinguishingSign,
        weight: weight);
  }

  Map<String, List<IssuerSignedItem>> generateIssuerSignedItems() {
    var items = <IssuerSignedItem>[];
    var random = Random.secure();
    var max = 2 ^ 31 - 1;
    if (familyName != null) {
      items.add(IssuerSignedItem(
          digestId: random.nextInt(max),
          dataElementIdentifier: familyNameIdentifier,
          dataElementValue: familyName));
    }
    if (givenName != null) {
      items.add(IssuerSignedItem(
          digestId: random.nextInt(max),
          dataElementIdentifier: givenNameIdentifier,
          dataElementValue: givenName));
    }
    if (issuingCountry != null) {
      items.add(IssuerSignedItem(
          digestId: random.nextInt(max),
          dataElementIdentifier: issuingCountryIdentifier,
          dataElementValue: issuingCountry));
    }
    if (issuingAuthority != null) {
      items.add(IssuerSignedItem(
          digestId: random.nextInt(max),
          dataElementIdentifier: issuingAuthorityIdentifier,
          dataElementValue: issuingAuthority));
    }
    if (documentNumber != null) {
      items.add(IssuerSignedItem(
          digestId: random.nextInt(max),
          dataElementIdentifier: documentNumberIdentifier,
          dataElementValue: documentNumber));
    }
    if (unDistinguishingSign != null) {
      items.add(IssuerSignedItem(
          digestId: random.nextInt(max),
          dataElementIdentifier: unDistinguishingSignIdentifier,
          dataElementValue: unDistinguishingSign));
    }
    if (birthDate != null) {
      items.add(IssuerSignedItem(
          digestId: random.nextInt(max),
          dataElementIdentifier: birthDateIdentifier,
          dataElementValue: birthDate));
    }
    if (issueDate != null) {
      items.add(IssuerSignedItem(
          digestId: random.nextInt(max),
          dataElementIdentifier: issueDateIdentifier,
          dataElementValue: issueDate));
    }
    if (expiryDate != null) {
      items.add(IssuerSignedItem(
          digestId: random.nextInt(max),
          dataElementIdentifier: expiryDateIdentifier,
          dataElementValue: expiryDate));
    }
    if (portrait != null) {
      items.add(IssuerSignedItem(
          digestId: random.nextInt(max),
          dataElementIdentifier: portraitIdentifier,
          dataElementValue: portrait));
    }
    items.add(IssuerSignedItem(
        digestId: random.nextInt(max),
        dataElementIdentifier: drivingPrivilegesIdentifier,
        dataElementValue: drivingPrivileges?.map((e) => e.toMap()) ?? []));
    if (administrativeNumber != null) {
      items.add(IssuerSignedItem(
          digestId: random.nextInt(max),
          dataElementIdentifier: administrativeNumberIdentifier,
          dataElementValue: administrativeNumber));
    }
    if (birthPlace != null) {
      items.add(IssuerSignedItem(
          digestId: random.nextInt(max),
          dataElementIdentifier: birthPlaceIdentifier,
          dataElementValue: birthPlace));
    }
    if (residentAddress != null) {
      items.add(IssuerSignedItem(
          digestId: random.nextInt(max),
          dataElementIdentifier: residentAddressIdentifier,
          dataElementValue: residentAddress));
    }
    if (issuingJurisdiction != null) {
      items.add(IssuerSignedItem(
          digestId: random.nextInt(max),
          dataElementIdentifier: issuingJurisdictionIdentifier,
          dataElementValue: issuingJurisdiction));
    }
    if (nationality != null) {
      items.add(IssuerSignedItem(
          digestId: random.nextInt(max),
          dataElementIdentifier: nationalityIdentifier,
          dataElementValue: nationality));
    }
    if (residentCity != null) {
      items.add(IssuerSignedItem(
          digestId: random.nextInt(max),
          dataElementIdentifier: residentCityIdentifier,
          dataElementValue: residentCity));
    }
    if (residentState != null) {
      items.add(IssuerSignedItem(
          digestId: random.nextInt(max),
          dataElementIdentifier: residentStateIdentifier,
          dataElementValue: residentState));
    }
    if (residentPostalCode != null) {
      items.add(IssuerSignedItem(
          digestId: random.nextInt(max),
          dataElementIdentifier: residentPostalCodeIdentifier,
          dataElementValue: residentPostalCode));
    }
    if (residentCountry != null) {
      items.add(IssuerSignedItem(
          digestId: random.nextInt(max),
          dataElementIdentifier: residentCountryIdentifier,
          dataElementValue: residentCountry));
    }
    if (familyNameNationalCharacter != null) {
      items.add(IssuerSignedItem(
          digestId: random.nextInt(max),
          dataElementIdentifier: familyNameNationalCharacterIdentifier,
          dataElementValue: familyNameNationalCharacter));
    }
    if (givenNameNationalCharacter != null) {
      items.add(IssuerSignedItem(
          digestId: random.nextInt(max),
          dataElementIdentifier: givenNameNationalCharacterIdentifier,
          dataElementValue: givenNameNationalCharacter));
    }
    if (sex != null) {
      items.add(IssuerSignedItem(
          digestId: random.nextInt(max),
          dataElementIdentifier: sexIdentifier,
          dataElementValue: sex));
    }
    if (weight != null) {
      items.add(IssuerSignedItem(
          digestId: random.nextInt(max),
          dataElementIdentifier: weightIdentifier,
          dataElementValue: weight));
    }
    if (height != null) {
      items.add(IssuerSignedItem(
          digestId: random.nextInt(max),
          dataElementIdentifier: heightIdentifier,
          dataElementValue: height));
    }
    if (ageInYears != null) {
      items.add(IssuerSignedItem(
          digestId: random.nextInt(max),
          dataElementIdentifier: ageBirthYearIdentifier,
          dataElementValue: ageInYears));
    }
    if (ageBirthYear != null) {
      items.add(IssuerSignedItem(
          digestId: random.nextInt(max),
          dataElementIdentifier: ageBirthYearIdentifier,
          dataElementValue: ageBirthYear));
    }
    if (ageOverNN != null) {
      for (int nn in ageOverNN!.keys) {
        items.add(IssuerSignedItem(
            digestId: random.nextInt(max),
            dataElementIdentifier: ageOverNNIdentifier(nn),
            dataElementValue: ageOverNN![nn]));
      }
    }
    if (hairColour != null) {
      items.add(IssuerSignedItem(
          digestId: random.nextInt(max),
          dataElementIdentifier: hairColourIdentifier,
          dataElementValue: hairColour.toString()));
    }
    if (eyeColour != null) {
      items.add(IssuerSignedItem(
          digestId: random.nextInt(max),
          dataElementIdentifier: eyeColourIdentifier,
          dataElementValue: eyeColour.toString()));
    }
    if (portraitCaptureDate != null) {
      items.add(IssuerSignedItem(
          digestId: random.nextInt(max),
          dataElementIdentifier: portraitCaptureDateIdentifier,
          dataElementValue: portraitCaptureDate));
    }
    if (signatureUsualMark != null) {
      items.add(IssuerSignedItem(
          digestId: random.nextInt(max),
          dataElementIdentifier: signatureUsualMarkIdentifier,
          dataElementValue: signatureUsualMark));
    }
    if (biometricTemplateXX != null) {
      for (var xx in biometricTemplateXX!.keys) {
        items.add(IssuerSignedItem(
            digestId: random.nextInt(max),
            dataElementIdentifier: biometricTemplateXXIdentifier(xx),
            dataElementValue: biometricTemplateXX![xx]));
      }
    }

    return {namespace: items};
  }

  void generateAgeOverNN(List<int> ageOver) {
    if (birthDate == null) {
      throw Exception('BirthDate missing');
    }
    var age = DateTime.now().year - birthDate!.year;

    ageOverNN ??= <int, bool>{};
    for (var a in ageOver) {
      if (a <= age) {
        ageOverNN![a] = true;
      } else {
        ageOverNN![a] = false;
      }
    }
  }

  Future<IssuerSignedObject> generateIssuerSignedObject(
      SignatureGenerator signer, String issuerCert, CoseKey deviceKey,
      [String hashAlg = 'SHA-256']) {
    return buildMso(signer, issuerCert, generateIssuerSignedItems(), hashAlg,
        deviceKey, docType);
  }

  @override
  String toString() {
    return 'MobileDriversLicense{familyName: $familyName, givenName: $givenName, issuingCountry: $issuingCountry, issuingAuthority: $issuingAuthority, documentNumber: $documentNumber, unDistinguishingSign: $unDistinguishingSign, birthDate: $birthDate, issueDate: $issueDate, expiryDate: $expiryDate, portrait: $portrait, drivingPrivileges: $drivingPrivileges, administrativeNumber: $administrativeNumber, birthPlace: $birthPlace, residentAddress: $residentAddress, issuingJurisdiction: $issuingJurisdiction, nationality: $nationality, residentCity: $residentCity, residentState: $residentState, residentPostalCode: $residentPostalCode, residentCountry: $residentCountry, familyNameNationalCharacter: $familyNameNationalCharacter, givenNameNationalCharacter: $givenNameNationalCharacter, sex: $sex, height: $height, weight: $weight, ageInYears: $ageInYears, ageBirthYear: $ageBirthYear, eyeColour: $eyeColour, hairColour: $hairColour, portraitCaptureDate: $portraitCaptureDate, signatureUsualMark: $signatureUsualMark, ageOverNN: $ageOverNN, biometricTemplateXX: $biometricTemplateXX}';
  }
}

class DrivingPrivilege {
  String vehicleCategoryCode;
  FullDate? issueDate, expiryDate;
  List<DrivingPrivilegeCode>? codes;

  DrivingPrivilege(
      {required this.vehicleCategoryCode,
      this.issueDate,
      this.expiryDate,
      this.codes});

  factory DrivingPrivilege.fromMap(Map<dynamic, dynamic> data) {
    String vehicleCategoryCode;
    FullDate? issueDate, expiryDate;
    List<DrivingPrivilegeCode>? codes;

    vehicleCategoryCode = data['vehicle_category_code'];
    if (data.containsKey('issue_date')) {
      var d = data['issue_date'];
      issueDate = d is FullDate ? d : FullDate.fromString(d);
    }
    if (data.containsKey('expiry_date')) {
      var e = data['expiry_date'];
      expiryDate = e is FullDate ? e : FullDate.fromString(e);
    }
    if (data.containsKey('codes')) {
      List c = data['codes'];
      codes = [];
      for (var code in c) {
        codes.add(DrivingPrivilegeCode.fromMap(code));
      }
    }
    return DrivingPrivilege(
        vehicleCategoryCode: vehicleCategoryCode,
        issueDate: issueDate,
        codes: codes,
        expiryDate: expiryDate);
  }

  Map<String, dynamic> toMap() {
    var m = <String, dynamic>{'vehicle_category_code': vehicleCategoryCode};
    if (issueDate != null) {
      m['issue_date'] = issueDate;
    }
    if (expiryDate != null) {
      m['expiry_date'] = expiryDate;
    }
    if (codes != null) {
      m['codes'] = codes!.map((e) => e.toMap()).toList();
    }

    return m;
  }

  @override
  String toString() {
    return 'DrivingPrivilege{vehicleCategoryCode: $vehicleCategoryCode, issueDate: $issueDate, expiryDate: $expiryDate, codes: $codes}';
  }
}

class DrivingPrivilegeCode {
  String code;
  String? sign, value;

  DrivingPrivilegeCode({required this.code, this.sign, this.value});

  factory DrivingPrivilegeCode.fromMap(Map<dynamic, dynamic> data) {
    String code;
    String? sign, value;

    code = data['code'];

    if (data.containsKey('sign')) {
      sign = data['sign'];
    }

    if (data.containsKey('value')) {
      value = data['value'];
    }

    return DrivingPrivilegeCode(code: code, sign: sign, value: value);
  }

  Map<String, dynamic> toMap() {
    var m = {'code': code};
    if (sign != null) {
      m['sign'] = sign!;
    }
    if (value != null) {
      m['value'] = value!;
    }
    return m;
  }

  @override
  String toString() {
    return 'DrivingPrivilegeCode{code: $code, sign: $sign, value: $value}';
  }
}

enum HairColour {
  bald,
  black,
  blond,
  brown,
  grey,
  red,
  auburn,
  sandy,
  white,
  unknown
}

enum EyeColour {
  black,
  blue,
  brown,
  dichromatic,
  grey,
  green,
  hazel,
  maroon,
  pink,
  unknown
}

/// Personal Identification Data (PID) as per Application Reference Framework (ARF) [Annex 6](https://github.com/eu-digital-identity-wallet/eudi-doc-architecture-and-reference-framework/releases/download/v1.3.0/annex-06-pid-rulebook.pdf)
class EuPiData {
  static const docType = 'eu.europa.ec.eudi.pid.1';
  static const namespace = 'eu.europa.ec.eudi.pid.1';

  // DataElementIdentifier
  static const familyNameIdentifier = 'family_name';
  static const givenNameIdentifier = 'given_name';
  static const birthDateIdentifier = 'birth_date';
  static const ageOver18Identifier = 'age_over_18';
  static String ageOverNNIdentifier(int nn) => 'age_over_$nn';
  static const ageInYearsIdentifier = 'age_in_years';
  static const ageBirthYearIdentifier = 'age_birth_year';
  static const familyNameBirthIdentifier = 'family_name_birth';
  static const givenNameBirthIdentifier = 'given_name_birth';
  static const birthPlaceIdentifier = 'birth_place';
  static const birthCountryIdentifier = 'birth_country';
  static const birthStateIdentifier = 'birth_state';
  static const birthCityIdentifier = 'birth_city';
  static const residentAddressIdentifier = 'resident_address';
  static const residentCityIdentifier = 'resident_city';
  static const residentStateIdentifier = 'resident_state';
  static const residentPostalCodeIdentifier = 'resident_postal_code';
  static const residentCountryIdentifier = 'resident_country';
  static const residentStreetIdentifier = 'resident_street';
  static const residentHouseNumberIdentifier = 'resident_house_number';
  static const genderIdentifier = 'gender';
  static const nationalityIdentifier = 'nationality';
  static const issuanceDateIdentifier = 'issuance_date';
  static const expiryDateIdentifier = 'expiry_date';
  static const administrativeNumberIdentifier = 'administrative_number';
  static const issuingCountryIdentifier = 'issuing_country';
  static const issuingAuthorityIdentifier = 'issuing_authority';
  static const documentNumberIdentifier = 'document_number';
  static const issuingJurisdictionIdentifier = 'issuing_jurisdiction';

  // Mandatory attributes
  String? familyName, givenName;
  FullDate? birthDate;

  // optionalAttributes
  bool? ageOver18;

  /// NN != 18
  Map<int, bool>? ageOverNN;
  int? ageInYears, ageBirthYear, gender;
  String? familyNameBirth,
      givenNameBirth,
      birthPlace,
      birthState,
      birthCountry,
      birthCity,
      residentAddress,
      residentCountry,
      residentState,
      residentCity,
      residentPostalCode,
      residentStreet,
      residentHouseNumber,
      nationality;

  // mandatory metadata
  FullDate? issuanceDate, expiryDate;
  String? issuingAuthority, issuingCountry;

  // optional Metadata
  String? documentNumber, administrativeNumber, issuingJurisdiction;

  EuPiData(
      {this.familyName,
      this.givenName,
      this.birthDate,
      this.ageOver18,
      this.ageOverNN,
      this.ageInYears,
      this.ageBirthYear,
      this.gender,
      this.familyNameBirth,
      this.givenNameBirth,
      this.birthPlace,
      this.birthState,
      this.birthCountry,
      this.birthCity,
      this.residentAddress,
      this.residentCountry,
      this.residentState,
      this.residentCity,
      this.residentPostalCode,
      this.residentStreet,
      this.residentHouseNumber,
      this.nationality,
      this.issuanceDate,
      this.expiryDate,
      this.issuingAuthority,
      this.issuingCountry,
      this.documentNumber,
      this.administrativeNumber,
      this.issuingJurisdiction});

  factory EuPiData.fromIssuerSignedItems(
      Map<String, List<IssuerSignedItem>> data) {
    var items = data[namespace];
    if (items == null) {
      throw Exception('cannot find data of a mobile drivers license');
    }

    // Mandatory attributes
    String? familyName, givenName;
    FullDate? birthDate;

    // optionalAttributes
    bool? ageOver18;

    /// NN != 18
    Map<int, bool>? ageOverNN;
    int? ageInYears, ageBirthYear, gender;
    String? familyNameBirth,
        givenNameBirth,
        birthPlace,
        birthState,
        birthCountry,
        birthCity,
        residentAddress,
        residentCountry,
        residentState,
        residentCity,
        residentPostalCode,
        residentStreet,
        residentHouseNumber,
        nationality;

    // mandatory metadata
    FullDate? issuanceDate, expiryDate;
    String? issuingAuthority, issuingCountry;

    // optional Metadata
    String? documentNumber, administrativeNumber, issuingJurisdiction;

    for (var item in items) {
      if (item.dataElementIdentifier == familyNameIdentifier) {
        familyName = item.dataElementValue;
      }
      if (item.dataElementIdentifier == givenNameIdentifier) {
        givenName = item.dataElementValue;
      }
      if (item.dataElementIdentifier == birthDateIdentifier) {
        birthDate = item.dataElementValue is FullDate
            ? item.dataElementValue
            : (item.dataElementValue is DateTime
                ? FullDate.fromDateTime(item.dataElementValue)
                : FullDate.fromString(item.dataElementValue));
      }
      if (item.dataElementIdentifier == ageOver18Identifier) {
        ageOver18 = item.dataElementValue;
      }
      if (item.dataElementIdentifier.startsWith('age_over_')) {
        ageOverNN ??= <int, bool>{};
        int age = int.parse(item.dataElementIdentifier.split('_')[2]);
        if (age != 18) {
          ageOverNN[age] = item.dataElementValue;
        }
      }
      if (item.dataElementIdentifier == ageInYearsIdentifier) {
        ageInYears = item.dataElementValue;
      }
      if (item.dataElementIdentifier == ageBirthYearIdentifier) {
        ageBirthYear = item.dataElementValue;
      }
      if (item.dataElementIdentifier == familyNameBirthIdentifier) {
        familyNameBirth = item.dataElementValue;
      }
      if (item.dataElementIdentifier == givenNameBirthIdentifier) {
        givenNameBirth = item.dataElementValue;
      }
      if (item.dataElementIdentifier == birthPlaceIdentifier) {
        birthPlace = item.dataElementValue;
      }
      if (item.dataElementIdentifier == birthCountryIdentifier) {
        birthCountry = item.dataElementValue;
      }
      if (item.dataElementIdentifier == birthStateIdentifier) {
        birthState = item.dataElementValue;
      }
      if (item.dataElementIdentifier == birthCityIdentifier) {
        birthCity = item.dataElementValue;
      }
      if (item.dataElementIdentifier == residentAddressIdentifier) {
        residentAddress = item.dataElementValue;
      }
      if (item.dataElementIdentifier == residentCountryIdentifier) {
        residentCountry = item.dataElementValue;
      }
      if (item.dataElementIdentifier == residentStateIdentifier) {
        residentState = item.dataElementValue;
      }
      if (item.dataElementIdentifier == residentCityIdentifier) {
        residentCity = item.dataElementValue;
      }
      if (item.dataElementIdentifier == residentPostalCodeIdentifier) {
        residentPostalCode = item.dataElementValue;
      }
      if (item.dataElementIdentifier == residentStreetIdentifier) {
        residentStreet = item.dataElementValue;
      }
      if (item.dataElementIdentifier == residentHouseNumberIdentifier) {
        residentHouseNumber = item.dataElementValue;
      }
      if (item.dataElementIdentifier == genderIdentifier) {
        gender = item.dataElementValue;
      }
      if (item.dataElementIdentifier == nationalityIdentifier) {
        nationality = item.dataElementValue;
      }
      if (item.dataElementIdentifier == expiryDateIdentifier) {
        expiryDate = item.dataElementValue is FullDate
            ? item.dataElementValue
            : (item.dataElementValue is DateTime
                ? FullDate.fromDateTime(item.dataElementValue)
                : FullDate.fromString(item.dataElementValue));
      }
      if (item.dataElementIdentifier == issuanceDateIdentifier) {
        issuanceDate = item.dataElementValue is FullDate
            ? item.dataElementValue
            : (item.dataElementValue is DateTime
                ? FullDate.fromDateTime(item.dataElementValue)
                : FullDate.fromString(item.dataElementValue));
      }
      if (item.dataElementIdentifier == administrativeNumberIdentifier) {
        administrativeNumber = item.dataElementValue;
      }
      if (item.dataElementIdentifier == issuingCountryIdentifier) {
        issuingCountry = item.dataElementValue;
      }
      if (item.dataElementIdentifier == issuingAuthorityIdentifier) {
        issuingAuthority = item.dataElementValue;
      }
      if (item.dataElementIdentifier == documentNumberIdentifier) {
        documentNumber = item.dataElementValue;
      }
      if (item.dataElementIdentifier == issuingJurisdiction) {
        issuingJurisdiction = item.dataElementValue;
      }
    }

    return EuPiData(
        familyName: familyName,
        givenName: givenName,
        birthDate: birthDate,
        ageOver18: ageOver18,
        ageOverNN: ageOverNN,
        ageInYears: ageInYears,
        ageBirthYear: ageBirthYear,
        gender: gender,
        familyNameBirth: familyNameBirth,
        givenNameBirth: givenNameBirth,
        birthPlace: birthPlace,
        birthState: birthState,
        birthCountry: birthCountry,
        birthCity: birthCity,
        residentAddress: residentAddress,
        residentCountry: residentCountry,
        residentState: residentState,
        residentCity: residentCity,
        residentPostalCode: residentPostalCode,
        residentStreet: residentStreet,
        residentHouseNumber: residentHouseNumber,
        nationality: nationality,
        issuanceDate: issuanceDate,
        expiryDate: expiryDate,
        issuingAuthority: issuingAuthority,
        issuingCountry: issuingCountry,
        documentNumber: documentNumber,
        administrativeNumber: administrativeNumber,
        issuingJurisdiction: issuingJurisdiction);
  }

  Map<String, List<IssuerSignedItem>> generateIssuerSignedItems() {
    var items = <IssuerSignedItem>[];
    var random = Random.secure();
    var max = 2 ^ 31 - 1;

    if (familyName != null) {
      items.add(IssuerSignedItem(
          digestId: random.nextInt(max),
          dataElementIdentifier: familyNameIdentifier,
          dataElementValue: familyName));
    }
    if (givenName != null) {
      items.add(IssuerSignedItem(
          digestId: random.nextInt(max),
          dataElementIdentifier: givenNameIdentifier,
          dataElementValue: givenName));
    }
    if (birthDate != null) {
      items.add(IssuerSignedItem(
          digestId: random.nextInt(max),
          dataElementIdentifier: birthDateIdentifier,
          dataElementValue: birthDate));
    }
    if (ageOver18 != null) {
      items.add(IssuerSignedItem(
          digestId: random.nextInt(max),
          dataElementIdentifier: ageOver18Identifier,
          dataElementValue: ageOver18));
    }
    if (ageOverNN != null) {
      for (int nn in ageOverNN!.keys) {
        if (nn == 18) continue;
        items.add(IssuerSignedItem(
            digestId: random.nextInt(max),
            dataElementIdentifier: ageOverNNIdentifier(nn),
            dataElementValue: ageOverNN![nn]));
      }
    }
    if (ageInYears != null) {
      items.add(IssuerSignedItem(
          digestId: random.nextInt(max),
          dataElementIdentifier: ageInYearsIdentifier,
          dataElementValue: ageInYears));
    }
    if (ageBirthYear != null) {
      items.add(IssuerSignedItem(
          digestId: random.nextInt(max),
          dataElementIdentifier: ageBirthYearIdentifier,
          dataElementValue: ageBirthYear));
    }
    if (familyNameBirth != null) {
      items.add(IssuerSignedItem(
          digestId: random.nextInt(max),
          dataElementIdentifier: familyNameBirthIdentifier,
          dataElementValue: familyNameBirth));
    }
    if (givenNameBirth != null) {
      items.add(IssuerSignedItem(
          digestId: random.nextInt(max),
          dataElementIdentifier: givenNameBirthIdentifier,
          dataElementValue: givenNameBirth));
    }
    if (birthPlace != null) {
      items.add(IssuerSignedItem(
          digestId: random.nextInt(max),
          dataElementIdentifier: birthPlaceIdentifier,
          dataElementValue: birthPlace));
    }
    if (birthState != null) {
      items.add(IssuerSignedItem(
          digestId: random.nextInt(max),
          dataElementIdentifier: birthStateIdentifier,
          dataElementValue: birthState));
    }
    if (birthCountry != null) {
      items.add(IssuerSignedItem(
          digestId: random.nextInt(max),
          dataElementIdentifier: birthCountryIdentifier,
          dataElementValue: birthCountry));
    }
    if (birthCity != null) {
      items.add(IssuerSignedItem(
          digestId: random.nextInt(max),
          dataElementIdentifier: birthCityIdentifier,
          dataElementValue: birthCity));
    }
    if (residentAddress != null) {
      items.add(IssuerSignedItem(
          digestId: random.nextInt(max),
          dataElementIdentifier: residentAddressIdentifier,
          dataElementValue: residentAddress));
    }
    if (residentCountry != null) {
      items.add(IssuerSignedItem(
          digestId: random.nextInt(max),
          dataElementIdentifier: residentCountryIdentifier,
          dataElementValue: residentCountry));
    }
    if (residentStreet != null) {
      items.add(IssuerSignedItem(
          digestId: random.nextInt(max),
          dataElementIdentifier: residentStreetIdentifier,
          dataElementValue: residentStreet));
    }
    if (residentState != null) {
      items.add(IssuerSignedItem(
          digestId: random.nextInt(max),
          dataElementIdentifier: residentStateIdentifier,
          dataElementValue: residentState));
    }
    if (residentCity != null) {
      items.add(IssuerSignedItem(
          digestId: random.nextInt(max),
          dataElementIdentifier: residentCityIdentifier,
          dataElementValue: residentCity));
    }
    if (residentPostalCode != null) {
      items.add(IssuerSignedItem(
          digestId: random.nextInt(max),
          dataElementIdentifier: residentPostalCodeIdentifier,
          dataElementValue: residentPostalCode));
    }
    if (residentHouseNumber != null) {
      items.add(IssuerSignedItem(
          digestId: random.nextInt(max),
          dataElementIdentifier: residentHouseNumberIdentifier,
          dataElementValue: residentHouseNumber));
    }
    if (gender != null) {
      items.add(IssuerSignedItem(
          digestId: random.nextInt(max),
          dataElementIdentifier: genderIdentifier,
          dataElementValue: gender));
    }
    if (nationality != null) {
      items.add(IssuerSignedItem(
          digestId: random.nextInt(max),
          dataElementIdentifier: nationalityIdentifier,
          dataElementValue: nationality));
    }
    if (issuanceDate != null) {
      items.add(IssuerSignedItem(
          digestId: random.nextInt(max),
          dataElementIdentifier: issuanceDateIdentifier,
          dataElementValue: issuanceDate));
    }
    if (expiryDate != null) {
      items.add(IssuerSignedItem(
          digestId: random.nextInt(max),
          dataElementIdentifier: expiryDateIdentifier,
          dataElementValue: expiryDate));
    }
    if (issuingCountry != null) {
      items.add(IssuerSignedItem(
          digestId: random.nextInt(max),
          dataElementIdentifier: issuingCountryIdentifier,
          dataElementValue: issuingCountry));
    }
    if (issuingJurisdiction != null) {
      items.add(IssuerSignedItem(
          digestId: random.nextInt(max),
          dataElementIdentifier: issuingJurisdictionIdentifier,
          dataElementValue: issuingJurisdiction));
    }
    if (issuingAuthority != null) {
      items.add(IssuerSignedItem(
          digestId: random.nextInt(max),
          dataElementIdentifier: issuingAuthorityIdentifier,
          dataElementValue: issuingAuthority));
    }
    if (documentNumber != null) {
      items.add(IssuerSignedItem(
          digestId: random.nextInt(max),
          dataElementIdentifier: documentNumberIdentifier,
          dataElementValue: documentNumber));
    }
    if (administrativeNumber != null) {
      items.add(IssuerSignedItem(
          digestId: random.nextInt(max),
          dataElementIdentifier: administrativeNumberIdentifier,
          dataElementValue: administrativeNumber));
    }

    return {namespace: items};
  }

  void generateAgeOverNN(List<int> ageOver) {
    if (birthDate == null) {
      throw Exception('BirthDate missing');
    }
    var age = DateTime.now().year - birthDate!.year;

    ageOverNN ??= <int, bool>{};
    for (var a in ageOver) {
      if (a == 18) continue;
      if (a <= age) {
        ageOverNN![a] = true;
      } else {
        ageOverNN![a] = false;
      }
    }
  }

  Future<IssuerSignedObject> generateIssuerSignedObject(
      SignatureGenerator signer, String issuerCert, CoseKey deviceKey,
      [String hashAlg = 'SHA-256']) {
    return buildMso(signer, issuerCert, generateIssuerSignedItems(), hashAlg,
        deviceKey, docType);
  }

  @override
  String toString() {
    return 'EuPiData{familyName: $familyName, givenName: $givenName, birthDate: $birthDate, ageOver18: $ageOver18, ageOverNN: $ageOverNN, ageInYears: $ageInYears, ageBirthYear: $ageBirthYear, gender: $gender, familyNameBirth: $familyNameBirth, givenNameBirth: $givenNameBirth, birthPlace: $birthPlace, birthState: $birthState, birthCountry: $birthCountry, birthCity: $birthCity, residentAddress: $residentAddress, residentCountry: $residentCountry, residentState: $residentState, residentCity: $residentCity, residentPostalCode: $residentPostalCode, residentStreet: $residentStreet, residentHouseNumber: $residentHouseNumber, nationality: $nationality, issuanceDate: $issuanceDate, expiryDate: $expiryDate, issuingAuthority: $issuingAuthority, issuingCountry: $issuingCountry, documentNumber: $documentNumber, administrativeNumber: $administrativeNumber, issuingJurisdiction: $issuingJurisdiction}';
  }
}
