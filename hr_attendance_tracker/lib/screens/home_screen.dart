import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hr_attendance_tracker/models/menu_model.dart';
import 'package:hr_attendance_tracker/providers/attendance_record_provider.dart';
import 'package:hr_attendance_tracker/providers/profile_provider.dart';
import 'package:hr_attendance_tracker/screens/attendance_history.dart';
import 'package:hr_attendance_tracker/widgets/clock_in_button.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final profile = context.watch<ProfileFormProvider>().profileData;
    final listAttendanceRecords = context
        .watch<AttendanceRecordProvider>()
        .attendanceRecords;

    String formattedDate = DateFormat(
      'EEE, d MMM',
    ).format(DateTime.now()).toUpperCase();
    String formattedTime = DateFormat('h:mm a').format(DateTime.now());
    String formattedDateOut = DateFormat(
      'EEE, d MMM hh:mm a',
    ).format(DateTime.now()).toUpperCase();
    String today = DateFormat('MMM d, yyyy').format(DateTime.now());

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== Greeting & Profile =====
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Text(
                            'Good morning, ',
                            style: TextStyle(fontSize: 20),
                          ),
                          Icon(Icons.waving_hand_rounded, color: Colors.yellow),
                        ],
                      ),
                      const Text(
                        'Dayat.',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        today == listAttendanceRecords.last.date
                            ? 'Have a great day at work!'
                            : 'Begin another great day by clocking in.',
                        style: TextStyle(
                          fontSize: screenWidth < 400 ? 12 : 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                CircleAvatar(
                  radius: 45,
                  backgroundImage: profile.profilePhoto.startsWith('assets/')
                      ? AssetImage(profile.profilePhoto) as ImageProvider
                      : FileImage(File(profile.profilePhoto)),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // ===== Clock In Card =====
            if (today != listAttendanceRecords.last.date)
              AttendanceCard(
                dateText: formattedDate,
                timeText: formattedTime,
                workingHours: 'Starts 9:00AM-10:00AM & Ends 6:00PM-7:00PM',
                buttonText: 'Clock in',
                buttonColor: Colors.green,
                showButton: true,
                onPressed: () {
                  final now = DateTime.now();
                  if (now.hour < 9 || (now.hour == 9 && now.minute == 0)) {
                    // Before 9:00
                  } else {
                    context.read<AttendanceRecordProvider>().addAttendance();
                    Fluttertoast.showToast(msg: 'success clock in');
                  }
                },
              ),

            // ===== Clock Out Card =====
            if (today == listAttendanceRecords.last.date)
              AttendanceCard(
                dateText: formattedDateOut,
                loggedHours: listAttendanceRecords.isNotEmpty
                    ? listAttendanceRecords.last.workDuration
                    : '-',
                sinceText:
                    'Since first in at ${listAttendanceRecords.last.checkIn}',
                workingHours: 'Starts 9:00AM-10:00AM & Ends 6:00PM-7:00PM',
                buttonText: 'Clock out',
                buttonColor: Colors.red,
                autoSizeDate: true,
                showButton: listAttendanceRecords.last.checkOut == '-',
                onPressed: () async {
                  final shouldUpdate = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Clock out'),
                      content: const Text(
                        'Are you sure you want to clock out?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(false),
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.of(ctx).pop(true),
                          child: const Text('Confirm'),
                        ),
                      ],
                    ),
                  );

                  if (!context.mounted) return;
                  if (shouldUpdate == true) {
                    context.read<AttendanceRecordProvider>().updateAttandance();
                    Fluttertoast.showToast(msg: 'success clock out');
                  }
                },
              ),
            // ===== View Attendance History Button =====
            SizedBox(height: 30),
            buildListMenus(),
          ],
        ),
      ),
    );
  }
}

Widget buildListMenus() {
  final List<Menu> menus = [
    Menu(name: 'Attendance History', icon: Icons.history),
    Menu(name: 'Leaves', icon: Icons.airplanemode_active),
    Menu(name: 'Payslips', icon: Icons.wallet),
    Menu(name: 'Claims', icon: Icons.paypal_rounded),
  ];

  return LayoutBuilder(
    builder: (context, constraints) {
      final screenWidth = constraints.maxWidth;
      // final crossAxisCount = screenWidth < 600 ? 1 : 2;
      int crossAxisCount;
      if (screenWidth < 600) {
        crossAxisCount = 2; // HP
      } else if (screenWidth < 1024) {
        crossAxisCount = 3; // Tablet
      } else {
        crossAxisCount = 4; // Desktop
      }
      final spacing = 16 * (crossAxisCount - 1);
      final itemWidth = (screenWidth - spacing) / crossAxisCount;
      final itemHeight = 120; // tinggi fix
      final childAspectRatio = itemWidth / itemHeight;

      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 4,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 20,
            childAspectRatio: childAspectRatio,
          ),
          itemBuilder: (context, index) {
            final menu = menus[index];
            return buildMenuCard(context, menu);
          },
        ),
      );
    },
  );
}

Widget buildMenuCard(BuildContext context, Menu menu) {
  final autosizeGroup = AutoSizeGroup();
  return ElevatedButton(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AttendanceHistoryScreen(withScaffold: true),
        ),
      );
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.white, // warna seperti card
      foregroundColor: Colors.black, // warna teks
      elevation: 4, // bayangan seperti card
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.all(12),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AutoSizeText(
          menu.name,
          group: autosizeGroup,
          minFontSize: 12,
          maxFontSize: 20,
          maxLines: 2,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Icon(menu.icon, color: Colors.blue),
      ],
    ),
  );
}
