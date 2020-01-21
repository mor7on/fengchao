import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:fengchao/pages/widgets/custom_appbar.dart';
import 'package:fengchao/pages/widgets/image_item_widget.dart';
import 'package:fengchao/pages/widgets/loading_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

import 'photo_view_screen.dart';

class GalleryContentListPage extends StatefulWidget {
  final List<AssetPathEntity> pathList;
  final int alreadySelected;
  final int imageTotal;

  const GalleryContentListPage({Key key, this.pathList, this.alreadySelected, this.imageTotal = 9}) : super(key: key);

  @override
  _GalleryContentListPageState createState() => _GalleryContentListPageState();
}

class _GalleryContentListPageState extends State<GalleryContentListPage> {
  List<AssetPathEntity> get pathList => widget.pathList;

  List<CheckBoxForImage> list = [];
  List<AssetEntity> selected = [];
  var page = 0;
  int pathIndex = 0;

  @override
  void initState() {
    super.initState();
    print(pathList);
    _onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    var length = pathList[pathIndex].assetCount;

    if (list.length == 0) {
      length = 0;
    } else if (list.length < length) {
      length = list.length + 1;
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: Text('${pathList[pathIndex].name}'),
        actions: <Widget>[
          Container(
            width: 50.0,
            child: Row(
              children: <Widget>[
                Text(selected.length.toString(), style: TextStyle(fontSize: 16.0)),
                Text('/${widget.imageTotal - widget.alreadySelected}', style: TextStyle(fontSize: 16.0)),
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 50.0,
        color: Colors.blueGrey,
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          children: <Widget>[
            Text('选择图片库'),
            Container(
              width: 30.0,
              child: PopupMenuButton(
                  padding: EdgeInsets.all(0.0),
                  initialValue: pathIndex.toString(),
                  icon: Icon(
                    Icons.signal_cellular_4_bar,
                    size: 16.0,
                  ),
                  onSelected: (index) {
                    setState(() {
                      pathIndex = int.parse(index);
                    });
                  },
                  itemBuilder: (BuildContext context) => pathList
                      .asMap()
                      .keys
                      .map((idx) => new PopupMenuItem(value: '$idx', child: Text('${pathList[idx].name}')))
                      .toList()),
            ),
            Expanded(flex: 1, child: Container()),
            Container(
              width: 60.0,
              height: 35.0,
              child: FlatButton(
                  color: Colors.grey[50],
                  child: Text('预览', style: TextStyle(fontSize: 14.0)),
                  onPressed: () async {
                    if (selected.length == 0) {
                      BotToast.showText(
                          text: "请先选择图片...",
                          textStyle: TextStyle(fontSize: 14.0, color: Colors.white),
                          borderRadius: BorderRadius.circular(5.0));
                      // BotToast.showSimpleNotification(title: "请先选择图片...");
                      return;
                    }
                    List<File> fileList = await _assetToFile(selected);
                    final page = PhotoViewScreen(
                      gallery: fileList,
                    );
                    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                      return page;
                    }));
                  }),
            ),
            SizedBox(width: 10.0),
            Container(
              width: 60.0,
              height: 35.0,
              child: FlatButton(
                  color: Colors.grey[50],
                  child: Text('确定', style: TextStyle(fontSize: 14.0)),
                  onPressed: () {
                    Navigator.of(context).pop(selected);
                  }),
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.black,
        child: GridView.builder(
          padding: EdgeInsets.all(4.0),
          itemBuilder: _buildItem,
          itemCount: length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,
          ),
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    if (list.length == index) {
      onLoadMore();
      return loadWidget;
    }

    final entity = list[index];

    return GestureDetector(
      onTap: () async {
        final f = [entity.image];
        List<File> fileList = await _assetToFile(f);
        final page = PhotoViewScreen(
          gallery: fileList,
        );
        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
          return page;
        }));
      },
      child: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: double.infinity,
            child: ImageItemWidget(key: ValueKey(entity.image), entity: entity.image),
          ),
          Checkbox(
              value: entity.checked,
              onChanged: (bool value) {
                if (widget.imageTotal - widget.alreadySelected - selected.length <= 0 && value == true) {
                  return;
                }
                if (value == true) {
                  selected.add(entity.image);
                } else {
                  selected.removeWhere((element) => element == entity.image);
                }
                setState(() {
                  entity.checked = value;
                });
              })
        ],
      ),
    );
  }

  final loadCount = 80;

  Future<void> onLoadMore() async {
    if (!mounted) {
      print("on load more, but it's unmounted");
      return;
    }
    print("on load more");
    final list = await pathList[pathIndex].getAssetListPaged(page + 1, loadCount);
    page = page + 1;
    for (var item in list) {
      this.list.add(new CheckBoxForImage(item, false));
    }
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _onRefresh() async {
    if (!mounted) {
      return;
    }
    final list = await pathList[pathIndex].getAssetListPaged(0, loadCount);
    page = 0;
    this.list.clear();
    for (var item in list) {
      this.list.add(new CheckBoxForImage(item, false));
    }
    // this.list.addAll(list);
    setState(() {});
    if (mounted) {
      setState(() {});
    }
  }

  Future _assetToFile(List<AssetEntity> assets) async {
    List<File> fileList = [];
    for (var item in assets) {
      File file = await item.file;
      fileList.add(file);
    }
    return fileList;
  }
}

class CheckBoxForImage {
  AssetEntity _image;
  bool checked;

  CheckBoxForImage(this._image, this.checked);

  AssetEntity get image => _image;
}
