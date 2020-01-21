import 'dart:io';
import 'dart:typed_data';

import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:fengchao/common/api/http_request.dart';
import 'package:fengchao/common/config/config.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PhotoViewScreen extends StatefulWidget {
  final List images;
  final List<File> gallery;
  final int index;
  final String heroTag;

  const PhotoViewScreen({Key key, this.images, this.index = 0, this.heroTag, this.gallery}) : super(key: key);

  @override
  _PhotoViewScreenState createState() => _PhotoViewScreenState();
}

class _PhotoViewScreenState extends State<PhotoViewScreen> {
  PageController _controller;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.index;
    _controller = PageController(initialPage: widget.index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            bottom: 0,
            right: 0,
            child: Container(
                child: PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              builder: (BuildContext context, int index) {
                return PhotoViewGalleryPageOptions(
                  imageProvider:
                      widget.images != null ? NetworkImage(CONFIG.BASE_URL + widget.images[index]) : FileImage(widget.gallery[index]),
                  heroAttributes: widget.heroTag != null ? PhotoViewHeroAttributes(tag: widget.heroTag) : null,
                );
              },
              itemCount: widget.images != null ? widget.images.length : widget.gallery.length,
              loadingChild: Container(),
              backgroundDecoration: null,
              pageController: _controller,
              enableRotation: true,
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
            )),
          ),
          Positioned(
            //图片index显示
            top: MediaQuery.of(context).padding.top + 15,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Text(
                  "${currentIndex + 1}/${widget.images != null ? widget.images.length : widget.gallery.length}",
                  style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ),
          Positioned(
            //右上角关闭按钮
            right: 10,
            top: MediaQuery.of(context).padding.top,
            child: IconButton(
              icon: Icon(
                Icons.close,
                size: 25,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          widget.images != null
              ? Positioned(
                  right: 10.0,
                  bottom: 0.0,
                  child: SafeArea(
                    bottom: true,
                    child: FlatButton(
                      color: Colors.white54,
                      child: Text('保存'),
                      onPressed: _saveImageFunc,
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  void _saveImageFunc() async {
    var response = await DioApi.request(
      path: widget.images[currentIndex],
      method: 'GET',
      options: Options(responseType: ResponseType.bytes),
    );
    final result = await ImageGallerySaver.saveImage(Uint8List.fromList(response));
    if (result != null && result != '') {
      BotToast.showText(text: '已保存：$result', textStyle: TextStyle(fontSize: 14.0, color: Colors.white));
    }
  }
}
