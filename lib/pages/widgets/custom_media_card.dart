import 'package:fengchao/common/config/config.dart';
import 'package:fengchao/common/utils/common_utils.dart';
import 'package:fengchao/models/article_model.dart';
import 'package:flutter/material.dart';

class CustomMediaCard extends StatelessWidget {
  const CustomMediaCard({Key key, this.item, this.navigatorName, this.voidCallback}) : super(key: key);

  final ArticleModel item;
  final String navigatorName;
  final VoidCallback voidCallback;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Card(
          margin: EdgeInsets.symmetric(horizontal: 0.0, vertical: 5.0),
          elevation: 3.0,
          child: Container(
            width: double.infinity,
            height: 180.0,
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        item.postTitle,
                        style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(
                      child: Text('浏览：${item.postHits}次  收藏：${item.postFavorites}人  发布：${CommonUtils.dateToPretty(item.createTime)}',
                          style: TextStyle(fontSize: 10.0)),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(
                      child: Row(
                        children: item.postKeywords != null
                            ? item.postKeywords.split(',').map<Widget>((str) {
                                return Container(
                                  height: 20.0,
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.symmetric(horizontal: 1.0, vertical: 3.0),
                                  padding: EdgeInsets.symmetric(horizontal: 4.0),
                                  decoration: BoxDecoration(
                                      color: Colors.blueGrey[50], borderRadius: BorderRadius.circular(2.0)),
                                  child: Text(str, style: TextStyle(fontSize: 12.0, color: Colors.blueGrey)),
                                );
                              }).toList()
                            : [],
                      ),
                    ),
                    item.type != null
                        ? Container(
                            height: 20.0,
                            alignment: Alignment.center,
                            margin: EdgeInsets.symmetric(horizontal: 1.0, vertical: 3.0),
                            padding: EdgeInsets.symmetric(horizontal: 4.0),
                            decoration:
                                BoxDecoration(color: Colors.blueGrey[50], borderRadius: BorderRadius.circular(2.0)),
                            child: Text(item.type == 0 ? '明标' : '暗标',
                                style: TextStyle(fontSize: 12.0, color: Colors.blueGrey)),
                          )
                        : Container()
                  ],
                ),
                Row(children: _biuldImageDelegate(item.imageList)),
                Container(
                  width: double.infinity,
                  child: Text(
                    '地址信息：${item.postAddress ?? '作者隐藏了发布地址'}',
                    style: TextStyle(fontSize: 10.0, color: Colors.blueGrey[200]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
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
                onTap: () async {
                  await Navigator.pushNamed(context, navigatorName, arguments: {'id': item.id}).then((isRefresh) {
                    if (isRefresh == true) {
                      voidCallback();
                    }
                  });
                },
              ),
            ),
          ),
        )
      ],
    );
  }

  List<Widget> _biuldImageDelegate(imageList) {
    List<Widget> childList;
    childList = <Widget>[
        Expanded(
          flex: 1,
          child: Container(
            width: double.infinity,
            height: 70.0,
            margin: EdgeInsets.symmetric(horizontal: 1.0, vertical: 4.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4.0),
              child: imageList.length >= 1
              ? Container(color: Color(0xFFFCFCFC), child: Image.network(CONFIG.BASE_URL + imageList[0], fit: BoxFit.cover))
              : Container(color: Color(0xFFFCFCFC), child: Image.network(CONFIG.BASE_URL + 'h5/asset/blank.png', fit: BoxFit.cover)),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            width: double.infinity,
            height: 70.0,
            margin: EdgeInsets.symmetric(horizontal: 1.0, vertical: 4.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4.0),
              child: imageList.length >= 2
                  ? Container(color: Color(0xFFFCFCFC), child: Image.network(CONFIG.BASE_URL + imageList[1], fit: BoxFit.cover))
                  : Container(),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            width: double.infinity,
            height: 70.0,
            margin: EdgeInsets.symmetric(horizontal: 1.0, vertical: 4.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4.0),
              child: imageList.length >= 3
                  ? Container(color: Color(0xFFFCFCFC), child: Image.network(CONFIG.BASE_URL + imageList[2], fit: BoxFit.cover))
                  : Container(),
            ),
          ),
        ),
      ];
    return childList;
  }
}
