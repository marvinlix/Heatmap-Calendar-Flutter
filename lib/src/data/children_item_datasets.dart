import 'package:flutter/widgets.dart';

class HeatmapChildrenData {
  /// label of the child
  final String label;

  /// color of the child
  final Color? color;

  /// widget of the child
  final Widget? child;

  /// background image url
  final String? backgroundImage;

  HeatmapChildrenData({required this.label, this.color, this.backgroundImage, this.child});

  @override
  String toString() {
    return 'HeatmapChildrenData{label: $label, desc: $color, child: $child, backgroundImage: $backgroundImage}';
  }
}
