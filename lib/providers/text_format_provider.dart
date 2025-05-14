// import 'package:flutter/material.dart';
//
// class TextFormatProvider extends ChangeNotifier {
//   bool _isBold = false;
//   bool _isItalic = false;
//   bool _isUnderline = false;
//   TextAlign _alignment = TextAlign.left;
//
//   bool get isBold => _isBold;
//
//   bool get isItalic => _isItalic;
//
//   bool get isUnderline => _isUnderline;
//
//   TextAlign get alignment => _alignment;
//
//   void toggleBold() {
//     _isBold = !_isBold;
//     notifyListeners();
//   }
//
//   void toggleItalic() {
//     _isItalic = !_isItalic;
//     notifyListeners();
//   }
//
//   void toggleUnderline() {
//     _isUnderline = !_isUnderline;
//     notifyListeners();
//   }
//
//   void changeAlignment(TextAlign align) {
//     _alignment = align;
//     notifyListeners();
//   }
//
//   void reset() {
//     _isBold = false;
//     _isItalic = false;
//     _isUnderline = false;
//     _alignment = TextAlign.left;
//     notifyListeners();
//   }
// }
import 'package:flutter/material.dart';

class Hmn extends StatelessWidget {
  const Hmn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          // IconButton(
          //   icon: const Icon(Icons.create_new_folder_rounded),
          //   onPressed: _showCategoryModal,
          // ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.pin_drop),
          ),
        ],
      ),
    );
  }

  // void _saveNote() {
  //   final updatedNote = widget.note.copyWith(
  //     title: _titleController.text,
  //     content: _contentController.text,
  //     category: _selectedCategory,
  //     isBold: _isBold,
  //     isItalic: _isItalic,
  //     isUnderline: _isUnderline,
  //     alignmentIndex: [TextAlign.left, TextAlign.center, TextAlign.right].indexOf(_alignment),
  //   );
  //
  //   if (widget.isNew) {
  //     ref.read(notesProvider.notifier).addNote(updatedNote);
  //   } else {
  //     ref.read(notesProvider.notifier).updateNote(updatedNote);
  //   }
  //   // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
  // }
  //
  // void _showCategoryModal() async {
  //   String? tempCategory = _selectedCategory;
  //
  //   await showModalBottomSheet(
  //     context: context,
  //     builder: (context) => StatefulBuilder(
  //       builder: (context, setModalState) {
  //         // Watch for category updates
  //         final categories = ref.watch(categoriesProvider);
  //
  //         return Scaffold(
  //           appBar: AppBar(
  //             leading: IconButton(
  //               onPressed: () {
  //                 Navigator.pop(context);
  //               },
  //               icon: const Icon(CupertinoIcons.xmark_circle_fill),
  //             ),
  //             title: const Text("Category"),
  //             centerTitle: true,
  //           ),
  //           bottomNavigationBar: Container(
  //             height: 50,
  //             margin: const EdgeInsets.only(bottom: 20),
  //             child: TextButton(
  //               onPressed: () {
  //                 setState(() => _selectedCategory = tempCategory!);
  //                 _saveNote();
  //                 Navigator.pushAndRemoveUntil(
  //                   context,
  //                   MaterialPageRoute(
  //                     builder: (_) => const HomeScreen(),
  //                   ),
  //                   (route) => false,
  //                 );
  //               },
  //               child: const Text('Save'),
  //             ),
  //           ),
  //           body: Column(
  //             children: [
  //               Expanded(
  //                 child: ListView(
  //                   children: [
  //                     ListTile(
  //                       title: const Text('Add a new category'),
  //                       contentPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
  //                       leading: const Icon(Icons.add_circle_outline_rounded),
  //                       onTap: () async {
  //                         final newCategory = await _createNewCategory(ref);
  //                         if (newCategory != null) {
  //                           setModalState(() => tempCategory = newCategory);
  //                         }
  //                       },
  //                     ),
  //                     const Padding(
  //                       padding: EdgeInsets.symmetric(horizontal: 20),
  //                       child: Divider(),
  //                     ),
  //                     ...categories
  //                         .map(
  //                           (category) => Container(
  //                             padding: const EdgeInsets.symmetric(horizontal: 20),
  //                             decoration: const BoxDecoration(
  //                               // color: Colors.grey,
  //                               borderRadius: BorderRadius.only(
  //                                 topLeft: Radius.circular(15),
  //                                 topRight: Radius.circular(15),
  //                               ),
  //                             ),
  //                             child: Column(
  //                               children: [
  //                                 RadioListTile<String>(
  //                                   title: Row(
  //                                     children: [
  //                                       Container(
  //                                         width: 20,
  //                                         height: 20,
  //                                         decoration: BoxDecoration(
  //                                           color: category.color,
  //                                           borderRadius: BorderRadius.circular(50),
  //                                         ),
  //                                       ),
  //                                       const SizedBox(width: 8),
  //                                       Text(category.name),
  //                                     ],
  //                                   ),
  //                                   controlAffinity: ListTileControlAffinity.trailing,
  //                                   activeColor: Colors.black87,
  //                                   value: category.name,
  //                                   groupValue: tempCategory,
  //                                   onChanged: (value) {
  //                                     setModalState(() => tempCategory = value);
  //                                     ref.read(notesProvider.notifier).updateNote(
  //                                           widget.note.copyWith(category: value),
  //                                         );
  //                                   },
  //                                 ),
  //                                 const Divider(),
  //                               ],
  //                             ),
  //                           ),
  //                         )
  //                         .toList(),
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }
  //
  // Future<String?> _createNewCategory(WidgetRef ref) async {
  //   final categoryController = TextEditingController();
  //   Color selectedColor = Colors.blue;
  //
  //   return showDialog<String?>(
  //     context: context,
  //     builder: (_) => AlertDialog(
  //       title: const Text('New Category'),
  //       content: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           TextField(
  //             controller: categoryController,
  //             decoration: const InputDecoration(
  //               labelText: 'Category Name',
  //             ),
  //           ),
  //           const SizedBox(height: 16),
  //           BlockPicker(
  //             pickerColor: selectedColor,
  //             onColorChanged: (color) => selectedColor = color,
  //           ),
  //         ],
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(context),
  //           child: const Text('Cancel'),
  //         ),
  //         FilledButton(
  //           onPressed: () {
  //             if (categoryController.text.isNotEmpty) {
  //               final newCategory = Category(categoryController.text, selectedColor);
  //               ref.read(categoriesProvider.notifier).addCategory(newCategory);
  //               Navigator.pop(context, newCategory.name);
  //             }
  //           },
  //           child: const Text('Create'),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
