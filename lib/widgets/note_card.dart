import 'package:flutter/material.dart';

import '../models/note.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;

  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: note.backgroundColor,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                note.title,
                style: Theme.of(context).textTheme.titleMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                note.category,
                style: Theme.of(context).textTheme.labelSmall,
              ),
              const SizedBox(height: 8),
              Text(
                note.content,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class NoteCard extends StatelessWidget {
//   final Note note;
//   final VoidCallback onTap;
//
//   const NoteCard({super.key, required this.note, required this.onTap});
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       color: note.backgroundColor,
//       child: InkWell(
//         onTap: () => Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => ChangeNotifierProvider(
//               create: (_) => TextFormatProvider(),
//               child: NoteEditor(note: note, isNew: false),
//             ),
//           ),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(12),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 note.title,
//                 style: Theme.of(context).textTheme.titleMedium,
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 DateFormat.yMMMd().format(note.updatedAt),
//                 style: Theme.of(context).textTheme.labelSmall,
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 note.content,
//                 maxLines: 3,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
