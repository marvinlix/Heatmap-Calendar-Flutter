import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:heatmap_calendar_flutter/heatmap_calendar_flutter.dart';
import '../data/heatmap_color.dart';

class HeatMapContainer extends StatelessWidget {
  final DateTime date;
  final HeatmapData? heatmapData;
  final HeatmapCalendarType? heatmapType;
  final double? size;
  final double? fontSize;
  final double? borderRadius;
  final Color? backgroundColor;
  final Color? selectedColor;
  final Color? textColor;
  final EdgeInsets? margin;
  final bool? showText;
  final bool? showBackgroundImage;
  final Function(DateTime dateTime, HeatmapData heatmapData)? onClick;
  final HeatmapLocaleType locale;
  final String? backgroundImage;

  HeatMapContainer({
    Key? key,
    required this.date,
    required this.heatmapType,
    this.heatmapData,
    this.margin,
    this.size,
    this.fontSize,
    this.borderRadius,
    this.backgroundColor,
    this.selectedColor,
    this.textColor,
    this.onClick,
    this.showText,
    this.showBackgroundImage = false,
    this.locale = HeatmapLocaleType.en
  })  : backgroundImage = findFirstNonNullImagePath(heatmapData, showBackgroundImage),
        super(key: key);

  static String? findFirstNonNullImagePath(HeatmapData? heatmapData, bool? showBackgroundImage) {
    if (heatmapData == null || heatmapData.heatMapChildren == null || heatmapData.heatMapChildren!.isEmpty) {
      return null;
    }

    if (showBackgroundImage ?? false) {
      HeatmapChildrenData? heatmapChildrenData = heatmapData.heatMapChildren!.firstWhereOrNull((ele) => ele.backgroundImage != null && ele.backgroundImage!.isNotEmpty);
      return heatmapChildrenData?.backgroundImage;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final pixelRatio = MediaQuery.devicePixelRatioOf(context);

    BoxDecoration buildBoxDecoration() {
      BoxDecoration boxDecoration;
      if (backgroundImage != null) {
        boxDecoration = BoxDecoration(
          image: DecorationImage(
              image: ResizeImage(
                FileImage(File(backgroundImage!)),
                width: (size! * pixelRatio).toInt(),
              ),
              fit: BoxFit.cover),
          borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 5)),
        );
      } else {
        boxDecoration = BoxDecoration(
          color: heatmapType == HeatmapCalendarType.widgets ? Colors.transparent : selectedColor,
          borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 5)),
        );
      }

      return boxDecoration;
    }

    Widget? buildDayView() {
      return (showText ?? true)
          ? (heatmapType == HeatmapCalendarType.widgets
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        date.day.toString(),
                        style: TextStyle(color: getTextColor(), fontSize: fontSize),
                      ),
                    ),
                    _widgetsFromData(heatmapData),
                  ],
                )
              : Text(
                  date.day.toString(),
                  style: TextStyle(color: getTextColor(), fontSize: fontSize),
                ))
          : null;
    }

    return Padding(
      padding: margin ?? const EdgeInsets.all(1),
      child: GestureDetector(
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor ?? HeatMapColor.defaultColor,
            borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 3)),
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOutQuad,
            width: size,
            height: size,
            alignment: Alignment.center,
            decoration: buildBoxDecoration(),
            child: buildDayView(),
          ),
        ),
        onTap: () {
          onClick != null ? onClick!(date, heatmapData ?? const HeatmapData()) : null;
        },
      ),
    );
  }

  Color getTextColor() {
    return textColor ?? ((backgroundImage != null || (selectedColor != null && heatmapType == HeatmapCalendarType.intensity)) ? const Color(0xFFFFFFFF) : const Color(0xFF8A8A8A));
  }

  _widgetsFromData(HeatmapData? heatmapData) {
    List<HeatmapChildrenData> heatMapChildren = [];

    if (heatmapData != null && heatmapData.heatMapChildren != null && heatmapData.heatMapChildren!.isNotEmpty) {
      heatMapChildren = heatmapData.heatMapChildren!.nonNulls.toList();
    }

    if (heatMapChildren.isNotEmpty) {
      List<HeatmapChildrenData>? newHeatMapChildren = [];
      if (heatMapChildren.length > 4) {
        newHeatMapChildren = heatMapChildren.take(2).toList();
        HeatmapChildrenData more = HeatmapChildrenData(label: i18nObjInLocaleLookupString(locale, 'moreItem'), color: Colors.blue);
        newHeatMapChildren.add(more);
        return _overlappedUI(newHeatMapChildren);
      } else {
        return _overlappedUI(heatMapChildren);
      }
    }

    return const SizedBox();
  }

  Widget _overlappedUI(List<HeatmapChildrenData> heatMapChildren) {
    if (heatMapChildren.isEmpty) {
      return const SizedBox();
    }

    List<Widget> stackLayers = List<Widget>.generate(heatMapChildren.length, (index) {
      HeatmapChildrenData childData = heatMapChildren[index];
      Text childWidget = Text(
        childData.label,
        softWrap: false,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: Colors.white, fontSize: 8),
      );

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: childData.color ?? selectedColor,
          borderRadius: const BorderRadius.all(Radius.circular(2)),
        ),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(2),
        child: childWidget,
      );
    });

    return Column(
      spacing: 1,
      children: stackLayers,
    );
  }
}
