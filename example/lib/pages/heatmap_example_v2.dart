import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:heatmap_calendar_flutter/heatmap_calendar_flutter.dart';

class HeatMapExampleV2 extends StatefulWidget {
  const HeatMapExampleV2({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HeatMapExample();
}

class _HeatMapExample extends State<HeatMapExampleV2> {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController heatLevelController = TextEditingController(text: '1');

  bool isOpacityMode = true;

  Map<DateTime, HeatmapData> heatMapDatasets = {};

  @override
  void dispose() {
    super.dispose();
    dateController.dispose();
    heatLevelController.dispose();
  }

  /// Get start day of month.
  static DateTime startDayOfYear(final DateTime referenceDate) =>
      DateTime(referenceDate.year, 1, 1);

  /// Get last day of month.
  static DateTime endDayOfYear(final DateTime referenceDate) =>
      DateTime(referenceDate.year, 12, 31);

  Widget _textField(final String hint, final TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 20, top: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xffe7e7e7), width: 1.0)),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF20bca4), width: 1.0)),
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
          isDense: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Heatmap'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Card(
              margin: const EdgeInsets.all(8),
              elevation: 20,
              child: HeatMapMonthView(
                locale: HeatmapLocaleType.zh,
                startDate: startDayOfYear(DateTime.now()),
                endDate: endDayOfYear(DateTime.now()),
                scrollable: true,
                colorMode: isOpacityMode ? ColorMode.opacity : ColorMode.color,
                datasets: heatMapDatasets,
                colorsets: const {
                  1: Colors.red,
                  3: Colors.orange,
                  5: Colors.yellow,
                  7: Colors.green,
                  9: Colors.blue,
                  11: Colors.indigo,
                  13: Colors.purple,
                },
                onClick: (value, heatmapData) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('$value : ${heatmapData?.intensity}')));
                },
              ),
            ),
            _textField('YYYYMMDD', dateController),
            _textField('Heat Level', heatLevelController),
            ElevatedButton(
              child: const Text('COMMIT'),
              onPressed: () {
                setState(() {
                  heatMapDatasets[DateTime.parse(dateController.text)] =
                      HeatmapData(intensity: int.parse(heatLevelController.text));
                });
              },
            ),

            // ColorMode/OpacityMode Switch.
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('Color Mode'),
                CupertinoSwitch(
                  value: isOpacityMode,
                  onChanged: (value) {
                    setState(() {
                      isOpacityMode = value;
                    });
                  },
                ),
                const Text('Opacity Mode'),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
