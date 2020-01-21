import 'dart:convert';
import 'package:fengchao/common/api/http_request.dart';
import 'package:fengchao/common/config/config.dart';
import 'package:fengchao/models/chat_message.dart';
import 'package:fengchao/models/inbox.dart';

Future getRecommendMissions() async {
  var res = await DioApi.request(path: CONFIG.path['getRecommendMissions'], method: 'GET');
  if (null != res) {
    return res;
  }
}

Future<dynamic> getUserUnreadInbox() async {
  var res = await DioApi.request(path: CONFIG.path['getUserUnreadInbox'], method: 'GET');
  // print(res);
  if (null != res) {
    List<Inbox> newItems;

    newItems = res['data'].map<Inbox>((item) => Inbox.fromJson(item)).toList();
    return newItems;
  }
}

Future<dynamic> getUserUnreadChat() async {
  var res = await DioApi.request(path: CONFIG.path['getUserUnreadChat'], method: 'GET');
  // print(res);
  if (null != res) {
    List<ChatMessage> newItems;

    newItems = res['data'].map<ChatMessage>((item) => ChatMessage.fromJson(item)).toList();
    return newItems;
  }
}

Future queryPublicKey() async {
  var res = await DioApi.request(path: CONFIG.path['queryPublicKey'], method: 'GET');
  if (null != res) {
    return res;
  }
}

Future getInboxInfo() async {
  var res = await DioApi.request(path: CONFIG.path['getInboxInfo'], method: 'GET');
  if (null != res) {
    return res;
  }
}

Future toSetInboxReaded({Map<String, dynamic> params}) async {
  var res = await DioApi.request(path: CONFIG.path['toSetInboxReaded'], method: 'GET', data: params);
  if (null != res) {
    return res;
  }
}

Future delInboxInfo({Map<String, dynamic> params}) async {
  var res = await DioApi.request(path: CONFIG.path['delInboxInfo'], method: 'GET', data: params);
  if (null != res) {
    return res;
  }
}

Future getChatBoxInfo() async {
  var res = await DioApi.request(path: CONFIG.path['getChatBoxInfo'], method: 'GET');
  if (null != res) {
    return res;
  }
}

Future getOrderInfo({Map<String, dynamic> params}) async {
  var res = await DioApi.request(path: CONFIG.path['getOrderInfo'], method: 'GET', data: params);
  if (null != res) {
    return res;
  } 
}


Future getMissionOrderInfo({Map<String, dynamic> params}) async {
  print(params);
  var res = await DioApi.request(path: CONFIG.path['getMissionOrderInfo'], method: 'GET', data: params);
  if (null != res) {
    return res;
  } 
}

Future toPayWithBill({Map<String, dynamic> params}) async {
  var res = await DioApi.request(path: CONFIG.path['toPayWithBill'], method: 'POST', data: params);
  if (null != res) {
    return res;
  } 
}
