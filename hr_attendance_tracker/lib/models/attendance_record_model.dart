import 'package:intl/intl.dart';

class AttendanceRecord {
  int? id;
  String date;
  String day;
  String checkIn;
  String checkOut;
  String status;
  String employeeId;
  String? clockInPhotoUrl;
  String? clockOutPhotoUrl;
  double? clockInLatitude;
  double? clockInLongitude;
  double? clockOutLatitude;
  double? clockOutLongitude;

  AttendanceRecord({
    this.id,
    required this.date,
    required this.day,
    required this.checkIn,
    required this.checkOut,
    required this.status,
    required this.employeeId,
    this.clockInPhotoUrl,
    this.clockOutPhotoUrl,
    this.clockInLatitude,
    this.clockInLongitude,
    this.clockOutLatitude,
    this.clockOutLongitude,
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

  // Fungsi untuk mengubah data JSON menjadi objek Attendance
  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      id: json['attendance_id'],
      date: json['attendance_date'],
      day: json['day_name'],
      checkIn: json['check_in'],
      checkOut: json['check_out'],
      status: json['status'],
      employeeId: json['employee_id'],
      clockInPhotoUrl: json['clock_in_photo_url'],
      clockOutPhotoUrl: json['clock_out_photo_url'],
      clockInLatitude: json['clock_in_latitude'],
      clockInLongitude: json['clock_in_longitude'],
      clockOutLatitude: json['clock_out_latitude'],
      clockOutLongitude: json['clock_out_longitude'],
    );
  }
  // Fungsi untuk mengubah objek attendance menjadi format JSON
  Map<String, dynamic> toJson() {
    return {
      'attendance_date': date,
      'day_name': day,
      'check_in': checkIn,
      'check_out': checkOut,
      'status': status,
      'employee_id': employeeId,
      'clock_in_photo_url': clockInPhotoUrl,
      'clock_out_photo_url': clockOutPhotoUrl,
      'clock_in_latitude': clockInLatitude,
      'clock_in_longitude': clockInLongitude,
      'clock_out_latitude': clockOutLatitude,
      'clock_out_longitude': clockOutLongitude,
    };
  }
}
