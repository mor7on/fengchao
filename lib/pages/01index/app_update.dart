import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fengchao/common/config/config.dart';
import 'package:fengchao/models/app_info.dart';
import 'package:fengchao/pages/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class AppUpdateComponent extends StatefulWidget {
  AppUpdateComponent({Key key}) : super(key: key);

  @override
  _AppUpdateComponentState createState() => _AppUpdateComponentState();
}

class _AppUpdateComponentState extends State<AppUpdateComponent> {
  int _loadState = 0;
  List<String> _loadText = ['正在检查更新...', '已是最新版本', '发现新版本', '正在下载...'];
  AppInfo _appInfo;
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    checkAppUpdate();
  }

  void checkAppUpdate() async {
    try {
      Dio dio = new Dio();
      Response response;
      response = await dio.get('http://www.4u2000.com/sesame/api/center/version');
      print(response);
      if (response.statusCode == 200) {
        Map<String, dynamic> res = response.data;
        if (res['code'] == 1) {
          _appInfo = AppInfo.fromJson(res['data']);
          if (_appInfo.versioncode > CONFIG.APP_VER) {
            _loadState = 2;
          } else {
            _loadState = 1;
          }
          if (mounted) {
            setState(() {});
          }
        }
      }
    } catch (e) {
      throw Exception('系统错误');
    }
  }

  CancelToken token = CancelToken();
  void _downloadFile() async {
    setState(() {
      _loadState = 3;
    });
    String filePath = _appInfo.link;
    var name = filePath.substring(filePath.lastIndexOf("/"), filePath.length);
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path + name;
    // String tempPath = './' + name;
    print(tempPath);
    try {
      Dio dio = new Dio();
      Response response;
      response =
          await dio.download(filePath, tempPath, onReceiveProgress: _onDownloadProgress, cancelToken: token);
      if (response.statusCode == 200) {
        OpenFile.open(tempPath);
      }
    } catch (e) {
      print('Request canceled! ' + e.toString());
      setState(() {
        _loadState = 2;
      });
    }
    // print(response);
  }

  void _onDownloadProgress(received, total) {
    if (total != -1) {
      setState(() {
        _progress = received / total;
      });
      print((received / total * 100).toStringAsFixed(1) + "%");
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text('版本更新'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        width: 120.0,
                        height: 120.0,
                        decoration: BoxDecoration(
                          border: Border.all(width: 5.0,color: Colors.blueGrey),
                          borderRadius: BorderRadius.circular(120.0),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(120.0),
                          child: DownloadBackground(
                            progress: _progress,
                          ),
                        ),
                      ),
                      Container(
                        width: 120.0,
                        height: 120.0,
                        child: Center(
                          child: Text((_progress * 100).toStringAsFixed(1) + '%'),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Text('${_loadText[_loadState]}'),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ListTile(
                    title: Text('当前版本号：${CONFIG.APP_VER}'),
                    subtitle: Text('当前版本名称；${CONFIG.APP_VER_NAME}'),
                    dense: true,
                  ),
                  _appInfo == null
                      ? Container()
                      : ListTile(
                          title: Text('最新版本号：${_appInfo.versioncode}'),
                          subtitle: Text('最新版本名称；${_appInfo.versionname}'),
                          dense: true,
                        ),
                ],
              ),
            ),
          ),
          Container(
            height: 50.0,
            padding: EdgeInsets.only(bottom: 20.0),
            child: FlatButton(
              color: Colors.green[200],
              child: Text('下载更新'),
              onPressed: _loadState == 2 ? _downloadFile : null,
            ),
          )
        ],
      ),
    );
  }
}

class DownloadBackground extends StatelessWidget {
  final double progress;

  const DownloadBackground({Key key, this.progress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double kHeight = 1.0 - progress;
    return WaveWidget(
      config: CustomConfig(
        gradients: [
          [Color.fromRGBO(172, 189, 226, 0.7), Color.fromRGBO(125, 170, 206, 0.6), Color.fromRGBO(184, 189, 245, 0.5)],
          [Color.fromRGBO(150, 160, 226, 0.7), Color.fromRGBO(125, 170, 206, 0.6), Color.fromRGBO(172, 182, 219, 0.5)],
          [Color.fromRGBO(150, 150, 226, 0.7), Color.fromRGBO(125, 170, 206, 0.6), Color.fromRGBO(190, 238, 246, 0.5)],
        ],
        durations: [19440, 10800, 6000],
        heightPercentages: [kHeight - 0.13, kHeight - 0.10, kHeight - 0.12],
        gradientBegin: Alignment.bottomCenter,
        gradientEnd: Alignment.topCenter,
      ),
      size: Size(double.infinity, double.infinity),
      waveAmplitude: 0.5,
      waveFrequency: 1.0,
      wavePhase: 10.0,
      backgroundColor: Colors.blue[50],
    );
  }
}
