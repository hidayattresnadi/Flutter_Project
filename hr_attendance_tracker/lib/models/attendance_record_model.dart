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

  double get workProgress {
    final format = DateFormat('HH:mm');
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // jam checkin hari ini
    final inTime = format.parse(checkIn.trim());
    final checkInTime = DateTime(
      today.year,
      today.month,
      today.day,
      inTime.hour,
      inTime.minute,
    );

    // jam selesai kerja (8 jam)
    final endTime = checkInTime.add(Duration(hours: 8));

    // total durasi kerja
    final totalWork = endTime.difference(checkInTime).inMinutes;

    // sudah bekerja berapa menit
    final worked = now.difference(checkInTime).inMinutes;

    // progress antara 0.0 - 1.0
    final progress = worked / totalWork;

    // biar ga lebih dari 1.0 atau kurang dari 0.0
    return progress.clamp(0.0, 1.0);
  }
}
