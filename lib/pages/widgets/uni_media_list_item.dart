import 'package:flutter/material.dart';

class UniMediaListItem extends StatelessWidget {
  const UniMediaListItem(
      {Key key, this.imageUrl, this.title, this.content, this.createTime, this.isFavorite, this.onTapItem, this.onTapCancle})
      : super(key: key);

  final String imageUrl;
  final String title;
  final String content;
  final String createTime;
  final bool isFavorite;
  final VoidCallback onTapItem;
  final VoidCallback onTapCancle;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(10.0, 1.5, 10.0, 1.5),
      child: Container(
        padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        width: double.infinity,
        child: InkWell(
          borderRadius: BorderRadius.circular(4.0),
          splashColor: Colors.blueGrey.withOpacity(0.2),
          highlightColor: Colors.blueGrey.withOpacity(0.1),
          onTap: () {
            onTapItem();
          },
          child: Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(right: 10.0),
                width: imageUrl != null ? 100.0 : 0.0,
                height: 100 * 0.618,
                child: imageUrl != null
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      child: Text(
                        title,
                        style: TextStyle(fontSize: 14.0),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      child: Text(
                        content,
                        style: TextStyle(fontSize: 12.0, color: Colors.grey),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Container(),
                        ),
                        Container(
                          child: isFavorite
                              ? Container(
                                  width: 40.0,
                                  height: 25.0,
                                  child: IconButton(
                                    padding: EdgeInsets.all(0.0),
                                    icon: Icon(
                                      Icons.clear,
                                      size: 20.0,
                                    ),
                                    onPressed: () {
                                      onTapCancle();
                                    },
                                  ),
                                )
                              : Container(),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class UniMissionListItem extends StatelessWidget {
  const UniMissionListItem(
      {Key key,
      this.imageUrl,
      this.title,
      this.createTime,
      this.isRecommended,
      this.onTapItem,
      this.isDeposit,
      this.areaId,
      this.missionType})
      : super(key: key);

  final String imageUrl;
  final String title;
  final String createTime;
  final bool isRecommended;
  final bool isDeposit;
  final int areaId;
  final int missionType;
  final VoidCallback onTapItem;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(10.0, 1.5, 10.0, 1.5),
      child: Container(
        padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        height: 100.0,
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Expanded(
                    flex: 1,
                    child: Container(
                      width: double.infinity,
                      child: Text(
                        title,
                        style: TextStyle(fontSize: 14.0),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0.0),
                  child: Row(
                    children: <Widget>[
                      CustomSmallTextTag(
                        show: true,
                        text: missionType == 1 ? '暗标任务' : '明标任务',
                        highLight: true,
                      ),
                      CustomSmallTextTag(
                        show: true,
                        text: '保证金',
                        highLight: isDeposit,
                      ),
                      CustomSmallTextTag(
                        show: true,
                        text: '区域限制',
                        highLight: areaId != null && areaId != 0,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Text(
                          createTime,
                          style: TextStyle(color: Color(0xFF999999), fontSize: 10.0),
                        ),
                      ),
                      Container(
                        child: isRecommended
                            ? Text('推荐', style: TextStyle(color: Color(0xFF999999), fontSize: 10.0))
                            : null,
                      )
                    ],
                  ),
                )
              ],
            ),
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(4.0),
                  splashColor: Colors.blueGrey.withOpacity(0.2),
                  highlightColor: Colors.blueGrey.withOpacity(0.1),
                  onTap: () {
                    onTapItem();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomSmallTextTag extends StatelessWidget {
  const CustomSmallTextTag({Key key, this.show, this.text, this.highLight}) : super(key: key);
  final bool show;
  final bool highLight;
  final String text;

  @override
  Widget build(BuildContext context) {
    return show
        ? Container(
            width: 50.0,
            height: 20.0,
            margin: EdgeInsets.only(right: 2.0),
            decoration: BoxDecoration(
                color: highLight ? Colors.blueGrey[100] : Colors.blueGrey[50],
                borderRadius: BorderRadius.circular(2.0)),
            child: Center(
              child: Text(text,
                  style: TextStyle(fontSize: 10.0, color: highLight ? Colors.blueGrey[300] : Colors.blueGrey[100])),
            ))
        : null;
  }
}
