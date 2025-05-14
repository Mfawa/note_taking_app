import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../models/note.dart';
import '../models/sort.dart';
import 'calender_provider.dart';

final notesProvider = StateNotifierProvider<NotesNotifier, List<Note>>((ref) {
  return NotesNotifier(ref);
});

class NotesNotifier extends StateNotifier<List<Note>> {
  final Ref ref;
  late final Box<Note> _notesBox;

  NotesNotifier(this.ref) : super([]) {
    _notesBox = Hive.box<Note>('notes');
    state = _notesBox.values.toList();
  }

  void addNote(Note note) {
    _notesBox.put(note.id, note);
    state = _notesBox.values.toList();
  }

  void updateNote(Note note) {
    _notesBox.put(note.id, note);
    state = _notesBox.values.toList();
  }

  void deleteNote(String id) async {
    await _notesBox.delete(id);
    state = _notesBox.values.toList();
  }
}

//filter

final searchQueryProvider = StateProvider<String>((ref) => '');
final sortModeProvider = StateProvider<SortMode>((ref) => SortMode.dateCreated);
final filterProvider = StateProvider<List<String>>((ref) => []);

class FilterNotifier extends StateNotifier<List<String>> {
  FilterNotifier() : super([]);
  void add(String category) => state = [...state, category];
  void remove(String category) => state = state.where((c) => c != category).toList();
  void clear() => state = [];
}

final filteredNotesProvider = Provider<List<Note>>((ref) {
  final notes = ref.watch(notesProvider);
  final searchQuery = ref.watch(searchQueryProvider);
  final sortMode = ref.watch(sortModeProvider);
  final filters = ref.watch(filterProvider);
  final selectedDate = ref.watch(selectedDateProvider);

  notes.where((note) {
    if (selectedDate == null) return true;
    final noteDate = DateTime(note.createdAt.year, note.createdAt.month, note.createdAt.day);
    return noteDate.isAtSameMomentAs(selectedDate);
  }).toList();

  List<Note> filtered = notes.where((note) {
    final matchesSearch =
        note.title.toLowerCase().contains(searchQuery.toLowerCase()) || note.content.toLowerCase().contains(searchQuery.toLowerCase());
    final matchesCategory = filters.isEmpty || filters.contains(note.category);
    return matchesSearch && matchesCategory;
  }).toList();

  switch (sortMode) {
    case SortMode.dateCreated:
      filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      break;
    case SortMode.dateModifiedNewestFirst:
      filtered.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      break;
    case SortMode.dateModifiedOldestFirst:
      filtered.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      break;
    case SortMode.alphabetical:
      filtered.sort((a, b) => a.title.compareTo(b.title));
      break;
    case SortMode.newestFirst:
      filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      break;
    case SortMode.oldestFirst:
      filtered.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      break;
    case SortMode.titleAsc:
      filtered.sort((a, b) => a.title.compareTo(b.title));
      break;
    case SortMode.titleDesc:
      filtered.sort((a, b) => b.title.compareTo(a.title));
      break;
  }

  return filtered;
});

class SortNotifier extends StateNotifier<SortMode> {
  SortNotifier() : super(SortMode.newestFirst);

  // Add this method
  void setSortMode(SortMode newMode) {
    state = newMode;
  }
}

final colorPaletteProvider = Provider<List<Color>>((ref) => const [
      Color(0xFFF8BBD0), // Pink
      Color(0xFFB3E5FC), // Blue
      Color(0xFFC8E6C9), // Green
      Color(0xFFFFF9C4), // Yellow
      Color(0xFFD1C4E9), // Purple
      Color(0xFFFFCCBC), // Orange
      Color(0xFFCFD8DC), // Grey
      Color(0xFFE0F7FA), // Cyan
    ]);
