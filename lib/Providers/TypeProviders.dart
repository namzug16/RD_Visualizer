import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

List<String> indexTypesStrings = [
  "Primary Key",
  "Unique Key",
  "Index",
  "None",
];

final indexTypesStringsProvider = Provider((ref) => indexTypesStrings);

List<String> relationshipTypesList = [
  "One-To-One",
  "One-To-Many",
  "Many-To-One",
];

final relationshipTypesListProvider = Provider((ref) => relationshipTypesList);

List<String> columnDataTypeList = [
  "bit",
  "tinyint",
  "smallint",
  "int",
  "bigint",
  "decimal",
  "numeric",
  "float",
  "real",
  "date",
  "time",
  "datetime",
  "timestamp",
  "year",
  "char",
  "varchar",
  "varchar(max)",
  "text",
  "Nchar",
  "Nvarchar",
  "Nvarchar(max)",
  "Ntext",
  "binary",
  "varbinary",
  "varbinary(max)",
  "image",
  "clob",
  "blob",
  "xml",
  "json",
];

final columnDataTypeListProvider = Provider((ref) => columnDataTypeList);

List<Color> colorsList = [
  Colors.lightGreen,
  Colors.lightGreenAccent,
  Colors.amber,
  Colors.amberAccent,
  Colors.blueAccent,
  Colors.blue,
  Colors.redAccent,
  Colors.red,
  Colors.lightBlueAccent,
  Colors.lightBlue,
  Colors.deepPurple,
  Colors.deepPurpleAccent,
  Colors.cyanAccent,
  Colors.cyan,
  Colors.deepOrange,
  Colors.deepOrangeAccent,
  Colors.teal,
  Colors.tealAccent,
  Colors.pink,
  Colors.pinkAccent,
];

final colorListProvider = Provider((ref) => colorsList);

// ? loratadina
