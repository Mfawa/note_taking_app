import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final selectedDateProvider = StateProvider<DateTime?>((ref) => null);

final calendarDatesProvider = StateNotifierProvider<CalendarDatesNotifier, List<DateTime>>((ref) {
  return CalendarDatesNotifier();
});

final currentDateProvider = StateNotifierProvider<CurrentDateNotifier, DateTime>(
  (ref) => CurrentDateNotifier(),
);

final dateListProvider = Provider<List<DateTime>>((ref) {
  final currentDate = ref.watch(currentDateProvider);
  final sunday = currentDate.subtract(Duration(days: currentDate.weekday % 7));
  return List.generate(7, (index) => sunday.add(Duration(days: index)));
});

// State Notifier to handle date updates
class CurrentDateNotifier extends StateNotifier<DateTime> {
  CurrentDateNotifier() : super(DateTime.now()) {
    _startDateChecker();
  }

  void _startDateChecker() {
    Timer.periodic(const Duration(seconds: 30), (timer) {
      final now = DateTime.now();
      if (now.day != state.day || now.month != state.month || now.year != state.year) {
        state = now;
      }
    });
  }
}

class CalendarDatesNotifier extends StateNotifier<List<DateTime>> {
  CalendarDatesNotifier() : super([]) {
    _initDates();
  }

  Future<void> _initDates() async {
    final prefs = await SharedPreferences.getInstance();
    final firstLaunch = prefs.getString('first_launch_date');

    if (firstLaunch == null) {
      final now = DateTime.now();
      await prefs.setString('first_launch_date', now.toIso8601String());
      state = [now];
    } else {
      final firstDate = DateTime.parse(firstLaunch);
      final currentDate = DateTime.now();
      state = _generateDateRange(firstDate, currentDate);
    }
  }

  List<DateTime> _generateDateRange(DateTime start, DateTime end) {
    final days = <DateTime>[];
    DateTime current = start;

    while (current.isBefore(end) || current.isAtSameMomentAs(end)) {
      days.add(current);
      current = current.add(const Duration(days: 1));
    }

    return days;
  }

  void updateDates(DateTime newDate) {
    if (state.isEmpty || newDate.isAfter(state.last)) {
      state = [...state, newDate];
    }
  }
}
