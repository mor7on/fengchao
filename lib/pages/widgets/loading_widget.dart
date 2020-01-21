import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

final loadWidget = Container(
  width: double.infinity,
  height: 400.0,
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Container(
        width: 50.0,
        height: 50.0,
        child: SpinKitCircle(
          color: Colors.blue,
          size: 25.0,
        ),
      ),
      Container(
        child:
            Text('正在加载...', style: TextStyle(fontSize: 12.0, color: Color(0xFF999999))),
      )
    ],
  ),
);
