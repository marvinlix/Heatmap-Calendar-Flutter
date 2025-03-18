import 'package:flutter/material.dart';

class WidgetUtil {
  static Widget flexibleContainer(bool isFlexible, bool isSquare, Widget child, double? aspectRatio) {
    return isFlexible
        ? Expanded(
            child: isSquare
                ? AspectRatio(
                    aspectRatio: aspectRatio ?? 1,
                    child: child,
                  )
                : child,
          )
        : child;
  }
}
