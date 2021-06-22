import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sqlvisualizer/Tabs/MainTab.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RD Visualizer Demo',
      theme: ThemeData(
        primaryColor: Color(0xFF00adb5),
        primarySwatch: MaterialColor(0xFF222831, {
          50: Color(0xFF222831),
          100: Color(0xFF222831),
          200: Color(0xFF222831),
          300: Color(0xFF222831),
          400: Color(0xFF222831),
          500: Color(0xFF222831),
          600: Color(0xFF222831),
          700: Color(0xFF222831),
          800: Color(0xFF222831),
          900: Color(0xFF222831),
        }),
        accentColor: Color(0xFF00adb5),
        backgroundColor: Color(0xFF393e46),
        hintColor: Color(0xFFeeeeee),
      ),
      home: MyHomePage(title: 'RD Visualizer Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
        backgroundColor: Theme.of(context).primaryColorDark,
      ),
      body: Center(
        child: MainTab(),
      ),
    );
  }
}
