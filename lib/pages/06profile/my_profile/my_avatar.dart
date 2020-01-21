import 'dart:io';
import 'dart:typed_data';

import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:extended_image/extended_image.dart';
import 'package:fengchao/common/api/06_user_profile_fun.dart';
import 'package:fengchao/common/utils/crop_editor_helper.dart';
import 'package:fengchao/pages/widgets/common_widget.dart';
import 'package:fengchao/pages/widgets/custom_appbar.dart';
import 'package:fengchao/pages/widgets/gallery_photos_picker.dart';
import 'package:fengchao/provider/login_user_model.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';

class MyAvatarComponent extends StatefulWidget {
  final Map arguments;

  const MyAvatarComponent({Key key, this.arguments}) : super(key: key);
  @override
  _MyAvatarComponentState createState() => _MyAvatarComponentState();
}

class _MyAvatarComponentState extends State<MyAvatarComponent> {
  final GlobalKey<ExtendedImageEditorState> editorKey = GlobalKey<ExtendedImageEditorState>();

  bool _cropping = false;

  @override
  Widget build(BuildContext context) {
    print('重建上传头像页面');
    return Scaffold(
      appBar: CustomAppBar(
        title: Text("上传头像"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_library),
            onPressed: _getImage,
          ),
          IconButton(
            icon: Icon(Icons.done),
            onPressed: () {
              _uploadAvatar();
            },
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: _fileImage != null
            ? ExtendedImage.file(
                _fileImage,
                fit: BoxFit.contain,
                mode: ExtendedImageMode.editor,
                enableLoadState: true,
                extendedImageEditorKey: editorKey,
                initEditorConfigHandler: (state) {
                  return EditorConfig(
                      maxScale: 8.0,
                      cropRectPadding: EdgeInsets.all(20.0),
                      hitTestSize: 20.0,
                      initCropRectType: InitCropRectType.imageRect,
                      cropAspectRatio: 1.0);
                },
              )
            : Consumer<LoginUserModel>(
                builder: (context, model, _) {
                  return ExtendedImage.network(
                    model.loginUser.avatar,
                    fit: BoxFit.contain,
                    mode: ExtendedImageMode.editor,
                    extendedImageEditorKey: editorKey,
                    initEditorConfigHandler: (state) {
                      return EditorConfig(
                          maxScale: 8.0,
                          cropRectPadding: EdgeInsets.all(20.0),
                          hitTestSize: 20.0,
                          initCropRectType: InitCropRectType.imageRect,
                          cropAspectRatio: 1.0);
                    },
                  );
                },
              ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Color(0xFF121234),
        shape: CircularNotchedRectangle(),
        child: ButtonTheme(
          minWidth: 0.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              FlatButtonWithIcon(
                icon: Icon(Icons.crop),
                label: Text(
                  "剪切",
                  style: TextStyle(fontSize: 10.0),
                ),
                textColor: Colors.white,
                onPressed: () {
                  _cropImage(false);
                },
              ),
              FlatButtonWithIcon(
                icon: Icon(Icons.flip),
                label: Text(
                  "翻转",
                  style: TextStyle(fontSize: 10.0),
                ),
                textColor: Colors.white,
                onPressed: () {
                  editorKey.currentState.flip();
                },
              ),
              FlatButtonWithIcon(
                icon: Icon(Icons.rotate_left),
                label: Text(
                  "左转",
                  style: TextStyle(fontSize: 10.0),
                ),
                textColor: Colors.white,
                onPressed: () {
                  editorKey.currentState.rotate(right: false);
                },
              ),
              FlatButtonWithIcon(
                icon: Icon(Icons.rotate_right),
                label: Text(
                  "右转",
                  style: TextStyle(fontSize: 10.0),
                ),
                textColor: Colors.white,
                onPressed: () {
                  editorKey.currentState.rotate(right: true);
                },
              ),
              FlatButtonWithIcon(
                icon: Icon(Icons.restore),
                label: Text(
                  "重置",
                  style: TextStyle(fontSize: 10.0),
                ),
                textColor: Colors.white,
                onPressed: () {
                  editorKey.currentState.reset();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _cropImage(bool useNative) async {
    if (_cropping) return;
    var msg = "";
    try {
      _cropping = true;

      showBusyingDialog();

      Uint8List fileData;
      String name = 'avatar_' + DateTime.now().millisecondsSinceEpoch.toString() + '.png';

      ///delay due to cropImageDataWithDartLibrary is time consuming on main thread
      ///it will block showBusyingDialog
      ///if you don't want to block ui, use compute/isolate,but it costs more time.
      //await Future.delayed(Duration(milliseconds: 200));

      ///if you don't want to block ui, use compute/isolate,but it costs more time.
      fileData = await cropImageDataWithDartLibrary(state: editorKey.currentState);

      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path + name;

      File avatar = await File(tempPath).writeAsBytes(fileData);

      // var fileFath = await ImagePickerSaver.saveFile(fileData: fileData);

      msg = "save image : $tempPath";

      setState(() {
        editorKey.currentState.reset();
        _fileImage = avatar;
      });
    } catch (e) {
      msg = "save faild: $e";
      print(msg);
    }

    Navigator.of(context).pop();
    BotToast.showText(text: msg, textStyle: TextStyle(fontSize: 14.0, color: Colors.white));
    _cropping = false;
  }

  File _fileImage;
  void _getImage() async {
    File image = await _imagePicker();
    print(image);
    if (image == null) {
      return null;
    } else {
      setState(() {
        editorKey.currentState.reset();
        _fileImage = image;
      });
    }
  }

  Future _uploadAvatar() async {
    print(_fileImage);
    if (null == _fileImage) {
      Navigator.of(context).pop();
    } else {
      BotToast.showLoading();
      String imgPath = _fileImage.absolute.toString();
      var name = imgPath.substring(imgPath.lastIndexOf("/") + 1, imgPath.length - 1);
      String path = imgPath.substring(imgPath.indexOf("/"), imgPath.length - 1);
      FormData formData =
          FormData.fromMap({"avatar": "flutter", "file": await MultipartFile.fromFile(path, filename: name)});

      var res = await uploadAvatar(params: formData, onSend: _uploadProgress);
      print(res);
      BotToast.closeAllLoading();
      if (null != res) {
        if (res['code'] == 1) {
          Provider.of<LoginUserModel>(context).fetchUserInfo();
          await Future.delayed(Duration(milliseconds: 300));
          Navigator.of(context).pop(true);
        } else {
          print('上传头像失败');
        }
      }
    }
  }

  void _uploadProgress(p) {
    print(p);
  }

  Future<File> _imagePicker() async {
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
      alreadySelected: 0,
      imageTotal: 1,
    );

    // List<File> tempList = [];
    File imageFile;

    await Navigator.of(context).push(MaterialPageRoute(builder: (context) => page)).then((res) async {
      List<AssetEntity> tempResult = res;
      if (tempResult == null || tempResult.length == 0) {
        return null;
      } else {
        // for (var item in tempResult) {
        //   File file = await item.file;
        //   tempList.add(file);
        // }
        imageFile = await tempResult[0].file;
        _fileImage = imageFile;
      }
    });
    return imageFile;
  }

  Future showBusyingDialog() async {
    var primaryColor = Theme.of(context).primaryColor;
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Material(
          color: Colors.transparent,
          child: Container(
            height: double.infinity,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(
                  strokeWidth: 2.0,
                  valueColor: AlwaysStoppedAnimation(primaryColor),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  "cropping...",
                  style: TextStyle(color: primaryColor),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
