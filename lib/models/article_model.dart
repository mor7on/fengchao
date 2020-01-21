import 'dart:convert';

import 'custom_entity_list.dart';
import 'user_entity.dart';
import 'user_team.dart';

class ArticleModel {
  int id;
  int postType;
  int type;
  User user;
  int postStatus;
  int commentStatus;
  int isTop;
  int recommended;
  int postHits;
  int postFavorites;
  int postLike;
  int commentCount;
  String createTime;
  String updateTime;
  String publishedTime;
  String deleteTime;
  String expiredTime;
  String postTitle;
  int postIndustry;
  String compAddress;
  String postAddress;
  String postKeywords;
  String postExcerpt;
  String postSalary;
  int state;
  int enroll;
  int bailId;
  Bail bail;
  int areaId;
  String thumbnail;
  String postContent;
  String postContentFiltered;
  String more;
  List<dynamic> imageList;
  bool isthumbs;
  int categoryId;
  List<Thumbs> thumbs;
  List<Comment> leaves;
  List<TeamUsers> teamUsers;

  ArticleModel({
    this.id,
    this.postType,
    this.type,
    this.user,
    this.postStatus,
    this.commentStatus,
    this.isTop,
    this.recommended,
    this.postHits,
    this.postFavorites,
    this.postLike,
    this.commentCount,
    this.createTime,
    this.updateTime,
    this.publishedTime,
    this.deleteTime,
    this.expiredTime,
    this.postTitle,
    this.postIndustry,
    this.compAddress,
    this.postAddress,
    this.postKeywords,
    this.postExcerpt,
    this.postSalary,
    this.state,
    this.enroll,
    this.bailId,
    this.bail,
    this.areaId,
    this.thumbnail,
    this.postContent,
    this.postContentFiltered,
    this.more,
    this.imageList,
    this.isthumbs,
    this.categoryId,
    this.thumbs,
    this.leaves,
    this.teamUsers,
  });

  ArticleModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    postType = json['post_type'];
    type = json['type'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    postStatus = json['post_status'];
    commentStatus = json['comment_status'];
    isTop = json['is_top'];
    recommended = json['recommended'];
    postHits = json['post_hits'];
    postFavorites = json['post_favorites'];
    postLike = json['post_like'];
    commentCount = json['comment_count'];
    createTime = json['create_time'];
    updateTime = json['update_time'];
    publishedTime = json['published_time'];
    deleteTime = json['delete_time'];
    expiredTime = json['expired_time'];
    postTitle = json['post_title'];
    if (json['post_industry'] != null && json['post_industry'] != '') {
      postIndustry =
          json['post_industry'].runtimeType == String ? int.parse(json['post_industry']) : json['post_industry'];
    }
    compAddress = json['comp_address'];
    postAddress = json['post_address'];
    postKeywords = json['post_keywords'];
    postExcerpt = json['post_excerpt'];
    postSalary = json['post_salary'];
    thumbnail = json['thumbnail'];
    postContent = json['post_content'];
    more = json['more'];
    state = json['state'];
    enroll = json['enroll'];
    bailId = json['bail_id'];
    bail = json['bail'] != null ? new Bail.fromJson(json['bail']) : null;
    areaId = json['area_id'];
    postContentFiltered = json['post_content_filtered'];
    more = json['more'];
    imageList = jsonDecode(json['more'])['photos'];
    categoryId = json['category_id'];
    if (json['thumbs'] != null) {
      thumbs = new List<Thumbs>();
      json['thumbs'].forEach((v) {
        thumbs.add(new Thumbs.fromJson(v));
      });
    }
    isthumbs = json['isthumbs'];
    if (json['leaves'] != null) {
      leaves = new List<Comment>();
      json['leaves'].forEach((v) {
        leaves.add(new Comment.fromJson(v));
      });
    }
    if (json['teamUsers'] != null) {
      teamUsers = new List<TeamUsers>();
      json['teamUsers'].forEach((v) {
        teamUsers.add(new TeamUsers.fromJson(v));
      });
    }
  }

  ArticleModel.fromMap(Map<String, dynamic> json) {
    id = json['id'];
    postType = json['post_type'];
    type = json['type'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    postStatus = json['post_status'];
    commentStatus = json['comment_status'];
    isTop = json['is_top'];
    recommended = json['recommended'];
    postHits = json['post_hits'];
    postFavorites = json['post_favorites'];
    postLike = json['post_like'];
    commentCount = json['comment_count'];
    createTime = json['create_time'];
    updateTime = json['update_time'];
    publishedTime = json['published_time'];
    deleteTime = json['delete_time'];
    postTitle = json['post_title'];
    if (json['post_industry'] != null) {
      postIndustry =
          json['post_industry'].runtimeType == String ? int.parse(json['post_industry']) : json['post_industry'];
    }
    compAddress = json['comp_address'];
    postAddress = json['post_address'];
    postKeywords = publishIndust[postIndustry].label.replaceAll(new RegExp(r'\|'), ',');
    postExcerpt = json['post_excerpt'];
    thumbnail = json['thumbnail'];
    postContent = json['post_content'];
    postContentFiltered = json['post_content_filtered'];
    more = json['more'];
    imageList = jsonDecode(json['more'])['photos'];
    isthumbs = json['isthumbs'];
    if (json['leaves'] != null) {
      leaves = new List<Comment>();
      json['leaves'].forEach((v) {
        leaves.add(new Comment.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['post_type'] = this.postType;
    data['type'] = this.type;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    data['post_status'] = this.postStatus;
    data['comment_status'] = this.commentStatus;
    data['is_top'] = this.isTop;
    data['recommended'] = this.recommended;
    data['post_hits'] = this.postHits;
    data['post_favorites'] = this.postFavorites;
    data['post_like'] = this.postLike;
    data['comment_count'] = this.commentCount;
    data['create_time'] = this.createTime;
    data['update_time'] = this.updateTime;
    data['published_time'] = this.publishedTime;
    data['delete_time'] = this.deleteTime;
    data['expired_time'] = this.expiredTime;
    data['post_title'] = this.postTitle;
    data['post_industry'] = this.postIndustry;
    data['comp_address'] = this.compAddress;
    data['post_address'] = this.postAddress;
    data['post_keywords'] = this.postKeywords;
    data['post_excerpt'] = this.postExcerpt;
    data['thumbnail'] = this.thumbnail;
    data['post_salary'] = this.postSalary;
    data['state'] = this.state;
    data['enroll'] = this.enroll;
    data['bail_id'] = this.bailId;
    if (this.bail != null) {
      data['bail'] = this.bail.toJson();
    }
    data['area_id'] = this.areaId;
    data['post_content'] = this.postContent;
    data['post_content_filtered'] = this.postContentFiltered;
    data['more'] = this.more;
    data['imageList'] = this.imageList;
    data['isthumbs'] = this.isthumbs;
    if (this.leaves != null) {
      data['leaves'] = this.leaves.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Comment {
  int id;
  int userId;
  int companyId;
  int postId;
  String content;
  String createTime;
  int discussId;
  int parentId;
  String deleteTime;
  User user;
  User discussUser;

  Comment({
    this.id,
    this.userId,
    this.companyId,
    this.postId,
    this.content,
    this.createTime,
    this.discussId,
    this.parentId,
    this.deleteTime,
    this.user,
    this.discussUser,
  });

  Comment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    companyId = json['company_id'];
    postId = json['post_id'];
    content = json['content'];
    createTime = json['create_time'];
    discussId = json['discuss_id'];
    parentId = json['parent_id'];
    deleteTime = json['delete_time'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    discussUser = json['discuss_user'] != null ? new User.fromJson(json['discuss_user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['company_id'] = this.companyId;
    data['post_id'] = this.postId;
    data['content'] = this.content;
    data['create_time'] = this.createTime;
    data['discuss_id'] = this.discussId;
    data['parent_id'] = this.parentId;
    data['delete_time'] = this.deleteTime;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    if (this.discussUser != null) {
      data['discuss_user'] = this.discussUser.toJson();
    }
    return data;
  }
}

class Bail {
  int id;
  int userId;
  int taskId;
  String coin;
  int state;
  String createTime;

  Bail({
    this.id,
    this.userId,
    this.taskId,
    this.coin,
    this.state,
    this.createTime,
  });

  Bail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    taskId = json['task_id'];
    coin = json['coin'];
    state = json['state'];
    createTime = json['create_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['task_id'] = this.taskId;
    data['coin'] = this.coin;
    data['state'] = this.state;
    data['create_time'] = this.createTime;
    return data;
  }
}

class Thumbs {
  int id;
  int userId;
  String createTime;
  int postId;
  User user;

  Thumbs({this.id, this.userId, this.createTime, this.postId, this.user});

  Thumbs.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    createTime = json['create_time'];
    postId = json['post_id'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['create_time'] = this.createTime;
    data['post_id'] = this.postId;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }
}