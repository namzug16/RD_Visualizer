import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sqlvisualizer/Providers/TableProvider.dart';

class CustomColumnNameTextFormInput extends HookWidget {
  final int indexTable;
  final int indexColumn;

  CustomColumnNameTextFormInput(
      {required this.indexTable, required this.indexColumn});

  @override
  Widget build(BuildContext context) {
    final tables = useProvider(tableProvider);
    final controllerTextField = useTextEditingController();
    useEffect(() {
      controllerTextField.text =
          tables.tables[indexTable].columns![indexColumn].name!;
    }, [tables.tables[indexTable].columns!.length]);
    return Container(
      width: 150,
      height: 30,
      child: TextField(
        textAlignVertical: TextAlignVertical.center,
        cursorColor: Colors.white,
        style: TextStyle(
          color: Theme.of(context).hintColor,
        ),
        controller: controllerTextField,
        onChanged: (val) {
          controllerTextField.text;
          tables.updateColumnName(
              indexTable, indexColumn, controllerTextField.text);
        },
        onSubmitted: (_) => tables.updateColumnName(
            indexTable, indexColumn, controllerTextField.text),
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding:
              EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
        ),
      ),
    );
  }
}
