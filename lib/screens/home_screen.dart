import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_taking_app/models/sort.dart';
import 'package:note_taking_app/screens/view_note_screen.dart';
import 'package:uuid/uuid.dart';

import '../models/category.dart';
import '../models/note.dart';
import '../providers/category_provider.dart';
import '../providers/notes_provider.dart';
import '../widgets/date_time_widget.dart';
import '../widgets/note_card.dart';
import 'note_edit_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notes = ref.watch(filteredNotesProvider);
    final categories = ref.watch(categoriesProvider);
    final filters = ref.watch(filterProvider);
    final selectedFilters = ref.watch(filterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () => _showSortDialog(context, ref),
          ),
          // IconButton(
          //   onPressed: () {},
          //   icon: Icon(Icons.more_vert_rounded),
          // )
        ],
        bottom: PreferredSize(
          preferredSize: const Size(100, 100),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    fillColor: Colors.grey[300],
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: const Icon(Icons.search),
                    hintText: 'Search for notes...',
                    hintStyle: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 14,
                    ),
                  ),
                  onChanged: (value) => ref.read(searchQueryProvider.notifier).state = value,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 15),
            const DateSortCalendar(),
            const SizedBox(height: 15),
            SizedBox(
              height: 50,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemCount: categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final isSelected = selectedFilters.contains(category.name);

                  return FilterChip(
                    label: Text(category.name),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                    avatar: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: category.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: category.color,
                    checkmarkColor: Colors.white,
                    onSelected: (selected) {
                      final newFilters = List<String>.from(selectedFilters);
                      selected ? newFilters.add(category.name) : newFilters.remove(category.name);
                      ref.read(filterProvider.notifier).state = newFilters;
                    },
                  );
                },
              ),
            ),
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: const EdgeInsets.all(5),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1,
              ),
              itemCount: notes.length,
              itemBuilder: (context, index) => NoteCard(
                note: notes[index],
                onTap: () => _navigateToNoteView(context, notes[index]),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black87,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        onPressed: () => _createNewNote(context, categories.first, ref),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  void _showSortDialog(BuildContext context, WidgetRef ref) {
    final currentSortMode = ref.read(sortModeProvider);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sort Notes'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSortOption(context, 'Newest First', SortMode.newestFirst, currentSortMode, ref),
              _buildSortOption(context, 'Oldest First', SortMode.oldestFirst, currentSortMode, ref),
              _buildSortOption(context, 'Title (A-Z)', SortMode.titleAsc, currentSortMode, ref),
              _buildSortOption(context, 'Title (Z-A)', SortMode.titleDesc, currentSortMode, ref),
              _buildSortOption(context, 'Last Modified (Newest)', SortMode.dateModifiedNewestFirst, currentSortMode, ref),
              _buildSortOption(context, 'Last Modified (Oldest)', SortMode.dateModifiedOldestFirst, currentSortMode, ref),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSortOption(
    BuildContext context,
    String title,
    SortMode mode,
    SortMode currentMode,
    WidgetRef ref,
  ) {
    return ListTile(
      title: Text(title),
      leading: Radio<SortMode>(
        value: mode,
        groupValue: currentMode,
        onChanged: (value) {
          ref.read(sortModeProvider.notifier).state = value!;
          Navigator.pop(context);
        },
      ),
      onTap: () {
        ref.read(sortModeProvider.notifier).state = mode;
        Navigator.pop(context);
      },
    );
  }

  void _createNewNote(BuildContext context, Category category, WidgetRef ref) {
    final colors = ref.read(colorPaletteProvider);
    final random = Random();
    final categories = ref.read(categoriesProvider);
    assert(colors.isNotEmpty, "Color Palette must not be empty");

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NoteEditor(
          note: Note(
            id: const Uuid().v4(),
            title: '',
            content: '',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            backgroundColor: colors[random.nextInt(colors.length)],
            category: categories.isNotEmpty ? categories.first.name : "General",
            isBold: false,
            isUnderline: false,
            isItalic: false,
            alignmentIndex: 0,
            styles: [],
          ),
          isNew: true,
        ),
      ),
    );
  }

  void _navigateToNoteView(BuildContext context, Note note) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteViewScreen(note: note),
      ),
    );
  }
}
