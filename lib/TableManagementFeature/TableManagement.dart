import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sqlvisualizer/Controllers/CanvasController.dart';
import 'package:sqlvisualizer/Providers/TableProvider.dart';
import 'package:sqlvisualizer/TableManagementFeature/TableManagementWidgetListTile.dart';
import 'package:sqlvisualizer/TableManagementFeature/Widgets/CustomTooltipWidget.dart';

class TableManagement extends StatefulHookWidget {
  @override
  _TableManagementState createState() => _TableManagementState();
}

class _TableManagementState extends State<TableManagement> {
  @override
  Widget build(BuildContext context) {
    final tables = useProvider(tableProvider);
    final canvasController = useProvider(canvasControllerProvider.notifier);


    return Container(
      color: Theme.of(context).backgroundColor,
      // color: Colors.amberAccent,
      width: 350,
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("Tables", style: TextStyle(color: Colors.white, fontSize: 25),),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: CustomTooltip(
                  tooltipText: "New Table",
                  direction: TooltipDirection.bottomCenter,
                  child: OutlinedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Theme.of(context).accentColor),
                    ),
                    onPressed: () {
                      tables.addNewTable();
                      int x = tables.tables.length;
                      canvasController.addObject(
                        new CanvasObject(
                          dx: 400,
                          dy: 400,
                          tableC: tables.tables[x - 1],
                        ),
                      );
                      setState(() {});
                    },
                    child: Icon(Icons.add),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 5.0, horizontal: 30.0),
            child: Container(
              height: 10,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Theme.of(context).accentColor),
            ),
          ),
          TableListWidget(tables: tables.tables),
        ],
      ),
    );
  }
}

class TableListWidget extends HookWidget {
  final List<TableC> tables;
  const TableListWidget({Key? key, required this.tables}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (tables.length > 0) {
      return Expanded(
        child: Container(
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: tables.length,
            itemBuilder: (context, index) {
              return TableManagementWidgetListTile(index);
            },
          ),
        ),
      );
    } else {
      return SizedBox();
    }
  }
}

class TableListWidget2 extends HookWidget {
  final List<TableC> tables;
  const TableListWidget2({Key? key, required this.tables}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (tables.length > 0) {
      return Expanded(
        child: Container(
          child: ExpansionPanelList(),
        ),
      );
    } else {
      return SizedBox();
    }
  }
}
