
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class UniIconButton extends StatefulWidget {

  final VoidCallback onPressed;


  const UniIconButton({Key key, this.onPressed}) : super(key: key);
  @override
  _UniIconButtonState createState() => _UniIconButtonState();

}

class _UniIconButtonState extends State<UniIconButton> {

  int state = 1;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 40.0,
      child: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: Colors.blueGrey,
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(right: 12.0),
                  child: state == 1 ?  Icon(Icons.near_me,color: Colors.white70,size: 20.0,) : SpinKitCircle(color: Colors.white70,size: 20.0,),
                ),
                Container(
                  width: 50.0,
                  child: Text('提交',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600)),
                )
              ],
            ),
          ),
          Positioned.fill(child: Material(
            color: Colors.transparent,
            child: InkWell(
              enableFeedback: false,
              borderRadius: BorderRadius.circular(5.0),
              splashColor: Colors.black.withOpacity(0.1),
              highlightColor: Colors.black.withOpacity(0.1),
              onTap: (){
                state = 2;
                print('11111111111');
                widget.onPressed();
              },
            ),
          )),
        ],
      ),
    );
  }
}
