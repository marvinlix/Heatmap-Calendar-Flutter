import 'package:flutter/material.dart';
import 'package:heatmap_calendar_flutter/src/data/heatmap_datasets.dart';
import '../../heatmap_calendar_flutter.dart';
import '../enums/heatmap_color_mode.dart';
import './heatmap_container.dart';
import '../utils/date_util.dart';
import '../utils/datasets_util.dart';

class HeatMapColumn extends StatelessWidget {
  /// The List widgets of [HeatMapContainer].
  ///
  /// It includes every days of the week and
  /// if one week doesn't have 7 days, it will be filled with empty [Container].
  final List<Widget> dayContainers;

  /// The List widgets of empty [Container].
  ///
  /// It only processes when given week's length is not 7.
  final List<Widget> preEmptySpace;

  /// The List widgets of empty [Container].
  ///
  /// It only processes when given week's length is not 7.
  final List<Widget> postEmptySpace;

  /// The date value of first day of given week.
  final DateTime startDate;

  /// The date value of last day of given week.
  final DateTime endDate;

  /// The double value of every [HeatMapContainer]'s width and height.
  final double? size;

  /// The double value of every [HeatMapContainer]'s fontSize.
  final double? fontSize;

  /// The default background color value of [HeatMapContainer].
  final Color? defaultColor;

  /// The datasets which fill blocks based on its value.
  ///
  /// datasets keys have to greater or equal to [startDate] and
  /// smaller or equal to [endDate].
  final Map<DateTime, HeatmapData>? datasets;

  /// The text color value of [HeatMapContainer].
  final Color? textColor;

  /// The colorsets which give the color value for its thresholds key value.
  ///
  /// Be aware that first Color is the maximum value if [ColorMode] is [ColorMode.opacity].
  final Map<int, Color>? colorsets;

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

  /// The double value of [HeatMapContainer]'s borderRadius.
  final double? borderRadius;

  /// The margin value for every block.
  final EdgeInsets? margin;

  /// Function that will be called when a block is clicked.
  ///
  /// Paratmeter gives clicked [DateTime] value.
  final Function(DateTime, HeatmapData)? onClick;

  /// The integer value of the maximum value for the highest value of the month.
  final int? maxValue;

  /// Show day text in every blocks if the value is true.
  final bool? showText;

  // The number of day blocks to draw. This should be seven for all but the
  // current week.
  final int numDays;

  final HeatmapLocaleType locale;

  final bool? showBackgroundImage;

  HeatMapColumn({
    Key? key,
    required this.startDate,
    required this.endDate,
    required this.colorMode,
    required this.heatmapType,
    required this.numDays,
    this.size,
    this.fontSize,
    this.defaultColor,
    this.datasets,
    this.textColor,
    this.borderRadius,
    this.margin,
    this.colorsets,
    this.onClick,
    this.maxValue,
    this.showText,
    this.showBackgroundImage = false,
    this.locale = HeatmapLocaleType.en
  })  :
        // Init list.
        dayContainers = List.generate(
          numDays,
          (i) => HeatMapContainer(
            locale: locale,
            date: DateUtil.changeDay(startDate, i),
            backgroundColor: defaultColor,
            heatmapType: heatmapType,
            size: size,
            fontSize: fontSize,
            textColor: textColor,
            borderRadius: borderRadius,
            margin: margin,
            onClick: onClick,
            showText: showText,
            showBackgroundImage: showBackgroundImage,
            // If datasets has DateTime key which is equal to this HeatMapContainer's date,
            // we have to color the matched HeatMapContainer.
            //
            // If datasets is null or doesn't contains the equal DateTime value, send null.
            selectedColor: datasets?.keys.contains(DateTime(
                        startDate.year,
                        startDate.month,
                        startDate.day - startDate.weekday % 7 + i)) ??
                    false
                // If colorMode is ColorMode.opacity,
                ? colorMode == ColorMode.opacity
                    // Color the container with first value of colorsets
                    // and set opacity value to current day's datasets key
                    // devided by maxValue which is the maximum value of the month.
                    ? colorsets?.values.first.withOpacity((datasets?[DateTime(
                                startDate.year,
                                startDate.month,
                                startDate.day + i - (startDate.weekday % 7))]?.intensity ??
                            1) /
                        (maxValue ?? 1))
                    // Else if colorMode is ColorMode.Color.
                    //
                    // Get color value from colorsets which is filtered with DateTime value
                    // Using DatasetsUtil.getColor()
                    : DatasetsUtil.getColor(
                        colorsets,
                        datasets?[DateTime(startDate.year, startDate.month,
                            startDate.day + i - (startDate.weekday % 7))]?.intensity)
                : null,
            heatmapData: datasets![DateTime(
                startDate.year,
                startDate.month,
                startDate.day + i - (startDate.weekday % 7))],
          ),
        ),
        // Fill emptySpace list only if given wek doesn't have 7 days.
        preEmptySpace = (numDays != 7) && startDate.weekday != 7
            ? List.generate(
          7 - numDays,
              (i) => Container(
              margin: margin ?? const EdgeInsets.all(2),
              width: size ?? 42,
              height: size ?? 42),
        )
            : [],
        // Fill emptySpace list only if given wek doesn't have 7 days.
        postEmptySpace = (numDays != 7) && endDate.weekday != 6
            ? List.generate(
                7 - numDays,
                (i) => Container(
                    margin: margin ?? const EdgeInsets.all(2),
                    width: size ?? 42,
                    height: size ?? 42),
              )
            : [],
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[...preEmptySpace, ...dayContainers, ...postEmptySpace],
    );
  }
}
