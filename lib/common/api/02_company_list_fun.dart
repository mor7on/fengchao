import 'package:fengchao/common/api/http_request.dart';
import 'package:fengchao/common/config/config.dart';

Future getCompanyList({Map<String, dynamic> params}) async {
  print(params);
  var res = await DioApi.request(path: CONFIG.path['getCompanyList'], method: 'GET', data: params);
  if (null != res) {
    return res;
  }
}

Future getCompanyById({Map<String, dynamic> params}) async {
  var res = await DioApi.request(path: CONFIG.path['getCompanyById'], method: 'GET', data: params);
  if (null != res) {
    
    return res;
  }
}

Future addCompany({Map<String, dynamic> params}) async {
  var res = await DioApi.request(path: CONFIG.path['addCompany'], method: 'POST', data: params);
  if (null != res) {
    return res;
  } 
}

Future editCompany({Map<String, dynamic> params}) async {
  print(params);
  var res = await DioApi.request(path: CONFIG.path['editCompany'], method: 'POST', data: params);
  if (null != res) {
    //{code: 1, msg: 更新失败, data: false}
    return res;
  }
}

Future deleteCompany({Map<String, dynamic> params}) async {
  var res = await DioApi.request(path: CONFIG.path['deleteCompany'], method: 'GET', data: params);
  if (null != res) {
    //{code: 1, msg: 删除成功, data: true}
    return res;
  }
}

Future getCompanyComments({Map<String, dynamic> params}) async {
  var res = await DioApi.request(path: CONFIG.path['getCompanyComments'], method: 'GET', data: params);
  if (null != res) {
    
    return res;
  }
}

Future toCompanyReply({Map<String, dynamic> params}) async {
  var res = await DioApi.request(path: CONFIG.path['toCompanyReply'], method: 'POST', data: params);
  if (null != res) {
    
    return res;
  }
}

Future toFavoriteCompany({Map<String, dynamic> params}) async {
  var res = await DioApi.request(path: CONFIG.path['toFavoriteCompany'], method: 'GET', data: params);
  if (null != res) {
    
    return res;
  }
}