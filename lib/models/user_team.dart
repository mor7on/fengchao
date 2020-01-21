import 'dart:convert';

import 'package:fengchao/common/config/config.dart';
import 'package:fengchao/models/user_entity.dart';

class UserTeam {
  int id;
  int postType;
  int userId;
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
  String postTitle;
  int postIndustry;
  String compAddress;
  String postAddress;
  String postKeywords;
  String postExcerpt;
  String thumbnail;
  String postContent;
  String more;
  List<String> imageList;
  List<TeamUsers> teamUsers;

  UserTeam(
      {this.id,
      this.postType,
      this.userId,
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
      this.postTitle,
      this.postIndustry,
      this.compAddress,
      this.postAddress,
      this.postKeywords,
      this.postExcerpt,
      this.thumbnail,
      this.postContent,
      this.more,
      this.teamUsers});

  UserTeam.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    postType = json['post_type'];
    userId = json['user_id'];
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
    postIndustry = json['post_industry'];
    compAddress = json['comp_address'];
    postAddress = json['post_address'];
    postKeywords = json['post_keywords'];
    postExcerpt = json['post_excerpt'];
    thumbnail = json['thumbnail'];
    postContent = json['post_content'];
    more = json['more'];
    if (json['more'] != null) {
      var items = jsonDecode(json['more']);
      if (items.length > 0) {
        imageList = new List<String>();
        items['photos'].forEach((v) {
          imageList.add(CONFIG.BASE_URL + v);
        });
      }
    }
    if (json['teamUsers'] != null) {
      teamUsers = new List<TeamUsers>();
      json['teamUsers'].forEach((v) {
        teamUsers.add(new TeamUsers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['post_type'] = this.postType;
    data['user_id'] = this.userId;
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
    data['post_title'] = this.postTitle;
    data['post_industry'] = this.postIndustry;
    data['comp_address'] = this.compAddress;
    data['post_address'] = this.postAddress;
    data['post_keywords'] = this.postKeywords;
    data['post_excerpt'] = this.postExcerpt;
    data['thumbnail'] = this.thumbnail;
    data['post_content'] = this.postContent;
    data['more'] = this.more;
    data['imageList'] = this.imageList;
    if (this.teamUsers != null) {
      data['teamUsers'] = this.teamUsers.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TeamUsers {
  int id;
  int teamId;
  int userId;
  String createTime;
  User user;

  TeamUsers({this.id, this.teamId, this.userId, this.createTime, this.user});

  TeamUsers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    teamId = json['team_id'];
    userId = json['user_id'];
    createTime = json['create_time'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['team_id'] = this.teamId;
    data['user_id'] = this.userId;
    data['create_time'] = this.createTime;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }
}

