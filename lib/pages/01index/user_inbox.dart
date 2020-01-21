import 'package:fengchao/common/api/01_index_component_fun.dart';
import 'package:fengchao/common/config/config.dart';
import 'package:fengchao/models/inbox.dart';
import 'package:fengchao/pages/widgets/custom_appbar.dart';
import 'package:fengchao/pages/widgets/custom_loading_widget.dart';
import 'package:fengchao/pages/widgets/loading_widget.dart';
import 'package:flutter/material.dart';

class UserInboxComponent extends StatefulWidget {
  UserInboxComponent({Key key}) : super(key: key);

  @override
  _UserInboxComponentState createState() => _UserInboxComponentState();
}

class _UserInboxComponentState extends State<UserInboxComponent> {
  List<Inbox> _inboxList;

  @override
  void initState() {
    super.initState();
    _initUserData();
  }

  void _initUserData() async {
    Map<String, dynamic> res = await getInboxInfo();
    print(res);
    if (res['code'] == 1) {
      _inboxList = [];
      for (var item in res['data']) {
        _inboxList.add(Inbox.fromJson(item));
      }
      if (mounted) {
        setState(() {});
      }
    }
  }

  Future _toSetReaded(id) async {
    var res = await toSetInboxReaded(params: {'id': id});
    print(res);
    if (null != res) {
      if (res['data'] == true) {
        _initUserData();
      }
    }
  }

  Future _toDelInboxInfo(id) async {
    var res = await delInboxInfo(params: {'id': id});
    print(res);
    if (null != res) {
      if (res['data'] == true) {
        _initUserData();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text('收件箱'),
      ),
      body: _inboxList == null
          ? loadWidget
          : _inboxList.length == 0
              ? CustomEmptyWidget()
              : ListView.builder(
                  itemCount: _inboxList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            color: _inboxList[index].state == 0 ? Colors.blueGrey[50] : Colors.white,
                            child: ListTile(
                              dense: true,
                              leading: Icon(
                                _inboxList[index].state == 0
                                ? Icons.mail : Icons.drafts
                              ),
                              title: Text(_inboxList[index].title),
                              subtitle: Text(
                                _inboxList[index].message,
                              ),
                              trailing: Container(
                                width: 100.0,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Container(
                                      width: 50.0,
                                      height: 30.0,
                                      child: FlatButton(
                                        padding: EdgeInsets.zero,
                                        child: Text('删除'),
                                        onPressed: () {
                                          _toDelInboxInfo(_inboxList[index].id);
                                        },
                                      ),
                                    ),
                                    _inboxList[index].state == 0
                                        ? Container(
                                            width: 50.0,
                                            height: 30.0,
                                            child: FlatButton(
                                              padding: EdgeInsets.zero,
                                              child: Text('已读'),
                                              onPressed: () {
                                                _toSetReaded(_inboxList[index].id);
                                              },
                                            ),
                                          )
                                        : Container(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Divider(
                            height: 2.0,
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
