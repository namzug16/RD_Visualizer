import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sqlvisualizer/Providers/TableProvider.dart';

class CustomTableNameTextFormInput extends HookWidget {
  final int index;
  CustomTableNameTextFormInput(this.index);

  @override
  Widget build(BuildContext context) {
    final tables = useProvider(tableProvider);
    final controllerTextField = useTextEditingController();
    useEffect(() {
      controllerTextField.text = tables.tables[index].name!;
    }, [tables.tables.length]);
    return Container(
      width: 200,
      height: 30,
      child: TextField(
        textAlignVertical: TextAlignVertical.center,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical:0.0)
        ),
        cursorColor: Colors.white,
        style: TextStyle(
          color: Theme.of(context).hintColor,
          decorationColor: Colors.transparent,
        ),
        controller: controllerTextField,
        onChanged: (val) {
          controllerTextField.text;
          tables.updateTableName(index, controllerTextField.text);
        },
        onSubmitted: (_) =>
            tables.updateTableName(index, controllerTextField.text),
      ),
    );
  }
}
