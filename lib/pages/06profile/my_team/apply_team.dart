import 'package:fengchao/common/api/06_user_profile_fun.dart';
import 'package:fengchao/models/apply_team_user.dart';
import 'package:fengchao/models/user_entity.dart';
import 'package:fengchao/pages/widgets/custom_appbar.dart';
import 'package:fengchao/provider/login_user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ApplyTeamComponent extends StatefulWidget {
  ApplyTeamComponent({Key key, this.arguments}) : super(key: key);
  final Map<String, dynamic> arguments;

  @override
  _ApplyTeamComponentState createState() => _ApplyTeamComponentState();
}

class _ApplyTeamComponentState extends State<ApplyTeamComponent> {
  List<ApplyTeamUser> _applyUser;

  @override
  void initState() {
    super.initState();
    initUserData();
  }

  initUserData() async {
    await Future.delayed(Duration(milliseconds: 200), () async {
      Map<String, dynamic> res = await getApplyTeamUser(params: widget.arguments);
      if (null != res) {
        if (res['data'] != null && res['data'].length > 0) {
          _applyUser = [];
          for (var item in res['data']) {
            _applyUser.add(ApplyTeamUser.fromJson(item));
          }
        }
      }
    });
    if (mounted) {
      setState(() {});
    }
  }

  /// 同意及拒绝团队申请 state: 2 拒绝，1 同意
  Future _toAddOrDelApplyTeamUser(index, state) async {
    var res = await toAddOrDelApplyTeamUser(params: {'id': _applyUser[index].id, 'state': state});
    print(res);
    if (null != res) {
      if (res['data'] == true) {
        setState(() {
          _applyUser.removeAt(index);
        });
        Provider.of<LoginUserModel>(context).fetchApplyUser();
        if (state == 1) {
          Provider.of<LoginUserModel>(context).fetchUserTeam();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text('队员申请'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.0),
            child: Text('申请加入团队的用户'),
          ),
          null == _applyUser || _applyUser.isEmpty
              ? Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.0),
                  margin: EdgeInsets.all(16.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5.0)),
                  child: Text('暂无队员申请'),
                )
              : _buildListView()
        ],
      ),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: EdgeInsets.all(16.0),
      shrinkWrap: true,
      itemCount: _applyUser.length,
      itemBuilder: (context, index) {
        return Container(
          child: Column(
            children: <Widget>[
              ListTile(
                dense: true,
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(_applyUser[index].user.avatar),
                ),
                title: Text(_applyUser[index].user.userNickname),
                subtitle: Text(
                  _applyUser[index].message ?? '这家伙很懒什么都没有留下',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Container(
                  width: 100.0,
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 50.0,
                        child: FlatButton(
                          padding: EdgeInsets.zero,
                          child: Text('拒绝'),
                          onPressed: () {
                            _toAddOrDelApplyTeamUser(index, 2);
                          },
                        ),
                      ),
                      Container(
                        width: 50.0,
                        child: FlatButton(
                          padding: EdgeInsets.zero,
                          child: Text('确定'),
                          onPressed: () {
                            _toAddOrDelApplyTeamUser(index, 1);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(),
            ],
          ),
        );
      },
    );
  }
}
