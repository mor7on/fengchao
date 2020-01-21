import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:fengchao/common/api/http_request.dart';
import 'package:fengchao/common/config/config.dart';
import 'package:fengchao/common/utils/common_utils.dart';
import 'package:fengchao/models/friend_group.dart';
import 'package:fengchao/models/mine_share.dart';
import 'package:fengchao/models/user_team.dart';

Future getMySkillList({Map<String, dynamic> params}) async {
  var res = await DioApi.request(path: CONFIG.path['getMySkillList'], method: 'GET', data: params);
  if (null != res) {
    var newItems = new List();
    var items = res['data'];

    for (int i = 0; i < items.length; i++) {
      var more = json.decode(items[i]['more']);
      List imageList;
      if (more != null && more['photos'].length > 0) {
        imageList = more['photos'].map((val) => CONFIG.BASE_URL + val).toList();
      } else {
        imageList = [
          "${CONFIG.BASE_URL}h5/asset/blank.png",
          "${CONFIG.BASE_URL}h5/asset/blank.png",
          "${CONFIG.BASE_URL}h5/asset/blank.png"
        ];
      }

      newItems.add({
        'id': items[i]['id'],
        'post_title': items[i]['post_title'],
        'post_hits': items[i]['post_hits'],
        'post_favorites': items[i]['post_favorites'],
        'post_keywords': items[i]['post_keywords'] == '' || items[i]['post_keywords'] == null
            ? null
            : items[i]['post_keywords'].split(','),
        'create_time': CommonUtils.dateToPretty(items[i]['create_time']),
        'post_type': null,
        'imageList': imageList,
      });
    }
    return newItems;
  }
}

Future getMyFavoriteList({Map<String, dynamic> params, String pathName}) async {
  Map<String, String> navigateName = {
    'getMyFavoriteCompany': '/companyDetail',
    'getMyFavoriteMission': '/missionDetail',
    'getMyFavoriteSkill': '/skillDetail',
    'getMyFavoriteArticle': '/articleDetail',
  };

  var res = await DioApi.request(path: CONFIG.path[pathName], method: 'GET', data: params);
  if (null != res) {
    List newItems = new List();
    if (pathName == 'getMyFavoriteSkill') {
      Map items = res['data'];
      if (items['team'] != null && items['team'].length > 0) {
        items['team'].forEach((v) {
          var more = json.decode(v['more']);
          List imageList;
          if (more != null && more['photos'].length > 0) {
            imageList = more['photos'].map((val) => CONFIG.BASE_URL + val).toList();
          } else {
            imageList = [
              "${CONFIG.BASE_URL}h5/asset/blank.png",
              "${CONFIG.BASE_URL}h5/asset/blank.png",
              "${CONFIG.BASE_URL}h5/asset/blank.png"
            ];
          }

          newItems.add({
            'id': v['id'],
            'post_title': v['post_title'],
            'post_type': v['post_type'],
            'user': v['user'],
            'post_hits': v['post_hits'] ?? 0,
            'post_favorites': v['post_favorites'] ?? 0,
            'create_time': CommonUtils.dateToPretty(v['create_time']),
            'post_keywords':
                v['post_keywords'] == '' || v['post_keywords'] == null ? null : v['post_keywords'].split(','),
            'post_content': v['post_content'],
            'imageList': imageList,
            'navigate_to': '/teamDetail',
          });
        });
      }
      if (items['knowhow'] != null && items['knowhow'].length > 0) {
        items['knowhow'].forEach((v) {
          var more = json.decode(v['more']);
          List imageList;
          if (more != null && more['photos'].length > 0) {
            imageList = more['photos'].map((val) => CONFIG.BASE_URL + val).toList();
          } else {
            imageList = [
              "${CONFIG.BASE_URL}h5/asset/blank.png",
              "${CONFIG.BASE_URL}h5/asset/blank.png",
              "${CONFIG.BASE_URL}h5/asset/blank.png"
            ];
          }

          newItems.add({
            'id': v['id'],
            'post_title': v['post_title'],
            'post_type': v['post_type'],
            'user': v['user'],
            'post_hits': v['post_hits'] ?? 0,
            'post_favorites': v['post_favorites'] ?? 0,
            'create_time': CommonUtils.dateToPretty(v['create_time']),
            'post_keywords':
                v['post_keywords'] == '' || v['post_keywords'] == null ? null : v['post_keywords'].split(','),
            'post_content': v['post_content'],
            'imageList': imageList,
            'navigate_to': navigateName[pathName],
          });
        });
      }
      return newItems;
    } else {
      List items = res['data'];

      items.forEach((v) {
        var more = json.decode(v['more']);
        List imageList;
        if (more != null && more['photos'].length > 0) {
          imageList = more['photos'].map((val) => CONFIG.BASE_URL + val).toList();
        } else {
          imageList = [
            "${CONFIG.BASE_URL}h5/asset/blank.png",
            "${CONFIG.BASE_URL}h5/asset/blank.png",
            "${CONFIG.BASE_URL}h5/asset/blank.png"
          ];
        }

        newItems.add({
          'id': v['id'],
          'post_title': v['post_title'],
          'post_type': v['post_type'],
          'user': v['user'],
          'post_hits': v['post_hits'] ?? 0,
          'post_favorites': v['post_favorites'] ?? 0,
          'create_time': CommonUtils.dateToPretty(v['create_time']),
          'post_keywords':
              v['post_keywords'] == '' || v['post_keywords'] == null ? null : v['post_keywords'].split(','),
          'post_content': v['post_content'],
          'imageList': imageList,
          'navigate_to': navigateName[pathName],
        });
      });

      return newItems;
    }
  }
}

Future getMyFriendsList({Map<String, dynamic> params}) async {
  var res = await DioApi.request(path: CONFIG.path['getMyFriendsList'], method: 'GET', data: params);
  if (null != res) {
    List<FriendGroup> newItems = res['data'].map<FriendGroup>((item) => FriendGroup.fromJson(item)).toList();
    return newItems;
  } 
}

Future getMyShareList({Map<String, dynamic> params}) async {
  var res = await DioApi.request(path: CONFIG.path['getMyShareList'], method: 'GET', data: params);
  if (null != res) {
    List<MineShare> newItems = res['data'].map<MineShare>((item) => MineShare.fromJson(item)).toList();
    return newItems;
  }
}

Future getTeamByUserId({Map<String, dynamic> params}) async {
  var res = await DioApi.request(path: CONFIG.path['getTeamByUserId'], method: 'GET', data: params);
  if (null != res) {
    return res;
  }
}

Future getTeamInfoById({Map<String, dynamic> params}) async {
  var res = await DioApi.request(path: CONFIG.path['getTeamInfoById'], method: 'GET', data: params);
  if (null != res) {
    UserTeam newItem = UserTeam.fromJson(res['data']);
    return newItem;
  }
}

Future getMyBalance({Map<String, dynamic> params}) async {
  var res = await DioApi.request(path: CONFIG.path['getMyBalance'], method: 'GET', data: params);
  if (null != res) {
    return res;
  } 
}

Future postFeedback({Map<String, dynamic> params}) async {
  var res = await DioApi.request(path: CONFIG.path['postFeedback'], method: 'POST', data: params);
  if (null != res) {
    return res;
  } 
}

Future uploadAvatar({FormData params, onSend}) async {
  var res = await DioApi.uploade(path: CONFIG.path['uploadAvatar'], data: params, onSend: onSend);
  if (null != res) {
    return res;
  }
}

Future editUserInfo({Map<String, dynamic> params}) async {
  var res = await DioApi.request(path: CONFIG.path['editUserInfo'], method: 'POST', data: params);
  if (null != res) {
    return res;
  }
}

Future publishIDCard({Map<String, dynamic> params}) async {
  var res = await DioApi.request(path: CONFIG.path['publishIDCard'], method: 'POST', data: params);
  if (null != res) {
    return res;
  }
}

Future getUserCertificate() async {
  var res = await DioApi.request(path: CONFIG.path['getUserCertificate'], method: 'GET');
  if (null != res) {
    return res;
  }
}

Future getUserInfo() async {
  var res = await DioApi.request(path: CONFIG.path['getUserInfo'], method: 'GET');
  if (null != res) {
    return res;
  }
}

Future getUserByNickName({Map<String, dynamic> params}) async {
  print(params);
  var res = await DioApi.request(path: CONFIG.path['getUserByNickName'], method: 'POST', data: params);
  if (null != res) {
    return res;
  }
}

Future getUserInfoById({Map<String, dynamic> params}) async {
  var res = await DioApi.request(path: CONFIG.path['getUserInfoById'], method: 'GET', data: params);
  if (null != res) {
    return res;
  } 
}

Future getUserShareList({Map<String, dynamic> params}) async {
  var res = await DioApi.request(path: CONFIG.path['getUserShareList'], method: 'GET', data: params);
  if (null != res) {
    // List<MineShare> newItems = res['data'].map<MineShare>((item) => MineShare.fromJson(item)).toList();
    return res;
  } 
}

Future getUserBankCards({Map<String, dynamic> params}) async {
  var res = await DioApi.request(path: CONFIG.path['getUserBankCards'], method: 'GET', data: params);
  if (null != res) {
    // List<MineShare> newItems = res['data'].map<MineShare>((item) => MineShare.fromJson(item)).toList();
    return res;
  } 
}

Future getUserPassState({Map<String, dynamic> params}) async {
  var res = await DioApi.request(path: CONFIG.path['getUserPassState'], method: 'GET', data: params);
  if (null != res) {
    // List<MineShare> newItems = res['data'].map<MineShare>((item) => MineShare.fromJson(item)).toList();
    return res;
  }
}

Future getMyFriendsDynamic({Map<String, dynamic> params}) async {
  var res = await DioApi.request(path: CONFIG.path['getMyFriendsDynamic'], method: 'GET', data: params);
  print(res);
  if (null != res) {
    // List<ArticleModel> newItems = res['data'].map<ArticleModel>((item) => ArticleModel.fromJson(item)).toList();
    return res;
  } 
}

Future getAskForNewFriend({Map<String, dynamic> params}) async {
  var res = await DioApi.request(path: CONFIG.path['getAskForNewFriend'], method: 'GET', data: params);
  if (null != res) {
    // List<FriendGroup> newItems = res['data'].map<FriendGroup>((item) => FriendGroup.fromJson(item)).toList();
    return res;
  } 
}

Future toApplyForFriend({Map<String, dynamic> params}) async {
  print(params);
  var res = await DioApi.request(path: CONFIG.path['toApplyForFriend'], method: 'POST', data: params);
  if (null != res) {
    return res;
  }
}

Future toPassFriendApply({Map<String, dynamic> params}) async {
  print(params);
  var res = await DioApi.request(path: CONFIG.path['toPassFriendApply'], method: 'GET', data: params);
  if (null != res) {
    return res;
  } 
}

Future creatTeam({Map<String, dynamic> params}) async {
  print(params);
  var res = await DioApi.request(path: CONFIG.path['creatTeam'], method: 'POST', data: params);
  if (null != res) {
    return res;
  }
}

Future editTeam({Map<String, dynamic> params}) async {
  print(params);
  var res = await DioApi.request(path: CONFIG.path['editTeam'], method: 'POST', data: params);
  if (null != res) {
    return res;
  }
}

Future getApplyTeamUser({Map<String, dynamic> params}) async {
  print(params);
  var res = await DioApi.request(path: CONFIG.path['getApplyTeamUser'], method: 'GET', data: params);
  if (null != res) {
    return res;
  }
}

Future toAddOrDelApplyTeamUser({Map<String, dynamic> params}) async {
  print(params);
  var res = await DioApi.request(path: CONFIG.path['toAddOrDelApplyTeamUser'], method: 'POST', data: params);
  if (null != res) {
    return res;
  }
}

// 解散团队
Future disbandUserTeam({Map<String, dynamic> params}) async {
  print(params);
  // var data = {'team_id': this.teamInfo.id};
  var res = await DioApi.request(path: CONFIG.path['disbandUserTeam'], method: 'POST', data: params);
  if (null != res) {
    return res;
  }
}

// 开除团队
Future dismissTeamUser({Map<String, dynamic> params}) async {
  print(params);
  // var data = {'team_id': this.teamInfo.id};
  var res = await DioApi.request(path: CONFIG.path['dismissTeamUser'], method: 'POST', data: params);
  if (null != res) {
    return res;
  }
}

// 退出团队
Future quitUserTeam({Map<String, dynamic> params}) async {
  print(params);
  // var data = {'team_id': this.teamInfo.id};
  var res = await DioApi.request(path: CONFIG.path['quitUserTeam'], method: 'GET', data: params);
  if (null != res) {
    return res;
  } 
}

// 获取用户帐单列表
Future getMyBillList({Map<String, dynamic> params}) async {
  print(params);
  // var data = {'team_id': this.teamInfo.id};
  var res = await DioApi.request(path: CONFIG.path['getMyBillList'], method: 'GET', data: params);
  if (null != res) {
    return res;
  } 
}

// 获取用户收入
Future getMyIncome({Map<String, dynamic> params}) async {
  print(params);
  // var data = {'team_id': this.teamInfo.id};
  var res = await DioApi.request(path: CONFIG.path['getMyIncome'], method: 'GET', data: params);
  if (null != res) {
    return res;
  } 
}

// 绑定银行卡
Future toBindBankCards({Map<String, dynamic> params}) async {
  print(params);
  // var data = {'team_id': this.teamInfo.id};
  var res = await DioApi.request(path: CONFIG.path['toBindBankCards'], method: 'POST', data: params);
  if (null != res) {
    return res;
  } 
}

// 删除银行卡
Future toDeleteBankCard({Map<String, dynamic> params}) async {
  print(params);
  // var data = {'team_id': this.teamInfo.id};
  var res = await DioApi.request(path: CONFIG.path['toDeleteBankCard'], method: 'GET', data: params);
  if (null != res) {
    return res;
  } 
}

// 设置支付密码
Future toSetPassword({Map<String, dynamic> params}) async {
  print(params);
  // var data = {'team_id': this.teamInfo.id};
  var res = await DioApi.request(path: CONFIG.path['toSetPassword'], method: 'POST', data: params);
  if (null != res) {
    return res;
  } 
}

// 验证支付密码
Future toVerifyPassword({Map<String, dynamic> params}) async {
  print(params);
  // var data = {'team_id': this.teamInfo.id};
  var res = await DioApi.request(path: CONFIG.path['toVerifyPassword'], method: 'POST', data: params);
  if (null != res) {
    return res;
  } 
}

// 修改支付密码
Future toUpdatePassword({Map<String, dynamic> params}) async {
  print(params);
  // var data = {'team_id': this.teamInfo.id};
  var res = await DioApi.request(path: CONFIG.path['toUpdatePassword'], method: 'POST', data: params);
  if (null != res) {
    return res;
  } 
}

// 申请加入团队
Future toJoinTeam({Map<String, dynamic> params}) async {
  print(params);
  // var data = {'team_id': this.teamInfo.id};
  var res = await DioApi.request(path: CONFIG.path['toJoinTeam'], method: 'POST', data: params);
  if (null != res) {
    return res;
  } 
}

// 提现
Future toPostWithdraw({Map<String, dynamic> params}) async {
  print(params);
  // var data = {'team_id': this.teamInfo.id};
  var res = await DioApi.request(path: CONFIG.path['toPostWithdraw'], method: 'POST', data: params);
  if (null != res) {
    return res;
  } 
}

// 取消收藏
Future toDelFavorite({Map<String, dynamic> params}) async {
  String pathName;
  if (params['navigateTo'] == '/companyDetail') {
    pathName = 'toDelFavoriteCompany';
  }
  else if (params['navigateTo'] == '/missionDetail') {
    pathName = 'toDelFavoriteMission';
  }
  else if (params['navigateTo'] == '/skillDetail') {
    pathName = 'toDelFavoriteSkill';
  }
  else if (params['navigateTo'] == '/articleDetail') {
    pathName = 'toDelFavoriteArticle';
  }
  else {
    pathName = 'toDelFavoriteTeam';
  }
  
  print(params);
  // var data = {'team_id': this.teamInfo.id};
  var res = await DioApi.request(path: CONFIG.path[pathName], method: 'GET', data: params);
  if (null != res) {
    return res;
  } 
}