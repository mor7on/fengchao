import 'package:flutter/material.dart';

class CustomExpandScrollView extends StatelessWidget {
  const CustomExpandScrollView({Key key, this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: child
          ),
        ),
      ],
    );
  }
}