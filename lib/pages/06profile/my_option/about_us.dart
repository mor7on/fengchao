import 'package:fengchao/pages/widgets/custom_appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluwx/fluwx.dart' as fluwx;

class AboutUsComponent extends StatelessWidget {
  const AboutUsComponent({Key key}) : super(key: key);

  final _url = "http://www.4u2000.com/h5/index.html";
  final _title = "蜂巢-ForYou，一个优秀的网络赏金平台；能力有多大，天地就有多宽广。";
  final _thumnail = "http://www.4u2000.com/public/upload/app4u/app_download.png";

  void _showShareSheet({BuildContext context, Widget child}) {
    showCupertinoModalPopup<String>(
      context: context,
      builder: (BuildContext context) => child,
    ).then((String value) {
      if (value == 'SESSION') {
        var share = fluwx.WeChatShareWebPageModel(
            webPage: _url,
            title: _title,
            thumbnail: _thumnail,
            transaction: "text${DateTime.now().millisecondsSinceEpoch}",
            scene: fluwx.WeChatScene.SESSION);
        _shareText(share);
      }
      if (value == 'TIMELINE') {
        var share = fluwx.WeChatShareWebPageModel(
            webPage: _url,
            title: _title,
            thumbnail: _thumnail,
            transaction: "text${DateTime.now().millisecondsSinceEpoch}",
            scene: fluwx.WeChatScene.TIMELINE);
        _shareText(share);
      }
      if (value == 'FAVORITE') {
        var share = fluwx.WeChatShareWebPageModel(
            webPage: _url,
            title: _title,
            thumbnail: _thumnail,
            transaction: "text${DateTime.now().millisecondsSinceEpoch}",
            scene: fluwx.WeChatScene.FAVORITE);
        _shareText(share);
      }
    });
  }

  void _shareText(fluwx.WeChatShareModel model) {
    fluwx.shareToWeChat(model).then((data) {
      print(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text('关于我们'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Container(
                width: 180.0,
                height: 180.0,
                child: Image.network('http://www.4u2000.com/public/upload/app4u/app_download.png'),
              ),
            ),
            Text('扫码体验蜂巢-ForYou'),
            SizedBox(height: 8.0),
            RichText(
              text: TextSpan(text: '"蜂巢-ForYou"', style: TextStyle(color: Colors.deepOrange), children: <InlineSpan>[
                TextSpan(
                  text: '是一个网络',
                  style: Theme.of(context).textTheme.body1,
                ),
                TextSpan(
                  text: '赏金',
                  style: TextStyle(color: Colors.deepOrange),
                ),
                TextSpan(
                  text: '平台，在这个娱乐至上的时代，技术人员如何寻求突破？',
                  style: Theme.of(context).textTheme.body1,
                ),
              ]),
            ),
            SizedBox(height: 8.0),
            Container(alignment: Alignment.centerLeft, child: Text('我们的宗旨：')),
            Container(alignment: Alignment.centerLeft, child: Text('智慧创造财富，科技搭建桥梁')),
            SizedBox(height: 8.0),
            RaisedButton(
              child: Text('分享'),
              onPressed: () {
                _showShareSheet(
                  context: context,
                  child: CupertinoActionSheet(
                    title: const Text('分享'),
                    message: const Text('您要分享到哪里？'),
                    actions: <Widget>[
                      CupertinoActionSheetAction(
                        child: Text(
                          '微信会话',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        onPressed: () {
                          Navigator.pop(context, 'SESSION');
                        },
                      ),
                      CupertinoActionSheetAction(
                        child: const Text(
                          '微信朋友圈',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        onPressed: () {
                          Navigator.pop(context, 'TIMELINE');
                        },
                      ),
                      CupertinoActionSheetAction(
                        child: const Text(
                          '微信收藏',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        onPressed: () {
                          Navigator.pop(context, 'FAVORITE');
                        },
                      ),
                    ],
                    cancelButton: CupertinoActionSheetAction(
                      child: const Text(
                        '取消',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      isDefaultAction: true,
                      onPressed: () {
                        Navigator.pop(context, 'Cancel');
                      },
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 160.0),
            Text(
              '©2011 - 2019 4u2000 All Right Reserved.',
              style: TextStyle(fontSize: 12.0, color: Colors.grey),
            ),
            Text(
              '4u2000.com版权所有',
              style: TextStyle(fontSize: 12.0, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
