import 'dart:math';

import 'package:flutter/material.dart';
import 'package:heatmap_calendar_flutter/src/data/heatmap_datasets.dart';
import 'package:heatmap_calendar_flutter/src/enums/i18n_model.dart';
import '../../heatmap_calendar_flutter.dart';
import './heatmap_month_text.dart';
import './heatmap_column.dart';
import '../enums/heatmap_color_mode.dart';
import '../utils/datasets_util.dart';
import '../utils/date_util.dart';
import './heatmap_week_text.dart';
import 'heatmap_month_column.dart';

class HeatMapDayPage extends StatelessWidget {
  /// The Date value of start day of heatmap.
  ///
  /// HeatMap shows the start day of [startDate]'s week.
  ///
  /// Default value is 1 year before the [endDate].
  /// And if [endDate] is null, then set 1 year before the [DateTime.now]
  final DateTime startDate;

  /// The Date value of end day of heatmap.
  ///
  /// Default value is [DateTime.now]
  final DateTime endDate;

  /// The double value of every block's width and height.
  final double? size;

  /// The double value of every block's fontSize.
  final double? fontSize;

  /// The datasets which fill blocks based on its value.
  final Map<DateTime, HeatmapData>? datasets;

  /// The margin value for every block.
  final EdgeInsets? margin;

  /// The default background color value of every blocks.
  final Color? defaultColor;

  /// The text color value of every blocks.
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

  /// The double value of every block's borderRadius.
  final double? borderRadius;

  /// The integer value of the maximum value for the [datasets].
  ///
  /// Get highest key value of filtered datasets using [DatasetsUtil.getMaxValue].
  final int? maxValue;
  final int? lineCount;

  /// Function that will be called when a block is clicked.
  ///
  /// Paratmeter gives clicked [DateTime] value.
  final Function(DateTime, HeatmapData)? onClick;

  /// The double value of week label's fontSize.
  final double? monthFontSize;

  /// The text color value of week labels.
  final Color? monthTextColor;

  final HeatmapLocaleType locale;

  HeatMapDayPage({
    Key? key,
    required this.colorMode,
    required this.heatmapType,
    required this.startDate,
    required this.endDate,
    this.size,
    this.fontSize,
    this.datasets,
    this.defaultColor,
    this.textColor,
    this.colorsets,
    this.borderRadius,
    this.onClick,
    this.margin,
    this.monthFontSize,
    this.monthTextColor,
    this.lineCount,
    this.locale = HeatmapLocaleType.en,
  })  : maxValue = DatasetsUtil.getMaxValue(datasets),
        super(key: key);

  /// Get [HeatMapColumn] from [startDate] to [endDate].
  List<Widget> _heatmapColumnList() {
    // Create empty list.
    List<Widget> columns = [];

    DateTime firstDate = startDate;

    while (firstDate.isBefore(endDate)) {
      DateTime lastDate = DateUtil.changeDay(firstDate, lineCount ?? 7);
      if (lastDate.isAfter(endDate)) {
        lastDate = endDate;
      }

      columns.add(HeatMapMonthColumn(
        startDate: DateTime(firstDate.year, firstDate.month, firstDate.day),
        endDate: DateTime(lastDate.year, lastDate.month, lastDate.day),
        colorMode: colorMode,
        heatmapType: heatmapType,
        size: size,
        fontSize: fontSize,
        defaultColor: defaultColor,
        colorsets: colorsets,
        textColor: textColor,
        borderRadius: borderRadius,
        margin: margin,
        maxValue: maxValue,
        onClick: onClick,
        datasets: datasets,
        flexible: true,
        showBackgroundImage: false,
        showMonthLabel: false,
        locale: locale,
        lineCount: lineCount ?? 7,
        aspectRatio: 1.0,
      ));

      print('$firstDate, $lastDate');

      firstDate = DateTime(lastDate.year, lastDate.month, lastDate.day + 1);
    }

    return columns;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ..._heatmapColumnList(),
            ],
          ),
        ),
      ],
    );
  }
}
