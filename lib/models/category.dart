import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'category.g.dart';

@HiveType(typeId: 1)
class Category extends HiveObject {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final Color color;

  Category(this.name, this.color);
}
