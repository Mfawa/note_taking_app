import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/category.dart';
import '../models/note.dart';
import '../providers/category_provider.dart';
import '../providers/notes_provider.dart';
import 'home_screen.dart';

class NoteEditor extends ConsumerStatefulWidget {
  final Note note;
  final bool isNew;

  const NoteEditor({super.key, required this.note, required this.isNew});

  @override
  ConsumerState<NoteEditor> createState() => _NoteEditorState();
}

class _NoteEditorState extends ConsumerState<NoteEditor> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late FocusNode _contentFocusNode;
  bool _isBold = false;
  bool _isItalic = false;
  bool _isUnderline = false;
  TextAlign _alignment = TextAlign.left;
  late String _selectedCategory;

  Color _selectedColor = Colors.white;
  final TextEditingController categoryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note.title);
    _contentController = TextEditingController(text: widget.note.content);
    _contentFocusNode = FocusNode();
    _selectedCategory = widget.note.category;
    _selectedColor = widget.note.backgroundColor;
    _isBold = widget.note.isBold;
    _isItalic = widget.note.isItalic;
    _isUnderline = widget.note.isUnderline;
    _alignment = [TextAlign.left, TextAlign.center, TextAlign.right][widget.note.alignmentIndex];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_contentFocusNode);
    });
  }

  @override
  Widget build(BuildContext context) {
    double maxHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.create_new_folder_rounded),
            onPressed: _showCategoryModal,
          ), IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _confirmDelete,
          ),
        ],
      ),
      extendBody: true,
      bottomNavigationBar: PreferredSize(
        preferredSize: Size(100, 500),
        child: _buildFormattingBar(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              style: const TextStyle(fontSize: 38),
              decoration: const InputDecoration(
                hintText: 'Title',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 12),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 75),
              child: TextField(
                controller: _contentController,
                focusNode: _contentFocusNode,
                textAlign: _alignment,
                style: TextStyle(
                  fontFamily: "Avenir",
                  fontWeight: _isBold ? FontWeight.bold : FontWeight.normal,
                  fontStyle: _isItalic ? FontStyle.italic : FontStyle.normal,
                  decoration: _isUnderline ? TextDecoration.underline : TextDecoration.none,
                ),
                maxLines: null,
                // expands: true,
                decoration: const InputDecoration(
                  hintText: 'Start writing...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveNote() {
    final updatedNote = widget.note.copyWith(
      title: _titleController.text,
      content: _contentController.text,
      category: _selectedCategory,
      isBold: _isBold,
      isItalic: _isItalic,
      isUnderline: _isUnderline,
      alignmentIndex: [TextAlign.left, TextAlign.center, TextAlign.right].indexOf(_alignment),
    );

    if (widget.isNew) {
      ref.read(notesProvider.notifier).addNote(updatedNote);
    } else {
      ref.read(notesProvider.notifier).updateNote(updatedNote);
    }
    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Note'),
          content: const Text('Are you sure you want to delete this note?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                ref.read(notesProvider.notifier).deleteNote(widget.note.id);

                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _showCategoryModal() async {
    String? tempCategory = _selectedCategory;

    await showModalBottomSheet(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          // Watch for category updates
          final categories = ref.watch(categoriesProvider);

          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(CupertinoIcons.xmark_circle_fill),
              ),
              title: Text("Category"),
              centerTitle: true,
            ),
            bottomNavigationBar: Container(
              height: 50,
              margin: EdgeInsets.only(bottom: 20),
              child: TextButton(
                onPressed: () {
                  setState(() => _selectedCategory = tempCategory!);
                  _saveNote();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const HomeScreen(),
                    ),
                    (route) => false,
                  );
                },
                child: const Text('Save'),
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      ListTile(
                        title: Text('Add a new category'),
                        contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                        leading: Icon(Icons.add_circle_outline_rounded),
                        onTap: () async {
                          final newCategory = await _createNewCategory(ref);
                          if (newCategory != null) {
                            setModalState(() => tempCategory = newCategory);
                          }
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Divider(),
                      ),
                      ...categories
                          .map(
                            (category) => Container(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              decoration: const BoxDecoration(
                                // color: Colors.grey,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15),
                                ),
                              ),
                              child: Column(
                                children: [
                                  RadioListTile<String>(
                                    title: Row(
                                      children: [
                                        Container(
                                          width: 20,
                                          height: 20,
                                          decoration: BoxDecoration(
                                            color: category.color,
                                            borderRadius: BorderRadius.circular(50),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(category.name),
                                      ],
                                    ),
                                    controlAffinity: ListTileControlAffinity.trailing,
                                    activeColor: Colors.black87,
                                    value: category.name,
                                    groupValue: tempCategory,
                                    onChanged: (value) {
                                      setModalState(() => tempCategory = value);
                                      ref.read(notesProvider.notifier).updateNote(
                                            widget.note.copyWith(category: value),
                                          );
                                    },
                                  ),
                                  Divider(),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<String?> _createNewCategory(WidgetRef ref) async {
    final categoryController = TextEditingController();
    Color selectedColor = Colors.blue;

    return showDialog<String?>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('New Category'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: categoryController,
              decoration: const InputDecoration(
                labelText: 'Category Name',
              ),
            ),
            const SizedBox(height: 16),
            BlockPicker(
              pickerColor: selectedColor,
              onColorChanged: (color) => selectedColor = color,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (categoryController.text.isNotEmpty) {
                final newCategory = Category(categoryController.text, selectedColor);
                ref.read(categoriesProvider.notifier).addCategory(newCategory);
                Navigator.pop(context, newCategory.name);
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  Widget _buildFormattingBar() {
    return Container(
      height: 56,
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 25),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: Icon(Icons.format_bold, color: _isBold ? Colors.blue : Colors.black),
            onPressed: () => setState(() => _isBold = !_isBold),
          ),
          IconButton(
            icon: Icon(Icons.format_italic, color: _isItalic ? Colors.blue : Colors.black),
            onPressed: () => setState(() => _isItalic = !_isItalic),
          ),
          IconButton(
            icon: Icon(Icons.format_underline, color: _isUnderline ? Colors.blue : Colors.black),
            onPressed: () => setState(() => _isUnderline = !_isUnderline),
          ),
          IconButton(
            color: _alignment == TextAlign.justify ? Colors.blue : Colors.black,
            icon: Icon(Icons.format_align_justify),
            onPressed: () => setState(
              () => _alignment = TextAlign.justify,
            ),
          ),
          IconButton(
            color: _alignment == TextAlign.left ? Colors.blue : Colors.black,
            icon: Icon(Icons.format_align_left),
            onPressed: () => setState(
              () => _alignment = TextAlign.left,
            ),
          ),
          IconButton(
            color: _alignment == TextAlign.center ? Colors.blue : Colors.black,
            icon: Icon(Icons.format_align_center),
            onPressed: () => setState(
              () => _alignment = TextAlign.center,
            ),
          ),
          IconButton(
            color: _alignment == TextAlign.right ? Colors.blue : Colors.black,
            icon: Icon(Icons.format_align_right),
            onPressed: () => setState(
              () => _alignment = TextAlign.right,
            ),
          ),
          // IconButton(
          //   color: Colors.black,
          //   icon: const Icon(Icons.category),
          //   onPressed: _showCategoryModal,
          // ),
          // IconButton(
          //   color: Colors.black,
          //   icon: Icon(Icons.color_lens, color: _selectedColor),
          //   onPressed: () => _showColorPicker(),
          // ),
        ],
      ),
    );
  }
}
