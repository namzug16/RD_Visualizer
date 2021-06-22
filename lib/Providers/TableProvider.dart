import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sqlvisualizer/Providers/TypeProviders.dart';

class Relation {
  int tableIndex;
  int ownColumnIndex;
  int columnIndex;

  Relation({
    required this.tableIndex,
    required this.ownColumnIndex,
    required this.columnIndex,
  });
}

class ColumnTable {
  String? name;
  bool nullable;
  String indexType;
  String dataType;
  String? relationshipType;

  ColumnTable({
    this.name,
    nullable,
    indexType,
    dataType,
    this.relationshipType,
  })  : indexType = indexType ?? indexTypesStrings[3],
        dataType = dataType ?? columnDataTypeList[3],
        nullable = nullable ?? false;
}

class TableC {
  String? name;
  List<ColumnTable>? columns;
  Color? color;
  List<Relation> relations;

  TableC({
    this.name,
    this.columns,
    relations,
    color,
  }) : color = color ?? colorsList[0],
  relations = relations ?? [];

}

List<TableC> dummyDataTableC = [
  new TableC(name: "teacher", columns: [
    new ColumnTable(name: "teacher_id", dataType: "int"),
    new ColumnTable(name: "first_name", dataType: "varchar(40)"),
    new ColumnTable(name: "last_name", dataType: "varchar(40)"),
    new ColumnTable(name: "language_1", dataType: "varchar(3)"),
    new ColumnTable(name: "language_2", dataType: "varchar(3)"),
    new ColumnTable(name: "dob", dataType: "date"),
    new ColumnTable(name: "phone_no", dataType: "varchar(20)"),
  ]),
  new TableC(name: "course", columns: [
    new ColumnTable(name: "course_id", dataType: "int"),
    new ColumnTable(name: "course_name", dataType: "varchar(40)"),
    new ColumnTable(name: "language", dataType: "varchar(3)"),
    new ColumnTable(name: "level", dataType: "varchar(2)"),
    new ColumnTable(name: "course_length_weeks", dataType: "int"),
    new ColumnTable(name: "start_date", dataType: "date"),
    new ColumnTable(name: "in_school", dataType: "tinyint"),
    new ColumnTable(name: "teacher", dataType: "int"),
    new ColumnTable(name: "client", dataType: "int"),
  ]),
  new TableC(name: "client", columns: [
    new ColumnTable(name: "client_id", dataType: "int"),
    new ColumnTable(name: "client_name", dataType: "varchar(40)"),
    new ColumnTable(name: "address", dataType: "varchar(60)"),
    new ColumnTable(name: "industry", dataType: "varchar(20)"),
  ]),
  new TableC(name: "participant", columns: [
    new ColumnTable(name: "participant_id", dataType: "int"),
    new ColumnTable(name: "first_name", dataType: "varchar(40)"),
    new ColumnTable(name: "last_name", dataType: "varchar(40)"),
    new ColumnTable(name: "phone_no", dataType: "varchar(20)"),
    new ColumnTable(name: "client", dataType: "int"),
  ]),
  new TableC(name: "takes_course", columns: [
    new ColumnTable(name: "participant_id", dataType: "int"),
    new ColumnTable(name: "course_id", dataType: "int"),
  ]),
];

class TableNotifier extends ChangeNotifier {
  List<TableC> get tables => _tables;
  List<TableC> _tables = [];

  void addNewTable() {
    final int length = _tables.length + 1;
    _tables.add(new TableC(
      name: "table-" + length.toString(),
      columns: [ColumnTable(name: "id")],
    ));
    notifyListeners();
  }

  void deleteTable(int? index) {

    for(var i = 0; i < _tables.length; i++){
      if(_tables[i].relations.length > 0){
        List<int> toDelete = [];
        for(var j = 0; j < _tables[i].relations.length; j++){
          if(_tables[i].relations[j].tableIndex == index){
            toDelete.add(j);
          }
        }
        for(var j = toDelete.length - 1; j >= 0; j--){
          deleteRelationship(i, toDelete[j]);
        }
      }
    }

    _tables.removeAt(index!);
    notifyListeners();
  }

  void updateTableName(int? index, String? name) {
    _tables[index!].name = name!;
    notifyListeners();
  }

  void updateColorTable(int? indexTable, int? indexColor) {
    _tables[indexTable!].color = colorsList[indexColor!];
    notifyListeners();
  }

  // * Columns methods -----------------------------------

  void addColumn(int? indexTable) {
    final int index = _tables[indexTable!].columns!.length + 1;
    _tables[indexTable].columns!.add(new ColumnTable(
          name: "column-" + index.toString(),
          nullable: false,
        ));
    notifyListeners();
  }

  void updateColumnName(int? indexTable, int? indexColumn, String? name) {
    _tables[indexTable!].columns![indexColumn!].name = name!;
    notifyListeners();
  }

  void updateColumnNullable(int? indexTable, int? indexColumn) {
    if (_tables[indexTable!].columns![indexColumn!].nullable) {
      _tables[indexTable].columns![indexColumn].nullable = false;
    } else {
      _tables[indexTable].columns![indexColumn].nullable = true;
    }
    notifyListeners();
  }

  void updateColumnDataType(
      int? indexTable, int? indexColumn, String? dataType) {
    _tables[indexTable!].columns![indexColumn!].dataType =
        dataType!;
    notifyListeners();
  }

  void deleteColumn(int? indexTable, int? indexColumn) {

    if(_tables[indexTable!].relations.length > 0){
      List<int> toDelete = [];
      for(var i = 0; i < _tables[indexTable].relations.length; i++){
        if(_tables[indexTable].relations[i].ownColumnIndex == indexColumn){
          toDelete.add(i);
        }else if(_tables[indexTable].relations[i].ownColumnIndex > indexColumn!){
          updateRelationship(indexTable, i, _tables[indexTable].relations[i].ownColumnIndex - 1, _tables[indexTable].relations[i].columnIndex);
        }
      }
      for(var i = toDelete.length - 1; i >= 0; i--){
        deleteRelationship(indexTable, toDelete[i]);
      }
    }

    for(var i = 0; i < _tables.length; i++){
      if(_tables[i].relations.length > 0){
        List<int> toDelete = [];
        for(var j = 0; j < _tables[i].relations.length; j++){
          if(_tables[i].relations[j].tableIndex == indexTable && _tables[i].relations[j].columnIndex == indexColumn){
            toDelete.add(j);
          }else if(_tables[i].relations[j].tableIndex == indexTable && _tables[i].relations[j].columnIndex > indexColumn!){
            updateRelationship(i, j, _tables[i].relations[j].ownColumnIndex, _tables[i].relations[j].columnIndex - 1);
          }
        }
        for(var j = toDelete.length - 1; j >= 0; j--){
          deleteRelationship(i, toDelete[j]);
        }
      }
    }

    _tables[indexTable].columns!.removeAt(indexColumn!);

    notifyListeners();
  }

  // * ==========================================================================================> Relationships
  void addRelationship(int ownTableIndex, int tableIndex, int ownColumnIndex, int columnIndex){
    _tables[ownTableIndex].relations.add(new Relation(tableIndex: tableIndex,ownColumnIndex: ownColumnIndex, columnIndex: columnIndex));
  }

  void updateRelationship(int ownTableIndex, int relationIndex, int ownColumnIndex, int columnIndex){
    _tables[ownTableIndex].relations[relationIndex] = new Relation(tableIndex: _tables[ownTableIndex].relations[relationIndex].tableIndex, ownColumnIndex: ownColumnIndex, columnIndex: columnIndex);
  }

  void deleteRelationship(int tableIndex, int relationIndex){
    _tables[tableIndex].relations.removeAt(relationIndex);
  }
}

final tableProvider = ChangeNotifierProvider((ref) => TableNotifier());
