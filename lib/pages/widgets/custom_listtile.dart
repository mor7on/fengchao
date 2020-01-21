import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class CustomListTile extends StatelessWidget {
  CustomListTile(
      {Key key,
      this.onPressed,
      this.itemIcon,
      this.itemTitle,
      this.itemDescription = '',
      this.isShowEnterIcon = true,
      this.showRedDot = false})
      : super(key: key);

  final VoidCallback onPressed;
  final itemIcon;
  final itemTitle;
  final String itemDescription;
  final bool isShowEnterIcon;
  final bool showRedDot;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(5, 15, 5, 15),
          child: Row(
            children: <Widget>[
              Icon(
                IconData(itemIcon, fontFamily: 'iconfont'),
                size: 25.0,
                color: Color(0xFF999999),
              ),
              SizedBox(width: 5.0),
              Expanded(
                flex: 1,
                child: Text(FlutterI18n.translate(context, itemTitle),
                    style: TextStyle(color: Color(0xFF000000), fontSize: 14.0)),
              ),
              itemDescription == null
                  ? Container()
                  : Container(
                      child: Text(
                        itemDescription,
                        style: TextStyle(color: Color(0xFF999999), fontSize: 12.0),
                      ),
                    ),
              isShowEnterIcon == true
                  ? Icon(
                      Icons.navigate_next,
                      // size: 16.0,
                      color: Color(0xFF999999),
                    )
                  : Container()
            ],
          ),
        ),
        showRedDot
            ? Positioned(
                left: 100.0,
                top: 20.0,
                child: Container(
                  width: 5.0,
                  height: 5.0,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              )
            : Container(),
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              splashColor: Colors.black.withOpacity(0.1),
              highlightColor: Colors.black.withOpacity(0.1),
              onTap: onPressed,
            ),
          ),
        )
      ],
    );
  }
}
