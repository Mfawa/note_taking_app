// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NoteAdapter extends TypeAdapter<Note> {
  @override
  final int typeId = 0;

  @override
  Note read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Note(
      id: fields[0] as String,
      title: fields[1] as String,
      content: fields[2] as String,
      createdAt: fields[3] as DateTime,
      updatedAt: fields[4] as DateTime,
      backgroundColor: fields[5] as Color,
      category: fields[6] as String,
      isBold: fields[7] as bool,
      isItalic: fields[8] as bool,
      isUnderline: fields[9] as bool,
      alignmentIndex: fields[10] as int,
      styles: [],
    );
  }

  @override
  void write(BinaryWriter writer, Note obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.content)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.updatedAt)
      ..writeByte(5)
      ..write(obj.backgroundColor)
      ..writeByte(6)
      ..write(obj.category)
      ..writeByte(7)
      ..write(obj.isBold)
      ..writeByte(8)
      ..write(obj.isItalic)
      ..writeByte(9)
      ..write(obj.isUnderline)
      ..writeByte(10)
      ..write(obj.alignmentIndex);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is NoteAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
