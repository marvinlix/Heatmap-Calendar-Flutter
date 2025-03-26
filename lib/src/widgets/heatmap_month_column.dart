import 'package:flutter/material.dart';
import 'package:heatmap_calendar_flutter/heatmap_calendar_flutter.dart';
import '../enums/heatmap_color_mode.dart';
import '../utils/datasets_util.dart';
import './heatmap_container.dart';
import '../utils/date_util.dart';
import '../utils/widget_util.dart';

class HeatMapMonthColumn extends StatelessWidget {
  /// The integer value of beginning date of the week.
  final DateTime startDate;

  /// The integer value of end date of the week
  final DateTime endDate;

  /// The double value of every [HeatMapContainer]'s width and height.
  final double? size;

  /// The double value of every [HeatMapContainer]'s fontSize.
  final double? fontSize;

  /// The List of row items.
  ///
  /// It includes every days of the week and
  /// if one week doesn't have 7 days, it will be filled with [SizedBox].
  final List<Widget> dayContainers;

  /// The default background color value of [HeatMapContainer]
  final Color? defaultColor;

  /// The text color value of [HeatMapContainer]
  final Color? textColor;

  /// The double value of week label's fontSize.
  final double? weekFontSize;

  /// The text color value of week labels.
  final Color? weekTextColor;

  /// The colorsets which give the color value for its thresholds key value.
  ///
  /// Be aware that first Color is the maximum value if [ColorMode] is [ColorMode.opacity].
  final Map<int, Color>? colorsets;

  /// The double value of [HeatMapContainer]'s borderRadius
  final double? borderRadius;

  /// Make block size flexible if value is true.
  final bool? flexible;

  /// The margin value for every block.
  final EdgeInsets? margin;

  /// The datasets which fill blocks based on its value.
  ///
  /// datasets keys have to greater or equal to [startDate] and
  /// smaller or equal to [endDate].
  final Map<DateTime, HeatmapData>? datasets;

  /// ColorMode changes the color mode of blocks.
  ///
  /// [ColorMode.opacity] requires just one colorsets value and changes color
  /// dynamically based on hightest value of [datasets].
  /// [ColorMode.color] changes colors based on [colorsets] thresholdsc key value.
  final ColorMode colorMode;

  /// HeatmapCalendarType changes the UI mode of blocks.
  ///
  /// [HeatmapCalendarType.intensity] requires just the intensity value to change the color
  /// dynamically based on hightest value of [datasets].
  /// [HeatmapCalendarType.widgets] requires the list of widgets (list of events/activities) on the same date.
  ///
  /// Default value is [HeatmapCalendarType.intensity].
  final HeatmapCalendarType heatmapType;

  /// The integer value of the maximum value for the highest value of the month.
  final int? maxValue;
  final bool? showBackgroundImage;
  final HeatmapLocaleType locale;

  /// Function that will be called when a block is clicked.
  ///
  /// Paratmeter gives clicked [DateTime] value.
  final Function(DateTime, HeatmapData)? onClick;

  HeatMapMonthColumn(
      {Key? key,
      required this.startDate,
      required this.endDate,
      required this.colorMode,
      required this.heatmapType,
      this.size,
      this.fontSize,
      this.defaultColor,
      this.colorsets,
      this.textColor,
      this.borderRadius,
      this.flexible,
      this.margin,
      this.datasets,
      this.maxValue,
      this.onClick,
      this.weekFontSize,
      this.weekTextColor,
      this.showBackgroundImage = false,
      this.locale = HeatmapLocaleType.en})
      : dayContainers = List<Widget>.generate(
          31,
          (i) => DateTime(startDate.year, startDate.month, startDate.day + i).isAfter(endDate) || DateTime(startDate.year, startDate.month, startDate.day + i).isBefore(startDate)
              ? Container(
                  width: size,
                  height: size,
                  margin: margin ?? const EdgeInsets.all(2),
                )
              // If the day is not a empty one then create HeatMapContainer.
              : HeatMapContainer(
                  locale: locale,
                  // Given information about the week is that
                  // start day of week value and end day of week.
                  //
                  // So we have to give every day information to each HeatMapContainer.
                  date: DateTime(startDate.year, startDate.month, startDate.day + i),
                  backgroundColor: defaultColor,
                  heatmapType: heatmapType,
                  size: size,
                  fontSize: fontSize,
                  textColor: textColor,
                  borderRadius: borderRadius,
                  margin: margin,
                  onClick: onClick,
                  showText: false,
                  showBackgroundImage: showBackgroundImage,
                  selectedColor: datasets?.keys.contains(DateTime(startDate.year, startDate.month, startDate.day + i)) ?? false
                      ? colorMode == ColorMode.opacity
                          ? colorsets?.values.first.withOpacity((datasets?[DateTime(startDate.year, startDate.month, startDate.day + i)]?.intensity ?? 1) / (maxValue ?? 1))
                          : DatasetsUtil.getColor(colorsets, datasets?[DateTime(startDate.year, startDate.month, startDate.day + i)]?.intensity)
                      : null,
                  heatmapData: datasets![DateTime(startDate.year, startDate.month, startDate.day + i)],
                ),
        ),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Container(
          width: size ?? 20,
          margin: margin ?? const EdgeInsets.all(2.0),
          child: Center(
            child: Text(
              shortMonthLabelInLocale(locale)[startDate.month],
              style: TextStyle(
                fontSize: weekFontSize ?? 9,
                color: weekTextColor ?? const Color(0xFF758EA1),
              ),
            ),
          ),
        ),
        for (Widget container in dayContainers) WidgetUtil.flexibleContainer(flexible ?? false, true, container, 0.6),
      ],
    );
  }
}
