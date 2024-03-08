import 'dart:typed_data';

String addPaddingToBase64(String base64Input) {
  while (base64Input.length % 4 != 0) {
    base64Input += '=';
  }
  return base64Input;
}

String removePaddingFromBase64(String base64Input) {
  while (base64Input.endsWith('=')) {
    base64Input = base64Input.substring(0, base64Input.length - 1);
  }
  return base64Input;
}

bool listEquals(List l1, List l2) {
  if (l2.length != l1.length) {
    return false;
  }

  for (int i = 0; i < l2.length; i++) {
    if (l1[i] != l2[i]) {
      return false;
    }
  }

  return true;
}

// Source: pointyCastle src/utils
var _byteMask = BigInt.from(0xff);

Uint8List unsignedIntToBytes(BigInt number) {
  if (number.isNegative) {
    throw Exception('Negative number');
  }
  if (number == BigInt.zero) {
    return Uint8List.fromList([0]);
  }
  var size = number.bitLength + (number.isNegative ? 8 : 7) >> 3;
  var result = Uint8List(size);
  for (var i = 0; i < size; i++) {
    result[size - i - 1] = (number & _byteMask).toInt();
    number = number >> 8;
  }
  return result;
}

BigInt bytesToUnsignedInt(List<int> magnitude) {
  BigInt result;

  if (magnitude.length == 1) {
    result = BigInt.from(magnitude[0]);
  } else {
    result = BigInt.from(0);
    for (var i = 0; i < magnitude.length; i++) {
      var item = magnitude[magnitude.length - i - 1];
      result |= BigInt.from(item) << (8 * i);
    }
  }

  if (result != BigInt.zero) {
    result = result.toUnsigned(result.bitLength);
  }
  return result;
}