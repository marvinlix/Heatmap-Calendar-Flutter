import 'package:flutter/material.dart';
import 'package:heatmap_calendar_flutter/heatmap_calendar_flutter.dart';
import './heatmap_calendar_row.dart';
import '../utils/date_util.dart';
import '../utils/datasets_util.dart';

class HeatMapCalendarPage extends StatelessWidget {
  /// The DateTime value which contains the current calendar's date value.
  final DateTime baseDate;

  /// The list value of the map value that contains
  /// separated start and end of every weeks on month.
  ///
  /// Separate [datasets] using [DateUtil.separatedMonth].
  final List<Map<DateTime, DateTime>> separatedDate;

  /// The margin value for every block.
  final EdgeInsets? margin;

  /// Make block size flexible if value is true.
  final bool? flexible;

  /// The double value of every block's width and height.
  final double? size;

  /// The double value of every block's fontSize.
  final double? fontSize;

  /// The datasets which fill blocks based on its value.
  final Map<DateTime, HeatmapData>? datasets;

  /// The default background color value of every blocks
  final Color? defaultColor;

  /// The text color value of every blocks
  final Color? textColor;

  /// ColorMode changes the color mode of blocks.
  ///
  /// [ColorMode.opacity] requires just one colorsets value and changes color
  /// dynamically based on hightest value of [datasets].
  /// [ColorMode.color] changes colors based on [colorsets] thresholds key value.
  final ColorMode colorMode;

  /// HeatmapCalendarType changes the UI mode of blocks.
  ///
  /// [HeatmapCalendarType.intensity] requires just the intensity value to change the color
  /// dynamically based on hightest value of [datasets].
  /// [HeatmapCalendarType.widgets] requires the list of widgets (list of events/activities) on the same date.
  ///
  /// Default value is [HeatmapCalendarType.intensity].
  final HeatmapCalendarType heatmapType;

  /// The colorsets which give the color value for its thresholds key value.
  ///
  /// Be aware that first Color is the maximum value if [ColorMode] is [ColorMode.opacity].
  final Map<int, Color>? colorsets;

  /// The double value of every block's borderRadius
  final double? borderRadius;

  /// The integer value of the maximum value for the [datasets].
  ///
  /// Filtering [datasets] with [baseDate] using [DatasetsUtil.filterMonth].
  /// And get highest key value of filtered datasets using [DatasetsUtil.getMaxValue].
  final int? maxValue;

  /// Function that will be called when a block is clicked.
  ///
  /// Paratmeter gives clicked [DateTime] value.
  final Function(DateTime, HeatmapData)? onClick;

  final bool? showBackgroundImage;

  final HeatmapLocaleType locale;

  HeatMapCalendarPage({
    Key? key,
    required this.baseDate,
    required this.colorMode,
    required this.heatmapType,
    this.flexible,
    this.size,
    this.fontSize,
    this.defaultColor,
    this.textColor,
    this.margin,
    this.datasets,
    this.colorsets,
    this.borderRadius,
    this.onClick,
    this.showBackgroundImage = false,
    this.locale = HeatmapLocaleType.en,
  })  : separatedDate = DateUtil.separatedMonth(baseDate),
        maxValue = DatasetsUtil.getMaxValue(
            DatasetsUtil.filterMonth(datasets, baseDate)),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (var date in separatedDate)
          HeatMapCalendarRow(
            locale: locale,
            startDate: date.keys.first,
            endDate: date.values.first,
            colorMode: colorMode,
            heatmapType: heatmapType,
            size: size,
            fontSize: fontSize,
            defaultColor: defaultColor,
            colorsets: colorsets,
            textColor: textColor,
            borderRadius: borderRadius,
            flexible: flexible,
            margin: margin,
            maxValue: maxValue,
            onClick: onClick,
            showBackgroundImage: showBackgroundImage,
            datasets: Map.from(datasets ?? {})
              ..removeWhere(
                (key, value) => !(key.isAfter(date.keys.first) &&
                        key.isBefore(date.values.first) ||
                    key == date.keys.first ||
                    key == date.values.first),
              ),
          ),
      ],
    );
  }
}
