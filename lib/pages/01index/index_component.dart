
import 'package:fengchao/common/api/01_index_component_fun.dart';
import 'package:fengchao/models/article_model.dart';
import 'package:fengchao/models/home_red_dot.dart';
import 'package:fengchao/pages/widgets/custom_appbar.dart';
import 'package:fengchao/pages/widgets/custom_loading_widget.dart';
import 'package:fengchao/pages/widgets/custom_media_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:provider/provider.dart';

class IndexComponent extends StatelessWidget {
  IndexComponent({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('重建IndexComponent页面--------------------');
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(FlutterI18n.translate(context, "appName")),
        actions: <Widget>[
          IconButtonWithBG(
            icon: Icon(Icons.next_week, size: 16.0),
            onTap: () {
              Navigator.pushNamed(context, '/missionCenter');
            },
          ),
          Consumer<HomeRedDot>(
            builder: (context, model, _) {
              return IconButtonWithBG(
                icon: Icon(Icons.notifications, size: 16.0),
                showDot: model.showChatDot,
                onTap: () {
                  Navigator.pushNamed(context, '/chatBoxInfo');
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            IndexHeaderComponent(),
            IndexSwiperComponent(),
            IndexMissionRecommend(),
          ],
        ),
      ),
    );
  }
}

class IconButtonWithBG extends StatelessWidget {
  final Widget icon;
  final VoidCallback onTap;
  final bool showDot;
  const IconButtonWithBG({
    Key key,
    this.icon,
    this.onTap,
    this.showDot = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Stack(
        children: <Widget>[
          Center(
            child: Container(
              width: 32.0,
              height: 32.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32.0),
                child: Container(
                  color: Colors.black54,
                  child: IconButton(
                    iconSize: 20.0,
                    color: Colors.white,
                    padding: EdgeInsets.all(0.0),
                    icon: icon,
                    onPressed: onTap,
                  ),
                ),
              ),
            ),
          ),
          showDot
              ? Positioned(
                  top: 8.0,
                  right: 2.0,
                  child: Container(
                    width: 8.0,
                    height: 8.0,
                    decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(8.0)),
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}

class IndexHeaderComponent extends StatelessWidget {
  const IndexHeaderComponent({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200.0,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomLeft,
          tileMode: TileMode.clamp,
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).scaffoldBackgroundColor,
          ],
        ),
      ),
      child: Column(
        children: <Widget>[
          Container(
              width: double.infinity,
              height: 80.0,
              margin: EdgeInsets.symmetric(horizontal: 16.0),
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                children: <Widget>[
                  IconNavigatorButton(
                    title: '扫一扫',
                    icon: Icons.crop_free,
                    backgroundSize: 40.0,
                    titleSize: 12.0,
                    onClick: () {
                      Navigator.pushNamed(context, '/qrScan');
                    },
                  ),
                  IconNavigatorButton(
                    title: '大礼包',
                    icon: Icons.card_giftcard,
                    backgroundSize: 40.0,
                    titleSize: 12.0,
                    onClick: () {},
                  ),
                  Consumer<HomeRedDot>(
                    builder: (context, homeRedDot, _) {
                      return IconNavigatorButton(
                        title: '站内信',
                        icon: Icons.mail_outline,
                        backgroundSize: 40.0,
                        titleSize: 12.0,
                        showRedDot: homeRedDot.showInboxDot,
                        onClick: () {
                          Navigator.pushNamed(context, '/inboxInfo');
                        },
                      );
                    },
                  ),
                  IconNavigatorButton(
                    title: '用户须知',
                    icon: Icons.sync_problem,
                    backgroundSize: 40.0,
                    titleSize: 12.0,
                    onClick: () {
                      // Provider.of<HomeRedDot>(context, listen: false).changeChatDot();
                      Navigator.pushNamed(context, '/userInstro');
                    },
                  ),
                ],
              )),
          Container(
            width: double.infinity,
            height: 120.0,
            margin: EdgeInsets.symmetric(horizontal: 16.0),
            padding: EdgeInsets.symmetric(vertical: 20.0),
            decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16.0))),
            child: Row(
              children: <Widget>[
                IconNavigatorButton(
                  title: '找合作',
                  backgroundColor: Colors.blueGrey[200],
                  icon: Icons.headset_mic,
                  onClick: () {
                    Navigator.pushNamed(context, '/companyList');
                  },
                ),
                IconNavigatorButton(
                  title: '淘任务',
                  backgroundColor: Colors.blue[200],
                  icon: Icons.card_travel,
                  onClick: () {
                    Navigator.pushNamed(context, '/missionList');
                  },
                ),
                IconNavigatorButton(
                  title: '找精英',
                  backgroundColor: Colors.deepPurple[200],
                  icon: Icons.people_outline,
                  onClick: () {
                    Navigator.pushNamed(context, '/skillList');
                  },
                ),
                IconNavigatorButton(
                  title: '蜂巢圈',
                  backgroundColor: Colors.brown[200],
                  icon: Icons.public,
                  onClick: () {
                    Navigator.pushNamed(context, '/socialList');
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class IndexSwiperComponent extends StatefulWidget {
  IndexSwiperComponent({Key key}) : super(key: key);

  _IndexSwiperComponentState createState() => _IndexSwiperComponentState();
}

class _IndexSwiperComponentState extends State<IndexSwiperComponent> {
  final List<String> images = [
    "assets/images/ad01.jpg",
    "assets/images/ad02.jpg",
    "assets/images/ad03.jpg",
    "assets/images/ad04.jpg",
    "assets/images/ad05.jpg",
    "assets/images/ad06.jpg",
    "assets/images/ad07.jpg",
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 120.0,
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: ClipRRect(
        borderRadius: new BorderRadius.all(new Radius.circular(8.0)),
        child: new Swiper(
          itemBuilder: (BuildContext context, int index) {
            return Image.asset(
              images[index],
              fit: BoxFit.fill,
            );
          },
          autoplay: true,
          itemCount: 7,
          pagination: new SwiperPagination(),
          control: new SwiperControl(),
        ),
      ),
    );
  }
}

class IndexMissionRecommend extends StatefulWidget {
  IndexMissionRecommend({Key key}) : super(key: key);

  _IndexMissionRecommendState createState() => _IndexMissionRecommendState();
}

class _IndexMissionRecommendState extends State<IndexMissionRecommend> with AutomaticKeepAliveClientMixin {
  List<ArticleModel> _result;

  @override
  void initState() {
    super.initState();
    initUserData();
  }

  initUserData() async {
    await Future.delayed(Duration.zero, () async {
      var res = await getRecommendMissions();
      if (null != res) {
        _result = [];
        res['data'].forEach((v){
          _result.add(ArticleModel.fromJson(v));
        });
      }
    });
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: _result == null
            ? [
                Container(
                  width: double.infinity,
                  height: 200.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 50.0,
                        height: 50.0,
                        child: SpinKitCircle(
                          color: Colors.blue,
                          size: 25.0,
                        ),
                      ),
                      Container(
                        child: Text('正在加载...', style: TextStyle(fontSize: 12.0, color: Color(0xFF999999))),
                      )
                    ],
                  ),
                ),
              ]
            : _result.length == 0
                ? [CustomEmptyWidget()]
                : _result.map((item) {
                    return CustomMediaCard(
                      item: item,
                      navigatorName: '/missionDetail',
                    );
                  }).toList(),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class IconNavigatorButton extends StatelessWidget {
  final String title;
  final Color backgroundColor;
  final IconData icon;
  final Color iconColor;
  final double backgroundSize;
  final double iconSize;
  final double titleSize;
  final String navigateName;
  final VoidCallback onClick;
  final bool showRedDot;

  const IconNavigatorButton(
      {Key key,
      this.title,
      this.backgroundColor = Colors.transparent,
      this.iconColor,
      this.backgroundSize = 50.0,
      this.iconSize = 32.0,
      this.titleSize = 10.0,
      this.navigateName,
      this.onClick,
      this.showRedDot = false,
      this.icon = Icons.headset_mic})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Stack(
        children: <Widget>[
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: backgroundSize,
                  height: backgroundSize,
                  decoration:
                      BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  child: Stack(
                    alignment: AlignmentDirectional.center,
                    children: <Widget>[
                      Icon(
                        icon,
                        size: iconSize,
                      ),
                      Positioned(
                        right: 0.0,
                        top: 0.0,
                        child: Container(
                          width: 8.0,
                          height: 8.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: showRedDot ? Colors.red : Colors.transparent,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Text(title, style: TextStyle(fontSize: titleSize))
              ],
            ),
          ),
          Positioned.fill(
            child: InkWell(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(4.0),
                  splashColor: Colors.blueGrey.withOpacity(0.2),
                  highlightColor: Colors.blueGrey.withOpacity(0.1),
                  onTap: onClick,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
