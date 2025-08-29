import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hr_attendance_tracker/models/attendance_record_model.dart';
import 'package:hr_attendance_tracker/providers/attendance_record_provider.dart';
import 'package:hr_attendance_tracker/screens/tab_attendance_screen/attendance_tab.dart';
import 'package:hr_attendance_tracker/screens/tab_attendance_screen/shift_tab.dart';
import 'package:hr_attendance_tracker/widgets/month_dropdown.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AttendanceItem extends StatelessWidget {
  final AttendanceRecord record;
  const AttendanceItem({super.key, required this.record});

  static const double dateWidth = 90;
  static const double smallColWidth = 80;
  static const double statusWidth = 90;

  @override
  Widget build(BuildContext context) {
    final AutoSizeGroup dateGroup = AutoSizeGroup();
    final AutoSizeGroup dayGroup = AutoSizeGroup();
    final AutoSizeGroup inTimeGroup = AutoSizeGroup();
    // final AutoSizeGroup statusGroup = AutoSizeGroup();

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // DATE
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AutoSizeText(
                  record.date,
                  group: dateGroup, // Pisah group untuk date
                  minFontSize: 12,
                  maxFontSize: 13,
                  maxLines: 1,
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                AutoSizeText(
                  record.day,
                  group: dayGroup, // Pisah group untuk day
                  minFontSize: 10,
                  maxFontSize: 12,
                  style: GoogleFonts.poppins(),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // CHECK IN
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AutoSizeText(
                  record.checkIn,
                  group: inTimeGroup,
                  minFontSize: 10,
                  maxFontSize: 13,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(),
                ),
                const SizedBox(height: 4),
                const SizedBox(height: 16), // Placeholder biar sejajar
              ],
            ),
          ),

          const SizedBox(width: 8),

          // CHECK OUT
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AutoSizeText(
                  record.checkOut,
                  group: inTimeGroup,
                  minFontSize: 10,
                  maxFontSize: 13,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(fontWeight: FontWeight.normal),
                ),
                const SizedBox(height: 4),
                const SizedBox(height: 16),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // STATUS
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (record.status != 'status')
                  Icon(
                    record.status == 'Present'
                        ? Icons.check_circle
                        : Icons.cancel,
                    size: 18,
                    color: record.status == 'Present'
                        ? Colors.green
                        : Colors.red,
                  ),
                const SizedBox(height: 4),
                AutoSizeText(
                  record.status,
                  group: dateGroup, // Pisah group untuk status
                  minFontSize: 10,
                  maxFontSize: 16,
                  style: GoogleFonts.poppins(fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AttendanceHistoryScreen extends StatelessWidget {
  final bool withScaffold;
  const AttendanceHistoryScreen({super.key, this.withScaffold = false});

  @override
  Widget build(BuildContext context) {
    Widget content = buildTabAttendanceLog(context);

    return withScaffold == true ? attendanceScreenScaffold(context) : content;
  }
}

Widget attendanceScreenScaffold(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.amber.shade900,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Attendance History',
            style: GoogleFonts.pacifico(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 15,
            ),
          ),
          Text(
            DateFormat('MMMM dd, yyyy').format(DateTime.now()),
            style: TextStyle(
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
    body: buildTabAttendanceLog(context),
  );
}

Widget _buildSummaryItem(String label, String count) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        label,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
      SizedBox(height: 10),
      Text(
        count,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.blue,
          fontSize: 15,
        ),
      ),
    ],
  );
}

Widget attendanceScreenBody(BuildContext context) {
  final listAttendanceRecords = context
      .watch<AttendanceRecordProvider>()
      .attendanceRecords;

  return SingleChildScrollView(
    padding: const EdgeInsets.all(20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Month Dropdown
        MonthDropdown(),

        const SizedBox(height: 16),
        // Summary Card (Grid)
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final screenWidth = constraints.maxWidth;
                final crossAxisCount = 3;
                final spacing = 8 * (crossAxisCount - 1);
                final itemWidth = (screenWidth - spacing) / crossAxisCount;
                final itemHeight = 60.0;
                final childAspectRatio = itemWidth / itemHeight;

                return GridView.count(
                  crossAxisCount: crossAxisCount,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: childAspectRatio,
                  children: [
                    _buildSummaryItem('Absent', '13'),
                    _buildSummaryItem('Late clock in', '13'),
                    _buildSummaryItem('Early clock in', '13'),
                    _buildSummaryItem('No clock in', '13'),
                    _buildSummaryItem('No clock out', '13'),
                  ],
                );
              },
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Attendance List Card
        Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Table Header
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 20,
                ),
                child: Row(
                  children: const [
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Date',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        'In Time',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Out Time',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Status',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              // const SizedBox(height: 40),
              Divider(thickness: 1),
              // List attendance
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: listAttendanceRecords.length,
                itemBuilder: (context, index) {
                  return AttendanceItem(record: listAttendanceRecords[index]);
                },
                separatorBuilder: (context, index) {
                  return const Divider(
                    thickness: 1,
                    color: Colors.grey,
                    height: 20, // jarak vertikal
                  );
                },
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget buildTabAttendanceLog(BuildContext context) {
  return DefaultTabController(
    length: 3,
    child: Column(
      children: [
        const TabBar(
          tabs: [
            Tab(text: 'Logs'),
            Tab(text: 'Attendance'),
            Tab(text: 'Shift'),
          ],
        ),
        Expanded(
          child: TabBarView(
            children: [
              attendanceScreenBody(context),
              buildTabAttendance(),
              buildTabShift(),
            ],
          ),
        ),
      ],
    ),
  );
}
