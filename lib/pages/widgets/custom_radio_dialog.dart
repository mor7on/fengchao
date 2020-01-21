

import 'package:flutter/material.dart';

class CustomRadioDialog extends StatefulWidget {
  CustomRadioDialog({Key key, this.selected, this.title, this.body}) : super(key: key);
  final int selected;
  final Widget title;
  final List<String> body;

  @override
  _CustomRadioDialogState createState() => _CustomRadioDialogState();
}

class _CustomRadioDialogState extends State<CustomRadioDialog> {
  int radioValue;

  @override
  void initState() {
    super.initState();
    radioValue = widget.selected;
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 280.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _biuldChildren(context),
      ),
    );
  }

  List<Widget> _biuldChildren(BuildContext context) {
    Widget header;
    List<Widget> childList = [];
    header = Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: widget.title,
        );
    childList.add(header);
    for (var i = 0; i < widget.body.length; i++) {
      childList.add(RadioListTile(
          value: i,
          groupValue: radioValue,
          title: Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Text(widget.body[i]),
          ),
          controlAffinity: ListTileControlAffinity.trailing,
          onChanged: (s) {
            setState(() {
              radioValue = s;
            });
            Navigator.pop(context, s);
          },
        ));
    }
    childList.add(SizedBox(height: 16.0));
    return childList;
  }
}
