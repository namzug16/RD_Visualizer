import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sqlvisualizer/Providers/TableProvider.dart';

List<CanvasObject> dummyData = [
  new CanvasObject(
    dx: 500,
    dy: 100,
    tableC: new TableC(
      color: Colors.indigo,
      name: "Table1",
      relations: [new Relation(columnIndex: 1,ownColumnIndex: 0, tableIndex: 1),],
      columns: [
        new ColumnTable(name: "One", nullable: true, indexType: "UK"),
        new ColumnTable(name: "Two"),
        new ColumnTable(name: "Three")
      ],
    ),
  ),
  new CanvasObject(
      dx: 900,
      dy: 400,
      tableC: new TableC(
        color: Colors.teal,
        name: "Table2",
        columns: [
          new ColumnTable(name: "One"),
          new ColumnTable(name: "Twooooooooooooooooooooooooooooooooooooo")
        ],
      )),
];

class CanvasController extends StateNotifier<List<CanvasObject>> {
  // CanvasController() : super(dummyData);
  CanvasController() : super([]);

  void addObject(CanvasObject object) {
    state.add(object);
    _listSizes.add(Size.zero);
    _middlePointsColumns.add([]);
  }

  void updateObject(int index, CanvasObject object) {
    state[index] = state[index].copyWith(index: index);
  }

  void deleteObject(int index) {
    state.removeAt(index);
    _listSizes.removeAt(index);
    _middlePointsColumns.removeAt(index);
  }

  double get scale => _scale;
  double _scale = 1;

  static const double maxScale = 3.0;
  static const double minScale = 0.2;
  static const double scaleAdjust = 0.025;

  set scale(double value) {
    if (value <= minScale) {
      value = minScale;
    } else if (value >= maxScale) {
      value = maxScale;
    }
    _scale = value;
  }

  PointerDownEvent? _pointer;
  int? index;
  int? indexColumnRelation;

  List<Offset>? get pointsOfRelation => _pointsOfRelation;
  List<Offset>? _pointsOfRelation;

  void addPointer(PointerDownEvent details) {
    _pointer = details;
    for (var i = 0; i < state.length; i++) {

      for(var p in middlePointsColumns[i]){
        if(_getRectColumn(p[0]).contains(details.localPosition)){
          _pointsOfRelation = [p[0], details.localPosition];
          i = state.length;
        }else if(_getRectColumn(p[1]).contains(details.localPosition)){
          _pointsOfRelation = [p[1], details.localPosition];
          i = state.length;
        }
      }
      if ( _pointsOfRelation == null && _getRect(state[i]).contains(_pointer!.localPosition)) {
        index = i;
        i = state.length;
      }
    }
    if (index != null &&
        !_getRect(state[index!]).contains(_pointer!.localPosition)) {
      index = null;
    }
  }

  int verifyHoover(PointerHoverEvent details) {
    int i = 0;
    int result = 0;
    for (; i < state.length; i++) {
      for(var p in middlePointsColumns[i]){
        if(_getRectColumn(p[0]).contains(details.localPosition) || _getRectColumn(p[1]).contains(details.localPosition)){
          result = 2;
          i = state.length;
        }
      }
      if (result != 2 && _getRect(state[i]).contains(details.localPosition)) {
        result = 1;
        i = state.length;
      }
    }
    return result;
  }

  void moveObject(PointerMoveEvent details) {

    if(_pointsOfRelation != null){
      _pointsOfRelation = [_pointsOfRelation![0], details.localPosition];
    }else{
      if (index != null) {
        state[index!].dx += details.delta.dx;
        state[index!].dy += details.delta.dy;
      } else {
        for (var o in state) {
          o.dx += details.delta.dx;
          o.dy += details.delta.dy;
        }
      }
    }
  }

  void onPointerUp(PointerUpEvent details, TableNotifier tables){
    for(var i = 0; i < state.length; i++){
      for(var p in middlePointsColumns[i]){
        if(_getRectColumn(p[0]).contains(details.localPosition) || _getRectColumn(p[1]).contains(details.localPosition)){
          final tableIndex = i;
          final columnIndex = middlePointsColumns[i].indexOf(p);
          for(var j = 0; j < state.length; j++){
            for(var p1 in middlePointsColumns[j]){
              if(pointsOfRelation![0] == p1[0] || pointsOfRelation![0] == p1[1]){
                final ownTableIndex = j;
                final ownColumnIndex = middlePointsColumns[j].indexOf(p1);
                tables.addRelationship(ownTableIndex, tableIndex, ownColumnIndex, columnIndex);
                j = state.length;
              }
            }
          }
          i = state.length;
        }
      }
    }
    _pointsOfRelation = null;
  }

  List<Size> _listSizes = [];
  // List<Size> _listSizes = [Size.zero, Size.zero]; //  * Dummy Data

  List<List<List<Offset>>> get middlePointsColumns => _middlePointsColumns;

  List<List<List<Offset>>> _middlePointsColumns = [];
  // List<List<List<Offset>>> _middlePointsColumns = [[], []]; // * Dummy Data

  void setAmountColumns(int indexTable, int amountColumns) {
    if (_middlePointsColumns[indexTable].length != amountColumns) {
      if (_middlePointsColumns[indexTable].length > 0) {
        _middlePointsColumns[indexTable].clear();
      }
      for (var i = 0; i < amountColumns; i++) {
        _middlePointsColumns[indexTable].add([]);
      }
    }
  }

  void setMiddlePoints(int indexTable, int indexColumn, List<Offset> points) {
    _middlePointsColumns[indexTable][indexColumn] = points;
  }

  void setSizeI(int index, Size size) {
    _listSizes[index] = size;
  }

  Size getSizeI(int index) {
    return _listSizes[index];
  }

  Rect _getRect(CanvasObject object) {
    return Offset(object.dx * scale, object.dy * scale) &
        _listSizes[state.indexOf(object)];
  }

  double get sizeOfPrecise => _sizeOfPrecise;
  double _sizeOfPrecise = 4.0;

  Rect _getRectColumn(Offset point){
    return Offset(point.dx - _sizeOfPrecise/2*_scale, point.dy - _sizeOfPrecise/2*_scale) & Size(_sizeOfPrecise, _sizeOfPrecise);
  }

}

// ! ==================================================================================>

final canvasControllerProvider =
    StateNotifierProvider<CanvasController, List<CanvasObject>>(
        (ref) => CanvasController());

class CanvasObject {
  double dx;
  double dy;
  TableC? tableC;

  CanvasObject({
    this.dx = 0,
    this.dy = 0,
    this.tableC,
  });

  CanvasObject copyWith({
    double? dx,
    double? dy,
    int? index,
    TableC? tableC,
  }) {
    return CanvasObject(
      dx: dx ?? this.dx,
      dy: dy ?? this.dy,
      tableC: tableC ?? this.tableC,
    );
  }
}
