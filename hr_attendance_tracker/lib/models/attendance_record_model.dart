import 'package:intl/intl.dart';

class AttendanceRecord {
  String date;
  String day;
  String checkIn;
  String checkOut;
  String status;

  AttendanceRecord({
    required this.date,
    required this.day,
    required this.checkIn,
    required this.checkOut,
    required this.status,
  });

  String get workDuration {
    bool isValidTime(String? value) {
      if (value == null) return false;
      final v = value.trim();
      if (v.isEmpty || v == '-') return false;
      return true;
    }

    if (!isValidTime(checkIn) || !isValidTime(checkOut)) {
      return '-';
    }

    final format = DateFormat('HH:mm');
    var inTime = format.parse(checkIn.trim());
    var outTime = format.parse(checkOut.trim());

    if (outTime.isBefore(inTime)) {
      outTime = outTime.add(const Duration(days: 1));
    }

    final diff = outTime.difference(inTime);
    final hours = diff.inHours;
    final minutes = diff.inMinutes % 60;

    return '$hours:${minutes.toString().padLeft(2, '0')}';
  }
}
