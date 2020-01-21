import 'package:fengchao/common/api/http_request.dart';
import 'package:fengchao/common/config/config.dart';
import 'package:fengchao/models/tender_user.dart';

Future getMissionList({Map<String, dynamic> params}) async {
  print(params);
  var res = await DioApi.request(path: CONFIG.path['getMissionList'], method: 'GET', data: params);
  if (null != res) {
    return res;
  }
}

Future getMissionById({Map<String, dynamic> params}) async {
  print('开始请求任务详情');
  var res = await DioApi.request(path: CONFIG.path['getMissionById'], method: 'GET', data: params);
  if (null != res) {
    return res;
  }
}

Future getMissionByState({Map<String, dynamic> params, int state}) async {
  String suffixText;
  switch (state) {
    case 0:
      suffixText = 'recommend';
      break;
    case 1:
      suffixText = 'mytask';
      break;
    case 2:
      suffixText = 'todo';
      break;
    case 3:
      suffixText = 'winning';
      break;
    case 4:
      suffixText = 'completion';
      break;
    default:
      suffixText = 'recommend';
  }
  var res = await DioApi.request(path: CONFIG.path['getMissionByState'] + suffixText, method: 'GET', data: params);
  if (null != res) {
    return res;
  }
}

Future getUserInfo({Map<String, dynamic> params}) async {
  var res = await DioApi.request(path: CONFIG.path['getUserInfo'], method: 'GET', data: params);
  if (null != res) {
    Map item = res['data'];
    return item;
  }
}

Future getMissionTenderUserList({Map<String, dynamic> params}) async {
  var res = await DioApi.request(path: CONFIG.path['getMissionTenderUserList'], method: 'GET', data: params);
  if (null != res) {
    List<TenderUser> newItems = res['data'].map<TenderUser>((item) => TenderUser.fromJson(item)).toList();
    
    return newItems;
  }
}

Future getMissionStateById({Map<String, dynamic> params}) async {
  var res = await DioApi.request(path: CONFIG.path['getMissionStateById'], method: 'GET', data: params);
  if (null != res) {
    
    return res;
  }
}

Future todoBMfunById({Map<String, dynamic> params}) async {
  var res = await DioApi.request(path: CONFIG.path['todoBMfunById'], method: 'GET', data: params);
  if (null != res) {
    return res;
  }
}

Future todoTBfunById({Map<String, dynamic> params}) async {
  var res = await DioApi.request(path: CONFIG.path['todoTBfunById'], method: 'GET', data: params);
  if (null != res) {
    return res;
  }
}

Future toCancleTenderById({Map<String, dynamic> params}) async {
  var res = await DioApi.request(path: CONFIG.path['toCancleTenderById'], method: 'GET', data: params);
  if (null != res) {
    return res;
  }
}

Future addMission({Map<String, dynamic> params}) async {
  print(params);
  var res = await DioApi.request(path: CONFIG.path['addMission'], method: 'POST', data: params);
  if (null != res) {
    
    return res;
  } 
}

Future editMission({Map<String, dynamic> params}) async {
  print(params);
  var res = await DioApi.request(path: CONFIG.path['editMission'], method: 'POST', data: params);
  if (null != res) {
    //{code: 1, msg: 更新失败, data: false}
    return res;
  }
}

Future deleteMission({Map<String, dynamic> params}) async {
  var res = await DioApi.request(path: CONFIG.path['deleteMission'], method: 'GET', data: params);
  if (null != res) {
    //{code: 1, msg: 删除成功, data: true}
    return res;
  } 
}

Future toPostResultById({Map<String, dynamic> params}) async {
  print(params);
  var res = await DioApi.request(path: CONFIG.path['toPostResultById'], method: 'POST', data: params);
  if (null != res) {
    
    return res;
  } 
}

Future toRefusResultById({Map<String, dynamic> params}) async {
  print(params);
  var res = await DioApi.request(path: CONFIG.path['toRefusResultById'], method: 'POST', data: params);
  if (null != res) {
    
    return res;
  } 
}

Future toAgreeResultById({Map<String, dynamic> params}) async {
  print(params);
  var res = await DioApi.request(path: CONFIG.path['toAgreeResultById'], method: 'POST', data: params);
  if (null != res) {
    
    return res;
  } 
}

Future getTradeBill({Map<String, dynamic> params}) async {
  var res = await DioApi.request(path: CONFIG.path['getTradeBill'], method: 'GET', data: params);
  if (null != res) {
    return res;
  }
}

Future toConfirmPayment({Map<String, dynamic> params}) async {
  print(params);
  var res = await DioApi.request(path: CONFIG.path['toConfirmPayment'], method: 'GET', data: params);
  if (null != res) {
    //{code: 1, msg: 删除成功, data: true}
    return res;
  }
}

Future toAgreeUserWinMissionById({Map<String, dynamic> params}) async {
  print(params);
  var res = await DioApi.request(path: CONFIG.path['toAgreeUserWinMissionById'], method: 'GET', data: params);
  if (null != res) {
    //{code: 1, msg: 同意, data: true}
    return res;
  }
}

Future toRefuseUserWinMissionById({Map<String, dynamic> params}) async {
  print(params);
  var res = await DioApi.request(path: CONFIG.path['toRefuseUserWinMissionById'], method: 'GET', data: params);
  if (null != res) {
    //{code: 1, msg: 不同意, data: true}
    return res;
  }
}


Future toPostUserRate({Map<String, dynamic> params}) async {
  print(params);
  var res = await DioApi.request(path: CONFIG.path['toPostUserRate'], method: 'POST', data: params);
  if (null != res) {
    
    return res;
  } 
}

Future toFavoriteMission({Map<String, dynamic> params}) async {
  var res = await DioApi.request(path: CONFIG.path['toFavoriteMission'], method: 'GET', data: params);
  if (null != res) {
    
    return res;
  }
}