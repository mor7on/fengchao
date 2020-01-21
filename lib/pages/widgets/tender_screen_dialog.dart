import 'package:bot_toast/bot_toast.dart';
import 'package:fengchao/pages/widgets/num_keyboard.dart';
import 'package:fengchao/pages/widgets/textfield/custom_textfield.dart';
import 'package:flutter/material.dart';

class TenderScreenDialog extends StatefulWidget {
  TenderScreenDialog({Key key}) : super(key: key);

  @override
  _TenderScreenDialogState createState() => _TenderScreenDialogState();
}

class _TenderScreenDialogState extends State<TenderScreenDialog> with SingleTickerProviderStateMixin {
  TextEditingController _textEditingController;
  AnimationController _controller;
  Animation<Offset> _animation;
  List<dynamic> _charge = [];

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    _textEditingController.addListener((){
      _textEditingController.selection = TextSelection(baseOffset:_charge.length , extentOffset:_charge.length);
    });
    _controller = AnimationController(duration: const Duration(milliseconds: 400), vsync: this);
    final Animation curve = CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn);
    _animation = Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(curve);

    _controller.forward();
  }

  void _deleteFunc() {
    if (_charge.length < 1) {
      return;
    }
    _charge.removeLast();
    _textEditingController.text = _charge.join();
    setState(() {});
  }

  void _numberFunc(n) {
    print(_charge);
    // if (_charge.length >= 6) {
    //   return;
    // }
    _charge.add(n);
    _textEditingController.text = _charge.join();
    setState(() {});
  }

  void _confirmFunc() {
    print(_charge.join());
    double doubleCharge = double.tryParse(_charge.join());
    if (doubleCharge == null || doubleCharge < 10.0) {
      BotToast.showText(text: '投标价格不得低于10元', textStyle: TextStyle(fontSize: 14.0, color: Colors.white));
      return;
    }else {
      Navigator.pop(context, doubleCharge);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Stack(
        children: <Widget>[
          Container(),
          Container(
            padding: EdgeInsets.only(top: 120.0, left: 32.0, right: 32.0),
            height: 312.0,
            child: Container(
              padding: EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 24.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0)
              ),
              child: Column(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        height: 24.0,
                        alignment: Alignment.center,
                        child: Text('投标报价'),
                      ),
                      Positioned(
                        top: 0.0,
                        right: 0.0,
                        child: Container(
                          width: 24.0,
                          height: 24.0,
                          child: Material(
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: Icon(Icons.close,size: 18.0,color: Colors.grey,),
                              onPressed: (){
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Divider(),
                  SizedBox(height: 16.0,),
                  CustomTextField(
                    autofocus: true,
                    systemKeyboardActive: false,
                    onTap: (){
                      if (_controller.isDismissed) {
                        _controller.forward();
                      }
                    },
                    controller: _textEditingController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      // labelText: '投标金额',
                      hintText: '投标金额',
                      helperText: '投标金额不得小于10元',
                      // isDense: true,
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: Container(
                          width: 20.0,
                          alignment: Alignment.bottomCenter,
                          child: Text(
                            '¥',
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                      ),
                      suffix: Text(
                        'CNY',
                        style: TextStyle(fontSize: 24.0, color: Colors.green),
                      ),
                      alignLabelWithHint: true,
                    ),
                    maxLines: 1,
                    style: TextStyle(fontSize: 24.0, height: 1.5, textBaseline: TextBaseline.alphabetic),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0.0,
            child: SlideTransition(
              position: _animation,
              child: Container(
                color: Colors.white,
                child: NumberKeyboardWidget(
                  controller: _controller,
                  numberFunc: _numberFunc,
                  deleteFunc: _deleteFunc,
                  confirmFunc: _confirmFunc,
                  confirmWidget: Text('确定'),
                  number: [1, 2, 3, 4, 5, 6, 7, 8, 9, '.', 0, ''],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
