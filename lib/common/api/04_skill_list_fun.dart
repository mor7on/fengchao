import 'dart:convert';
import 'package:fengchao/common/api/http_request.dart';
import 'package:fengchao/common/config/config.dart';

Future getSkillList({Map<String, dynamic> params, int cateIdx}) async {
  var res;
  if (cateIdx == 0) {
    res = await DioApi.request(path: CONFIG.path['getSkillList'], method: 'GET', data: params);
  } else {
    res = await DioApi.request(path: CONFIG.path['getTeamList'], method: 'GET', data: params);
  }
  if (null != res) {
    return res;
  }
}

Future getSkillById({Map<String, dynamic> params}) async {
  print(params);
  var res = await DioApi.request(path: CONFIG.path['getSkillById'], method: 'GET', data: params);
  if (null != res) {
    return res;
  }
}

Future getTeamInfoById({Map<String, dynamic> params}) async {
  var res = await DioApi.request(path: CONFIG.path['getTeamInfoById'], method: 'GET', data: params);
  if (null != res) {
    return res;
  }
}


Future addSkill({Map<String, dynamic> params}) async {
  var res = await DioApi.request(path: CONFIG.path['addSkill'], method: 'POST', data: params);
  if (null != res) {
    
    return res;
  }
}

Future editSkill({Map<String, dynamic> params}) async {
  print(params);
  var res = await DioApi.request(path: CONFIG.path['editSkill'], method: 'POST', data: params);
  if (null != res) {
    //{code: 1, msg: 更新失败, data: false}
    return res;
  }
}

Future deleteSkill({Map<String, dynamic> params}) async {
  var res = await DioApi.request(path: CONFIG.path['deleteSkill'], method: 'GET', data: params);
  if (null != res) {
    //{code: 1, msg: 删除成功, data: true}
    return res;
  }
}

Future toFavoriteSkill({Map<String, dynamic> params}) async {
  var res = await DioApi.request(path: CONFIG.path['toFavoriteSkill'], method: 'GET', data: params);
  if (null != res) {
    
    return res;
  }
}

Future toFavoriteTeam({Map<String, dynamic> params}) async {
  var res = await DioApi.request(path: CONFIG.path['toFavoriteTeam'], method: 'GET', data: params);
  if (null != res) {
    
    return res;
  }
}