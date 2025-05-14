import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/calender_provider.dart';

class DateSortCalendar extends ConsumerWidget {
  const DateSortCalendar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dates = ref.watch(dateListProvider);
    final currentDate = ref.watch(currentDateProvider);
    final today = DateTime(currentDate.year, currentDate.month, currentDate.day);

    return Container(
      height: 80,
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: dates.length,
        itemBuilder: (context, index) {
          final date = dates[index];
          final normalizedDate = DateTime(date.year, date.month, date.day);
          final isCurrent = normalizedDate == today;
          final isPast = normalizedDate.isBefore(today);
          final isFuture = normalizedDate.isAfter(today);

          return _DateBox(
            date: date,
            isCurrent: isCurrent,
            isPast: isPast,
            isFuture: isFuture,
          );
        },
      ),
    );
  }
}

// Date Box Component
class _DateBox extends StatelessWidget {
  final DateTime date;
  final bool isCurrent;
  final bool isPast;
  final bool isFuture;

  const _DateBox({
    required this.date,
    required this.isCurrent,
    required this.isPast,
    required this.isFuture,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isFuture ? 0.5 : 1.0,
      child: Container(
        width: 60,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: isCurrent ? Colors.grey[900] : (isPast ? Colors.white : Colors.grey[300]),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isCurrent ? Colors.black26 : (isPast ? Colors.black26 : Colors.black12),
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _getDayName(date),
              style: TextStyle(
                color: isCurrent ? Colors.white : (isPast ? Colors.black54 : Colors.black87),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              date.day.toString(),
              style: TextStyle(
                color: isCurrent ? Colors.white : (isPast ? Colors.black87 : Colors.black87),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getDayName(DateTime date) {
    return ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'][date.weekday % 7];
  }
}
