import 'package:flutter/material.dart';
import 'package:hr_attendance_tracker/models/attendance_record_model.dart';
import 'package:hr_attendance_tracker/services/attendance_service.dart';
import 'package:intl/intl.dart';

class AttendanceRecordProvider extends ChangeNotifier {
  List<AttendanceRecord> _attendanceRecords = [];
  String? _errorMessage;
  bool _isLoading = false;
  AttendanceRecord? _lastRecord;

  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  List<AttendanceRecord> get attendanceRecords => _attendanceRecords;
  AttendanceRecord? get lastRecord => _lastRecord;

  // get all data from API
  Future<void> fetchAttendances() async {
    _errorMessage = null;
    _isLoading = true;
    _attendanceRecords = [];

    await Future.delayed(const Duration(seconds: 2));
    try {
      _attendanceRecords = await AttendanceService.fetchAttendances();
      _lastRecord = _attendanceRecords.isNotEmpty
          ? _attendanceRecords.last
          : null;
    } catch (e) {
      _errorMessage = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  // Add Attendance (clock in)
  Future<bool> addAttendance() async {
    try {
      String today = DateFormat('MMM d, yyyy').format(DateTime.now());
      String dayName = DateFormat('EEEE').format(DateTime.now());
      String time24 = DateFormat('HH:mm').format(DateTime.now());

      AttendanceRecord attendanceRecord = AttendanceRecord(
        date: today,
        day: dayName,
        checkIn: time24,
        checkOut: '-',
        status: 'Present',
        employeeId: 1,
      );

      await AttendanceService.addAttendance(attendanceRecord);
      await fetchAttendances();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Update Attendance (clock out)
  Future<bool> updateAttandance() async {
    try {
      String time24 = DateFormat('HH:mm').format(DateTime.now());
      await AttendanceService.updateAttendance(time24);
      await fetchAttendances();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}
