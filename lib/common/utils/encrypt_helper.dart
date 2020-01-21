

import 'package:encrypt/encrypt.dart';
import 'package:fengchao/common/api/01_index_component_fun.dart';
import 'package:pointycastle/asymmetric/api.dart';


class EncryptHelper {
  RSAPublicKey _publicKey;
  RSAKeyParser _parser = RSAKeyParser();

  void init() async {
    Map<String, dynamic> res = await queryPublicKey();
    if (res['code'] == 1) {
      String publicKeyStr = '-----BEGIN PUBLIC KEY-----\n' + res['data'] + '\n-----END PUBLIC KEY-----';
      print(publicKeyStr);
      _publicKey = _parser.parse(publicKeyStr);
    } else {
      print('系统错误');
    }
  }

  String encode(String str) {
    final encrypter = Encrypter(RSA(publicKey: _publicKey));
    return encrypter.encrypt(str).base64;
  }

}