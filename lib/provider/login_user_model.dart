import 'package:fengchao/common/api/06_user_profile_fun.dart';
import 'package:fengchao/common/utils/sp_utils.dart';
import 'package:fengchao/models/my_balance.dart';
import 'package:fengchao/models/user_entity.dart';
import 'package:fengchao/models/user_profile_model.dart';
import 'package:fengchao/models/user_team.dart';
import 'package:flutter/material.dart';

class LoginUserModel with ChangeNotifier {
  User _loginUser;
  User get loginUser => _loginUser;

  Balance _myBlance;
  Balance get myblance => _myBlance;

  int _certificateState;
  int get certificateState => _certificateState;

  int _userPassState;
  int get userpassState => _userPassState;

  UserTeam _userTeam;
  UserTeam get userTeam => _userTeam;

  List<User> _applyUser = [];
  List<User> get applyUser => _applyUser;

  List<String> _certifiString = ['审核中', '未通过', '已认证', '未认证'];

  List<UserProfileModel> userProfileList = [
    UserProfileModel(title: "userCertification", icon: 0xe6ac, description: "", showEnterIcon: true),
    UserProfileModel(title: "userFriendDynamic", icon: 0xe6e5, description: "", showEnterIcon: true),
    UserProfileModel(title: "userSkills", icon: 0xe709, description: "", showEnterIcon: true),
    UserProfileModel(title: "userFavorite", icon: 0xe70c, description: "", showEnterIcon: true),
    UserProfileModel(title: "userShare", icon: 0xe701, description: "", showEnterIcon: true),
    UserProfileModel(title: "userNewFriends", icon: 0xe6e3, description: "", showEnterIcon: true),
    UserProfileModel(title: "userFriends", icon: 0xe71c, description: "", showEnterIcon: true),
    UserProfileModel(title: "userTeam", icon: 0xe703, description: "", showEnterIcon: true),
    UserProfileModel(title: "userWallet", icon: 0xe726, description: "", showEnterIcon: true),
    UserProfileModel(title: "userSysOption", icon: 0xe732, description: "", showEnterIcon: true),
  ];

  void init() async {
    int loginId = SpUtil.getInt('xxUserId');
    List<dynamic> res = await Future.wait([
      getUserInfo(),
      getUserCertificate(),
      getUserPassState(),
      getTeamByUserId(params: {'user_id': loginId})
    ]);
    if (null != res[0]) {
      _loginUser = User.fromJson(res[0]['data']);
    }
    if (null != res[1]) {
      _certificateState = int.parse(res[1]['data']['state']);
      userProfileList[0].description = _certifiString[_certificateState];
    }
    if (null != res[2]) {
      _userPassState = int.parse(res[2]['data']['state']);
    }
    if (null != res[3]) {
      _userTeam = res[3]['data'] == null ? null : UserTeam.fromJson(res[3]['data']);
      if (_userTeam != null) {
        userProfileList[7].description = _userTeam.postTitle;
      }
    }

    notifyListeners();
  }

  void fetchApplyUser() async {
    if (null == _userTeam) return;
    _applyUser = [];
    Map<String, dynamic> res = await getApplyTeamUser(params: {'id': _userTeam.id});
    // print(res);
    if (null != res) {
      if (res['data'] != null) {
        for (var item in res['data']) {
          _applyUser.add(User.fromJson(item));
        }
      }
    }
    notifyListeners();
  }

  void fetchUserTeam() async {
    int loginId = SpUtil.getInt('xxUserId');
    Map<String, dynamic> res = await getTeamByUserId(params: {'user_id': loginId});
    if (null != res) {
      _userTeam = res['data'] == null ? null : UserTeam.fromJson(res[3]['data']);
    }
    notifyListeners();
  }

  void fetchMyBlance() async {
    Map<String, dynamic> res = await getMyBalance();
    if (null != res) {
      _myBlance = res['data'] == null ? null : Balance.fromJson(res['data']);
    }
    notifyListeners();
  }

  void fetchUserInfo() async {
    Map<String, dynamic> res = await getUserInfo();
    if (null != res) {
      _loginUser = User.fromJson(res['data']);
    }
    notifyListeners();
  }

  void fetchUpdatePayPass() async {
    Map<String, dynamic> res = await getUserPassState();
    if (null != res) {
      _userPassState = int.parse(res[2]['data']['state']);
    }
    notifyListeners();
  }

  void fetchDisbandTeam() async {
    _userTeam = null;
    userProfileList[7].description = '';
    notifyListeners();
  }

  void fetchUserCertificate() async {
    var res = await getUserCertificate();
    if (null != res) {
      _certificateState = int.parse(res[1]['data']['state']);
      userProfileList[0].description = _certifiString[_certificateState];
    }
    notifyListeners();
  }
}
