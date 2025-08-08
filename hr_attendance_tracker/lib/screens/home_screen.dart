import 'package:flutter/material.dart';
import 'package:hr_attendance_tracker/screens/attendance_history.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'HR Attendance Tracker',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF004966),
                  ),
                ),
                SizedBox(height: 40),
                Image.asset('assets/images/attendance.jpg', height: 200),
                SizedBox(height: 40),
                Text(
                  'Track your attendance',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF004966),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Track and view your attendance records easily.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22, color: Color(0xFF004966)),
                ),
                SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            AttendanceHistoryScreen(withScaffold: true),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF004966),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Text(
                    'View Attendance History',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
                SizedBox(height: 30), // Extra space at the bottom
              ],
            ),
          ),
        ),
      ),
    );
  }
}
