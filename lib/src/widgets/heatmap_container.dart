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
  final Function(DateTime dateTime, HeatmapData heatmapData)? onClick;

  const HeatMapContainer({
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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pixelRatio = MediaQuery.devicePixelRatioOf(context);

    BoxDecoration buildBoxDecoration() {
      BoxDecoration boxDecoration;

      HeatmapChildrenData? heatmapChildrenData;
      if (heatmapData != null && heatmapData?.heatMapChildren != null && heatmapData!.heatMapChildren!.isNotEmpty) {
        heatmapChildrenData = heatmapData!.heatMapChildren!.firstWhereOrNull((ele) => ele.backgroundImage != null && ele.backgroundImage!.isNotEmpty);
      }

      if (heatmapChildrenData != null) {
        boxDecoration = BoxDecoration(
          image: DecorationImage(
              image: ResizeImage(
                FileImage(File(heatmapChildrenData.backgroundImage!)),
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
      return (showText ?? true) || date.day == 1
          ? (heatmapType == HeatmapCalendarType.widgets
              ? Stack(
                  children: [
                    Center(
                      child: Text(
                        date.day.toString(),
                        style: TextStyle(color: textColor ?? const Color(0xFF8A8A8A), fontSize: fontSize),
                      ),
                    ),
                    _widgetsFromData(heatmapData),
                  ],
                )
              : Text(
                  date.day.toString(),
                  style: TextStyle(color: textColor ?? const Color(0xFF8A8A8A), fontSize: fontSize),
                ))
          : null;
    }

    return Padding(
      padding: margin ?? const EdgeInsets.all(2),
      child: GestureDetector(
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor ?? HeatMapColor.defaultColor,
            borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 5)),
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

  _widgetsFromData(HeatmapData? heatmapData) {
    List<HeatmapChildrenData> heatMapChildren = [];

    if (heatmapData != null && heatmapData.heatMapChildren != null && heatmapData.heatMapChildren!.isNotEmpty) {
      heatMapChildren = heatmapData.heatMapChildren!.nonNulls.toList();
    }

    if (heatMapChildren.isNotEmpty) {
      if (heatMapChildren.length > 2) {
        return _overlappedUI(heatMapChildren);
      }

      if (heatMapChildren.length == 1) {
        return SizedBox(
          height: 20.0,
          width: 20.0,
          child: heatMapChildren[0].child,
        );
      }

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [...heatMapChildren.map((childWidget) => childWidget.child).nonNulls.toList()],
      );
    }

    return const SizedBox();
  }

  Widget _overlappedUI(List<HeatmapChildrenData> heatMapChildren) {
    const overlap = 10.0;
    final items = [...heatMapChildren.map((childWidget) => childWidget.child).nonNulls.toList()];

    if (items.isEmpty) {
      return const SizedBox();
    }

    List<Widget> stackLayers = List<Widget>.generate(items.length, (index) {
      return Padding(
        padding: EdgeInsets.fromLTRB(index.toDouble() * overlap, 0, 0, 0),
        child: items[index],
      );
    });
    return Stack(children: stackLayers);
  }
}
