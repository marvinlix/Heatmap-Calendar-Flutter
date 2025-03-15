import 'package:flutter/material.dart';
import 'package:heatmap_calendar_flutter/src/enums/i18n_model.dart';
import '../utils/date_util.dart';

class HeatMapWeekText extends StatelessWidget {
  /// The margin value for correctly space between labels.
  final EdgeInsets? margin;

  /// The double value of label's font size.
  final double? fontSize;

  /// The double value of every block's size to fit the height.
  final double? size;

  /// The double value of week label's fontSize.
  final double? weekFontSize;

  /// The text color value of week labels.
  final Color? weekTextColor;

  final HeatmapLocaleType locale;

  const HeatMapWeekText({
    Key? key,
    this.margin,
    this.fontSize,
    this.size,
    this.weekFontSize,
    this.weekTextColor,
    this.locale = HeatmapLocaleType.en
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (String label in weekLabelInLocale(locale))
          Container(
            height: size ?? 20,
            margin: margin ?? const EdgeInsets.all(2.0),
            child: Text(
              label,
              style: TextStyle(
                fontSize: weekFontSize ?? 9,
                color: weekTextColor ?? const Color(0xFF758EA1),
              ),
            ),
          ),
      ],
    );
  }
}
