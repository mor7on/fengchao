import 'package:bot_toast/bot_toast.dart';
import 'package:fengchao/common/api/04_skill_list_fun.dart';
import 'package:fengchao/common/api/06_user_profile_fun.dart';
import 'package:fengchao/pages/widgets/custom_appbar.dart';
import 'package:fengchao/pages/widgets/custom_loading_widget.dart';
import 'package:fengchao/pages/widgets/custom_toast.dart';
import 'package:fengchao/pages/widgets/loading_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MySkillListComponent extends StatefulWidget {
  MySkillListComponent({Key key}) : super(key: key);

  _MySkillListComponentState createState() => _MySkillListComponentState();
}

class _MySkillListComponentState extends State<MySkillListComponent> {
  int page;
  List _result;

  RefreshController _refreshController;

  @override
  void initState() {
    super.initState();
    page = 0;
    _refreshController = RefreshController(initialRefresh: false);
    initUserData();
  }

  void initUserData() async {
    _result = null;
    await Future.delayed(Duration(milliseconds: 600), () async {
      var res = await getMySkillList(params: {"page": page});
      if (null != res) {
        _result = res;
      }
    });
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _onRefresh() async {
    page = 0;
    var requestParams = {"page": page};
    await Future.delayed(Duration(milliseconds: 600), () {
      getMySkillList(params: requestParams).then((v) {
        if (null != v) {
          _result = v.length > 0 ? v : [];
          setState(() {});
          _refreshController.refreshCompleted();
          _refreshController.resetNoData();
        }
      });
    });
  }

  Future<void> _onLoading() async {
    page += 1;
    var requestParams = {"page": page};
    await getMySkillList(params: requestParams).then((v) {
      if (null != v) {
        setState(() {
          _result.addAll(v);
        });
        _refreshController.loadComplete();
        if (v.length < 10) {
          _refreshController.loadNoData();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text('我的技能'),
      ),
      body: SmartRefresher(
        enablePullDown: false,
        enablePullUp: true,
        header: BezierCircleHeader(
          dismissType: BezierDismissType.ScaleToCenter,
        ),
        footer: CustomFooter(
          builder: (BuildContext context, LoadStatus mode) {
            Widget body;
            if (mode == LoadStatus.idle) {
              body = Text("上拉加载");
            } else if (mode == LoadStatus.loading) {
              body = CupertinoActivityIndicator();
            } else if (mode == LoadStatus.failed) {
              body = Text("加载失败，请重试");
            } else if (mode == LoadStatus.canLoading) {
              body = Text("释放加载");
            } else {
              body = Text("- END -");
            }
            return Container(
              height: 55.0,
              child: Center(child: body),
            );
          },
        ),
        onLoading: _onLoading,
        onRefresh: _onRefresh,
        controller: _refreshController,
        child: _result == null
            ? loadWidget
            : _result.length == 0
                ? CustomEmptyWidget()
                : ListView.builder(
                    padding: EdgeInsets.all(8.0),
                    itemCount: _result.length,
                    itemBuilder: _biuldMySkillList,
                  ),
      ),
    );
  }

  Widget _biuldMySkillList(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/skillDetail', arguments: {'id': _result[index]['id']});
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Text(_result[index]['post_title']),
              ),
              Row(
                children: <Widget>[
                  Icon(Icons.visibility, size: 12.0, color: Colors.blueGrey),
                  Text('${_result[index]['post_hits']}次浏览', style: TextStyle(fontSize: 12.0, color: Colors.blueGrey)),
                  SizedBox(
                    width: 8.0,
                  ),
                  Icon(Icons.center_focus_strong, size: 12.0, color: Colors.blueGrey),
                  Text('${_result[index]['post_favorites']}人收藏',
                      style: TextStyle(fontSize: 12.0, color: Colors.blueGrey)),
                  SizedBox(
                    width: 8.0,
                  ),
                  Icon(Icons.launch, size: 12.0, color: Colors.blueGrey),
                  Text(_result[index]['create_time'], style: TextStyle(fontSize: 12.0, color: Colors.blueGrey)),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: _result[index]['post_keywords'] != null
                          ? _result[index]['post_keywords'].map<Widget>((str) {
                              return Container(
                                margin: EdgeInsets.symmetric(horizontal: 1.0, vertical: 2.0),
                                padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
                                decoration:
                                    BoxDecoration(color: Colors.blueGrey[50], borderRadius: BorderRadius.circular(2.0)),
                                child: Text(str, style: TextStyle(fontSize: 12.0)),
                              );
                            }).toList()
                          : [],
                    ),
                  ),
                  Container(
                    child: IconButton(
                        icon: Icon(Icons.edit),
                        iconSize: 20.0,
                        onPressed: () {
                          Navigator.pushNamed(context, '/skillEdit', arguments: _result[index]);
                        }),
                  ),
                  Container(
                    child: IconButton(
                      icon: Icon(Icons.delete),
                      iconSize: 20.0,
                      onPressed: () {
                        final ThemeData theme = Theme.of(context);
                        final TextStyle dialogTextStyle =
                            theme.textTheme.subhead.copyWith(color: theme.textTheme.caption.color);
                        showCustomDialog<Map<String, dynamic>>(
                          context: context,
                          child: AlertDialog(
                            content: Text(
                              '确定要删除：${_result[index]['post_title']}?',
                              style: dialogTextStyle,
                            ),
                            actions: <Widget>[
                              FlatButton(
                                child: const Text('取消'),
                                onPressed: () {
                                  Navigator.pop(context, {'action': 'cancel'});
                                },
                              ),
                              FlatButton(
                                child: const Text('确定'),
                                onPressed: () {
                                  Navigator.pop(
                                      context, {'action': 'confirm', 'index': index, 'id': _result[index]['id']});
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showCustomDialog<T>({BuildContext context, Widget child}) {
    showDialog<T>(
      context: context,
      builder: (BuildContext context) => child,
    ).then<void>((T value) async {
      // The value passed to Navigator.pop() or null.
      Map<String, dynamic> action = value as Map;

      if (action['action'] == 'confirm') {
        var res = await deleteSkill(params: {'id': action['id']});
        if (null != res) {
          if (res['data'] == true) {
            BotToast.showCustomLoading(
              duration: Duration(milliseconds: 1000),
              toastBuilder: (cancelFunc) {
                return CustomToastWidget(title: '删除成功', icon: Icons.done);
              },
            );
            await Future.delayed(Duration(milliseconds: 1000));
            _result.removeAt(action['index']);
            setState(() {});
          }else {
            print('删除失败');
          }
        }
      }
    });
  }
}
