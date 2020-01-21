
import 'package:flutter/material.dart';

class NumberKeyboardWidget extends StatelessWidget {
  NumberKeyboardWidget({
    Key key,
    @required AnimationController controller,
    this.numberFunc,
    this.deleteFunc,
    this.confirmFunc,
    this.confirmWidget,
    this.number = const [1, 2, 3, 4, 5, 6, 7, 8, 9, '', 0, ''],
  })  : _controller = controller,
        super(key: key);

  final AnimationController _controller;
  final Function numberFunc;
  final VoidCallback deleteFunc;
  final VoidCallback confirmFunc;
  final Widget confirmWidget;
  final List<dynamic> number;
  final double _kHeight = 260.0;
  final double _topHeight = 30.0;

  @override
  Widget build(BuildContext context) {
    final double screenWith = MediaQuery.of(context).size.width;

    return Container(
      width: screenWith,
      height: _kHeight,
      color: Colors.grey.withOpacity(0.2),
      child: Column(
        children: <Widget>[
          Container(
            width: screenWith,
            height: _topHeight,
            color: Colors.grey[200],
            child: FlatButton(
              padding: EdgeInsets.zero,
              child: Icon(Icons.keyboard_arrow_down),
              onPressed: () {
                if (_controller.isCompleted) {
                  _controller.reverse();
                }
              },
            ),
          ),
          Container(
            child: Row(
              children: <Widget>[
                Container(
                  width: screenWith * 0.75,
                  child: Wrap(
                    children: number.map((f) {
                      return Container(
                        width: screenWith * 0.25,
                        height: (_kHeight - _topHeight) / 4,
                        decoration: BoxDecoration(
                          border: Border.fromBorderSide(
                            BorderSide(width: 0.5, color: Colors.grey),
                          ),
                        ),
                        child: FlatButton(
                          child: Text(
                            '$f',
                            style: TextStyle(fontSize: 25.0),
                          ),
                          onPressed: () {
                            print('$f');
                            if (f == '') return;
                            numberFunc(f);
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Container(
                  width: screenWith * 0.25,
                  height: _kHeight - _topHeight,
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.fromBorderSide(
                              BorderSide(width: 0.5, color: Colors.grey),
                            ),
                          ),
                          child: FlatButton(
                            child: Icon(Icons.first_page),
                            onPressed: deleteFunc,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.fromBorderSide(
                              BorderSide(width: 0.5, color: Colors.grey),
                            ),
                          ),
                          child: FlatButton(
                            child: confirmWidget,
                            onPressed: confirmFunc,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}