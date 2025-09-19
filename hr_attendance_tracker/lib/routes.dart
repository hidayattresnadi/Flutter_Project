import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:hr_attendance_tracker/main.dart';
import 'package:hr_attendance_tracker/screens/about_page_screen.dart';
import 'package:hr_attendance_tracker/screens/admin/admin_main_screen.dart';
import 'package:hr_attendance_tracker/screens/attendance_screen_detail.dart';
import 'package:hr_attendance_tracker/screens/attendance_selfie_screen.dart';
import 'package:hr_attendance_tracker/screens/edit_profile_screen.dart';
import 'package:hr_attendance_tracker/screens/home_screen.dart';
import 'package:hr_attendance_tracker/screens/login_screen.dart';
import 'package:hr_attendance_tracker/screens/settings_screen.dart';

class AppRoutes {
  static const updateProfile = '/update_profile';
  static const settingPage = '/settings';
  static const aboutPage = '/about_page';
  static const home = '/home';
  static const login = '/login';
  static const admindashboard = '/admin_dashboard';
  static const selfieScreen = '/selfie_attendance';
  static const detailAttendancePage = '/attendance_detail';

  static Route<dynamic> generateRoute(
    RouteSettings settings,
    List<CameraDescription> cameras,
  ) {
    switch (settings.name) {
      case updateProfile:
        return MaterialPageRoute(builder: (_) => UpdateProfileScreen());
      case settingPage:
        return MaterialPageRoute(builder: (_) => SettingsScreen());
      case aboutPage:
        return MaterialPageRoute(builder: (_) => AboutPageScreen());
      case home:
        return MaterialPageRoute(builder: (_) => MainScreen());
      case login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case admindashboard:
        return MaterialPageRoute(builder: (_) => AdminMainScreen());
      case detailAttendancePage:
        final attendanceRecordId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) =>
              AttendanceScreenDetail(attendanceRecordId: attendanceRecordId),
        );
      case selfieScreen:
        final isClockOut = settings.arguments as bool? ?? false;
        return MaterialPageRoute(
          builder: (_) =>
              CameraWithMapScreen(cameras: cameras, isClockOut: isClockOut),
        );
      default:
        return MaterialPageRoute(builder: (_) => HomeScreen());
    }
  }
}
