import 'package:flutter/widgets.dart';

class HeatmapChildrenData {

  /// label of the child
  final String label;

  /// description of the child
  final String desc;

  /// widget of the child
  final Widget? child;

  /// background image url
  final String? backgroundImage;

  HeatmapChildrenData({required this.label, required this.desc, this.backgroundImage, this.child});

}