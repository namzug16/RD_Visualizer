import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sqlvisualizer/TableManagementFeature/TableManagement.dart';
import 'package:sqlvisualizer/TableManagementVisualizerFeature/VisualizerTabCanvas.dart';

class MainTab extends StatefulHookWidget {
  @override
  _MainTabState createState() => _MainTabState();
}

class _MainTabState extends State<MainTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        fit: StackFit.expand,
        // alignment: Alignment.center,
        children: [
          Container(
            child: VisualizerCanvas(
              width: MediaQuery.of(context).size.width - 350,
              height: MediaQuery.of(context).size.height,
            ),
          ),
          Positioned(
            child: TableManagement(),
            left: 0,
          ),
        ],
      ),
    );
  }
}
