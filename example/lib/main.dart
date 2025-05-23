import 'package:example/pages/heatmap_day_example.dart';
import 'package:flutter/material.dart';
import 'pages/heatmap_calendar_example.dart';
import 'pages/heatmap_example.dart';
import 'pages/heatmap_example_v2.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Heatmap Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(),
        '/heatmap_calendar': (context) => const HeatMapCalendarExample(),
        '/heatmap': (context) => const HeatMapExample(),
        '/heatmapV2': (context) => const HeatMapExampleV2(),
        '/heatmap_day': (context) => const HeatMapDayExample(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter heatmap example')),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: const Text('Heatmap calendar'),
              onTap: () => Navigator.of(context).pushNamed('/heatmap_calendar'),
            ),
            ListTile(
              title: const Text('Heatmap'),
              onTap: () => Navigator.of(context).pushNamed('/heatmap'),
            ),
            ListTile(
              title: const Text('HeatmapV2'),
              onTap: () => Navigator.of(context).pushNamed('/heatmapV2'),
            ),
            ListTile(
              title: const Text('HeatmapDay'),
              onTap: () => Navigator.of(context).pushNamed('/heatmap_day'),
            ),
          ],
        ),
      ),
    );
  }
}
