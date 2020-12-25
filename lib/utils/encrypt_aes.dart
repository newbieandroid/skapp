import 'dart:convert';

import 'package:encrypt/encrypt.dart';
// import 'package:flustars/flustars.dart';

var _key = "hwwaafrvaervhyuk";
var _iv = "1012132405963708";

//128的keysize=16，192keysize=24，256keysize=32

class JhEncryptUtils {
  //Base64编码
  static String encodeBase64(String data) {
    return base64Encode(utf8.encode(data));
  }

  //Base64解码
  static String decodeBase64(String data) {
    return String.fromCharCodes(base64Decode(data));
  }

  //AES加密
  // static aesEncrypt(plainText) {
  //   try {
  //     final key = Key.fromUtf8(_key);
  //     final iv = IV.fromUtf8(_iv);
  //     final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
  //     final encrypted = encrypter.encrypt(plainText, iv: iv);
  //     return encrypted.base16;
  //   } catch (err) {
  //     print("aes encode error:$err");
  //     return plainText;
  //   }
  // }

  //AES解密
  static dynamic aesDecrypt(encrypted) {
    try {
      final key = Key.fromUtf8(_key);
      final iv = IV.fromUtf8(_iv);
      final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
      final decrypted = encrypter.decrypt16(encrypted, iv: iv);
      return decrypted;
    } catch (err) {
      print("aes decode error:$err");
      return encrypted;
    }
  }
}
