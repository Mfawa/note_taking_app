import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'note.g.dart';

@HiveType(typeId: 0)
class Note extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  String title;
  @HiveField(2)
  String content;
  @HiveField(3)
  final DateTime createdAt;
  @HiveField(4)
  DateTime updatedAt;
  @HiveField(5)
  Color backgroundColor;
  @HiveField(6)
  String category;
  @HiveField(7)
  bool isBold;
  @HiveField(8)
  bool isItalic;
  @HiveField(9)
  bool isUnderline;
  @HiveField(10)
  int alignmentIndex;
  @HiveField(11)
  List styles;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.backgroundColor,
    required this.category,
    this.isBold = false,
    this.isItalic = false,
    this.isUnderline = false,
    this.alignmentIndex = 0,
    required this.styles,
  });

  Note copyWith({
    String? title,
    String? content,
    Color? backgroundColor,
    List<String>? tags,
    String? category,
    bool? isBold,
    bool? isItalic,
    bool? isUnderline,
    int? alignmentIndex,
    DateTime? updatedAt,
    List<TextStyleRange>? styles,
  }) {
    return Note(
      id: id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      backgroundColor: backgroundColor ?? this.backgroundColor,
      category: category ?? this.category,
      // tags: tags ?? this.tags,
      isBold: isBold ?? this.isBold,
      isItalic: isItalic ?? this.isItalic,
      isUnderline: isUnderline ?? this.isUnderline,
      alignmentIndex: alignmentIndex ?? this.alignmentIndex,
      styles: [],
    );
  }
}

class TextStyleRange {
  final int start;
  final int end;
  final bool isBold;
  final bool isItalic;
  final bool isUnderline;
  final TextAlign alignment;

  const TextStyleRange({
    required this.start,
    required this.end,
    this.isBold = false,
    this.isItalic = false,
    this.isUnderline = false,
    this.alignment = TextAlign.left,
  });
}
