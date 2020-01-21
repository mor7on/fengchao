import 'dart:convert';
import 'package:fengchao/common/api/http_request.dart';
import 'package:fengchao/common/config/config.dart';

Future getSocialList({Map<String, dynamic> params}) async {
  var res = await DioApi.request(path: CONFIG.path['getSocialList'], method: 'GET', data: params);
  if (null != res) {
    var items = res['data'];
    var newItems = new List();
    for (int i = 0; i < items.length; i++) {
      var more = json.decode(items[i]['thumbnail']);

      newItems.add({
        'id': items[i]['id'],
        'user_id': items[i]['user_id'],
        'post_title': items[i]['name'],
        'description': items[i]['description'],
        'post_count': items[i]['post_count'],
        'cate_favorites': items[i]['cate_favorites'],
        'post_keywords': items[i]['post_keywords'],
        'create_time': items[i]['create_time'],
        'is_follow': items[i]['isfollow'] == 1 ? true : false,
        'is_recommended': items[i]['recommended'] == 1 ? true : false,
        'imageUrl': more != null && more['photos'].length != 0 ? CONFIG.BASE_URL + more['photos'][0] : 'http://5b0988e595225.cdn.sohucs.com/images/20190306/d7ac11378a6e446aab6fae04494c8301.gif',
      });
    }
    return newItems;
  } 
}

Future getSocialPostById({Map<String, dynamic> params}) async {
  var res = await DioApi.request(path: CONFIG.path['getSocialPostById'], method: 'GET', data: params);
  if (null != res) {

    return res;
  }
}

Future getSocialById({Map<String, dynamic> params}) async {
  var res = await DioApi.request(path: CONFIG.path['getSocialById'], method: 'GET', data: params);
  if (null != res) {

    return res;
  } 
}

Future getArticleById({Map<String, dynamic> params}) async {
  var res = await DioApi.request(path: CONFIG.path['getArticleById'], method: 'GET', data: params);
  if (null != res) {

    return res;
  } 
}

Future getUserSocialList({Map<String, dynamic> params}) async {
  var res = await DioApi.request(path: CONFIG.path['getUserSocialList'], method: 'GET', data: params);
  if (null != res) {
    var items = res['data'];
    var newItems = new List();
    for (int i = 0; i < items.length; i++) {
      var more = json.decode(items[i]['thumbnail']);
      Map item = {
        'id': items[i]['id'],
        'title': items[i]['name'],
        'content': items[i]['description'],
        'create_time': items[i]['create_time'],
        'is_follow': items[i]['isfollow'] == 1 ? true : false,
        'is_recommended': items[i]['recommended'] == 1 ? true : false,
        'imageUrl': more != null && more['photos'].length != 0 ? CONFIG.BASE_URL + more['photos'][0] : null,
      };

      newItems.add(item);
    }
    return newItems;
  }
}

Future toCancleUserFollow({Map<String, dynamic> params}) async {
  var res = await DioApi.request(path: CONFIG.path['toCancleUserFollow'], method: 'GET', data: params);
  if (null != res) {

    return res;
  } 
}


Future addSocial({Map<String, dynamic> params}) async {
  print(params);
  var res = await DioApi.request(path: CONFIG.path['addSocial'], method: 'POST', data: params);
  if (null != res) {
    
    return res;
  } 
}

Future addSocialPost({Map<String, dynamic> params}) async {
  print(params);
  var res = await DioApi.request(path: CONFIG.path['addSocialPost'], method: 'POST', data: params);
  if (null != res) {
    
    return res;
  } 
}

Future editSocial({Map<String, dynamic> params}) async {
  print(params);
  var res = await DioApi.request(path: CONFIG.path['editSocial'], method: 'POST', data: params);
  if (null != res) {
    //{code: 1, msg: 更新失败, data: false}
    return res;
  }
}

Future editSocialPost({Map<String, dynamic> params}) async {
  print(params);
  var res = await DioApi.request(path: CONFIG.path['editSocialPost'], method: 'POST', data: params);
  if (null != res) {
    //{code: 1, msg: 更新失败, data: false}
    return res;
  }
}

Future deleteSocial({Map<String, dynamic> params}) async {
  var res = await DioApi.request(path: CONFIG.path['deleteSocial'], method: 'GET', data: params);
  if (null != res) {
    //{code: 1, msg: 删除成功, data: true}
    return res;
  }
}

Future delArticleById({Map<String, dynamic> params}) async {
  var res = await DioApi.request(path: CONFIG.path['delArticleById'], method: 'GET', data: params);
  if (null != res) {
    //{code: 1, msg: 删除成功, data: true}
    return res;
  }
}

Future doArticleThumb({Map<String, dynamic> params}) async {
  var res = await DioApi.request(path: CONFIG.path['doArticleThumb'], method: 'GET', data: params);
  if (null != res) {
    //{code: 1, msg: 删除成功, data: true}
    return res;
  }
}


Future toArticleReply({Map<String, dynamic> params}) async {
  var res = await DioApi.request(path: CONFIG.path['toArticleReply'], method: 'POST', data: params);
  if (null != res) {
    
    return res;
  }
}

Future doArticleFavorate({Map<String, dynamic> params}) async {
  var res = await DioApi.request(path: CONFIG.path['doArticleFavorate'], method: 'GET', data: params);
  if (null != res) {
    //{code: 1, msg: 删除成功, data: 1收藏成功，2重复收藏}
    return res;
  }
}

Future getArticleComments({Map<String, dynamic> params}) async {
  var res = await DioApi.request(path: CONFIG.path['getArticleComments'], method: 'GET', data: params);
  if (null != res) {
    
    return res;
  }
}

Future toFavoriteSocial({Map<String, dynamic> params}) async {
  var res = await DioApi.request(path: CONFIG.path['toFavoriteSocial'], method: 'GET', data: params);
  if (null != res) {
    //{code: 1, msg: 删除成功, data: 1收藏成功，2重复收藏}
    return res;
  }
}