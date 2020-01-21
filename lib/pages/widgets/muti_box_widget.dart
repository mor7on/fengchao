import 'package:fengchao/common/config/config.dart';
import 'package:fengchao/pages/widgets/photo_view_screen.dart';
import 'package:flutter/material.dart';

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

class MultiImageBoxBuilder extends StatelessWidget {
  final List imageList;

  MultiImageBoxBuilder({Key key, this.imageList}) : super(key: key);

  void _previewImages(BuildContext context, int i) {
    Navigator.of(context).push(
      new FadeRoute(
        page: PhotoViewScreen(
          images: imageList, //传入图片list
          index: i, //传入当前点击的图片的index
          heroTag: 'pic$i', //传入当前点击的图片的hero tag （可选）
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget imageBox;

    switch (imageList.length) {
      case 0:
        imageBox = Container(
          width: 0.0,
          height: 0.0,
        );
        break;
      case 1:
        imageBox = Container(
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: GestureDetector(
                  child: Container(
                    height: 100.0,
                    margin: EdgeInsets.all(0.5),
                    child: Hero(
                      tag: 'pic0',
                      child: Image.network(
                        CONFIG.BASE_URL + imageList[0],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  onTap: () {
                    _previewImages(context, 0);
                  },
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  height: 100.0,
                  margin: EdgeInsets.all(0.5),
                  child: null,
                ),
              ),
            ],
          ),
        );
        break;
      case 2:
        imageBox = Container(
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: GestureDetector(
                  child: Container(
                    height: 100.0,
                    margin: EdgeInsets.all(0.5),
                    child: Hero(
                      tag: 'pic0',
                      child: Image.network(
                        CONFIG.BASE_URL + imageList[0],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  onTap: () {
                    _previewImages(context, 0);
                  },
                ),
              ),
              Expanded(
                flex: 2,
                child: GestureDetector(
                  child: Container(
                    height: 100.0,
                    margin: EdgeInsets.all(0.5),
                    child: Hero(
                      tag: 'pic1',
                      child: Image.network(
                        CONFIG.BASE_URL + imageList[1],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  onTap: () {
                    _previewImages(context, 1);
                  },
                ),
              ),
            ],
          ),
        );
        break;
      case 3:
        imageBox = Container(
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: GestureDetector(
                  child: Container(
                    height: 100.0,
                    margin: EdgeInsets.all(0.5),
                    child: Hero(
                      tag: 'pic0',
                      child: Image.network(
                        CONFIG.BASE_URL + imageList[0],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  onTap: () {
                    _previewImages(context, 0);
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  child: Container(
                    height: 100.0,
                    margin: EdgeInsets.all(0.5),
                    child: Hero(
                      tag: 'pic1',
                      child: Image.network(
                        CONFIG.BASE_URL + imageList[1],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  onTap: () {
                    _previewImages(context, 1);
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  child: Container(
                    height: 100.0,
                    margin: EdgeInsets.all(0.5),
                    child: Hero(
                      tag: 'pic2',
                      child: Image.network(
                        CONFIG.BASE_URL + imageList[2],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  onTap: () {
                    _previewImages(context, 2);
                  },
                ),
              ),
            ],
          ),
        );
        break;
      case 4:
        imageBox = Container(
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: GestureDetector(
                  child: Container(
                    height: 100.0,
                    margin: EdgeInsets.all(0.5),
                    child: Hero(
                      tag: 'pic0',
                      child: Image.network(
                        CONFIG.BASE_URL + imageList[0],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  onTap: () {
                    _previewImages(context, 0);
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  child: Container(
                    height: 100.0,
                    margin: EdgeInsets.all(0.5),
                    child: Hero(
                      tag: 'pic1',
                      child: Image.network(
                        CONFIG.BASE_URL + imageList[1],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  onTap: () {
                    _previewImages(context, 1);
                  },
                ),
              ),
              Expanded(
                flex: 2,
                child: GestureDetector(
                  child: Container(
                    height: 100.0,
                    margin: EdgeInsets.all(0.5),
                    child: Hero(
                      tag: 'pic2',
                      child: Image.network(
                        CONFIG.BASE_URL + imageList[2],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  onTap: () {
                    _previewImages(context, 2);
                  },
                ),
              ),
              Expanded(
                flex: 2,
                child: GestureDetector(
                  child: Container(
                    height: 100.0,
                    margin: EdgeInsets.all(0.5),
                    child: Hero(
                      tag: 'pic3',
                      child: Image.network(
                        CONFIG.BASE_URL + imageList[3],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  onTap: () {
                    _previewImages(context, 3);
                  },
                ),
              ),
            ],
          ),
        );
        break;
      case 5:
        imageBox = Container(
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: GestureDetector(
                  child: Container(
                    height: 100.0,
                    margin: EdgeInsets.all(0.5),
                    child: Hero(
                      tag: 'pic0',
                      child: Image.network(
                        CONFIG.BASE_URL + imageList[0],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  onTap: () {
                    _previewImages(context, 0);
                  },
                ),
              ),
              Expanded(
                flex: 2,
                child: GestureDetector(
                  child: Container(
                    height: 100.0,
                    margin: EdgeInsets.all(0.5),
                    child: Hero(
                      tag: 'pic1',
                      child: Image.network(
                        CONFIG.BASE_URL + imageList[1],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  onTap: () {
                    _previewImages(context, 1);
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  child: Container(
                    height: 100.0,
                    margin: EdgeInsets.all(0.5),
                    child: Hero(
                      tag: 'pic2',
                      child: Image.network(
                        CONFIG.BASE_URL + imageList[2],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  onTap: () {
                    _previewImages(context, 2);
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  child: Container(
                    height: 100.0,
                    margin: EdgeInsets.all(0.5),
                    child: Hero(
                      tag: 'pic3',
                      child: Image.network(
                        CONFIG.BASE_URL + imageList[3],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  onTap: () {
                    _previewImages(context, 3);
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  child: Container(
                    height: 100.0,
                    margin: EdgeInsets.all(0.5),
                    child: Hero(
                      tag: 'pic4',
                      child: Image.network(
                        CONFIG.BASE_URL + imageList[4],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  onTap: () {
                    _previewImages(context, 4);
                  },
                ),
              ),
            ],
          ),
        );
        break;
      case 6:
        imageBox = Container(
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: GestureDetector(
                  child: Container(
                    height: 100.0,
                    margin: EdgeInsets.all(0.5),
                    child: Hero(
                      tag: 'pic0',
                      child: Image.network(
                        CONFIG.BASE_URL + imageList[0],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  onTap: () {
                    _previewImages(context, 0);
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  child: Container(
                    height: 100.0,
                    margin: EdgeInsets.all(0.5),
                    child: Hero(
                      tag: 'pic1',
                      child: Image.network(
                        CONFIG.BASE_URL + imageList[1],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  onTap: () {
                    _previewImages(context, 1);
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  child: Container(
                    height: 100.0,
                    margin: EdgeInsets.all(0.5),
                    child: Hero(
                      tag: 'pic2',
                      child: Image.network(
                        CONFIG.BASE_URL + imageList[2],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  onTap: () {
                    _previewImages(context, 2);
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  child: Container(
                    height: 100.0,
                    margin: EdgeInsets.all(0.5),
                    child: Hero(
                      tag: 'pic3',
                      child: Image.network(
                        CONFIG.BASE_URL + imageList[3],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  onTap: () {
                    _previewImages(context, 3);
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  child: Container(
                    height: 100.0,
                    margin: EdgeInsets.all(0.5),
                    child: Hero(
                      tag: 'pic4',
                      child: Image.network(
                        CONFIG.BASE_URL + imageList[4],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  onTap: () {
                    _previewImages(context, 4);
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  child: Container(
                    height: 100.0,
                    margin: EdgeInsets.all(0.5),
                    child: Hero(
                      tag: 'pic5',
                      child: Image.network(
                        CONFIG.BASE_URL + imageList[5],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  onTap: () {
                    _previewImages(context, 5);
                  },
                ),
              ),
            ],
          ),
        );
        break;
      case 7:
        imageBox = Container(
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  height: 100.0,
                  margin: EdgeInsets.all(0.5),
                  child: Column(
                    children: <Widget>[
                      GestureDetector(
                        child: Container(
                          width: double.infinity,
                          height: 50.0,
                          child: Hero(
                            tag: 'pic0',
                            child: Image.network(
                              CONFIG.BASE_URL + imageList[0],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        onTap: () {
                          _previewImages(context, 0);
                        },
                      ),
                      GestureDetector(
                        child: Container(
                          width: double.infinity,
                          height: 50.0,
                          child: Hero(
                            tag: 'pic1',
                            child: Image.network(
                              CONFIG.BASE_URL + imageList[1],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        onTap: () {
                          _previewImages(context, 1);
                        },
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  height: 100.0,
                  margin: EdgeInsets.all(0.5),
                  child: Column(
                    children: <Widget>[
                      GestureDetector(
                        child: Container(
                          width: double.infinity,
                          height: 50.0,
                          child: Hero(
                            tag: 'pic2',
                            child: Image.network(
                              CONFIG.BASE_URL + imageList[2],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        onTap: () {
                          _previewImages(context, 2);
                        },
                      ),
                      GestureDetector(
                        child: Container(
                          width: double.infinity,
                          height: 50.0,
                          child: Hero(
                            tag: 'pic3',
                            child: Image.network(
                              CONFIG.BASE_URL + imageList[3],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        onTap: () {
                          _previewImages(context, 3);
                        },
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  child: Container(
                    height: 100.0,
                    margin: EdgeInsets.all(0.5),
                    child: Hero(
                      tag: 'pic4',
                      child: Image.network(
                        CONFIG.BASE_URL + imageList[4],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  onTap: () {
                    _previewImages(context, 4);
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  child: Container(
                    height: 100.0,
                    margin: EdgeInsets.all(0.5),
                    child: Hero(
                      tag: 'pic5',
                      child: Image.network(
                        CONFIG.BASE_URL + imageList[5],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  onTap: () {
                    _previewImages(context, 5);
                  },
                ),
              ),
              Expanded(
                flex: 2,
                child: GestureDetector(
                  child: Container(
                    height: 100.0,
                    margin: EdgeInsets.all(0.5),
                    child: Hero(
                      tag: 'pic6',
                      child: Image.network(
                        CONFIG.BASE_URL + imageList[6],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  onTap: () {
                    _previewImages(context, 6);
                  },
                ),
              ),
            ],
          ),
        );
        break;
      case 8:
        imageBox = Container(
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  height: 100.0,
                  margin: EdgeInsets.all(0.5),
                  child: Column(
                    children: <Widget>[
                      GestureDetector(
                        child: Container(
                          width: double.infinity,
                          height: 50.0,
                          child: Hero(
                            tag: 'pic0',
                            child: Image.network(
                              CONFIG.BASE_URL + imageList[0],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        onTap: () {
                          _previewImages(context, 0);
                        },
                      ),
                      GestureDetector(
                        child: Container(
                          width: double.infinity,
                          height: 50.0,
                          child: Hero(
                            tag: 'pic1',
                            child: Image.network(
                              CONFIG.BASE_URL + imageList[1],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        onTap: () {
                          _previewImages(context, 1);
                        },
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  height: 100.0,
                  margin: EdgeInsets.all(0.5),
                  child: Column(
                    children: <Widget>[
                      GestureDetector(
                        child: Container(
                          width: double.infinity,
                          height: 50.0,
                          child: Hero(
                            tag: 'pic2',
                            child: Image.network(
                              CONFIG.BASE_URL + imageList[2],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        onTap: () {
                          _previewImages(context, 2);
                        },
                      ),
                      GestureDetector(
                        child: Container(
                          width: double.infinity,
                          height: 50.0,
                          child: Hero(
                            tag: 'pic3',
                            child: Image.network(
                              CONFIG.BASE_URL + imageList[3],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        onTap: () {
                          _previewImages(context, 3);
                        },
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  child: Container(
                    height: 100.0,
                    margin: EdgeInsets.all(0.5),
                    child: Hero(
                      tag: 'pic4',
                      child: Image.network(
                        CONFIG.BASE_URL + imageList[4],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  onTap: () {
                    _previewImages(context, 4);
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  child: Container(
                    height: 100.0,
                    margin: EdgeInsets.all(0.5),
                    child: Hero(
                      tag: 'pic5',
                      child: Image.network(
                        CONFIG.BASE_URL + imageList[5],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  onTap: () {
                    _previewImages(context, 5);
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  child: Container(
                    height: 100.0,
                    margin: EdgeInsets.all(0.5),
                    child: Hero(
                      tag: 'pic6',
                      child: Image.network(
                        CONFIG.BASE_URL + imageList[6],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  onTap: () {
                    _previewImages(context, 6);
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  child: Container(
                    height: 100.0,
                    margin: EdgeInsets.all(0.5),
                    child: Hero(
                      tag: 'pic7',
                      child: Image.network(
                        CONFIG.BASE_URL + imageList[7],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  onTap: () {
                    _previewImages(context, 7);
                  },
                ),
              ),
            ],
          ),
        );
        break;
      case 9:
        imageBox = Container(
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  height: 100.0,
                  margin: EdgeInsets.all(0.5),
                  child: Column(
                    children: <Widget>[
                      GestureDetector(
                        child: Container(
                          width: double.infinity,
                          height: 50.0,
                          child: Hero(
                            tag: 'pic0',
                            child: Image.network(
                              CONFIG.BASE_URL + imageList[0],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        onTap: () {
                          _previewImages(context, 0);
                        },
                      ),
                      GestureDetector(
                        child: Container(
                          width: double.infinity,
                          height: 50.0,
                          child: Hero(
                            tag: 'pic1',
                            child: Image.network(
                              CONFIG.BASE_URL + imageList[1],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        onTap: () {
                          _previewImages(context, 1);
                        },
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  height: 100.0,
                  margin: EdgeInsets.all(0.5),
                  child: Column(
                    children: <Widget>[
                      GestureDetector(
                        child: Container(
                          width: double.infinity,
                          height: 50.0,
                          child: Hero(
                            tag: 'pic2',
                            child: Image.network(
                              CONFIG.BASE_URL + imageList[2],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        onTap: () {
                          _previewImages(context, 2);
                        },
                      ),
                      GestureDetector(
                        child: Container(
                          width: double.infinity,
                          height: 50.0,
                          child: Hero(
                            tag: 'pic3',
                            child: Image.network(
                              CONFIG.BASE_URL + imageList[3],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        onTap: () {
                          _previewImages(context, 3);
                        },
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  height: 100.0,
                  margin: EdgeInsets.all(0.5),
                  child: Column(
                    children: <Widget>[
                      GestureDetector(
                        child: Container(
                          width: double.infinity,
                          height: 50.0,
                          child: Hero(
                            tag: 'pic4',
                            child: Image.network(
                              CONFIG.BASE_URL + imageList[4],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        onTap: () {
                          _previewImages(context, 4);
                        },
                      ),
                      GestureDetector(
                        child: Container(
                          width: double.infinity,
                          height: 50.0,
                          child: Hero(
                            tag: 'pic5',
                            child: Image.network(
                              CONFIG.BASE_URL + imageList[5],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        onTap: () {
                          _previewImages(context, 5);
                        },
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  height: 100.0,
                  margin: EdgeInsets.all(0.5),
                  child: Column(
                    children: <Widget>[
                      GestureDetector(
                        child: Container(
                          width: double.infinity,
                          height: 50.0,
                          child: Hero(
                            tag: 'pic6',
                            child: Image.network(
                              CONFIG.BASE_URL + imageList[6],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        onTap: () {
                          _previewImages(context, 6);
                        },
                      ),
                      GestureDetector(
                        child: Container(
                          width: double.infinity,
                          height: 50.0,
                          child: Hero(
                            tag: 'pic7',
                            child: Image.network(
                              CONFIG.BASE_URL + imageList[7],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        onTap: () {
                          _previewImages(context, 7);
                        },
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: GestureDetector(
                  child: Container(
                    height: 100.0,
                    margin: EdgeInsets.all(0.5),
                    child: Hero(
                      tag: 'pic8',
                      child: Image.network(
                        CONFIG.BASE_URL + imageList[8],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  onTap: () {
                    _previewImages(context, 8);
                  },
                ),
              ),
            ],
          ),
        );
        break;
      default:
    }
    return imageBox;
  }
}
