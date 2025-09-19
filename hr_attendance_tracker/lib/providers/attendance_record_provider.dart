import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hr_attendance_tracker/models/attendance_record_model.dart';
import 'package:hr_attendance_tracker/services/attendance_service.dart';
import 'package:intl/intl.dart';

class AttendanceRecordProvider extends ChangeNotifier {
  List<AttendanceRecord> _attendanceRecords = [];
  final AttendanceService _attendanceService = AttendanceService();
  String? _errorMessage;
  bool _isLoading = false;
  AttendanceRecord? _lastRecord;
  AttendanceRecord? _chosenAttendanceRecord;

  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  List<AttendanceRecord> get attendanceRecords => _attendanceRecords;
  AttendanceRecord? get lastRecord => _lastRecord;
  AttendanceRecord? get chosenAttendanceRecord => _chosenAttendanceRecord;

  // get all data from API
  Future<void> fetchAttendances(String employeeId) async {
    _errorMessage = null;
    _isLoading = true;
    _attendanceRecords = [];

    await Future.delayed(const Duration(seconds: 2));
    try {
      _attendanceRecords = await AttendanceService.fetchAttendances(employeeId);
      _lastRecord = _attendanceRecords.isNotEmpty
          ? _attendanceRecords.last
          : null;
    } catch (e) {
      _errorMessage = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchAttendance(
    String employeeId,
    int attendanceRecordId,
  ) async {
    _errorMessage = null;
    _isLoading = true;
    _chosenAttendanceRecord;

    await Future.delayed(const Duration(seconds: 2));
    try {
      _chosenAttendanceRecord = await AttendanceService.fetchAttendance(
        employeeId,
        attendanceRecordId,
      );
    } catch (e) {
      _errorMessage = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  // Add Attendance (clock in)
  Future<bool> addAttendance(
    String employeeId,
    File file,
    double latitude,
    double longitude,
  ) async {
    try {
      String today = DateFormat('MMM d, yyyy').format(DateTime.now());
      String dayName = DateFormat('EEEE').format(DateTime.now());
      String time24 = DateFormat('HH:mm').format(DateTime.now());

      final url = await uploadAttendancePhoto(employeeId, file);

      AttendanceRecord attendanceRecord = AttendanceRecord(
        date: today,
        day: dayName,
        checkIn: time24,
        checkOut: '-',
        status: 'Present',
        employeeId: employeeId,
        clockInPhotoUrl: url,
        clockInLatitude: latitude,
        clockInLongitude: longitude,
      );

      await AttendanceService.addAttendance(attendanceRecord);
      await fetchAttendances(employeeId);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<String?> uploadAttendancePhoto(String? employeeId, File file) async {
    if (employeeId == null) return null;

    _isLoading = true;
    notifyListeners();

    try {
      final url = await _attendanceService.uploadAttendancePhoto(
        employeeId,
        file,
      );

      return url;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update Attendance (clock out)
  Future<bool> updateAttandance(
    String employeeId,
    File file,
    double latitude,
    double longitude,
  ) async {
    try {
      String time24 = DateFormat('HH:mm').format(DateTime.now());
      final url = await uploadAttendancePhoto(employeeId, file);
      await AttendanceService.updateAttendance(
        time24,
        url,
        latitude,
        longitude,
        employeeId,
      );
      await fetchAttendances(employeeId);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}
