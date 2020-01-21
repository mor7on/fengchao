import 'package:flutter/material.dart';

class ReplyScreenDialog extends StatefulWidget {
  ReplyScreenDialog({Key key}) : super(key: key);

  @override
  _ReplyScreenDialogState createState() => _ReplyScreenDialogState();
}

class _ReplyScreenDialogState extends State<ReplyScreenDialog> with SingleTickerProviderStateMixin {
  TextEditingController _textController = TextEditingController();
  AnimationController _controller;
  Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 400), vsync: this);
    final Animation curve = CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn);
    _animation = Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(curve);

    _controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
    _textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Stack(
        children: <Widget>[
          Container(),
          Positioned(
            bottom: 0.0,
            child: SlideTransition(
              position: _animation,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 200.0,
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 40.0,
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            width: 50.0,
                            height: 30.0,
                            child: FlatButton(
                              padding: EdgeInsets.zero,
                              child: Text('取消'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          Container(
                            width: 50.0,
                            height: 30.0,
                            child: FlatButton(
                              padding: EdgeInsets.zero,
                              child: Text('确定'),
                              color: Colors.green[100],
                              onPressed: () {
                                String content = _textController.text.trim();
                                if (content.isNotEmpty) {
                                  print('----' + content + '----');
                                  print(content.length);
                                  Navigator.pop(context, content);
                                }
                                // Navigator.pop(context, _textController.text);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextFormField(
                        // autofocus: true,
                        controller: _textController,
                        keyboardType: TextInputType.multiline,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: '回复留言',
                          hintText: '请输入回复留言...',
                          alignLabelWithHint: true,
                        ),
                        maxLines: 4,
                        maxLength: 500,
                        style: TextStyle(fontSize: 14.0, height: 1.5, textBaseline: TextBaseline.alphabetic),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
