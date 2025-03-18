import 'package:flutter/material.dart';
import 'package:heatmap_calendar_flutter/heatmap_calendar_flutter.dart';

class WidgetUtil {
  /// Make [HeatMapContainer] flexible size if [isFlexible] is true.
  static Widget flexibleContainer(bool isFlexible, bool isSquare, Widget child, HeatmapCalendarType heatmapType) {
    return isFlexible
        ? Expanded(
            child: isSquare
                ? AspectRatio(
                    aspectRatio: heatmapType == HeatmapCalendarType.intensity ? 1 : 0.7,
                    child: child,
                  )
                : child,
          )
        : child;
  }
}
