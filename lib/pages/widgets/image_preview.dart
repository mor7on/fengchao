import 'package:fengchao/common/config/config.dart';
import 'package:fengchao/pages/widgets/photo_view_screen.dart';
import 'package:flutter/material.dart';

class ImagePreview extends StatelessWidget {
  final List<dynamic> imageList;
  ImagePreview({Key key, this.imageList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(
        children: _biuldChildren(context),
      ),
    );
  }

  List<Widget> _biuldChildren(context) {
    print(imageList);
    List<Widget> children = [];
    for (var i = 0; i < imageList.length; i++) {
      children.add(
        Container(
          margin: EdgeInsets.all(1.0),
          child: GestureDetector(
            child: Container(
              width: 100,
              height: 100,
              child: Hero(
                tag: 'pic$i',
                transitionOnUserGestures: true,
                child: Image.network(
                  CONFIG.BASE_URL+imageList[i],
                  fit: BoxFit.cover,
                ),
              ),
            ),
            onTap: () {
              Navigator.of(context).push(
                new FadeRoute(
                  page: PhotoViewScreen(
                    images: imageList, //传入图片list
                    index: i, //传入当前点击的图片的index
                    heroTag: 'pic$i', //传入当前点击的图片的hero tag （可选）
                  ),
                ),
              );
            },
          ),
        ),
      );
    }
    return children;
  }
}

class FadeRoute extends PageRouteBuilder {
  final Widget page;
  FadeRoute({this.page})
      : super(
          // 设置过度时间
          transitionDuration: Duration(milliseconds: 500),
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
}
