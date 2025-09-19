import 'dart:convert';
import 'dart:io';
import 'package:hr_attendance_tracker/models/attendance_record_model.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

class AttendanceService {
  static const String baseUrl = 'http://10.0.2.2:3000/api/attendance';
  final SupabaseClient _supabase = Supabase.instance.client;

  // Fetch attendances from the API
  static Future<List<AttendanceRecord>> fetchAttendances(
    String employeeId,
  ) async {
    final response = await http.get(Uri.parse("$baseUrl/$employeeId"));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => AttendanceRecord.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load attendances");
    }
  }

  static Future<AttendanceRecord> fetchAttendance(
    String employeeId,
    int attendanceRecordId,
  ) async {
    final response = await http.get(
      Uri.parse("$baseUrl/$employeeId/$attendanceRecordId"),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return AttendanceRecord.fromJson(data);
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

  Future<String> uploadAttendancePhoto(String uid, File file) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final fileName = "${uid}_$timestamp.jpg";

    // Upload ke Supabase Storage
    await _supabase.storage
        .from('profile-photos')
        .upload(fileName, file, fileOptions: const FileOptions(upsert: true));

    // Ambil URL public
    final url = _supabase.storage.from('profile-photos').getPublicUrl(fileName);

    return url;
  }

  // Update attendance (clock out)
  static Future<void> updateAttendance(
    String checkOut,
    String? url,
    double latitude,
    double longitude,
    String employeeId,
  ) async {
    final response = await http.put(
      Uri.parse('$baseUrl/clockout'),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: json.encode({
        'check_out': checkOut,
        'employee_id': employeeId,
        'clock_out_photo_url': url,
        'clock_out_latitude': latitude,
        'clock_out_longitude': longitude,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to clock out');
    }
  }
}
