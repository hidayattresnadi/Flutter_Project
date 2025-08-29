import 'package:flutter/material.dart';
import 'package:hr_attendance_tracker/screens/about_page_screen.dart';
import 'package:hr_attendance_tracker/screens/edit_profile_screen.dart';
import 'package:hr_attendance_tracker/screens/home_screen.dart';
import 'package:hr_attendance_tracker/screens/settings_screen.dart';

class AppRoutes {
  static const updateProfile = '/update_profile';
  static const settingPage = '/settings';
  static const aboutPage = '/about_page';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case updateProfile:
        return MaterialPageRoute(builder: (_) => UpdateProfileScreen());
      case settingPage:
        return MaterialPageRoute(builder: (_) => SettingsScreen());
      case aboutPage:
        return MaterialPageRoute(builder: (_) => AboutPageScreen());
      default:
        return MaterialPageRoute(builder: (_) => HomeScreen());
    }
  }
}
