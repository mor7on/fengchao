import 'package:fengchao/pages/widgets/custom_appbar.dart';
import 'package:fengchao/pages/widgets/mission_tab_view.dart';
import 'package:flutter/material.dart';

class MissionCenterComponent extends StatefulWidget {
  MissionCenterComponent({Key key}) : super(key: key);

  @override
  _MissionCenterComponentState createState() => _MissionCenterComponentState();
}

class _MissionCenterComponentState extends State<MissionCenterComponent> {
  int _index = 0;
  PageController _pageController;
  MissionTabController _todoController;
  MissionTabController _publishController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _todoController = MissionTabController();
    _publishController = MissionTabController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void showMenuSelection(String value) {
    MissionTabController controller;
    if (_index == 0) {
      controller = _todoController;
    } else {
      controller = _publishController;
    }
    switch (value) {
      case 'Todo':
        print('Todo');
        controller.changeMissionState(0);
        break;
      case 'Tender':
        print('Tender');
        controller.changeMissionState(1);
        break;
      case 'Oerate':
        print('Oerate');
        controller.changeMissionState(2);
        break;
      case 'Complete':
        print('Complete');
        controller.changeMissionState(3);
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text('我的任务中心'),
        actions: <Widget>[
          PopupMenuButton<String>(
            padding: EdgeInsets.zero,
            icon: Icon(Icons.menu),
            offset: Offset(20.0, 100.0),
            color: Colors.black87,
            onSelected: showMenuSelection,
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'Todo',
                child: ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.playlist_play, color: Colors.white),
                  title: Text('全部', style: TextStyle(color: Colors.white)),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'Tender',
                child: ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.person_add, color: Colors.white),
                  title: Text('报名中...', style: TextStyle(color: Colors.white)),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'Oerate',
                child: ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.rotate_right, color: Colors.white),
                  title: Text('执行中...', style: TextStyle(color: Colors.white)),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'Complete',
                child: ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.playlist_add_check, color: Colors.white),
                  title: Text('已完成...', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: _index == 0 ? Color(0xFF121234) : Color(0xFF123400),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: Container(
                child: IconButton(
                  icon: Text(
                    '待办',
                    style: TextStyle(fontSize: 16.0, color: _index == 0 ? Color(0xFFF0F0F0) : Color(0xFF999999)),
                  ),
                  onPressed: () {
                    _pageController.jumpToPage(0);
                    setState(() {
                      _index = 0;
                    });
                  },
                ),
              ),
            ),
            Container(
              width: 80.0,
              height: 40.0,
              child: Center(
                child: Container(
                  width: 35.0,
                  height: 25.0,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5.0), boxShadow: [
                    BoxShadow(
                      offset: Offset(-1, -1),
                      // blurRadius: 1.0,
                      color: Colors.redAccent,
                    ),
                    BoxShadow(
                      offset: Offset(2, -1),
                      // blurRadius: 1.0,
                      color: Colors.cyanAccent,
                    ),
                    BoxShadow(
                      offset: Offset(1, 1),
                      // blurRadius: 1.0,
                      color: Colors.yellowAccent,
                    ),
                  ]),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(Icons.add),
                    onPressed: () {
                      Navigator.pushNamed(context, '/missionPublish');
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: IconButton(
                  icon: Text(
                    '已发',
                    style: TextStyle(fontSize: 16.0, color: _index == 1 ? Color(0xFFF0F0F0) : Color(0xFF999999)),
                  ),
                  onPressed: () {
                    _pageController.jumpToPage(1);
                    setState(() {
                      _index = 1;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _index = index;
          });
        },
        children: <Widget>[
          UserMissionTabComponent(type: 2, missionTabController: _todoController),
          UserMissionTabComponent(type: 1, missionTabController: _publishController),
        ],
      ),
    );
  }
}

// A diamond-shaped floating action button.
