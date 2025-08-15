import 'package:flutter/material.dart';
import 'package:hr_attendance_tracker/models/attendance_record_model.dart';
import 'package:intl/intl.dart';

class AttendanceRecordProvider extends ChangeNotifier {
  final List<AttendanceRecord> _attendanceRecords = [
    AttendanceRecord(
      date: 'Aug 1, 2022',
      day: 'Monday',
      checkIn: '08:00',
      checkOut: '17:00',
      status: 'Present',
    ),
    AttendanceRecord(
      date: 'Aug 2, 2022',
      day: 'Monday',
      checkIn: '08:05',
      checkOut: '17:10',
      status: 'Present',
    ),
    AttendanceRecord(
      date: 'Aug 3, 2022',
      day: 'Monday',
      checkIn: '08:15',
      checkOut: '16:50',
      status: 'Present',
    ),
    AttendanceRecord(
      date: 'Aug 4, 2022',
      day: 'Monday',
      checkIn: '-',
      checkOut: '-',
      status: 'Absent',
    ),
    AttendanceRecord(
      date: 'Aug 5, 2022',
      day: 'Monday',
      checkIn: '08:10',
      checkOut: '17:00',
      status: 'Present',
    ),
    AttendanceRecord(
      date: 'Aug 6, 2022',
      day: 'Monday',
      checkIn: '08:20',
      checkOut: '17:30',
      status: 'Present',
    ),
    AttendanceRecord(
      date: 'Aug 7, 2022',
      day: 'Monday',
      checkIn: '-',
      checkOut: '-',
      status: 'Absent',
    ),
  ];

  List<AttendanceRecord> get attendanceRecords => _attendanceRecords;
  void addAttendance() {
    String today = DateFormat('MMM d, yyyy').format(DateTime.now());
    String dayName = DateFormat('EEEE').format(DateTime.now());
    String time24 = DateFormat('HH:mm').format(DateTime.now());

    _attendanceRecords.add(
      AttendanceRecord(
        date: today,
        day: dayName,
        checkIn: time24,
        checkOut: '-',
        status: 'Present',
      ),
    );
    notifyListeners();
  }

  void updateAttandance() {
    int index = _attendanceRecords.length - 1;
    String time24 = DateFormat('HH:mm').format(DateTime.now());
    _attendanceRecords[index].checkOut = time24;
    notifyListeners();
  }
}
