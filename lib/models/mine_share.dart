import 'dart:convert';

import 'package:fengchao/common/config/config.dart';

class MineShare {
  int id;
  int postType;
  int postFormat;
  int userId;
  int postStatus;
  int commentStatus;
  int isTop;
  int recommended;
  int postFavorites;
  int postLike;
  int commentCount;
  String createTime;
  String updateTime;
  String publishedTime;
  String deleteTime;
  String postTitle;
  String postKeywords;
  String postExcerpt;
  String postContent;
  String more;
  int categoryId;
  String postAddress;
  List<String> imageList;

  MineShare(
      {this.id,
      this.postType,
      this.postFormat,
      this.userId,
      this.postStatus,
      this.commentStatus,
      this.isTop,
      this.recommended,
      this.postFavorites,
      this.postLike,
      this.commentCount,
      this.createTime,
      this.updateTime,
      this.publishedTime,
      this.deleteTime,
      this.postTitle,
      this.postKeywords,
      this.postExcerpt,
      this.postContent,
      this.more,
      this.categoryId,
      this.postAddress,
      this.imageList});

  MineShare.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    postType = json['post_type'];
    postFormat = json['post_format'];
    userId = json['user_id'];
    postStatus = json['post_status'];
    commentStatus = json['comment_status'];
    isTop = json['is_top'];
    recommended = json['recommended'];
    postFavorites = json['post_favorites'];
    postLike = json['post_like'];
    commentCount = json['comment_count'];
    createTime = json['create_time'];
    updateTime = json['update_time'];
    publishedTime = json['published_time'];
    deleteTime = json['delete_time'];
    postTitle = json['post_title'];
    postKeywords = json['post_keywords'];
    postExcerpt = json['post_excerpt'];
    postContent = json['post_content'];
    more = json['more'];
    categoryId = json['category_id'];
    postAddress = json['post_address'];
    if (json['more'] != null) {
      var items = jsonDecode(json['more']);
      if (items.length > 0) {
        imageList = new List<String>();
        items['photos'].forEach((v) {
          imageList.add(CONFIG.BASE_URL + v);
        });
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['post_type'] = this.postType;
    data['post_format'] = this.postFormat;
    data['user_id'] = this.userId;
    data['post_status'] = this.postStatus;
    data['comment_status'] = this.commentStatus;
    data['is_top'] = this.isTop;
    data['recommended'] = this.recommended;
    data['post_favorites'] = this.postFavorites;
    data['post_like'] = this.postLike;
    data['comment_count'] = this.commentCount;
    data['create_time'] = this.createTime;
    data['update_time'] = this.updateTime;
    data['published_time'] = this.publishedTime;
    data['delete_time'] = this.deleteTime;
    data['post_title'] = this.postTitle;
    data['post_keywords'] = this.postKeywords;
    data['post_excerpt'] = this.postExcerpt;
    data['post_content'] = this.postContent;
    data['more'] = this.more;
    data['category_id'] = this.categoryId;
    data['post_address'] = this.postAddress;
    data['imageList'] = this.imageList;
    return data;
  }
}
