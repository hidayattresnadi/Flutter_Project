import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hr_attendance_tracker/providers/attendance_record_provider.dart';
import 'package:hr_attendance_tracker/providers/employee_provider.dart';
import 'package:hr_attendance_tracker/widgets/attendance_section.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class AttendanceScreenDetail extends StatefulWidget {
  final int attendanceRecordId;
  const AttendanceScreenDetail({super.key, required this.attendanceRecordId});

  @override
  State<AttendanceScreenDetail> createState() => AttendanceScreenDetailState();
}

class AttendanceScreenDetailState extends State<AttendanceScreenDetail> {
  String? _address;
  String? _addressClockOut;
  bool _loadingClockIn = true;
  bool _loadingClockOut = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final attendanceRecordProvider = context.read<AttendanceRecordProvider>();
    final employeeLoggedIn = context.read<EmployeeProvider>().employee;

    if (employeeLoggedIn?.employeeId == null) return;

    await attendanceRecordProvider.fetchAttendance(
      employeeLoggedIn!.employeeId,
      widget.attendanceRecordId,
    );

    final record = attendanceRecordProvider.chosenAttendanceRecord;

    if (record?.clockInLatitude != null && record?.clockInLongitude != null) {
      await _getAddressFromLatLng(
        record!.clockInLatitude!,
        record.clockInLongitude!,
        'clock in',
      );
    }

    setState(() => _loadingClockIn = false);

    if (record?.clockOutLatitude != null && record?.clockOutLongitude != null) {
      await _getAddressFromLatLng(
        record!.clockOutLatitude!,
        record.clockOutLongitude!,
        'clock out',
      );
    }

    setState(() => _loadingClockOut = false);
    await Future.delayed(const Duration(seconds: 2));
  }

  Future<void> _getAddressFromLatLng(
    double lat,
    double lon,
    String clockType,
  ) async {
    final url = Uri.parse(
      "https://nominatim.openstreetmap.org/reverse?lat=$lat&lon=$lon&format=json",
    );
    try {
      final response = await http.get(
        url,
        headers: {"User-Agent": "flutter_app"},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (clockType == 'clock in') {
          setState(() => _address = data['display_name']);
        } else {
          setState(() => _addressClockOut = data['display_name']);
        }
      }
    } catch (e) {
      print("Error fetching address: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final attendanceRecord = context
        .watch<AttendanceRecordProvider>()
        .chosenAttendanceRecord;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber.shade900,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Attendance Detail',
                style: GoogleFonts.pacifico(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
            Text(
              DateFormat('MMMM dd, yyyy').format(DateTime.now()),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        centerTitle: false,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: _loadingClockIn == true && _loadingClockOut == true
              ? SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height,
                  child: const Center(child: CircularProgressIndicator()),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AttendanceSection(
                      title: "Clock In",
                      photoUrl: attendanceRecord!.clockInPhotoUrl,
                      time: attendanceRecord.checkIn,
                      status: attendanceRecord.status,
                      type: "Clock in",
                      latitude: attendanceRecord.clockInLatitude,
                      longitude: attendanceRecord.clockInLongitude,
                      address: _address,
                    ),

                    const SizedBox(height: 40),

                    if (attendanceRecord.checkOut != "-")
                      AttendanceSection(
                        title: "Clock Out",
                        photoUrl: attendanceRecord.clockOutPhotoUrl,
                        time: attendanceRecord.checkOut,
                        status: attendanceRecord.status,
                        type: "Clock out",
                        latitude: attendanceRecord.clockOutLatitude,
                        longitude: attendanceRecord.clockOutLongitude,
                        address: _addressClockOut,
                      ),
                  ],
                ),
        ),
      ),
    );
  }
}
