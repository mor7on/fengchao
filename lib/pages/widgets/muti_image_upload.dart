import 'dart:convert';
import 'dart:io';
import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:fengchao/common/api/http_request.dart';
import 'package:fengchao/common/config/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

import 'gallery_photos_picker.dart';

class MutiImageUploadComponent extends StatefulWidget {
  final ValueChanged onChanged;
  final int total;
  final int type;
  final List<dynamic> imageList;

  const MutiImageUploadComponent({Key key, this.onChanged, this.total = 9, this.type = 0, this.imageList}) : super(key: key);

  @override
  _MutiImageUploadComponentState createState() => _MutiImageUploadComponentState();
}

class _MutiImageUploadComponentState extends State<MutiImageUploadComponent> {
  //存放firestorage返回的图片下载地址
  List _imageUrl = [];
  //存放压缩后的图片数据路径
  List<File> _imagePath = [];
  double uploadProgress = 0.0;

  @override
  void initState() { 
    super.initState();
    _imageUrl = widget.imageList??[];
  }

  _upLoadImage(List<File> fileList) async {
    Map<String, MultipartFile> uploadMap = new Map();
    int total = 0;
    for (var i = 0; i < fileList.length; i++) {
      String imgPath = fileList[i].absolute.toString();
      var name = imgPath.substring(imgPath.lastIndexOf("/") + 1, imgPath.length - 1);
      String path = imgPath.substring(imgPath.indexOf("/"), imgPath.length - 1);
      print(path);
      // var suffix = name.substring(name.lastIndexOf(".") + 1, name.length);
      // print('name========$name');
      // print('suffix========$suffix');
      int fileSize = fileList[i].lengthSync();
      total = total + fileSize;

      uploadMap.addAll({'file$i': await MultipartFile.fromFile(path, filename: name)});
    }

    if (total > 5 * 1024 * 1024) {
      print(total);
      return BotToast.showText(text: '上传文件过大，请分开上传', textStyle: TextStyle(fontSize: 14.0, color: Colors.white));
    }

    FormData formData = FormData.fromMap(uploadMap);
    print(formData.files.toString());

    String _path = widget.type == 0 ? CONFIG.path['mutiImageUpload'] : CONFIG.path['kIDCardUpload'];

    BotToast.showLoading();

    var respone = await DioApi.uploade(path: _path, data: formData, onSend: onUpload);

    BotToast.closeAllLoading();
    print(respone);
    if (respone['code'] == 1) {
      print('上传成功');
      _imagePath.addAll(fileList);
      _imageUrl.addAll(respone['data']);
      setState(() {});
    }

    widget.onChanged(_imageUrl);
  }

  void onUpload(progress) {
    print(progress);
    uploadProgress = progress;
    setState(() {});
  }

  _scanGalleryList() async {
    var galleryList = await PhotoManager.getAssetPathList(
      fetchDateTime: DateTime.now(),
      type: RequestType.image,
      hasAll: true,
    );

    galleryList.sort((s1, s2) {
      return s2.assetCount.compareTo(s1.assetCount);
    });

    final page = GalleryContentListPage(
      pathList: galleryList,
      alreadySelected: _imageUrl.length,
      imageTotal: widget.total,
    );

    List<File> tempList = [];

    Navigator.of(context).push(MaterialPageRoute(builder: (context) => page)).then((res) async {
      List<AssetEntity> tempResult = res;
      if (tempResult == null || tempResult.length == 0) {
        return;
      } else {
        print(tempResult);
        for (var item in tempResult) {
          File file = await item.file;
          tempList.add(file);
        }
        _upLoadImage(tempList);
      }
    });
  }

  List<Widget> _mutiImageUploadBox() {
    List<Widget> imageBox;
    imageBox = _imageUrl.asMap().keys.map((index) {
      return Stack(
        children: <Widget>[
          Container(
            width: 100.0,
            height: 100.0,
            color: Color(0xFFE4E5E6),
            margin: EdgeInsets.all(1.0),
            child: Image.network(
              CONFIG.BASE_URL + _imageUrl[index],
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 0.0,
            right: 0.0,
            child: Container(
              width: 20.0,
              height: 20.0,
              alignment: Alignment(0.0, 0.0),
              decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(15.0)),
              child: FlatButton(
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(0.0),
                  // color: Colors.blueGrey,
                  splashColor: Colors.blueGrey,
                  child: Icon(
                    Icons.clear,
                    size: 16.0,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    // _imagePath.removeAt(index);
                    _imageUrl.removeAt(index);
                    widget.onChanged(_imageUrl);
                    setState(() {});
                  }),
            ),
          )
        ],
      );
    }).toList();

    if (imageBox.length < widget.total) {
      imageBox.add(Stack(
        children: <Widget>[
          Container(
            width: 100.0,
            height: 100.0,
            color: Color(0xFFE4E5E6),
            margin: EdgeInsets.all(1.0),
            child: IconButton(
              icon: Icon(Icons.add, size: 50.0, color: Colors.grey),
              onPressed: _scanGalleryList,
            ),
          )
        ],
      ));
    }

    return imageBox;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Wrap(
            children: _mutiImageUploadBox(),
          ),
        ],
      ),
    );
  }
}
