## 1.6.0
- fix bug in DrivingPrivileges class (thanks to @rhbrunetto)
- add [OpenID4VPHandover from OID4VP 1.0](https://openid.net/specs/openid-4-verifiable-presentations-1_0.html#name-handover-and-sessiontranscr)

## 1.5.0
- payload in sig_structure of cose_sign1 is always casted to CborBytes (thanks to @LuigiFiorillo)
- update pointyCastle to 4.0.0

## 1.4.1
- bugfix: await signing processes

## 1.4.0
- change CoseHeader x509chain parameter from List<int> to List<List<int>> to hold a whole certificate chain

## 1.3.1 
- fix dateTime parsing in data classes (thanks @imhafeez)
- update lints to 4.0.0

## 1.3.0
- add OID4VP Handover from ISO/IEC 18013-7

## 1.2.0
- add data classes for mdl and eu pid
- move constants for namespace and doctype to these dataclasses

## 1.1.0

- add constants for namespaces and docTypes
- bugFix: readerAuth signature is now optional (as specified)
- add full-date as datatype

## 1.0.0

- Initial version.
