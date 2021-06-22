import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sqlvisualizer/Providers/TableProvider.dart';
import 'package:sqlvisualizer/Providers/TypeProviders.dart';
import 'package:sqlvisualizer/TableManagementFeature/Widgets/CustomColumnNameTextFormInput.dart';
import 'package:sqlvisualizer/TableManagementFeature/Widgets/CustomTooltipWidget.dart';

class TableColumnWidget extends StatefulHookWidget {
  final int indexTable;
  final int indexColumn;

  TableColumnWidget({required this.indexTable, required this.indexColumn});

  @override
  _TableColumnWidgetState createState() => _TableColumnWidgetState();
}

class _TableColumnWidgetState extends State<TableColumnWidget> {
  @override
  Widget build(BuildContext context) {
    final tables = useProvider(tableProvider);
    final column =
        tables.tables[widget.indexTable].columns![widget.indexColumn];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: CustomColumnNameTextFormInput(
              indexTable: widget.indexTable, indexColumn: widget.indexColumn),
        ),
        DataTypeButton(
          indexTable: widget.indexTable,
          indexColumn: widget.indexColumn,
        ),
        CustomTooltip(
          direction: TooltipDirection.bottomCenter,
          tooltipText: "Nullable?",
          child: InkWell(
            onTap: () {
              tables.updateColumnNullable(
                  widget.indexTable, widget.indexColumn);
            },
            child: Text(
              "N",
              style: TextStyle(
                color: column.nullable
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).hintColor,
              ),
            ),
          ),
        ),
        CustomTooltip(
          direction: TooltipDirection.bottomCenter,
          tooltipText: "Delete Column",
          child: IconButton(
            icon: Icon(Icons.delete),
            color: Theme.of(context).hintColor,
            onPressed: () {
              tables.deleteColumn(widget.indexTable, widget.indexColumn);
            },
          ),
        ),
      ],
    );
  }
}

class DataTypeButton extends HookWidget {
  final int indexTable;
  final int indexColumn;

  const DataTypeButton(
      {Key? key, required this.indexTable, required this.indexColumn})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = useProvider(columnDataTypeListProvider);
    final tables = useProvider(tableProvider);
    final column = tables.tables[indexTable].columns![indexColumn];

    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        dropdownColor: Theme.of(context).backgroundColor,
        // style: TextStyle(color: Theme.of(context).primaryColor),
        style: TextStyle(color: Theme.of(context).hintColor),
        value: column.dataType,
        onChanged: (String? nexValue) {
          tables.updateColumnDataType(indexTable, indexColumn, nexValue);
        },
        items: data.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
