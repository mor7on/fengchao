

import 'package:flutter/material.dart';

class UNIPasswordWidget extends StatelessWidget {
  final List<int> passwords;
  final String title;
  final Color borderColor;
  const UNIPasswordWidget({
    Key key,
    this.passwords,
    this.title,
    this.borderColor = Colors.green,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            child: Text(
              title,
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          SizedBox(
            height: 16.0,
          ),
          Stack(
            children: <Widget>[
              Container(
                height: 50.0,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.fromBorderSide(BorderSide(width: 0.5,color: borderColor)),
                    borderRadius: BorderRadius.circular(5.0),
                    boxShadow: [
                      BoxShadow(
                        color: borderColor,
                        blurRadius: 1.0,
                      ),
                    ]),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        height: 50.0,
                        decoration: BoxDecoration(
                          border: Border.fromBorderSide(BorderSide(width: 0.5,color: borderColor)),
                          borderRadius: BorderRadius.horizontal(left: Radius.circular(5.0)),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 50.0,
                        decoration: BoxDecoration(
                          border: Border.fromBorderSide(BorderSide(width: 0.5,color: borderColor)),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 50.0,
                        decoration: BoxDecoration(
                          border: Border.fromBorderSide(BorderSide(width: 0.5,color: borderColor)),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 50.0,
                        decoration: BoxDecoration(
                          border: Border.fromBorderSide(BorderSide(width: 0.5,color: borderColor)),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 50.0,
                        decoration: BoxDecoration(
                          border: Border.fromBorderSide(BorderSide(width: 0.5,color: borderColor)),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 50.0,
                        decoration: BoxDecoration(
                          border: Border.fromBorderSide(BorderSide(width: 0.5,color: borderColor)),
                          borderRadius: BorderRadius.horizontal(right: Radius.circular(5.0)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: _biuldBlackDot(),
              )
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _biuldBlackDot() {
    List<Widget> children;
    children = passwords.map((f) {
      return Expanded(
        child: Container(
          height: 50.0,
          alignment: Alignment.center,
          child: Container(
            width: 10.0,
            height: 10.0,
            decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10.0)),
          ),
        ),
      );
    }).toList();
    if (passwords.length < 6) {
      for (var i = 0; i < 6 - passwords.length; i++) {
        children.add(
          Expanded(
            child: Container(
              height: 50.0,
              alignment: Alignment.center,
              child: Container(
                width: 10.0,
                height: 10.0,
                decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(10.0)),
              ),
            ),
          ),
        );
      }
    }
    print(children.length);
    return children;
  }
}