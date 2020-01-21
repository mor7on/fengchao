import 'dart:ui' show Color;

import 'package:flutter/material.dart';

class CustomBottomBarItem {
  const CustomBottomBarItem({
    this.title,
    this.backgroundColor,
  })  : assert(title != null);

  final Widget title;

  final Color backgroundColor;
}
