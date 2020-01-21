import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

class CustomToastWidget extends StatelessWidget {
  final CancelFunc cancelFunc;
  final IconData icon;
  final String title;

  const CustomToastWidget({Key key, this.cancelFunc, this.icon, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: Colors.black38,
        child: Container(
          width: 160.0,
          height: 100.0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(icon,size: 60.0,color: Colors.white,),
              Text(
                title,
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }
}

