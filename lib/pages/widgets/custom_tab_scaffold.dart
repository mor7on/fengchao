import 'package:flutter/material.dart';


class CustomTabScaffold extends StatelessWidget {

  final List tabs;
  final int currentIndex;
  final Function onItemClick;
  
  const CustomTabScaffold({Key key, this.tabs, this.currentIndex = 0, this.onItemClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            child: LeftTabContainer(
              tabText: tabs[0]['label'],
              active: currentIndex == 0,
            ),
            onTap: (){
              if(currentIndex == 0)return;
              onItemClick(0);
            },
          ),
          GestureDetector(
            child: RightTabContainer(
              tabText: tabs[1]['label'],
              active: currentIndex == 1,
            ),
            onTap: (){
              if(currentIndex == 1)return;
              onItemClick(1);
            },
          ),
        ],
      ),
    );
  }
}



class LeftTabContainer extends StatelessWidget {
  final String tabText;
  final bool active;
  const LeftTabContainer({Key key, this.tabText, this.active})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70.0,
      height: 40.0,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: active ? Colors.blue.withOpacity(0.8) : Colors.blueGrey[200].withOpacity(0.8),
          borderRadius: BorderRadius.horizontal(left: Radius.circular(20.0))),
      child: Text(tabText, style: TextStyle(fontSize: 14.0,color: Colors.white)),
    );
  }
}

class RightTabContainer extends StatelessWidget {
  final String tabText;
  final bool active;
  const RightTabContainer({Key key, this.tabText, this.active})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70.0,
      height: 40.0,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: active ? Colors.blue.withOpacity(0.8) : Colors.blueGrey[200].withOpacity(0.8),
          borderRadius:
              BorderRadius.horizontal(right: Radius.circular(20.0))),
      child: Text(tabText, style: TextStyle(fontSize: 14.0,color: Colors.white)),
    );
  }
}

class CenterTabContainer extends StatelessWidget {
  final String tabText;
  final bool active;
  const CenterTabContainer({Key key, this.tabText, this.active})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        width: double.infinity,
        height: 30.0,
        decoration: BoxDecoration(
          color: active ? Colors.blueGrey : Colors.blue,
        ),
        child: Text(tabText),
      ),
    );
  }
}
