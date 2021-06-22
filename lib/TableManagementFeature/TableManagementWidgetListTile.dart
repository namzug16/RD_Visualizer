import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sqlvisualizer/Controllers/CanvasController.dart';
import 'package:sqlvisualizer/Providers/TableProvider.dart';
import 'package:sqlvisualizer/TableManagementFeature/Widgets/CustomTableNameTextFormInput.dart';
import 'package:sqlvisualizer/TableManagementFeature/Widgets/CustomTooltipWidget.dart';
import 'Widgets/TableColumnWidget.dart';

class TableManagementWidgetListTile extends StatefulHookWidget {
  final int index;

  TableManagementWidgetListTile(this.index);

  @override
  _TableManagementWidgetListTileState createState() =>
      _TableManagementWidgetListTileState();
}

class _TableManagementWidgetListTileState
    extends State<TableManagementWidgetListTile> {
  @override
  Widget build(BuildContext context) {
    final tables = useProvider(tableProvider);

    return Column(
      children: [
        Container(
          width: 348,
          height: 10,
          decoration: BoxDecoration(
              color: tables.tables[widget.index].color,
              borderRadius: BorderRadius.vertical(top: Radius.circular(100))),
        ),
        ExpansionTile(
          tilePadding: EdgeInsets.zero,
          childrenPadding: EdgeInsets.symmetric(vertical: 10),
          title: _TableWidgetHeader(widget.index),
          initiallyExpanded: true,
          children: List<Widget>.generate(
              tables.tables[widget.index].columns!.length, (i) {
            return TableColumnWidget(
              indexTable: widget.index,
              indexColumn: i,
            );
          })
            ..add(_TableWidgetBottom(widget.index)),
        ),
      ],
    );
  }
}

class _TableWidgetBottom extends HookWidget {
  final int index;

  _TableWidgetBottom(
    this.index,
  );

  @override
  Widget build(BuildContext context) {
    final tables = useProvider(tableProvider);
    final canvasController = useProvider(canvasControllerProvider.notifier);
    final i = useState(1);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CustomTooltip(
              direction: TooltipDirection.bottomCenter,
              tooltipText: "Change Color",
              child: OutlinedButton(
                  onPressed: () {
                    if (i.value > 13) {
                      i.value = 0;
                    }
                    tables.updateColorTable(index, i.value);
                    canvasController.updateObject(
                      index,
                      CanvasObject(
                        dx: 300,
                        dy: 300,
                        tableC: tables.tables[index],
                      ),
                    );
                    i.value++;
                  },
                  child: Icon(
                    Icons.color_lens,
                    color: Theme.of(context).hintColor,
                  )),
            ),
            CustomTooltip(
              direction: TooltipDirection.bottomCenter,
              tooltipText: "Delete Table",
              child: OutlinedButton(
                onPressed: () {
                  tables.deleteTable(index);
                  canvasController.deleteObject(index);
                },
                child: Icon(
                  Icons.delete,
                  color: Theme.of(context).hintColor,
                ),
              ),
            ),
            CustomTooltip(
              direction: TooltipDirection.bottomCenter,
              tooltipText: "Add Column",
              child: OutlinedButton(
                onPressed: () {
                  tables.addColumn(index);
                  canvasController.updateObject(
                    index,
                    CanvasObject(
                      tableC: tables.tables[index],
                    ),
                  );
                },
                child: Icon(
                  Icons.add_comment,
                  color: Theme.of(context).hintColor,
                ),
              ),
            ),
          ],
        ),
        Container(
          width: 348,
          height: 10,
          decoration: BoxDecoration(
              color: tables.tables[index].color,
              borderRadius:
                  BorderRadius.vertical(bottom: Radius.circular(100))),
        ),
      ],
    );
  }
}

class _TableWidgetHeader extends HookWidget {
  final int index;

  _TableWidgetHeader(this.index);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // * ==========================================================================>Name Table Input
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: CustomTableNameTextFormInput(index),
          ),
        ],
      ),
    );
  }
}
