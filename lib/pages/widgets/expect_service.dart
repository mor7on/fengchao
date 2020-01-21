import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class ExpectServiceComponent extends StatelessWidget {
  const ExpectServiceComponent({Key key}) : super(key: key);

  void updateStatusBarBrightness() {
    Future.delayed(Duration(milliseconds: 600), () {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    this.updateStatusBarBrightness();
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset('assets/images/expect_service_bg.png', fit: BoxFit.cover),
          ),
          BottomBackground(),
          Positioned(
            top: 160.0,
            left: 50.0,
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '敬请期待',
                    style: TextStyle(fontSize: 30.0, color: Colors.white),
                  ),
                  Text(
                    '该功能正在紧张制作中...',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class BottomBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WaveWidget(
      config: CustomConfig(
          gradients: [
            [Color.fromRGBO(72, 74, 126, 1), Color.fromRGBO(125, 170, 206, 1), Color.fromRGBO(184, 189, 245, 0.7)],
            [Color.fromRGBO(72, 74, 126, 1), Color.fromRGBO(125, 170, 206, 1), Color.fromRGBO(172, 182, 219, 0.7)],
            [Color.fromRGBO(72, 73, 126, 1), Color.fromRGBO(125, 170, 206, 1), Color.fromRGBO(190, 238, 246, 0.7)],
          ],
          durations: [
            19440,
            10800,
            6000
          ],
          heightPercentages: [
            0.63,
            0.61,
            0.65
          ],
          gradientBegin: Alignment.bottomCenter,
          gradientEnd: Alignment.center,
          blur: MaskFilter.blur(BlurStyle.outer, 20.0)),
      size: Size(double.infinity, double.infinity),
      waveAmplitude: 25,
      backgroundColor: Colors.transparent,
    );
  }
}
