import 'dart:convert';
import 'package:hr_attendance_tracker/models/attendance_record_model.dart';
import 'package:http/http.dart' as http;

class AttendanceService {
  static const String baseUrl = 'http://10.0.2.2:3000/api/attendance';

  // Fetch attendances from the API
  static Future<List<AttendanceRecord>> fetchAttendances() async {
    final response = await http.get(Uri.parse("$baseUrl/1"));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => AttendanceRecord.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load attendances");
    }
  }

  //Add a new attendance (clock in)
  static Future<void> addAttendance(AttendanceRecord attendance) async {
    final response = await http.post(
      Uri.parse("$baseUrl/clockin"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(attendance.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception("Failed to clock in");
    }
  }

  // Update attendance (clock out)
  static Future<void> updateAttendance(String checkOut) async {
    final response = await http.put(
      Uri.parse('$baseUrl/clockout'),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: json.encode({'check_out': checkOut, 'employee_id': 1}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to clock out');
    }
  }
}
