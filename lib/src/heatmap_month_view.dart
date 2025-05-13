import 'package:flutter/material.dart';

import '../heatmap_calendar_flutter.dart';
import './utils/date_util.dart';
import './widgets/heatmap_color_tip.dart';
import 'widgets/heatmap_month_page.dart';

class HeatMapMonthView extends StatelessWidget {
  /// The Date value of start day of heatmap.
  ///
  /// HeatMap shows the start day of [startDate]'s week.
  ///
  /// Default value is 1 year before of the [endDate].
  /// And if [endDate] is null, then set 1 year before of the [DateTime.now].
  final DateTime? startDate;

  /// The Date value of end day of heatmap.
  ///
  /// Default value is [DateTime.now].
  final DateTime? endDate;

  /// The datasets which fill blocks based on its value.
  final Map<DateTime, HeatmapData>? datasets;

  /// The color value of every block's default color.
  final Color? defaultColor;

  /// The text color value of every blocks.
  final Color? textColor;

  /// The double value of every block's size.
  final double? size;

  /// The double value of every block's fontSize.
  final double? fontSize;

  /// The double value of week label's fontSize.
  final double? weekFontSize;

  /// The text color value of week labels.
  final Color? weekTextColor;

  /// The colorsets which give the color value for its thresholds key value.
  ///
  /// Be aware that first Color is the maximum value if [ColorMode] is [ColorMode.opacity].
  /// Also colorsets must have at least one color.
  final Map<int, Color> colorsets;

  /// ColorMode changes the color mode of blocks.
  ///
  /// [ColorMode.opacity] requires just one colorsets value and changes color
  /// dynamically based on hightest value of [datasets].
  /// [ColorMode.color] changes colors based on [colorsets] thresholds key value.
  ///
  /// Default value is [ColorMode.opacity].
  final ColorMode colorMode;

  /// HeatmapCalendarType changes the UI mode of blocks.
  ///
  /// [HeatmapCalendarType.intensity] requires just the intensity value to change the color
  /// dynamically based on hightest value of [datasets].
  /// [HeatmapCalendarType.widgets] requires the list of widgets (list of events/activities) on the same date.
  ///
  /// Default value is [HeatmapCalendarType.intensity].
  final HeatmapCalendarType heatmapType;

  /// Show widget legends of the heatmap if [HeatmapCalendarType] is [HeatmapCalendarType.widgets] at the below.
  final List<HeatmapChildrenData>? heatmapWidgetLegends;

  /// Function that will be called when a block is clicked.
  ///
  /// Parameter gives clicked [DateTime] value.
  final Function(DateTime, HeatmapData)? onClick;

  /// The margin value for every block.
  final EdgeInsets? margin;

  /// The double value of every block's borderRadius.
  final double? borderRadius;

  /// Show day text in every blocks if the value is true.
  ///
  /// Default value is false.
  final bool? showText;

  final bool? showBackgroundImage;

  /// Show color tip which represents the color range at the below.
  ///
  /// Default value is true.
  final bool? showColorTip;

  /// Makes heatmap scrollable if the value is true.
  ///
  /// default value is false.
  final bool scrollable;

  /// Widgets which shown at left and right side of colorTip.
  ///
  /// First value is the left side widget and second value is the right side widget.
  /// Be aware that [colorTipHelper.length] have to greater or equal to 2.
  /// Give null value makes default 'less' and 'more' [Text].
  final List<Widget?>? colorTipHelper;

  /// The integer value which represents the number of [HeatMapColorTip]'s tip container.
  final int? colorTipCount;

  /// The double value of [HeatMapColorTip]'s tip container's size.
  final double? colorTipSize;
  final double? aspectRatio;

  final HeatmapLocaleType locale;

  const HeatMapMonthView(
      {Key? key,
      required this.colorsets,
      this.colorMode = ColorMode.opacity,
      this.heatmapType = HeatmapCalendarType.intensity,
      this.heatmapWidgetLegends,
      this.startDate,
      this.endDate,
      this.textColor,
      this.size,
      this.fontSize = 10,
      this.onClick,
      this.margin,
      this.borderRadius,
      this.datasets,
      this.defaultColor,
      this.showText = false,
      this.showBackgroundImage = false,
      this.showColorTip = false,
      this.scrollable = false,
      this.colorTipHelper,
      this.colorTipCount,
      this.colorTipSize,
      this.weekFontSize,
      this.weekTextColor,
      this.aspectRatio,
      this.locale = HeatmapLocaleType.en})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        HeatMapMonthPage(
          endDate: endDate ?? DateTime.now(),
          startDate: startDate ?? DateUtil.oneYearBefore(endDate ?? DateTime.now()),
          colorMode: colorMode,
          heatmapType: heatmapType,
          size: size,
          fontSize: fontSize,
          datasets: datasets,
          defaultColor: defaultColor,
          textColor: textColor,
          colorsets: colorsets,
          borderRadius: borderRadius,
          onClick: onClick,
          margin: margin,
          showText: showText,
          showBackgroundImage: showBackgroundImage,
          locale: locale,
          aspectRatio: aspectRatio,
        ),
        // Show HeatMapColorTip if showColorTip is true.
        if (showColorTip == true)
          HeatMapColorTip(
            colorMode: colorMode,
            heatmapType: heatmapType,
            heatmapWidgetLegends: heatmapWidgetLegends,
            colorsets: colorsets,
            leftWidget: colorTipHelper?[0],
            rightWidget: colorTipHelper?[1],
            containerCount: colorTipCount,
            size: colorTipSize,
            locale: locale,
          ),
      ],
    );
  }
}
