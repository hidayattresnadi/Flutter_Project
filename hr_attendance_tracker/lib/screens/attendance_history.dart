import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AttendanceRecord {
  final String date;
  final String checkIn;
  final String checkOut;
  final String status;

  AttendanceRecord({
    required this.date,
    required this.checkIn,
    required this.checkOut,
    required this.status,
  });
}

final List<AttendanceRecord> dummyRecords = [
  AttendanceRecord(
    date: 'Aug 1, 2022',
    checkIn: '08:00',
    checkOut: '17:00',
    status: 'Present',
  ),
  AttendanceRecord(
    date: 'Aug 2, 2022',
    checkIn: '08:05',
    checkOut: '17:10',
    status: 'Present',
  ),
  AttendanceRecord(
    date: 'Aug 3, 2022',
    checkIn: '08:15',
    checkOut: '16:50',
    status: 'Present',
  ),
  AttendanceRecord(
    date: 'Aug 4, 2022',
    checkIn: '-',
    checkOut: '-',
    status: 'Absent',
  ),
  AttendanceRecord(
    date: 'Aug 5, 2022',
    checkIn: '08:10',
    checkOut: '17:00',
    status: 'Present',
  ),
  AttendanceRecord(
    date: 'Aug 6, 2022',
    checkIn: '08:20',
    checkOut: '17:30',
    status: 'Present',
  ),
  AttendanceRecord(
    date: 'Aug 7, 2022',
    checkIn: '-',
    checkOut: '-',
    status: 'Absent',
  ),
];

class AttendanceItem extends StatelessWidget {
  final AttendanceRecord record;
  const AttendanceItem({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(height: 24, thickness: 2),
        ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 8),
          title: Row(
            children: [
              // Date and Day
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      record.date,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text("Monday", style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
              // Check-in
              Expanded(
                flex: 2,
                child: Text(record.checkIn, textAlign: TextAlign.center),
              ),
              // Check-out
              Expanded(
                flex: 2,
                child: Text(record.checkOut, textAlign: TextAlign.center),
              ),
              // Status (Icon + Text)
              Expanded(
                flex: 2,
                child: Column(
                  children: [
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
                    Text(record.status, style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AttendanceHistoryScreen extends StatelessWidget {
  final bool withScaffold;
  const AttendanceHistoryScreen({super.key, this.withScaffold = false});

  @override
  Widget build(BuildContext context) {
    Widget content = attendanceScreenBody();

    return withScaffold == true ? attendanceScreenScaffold() : content;
  }
}

Widget attendanceScreenScaffold() {
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
    body: attendanceScreenBody(),
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

Widget attendanceScreenBody() {
  return SingleChildScrollView(
    padding: const EdgeInsets.all(20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
            children: [
              // Table Header
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 8, right: 8),
                child: Row(
                  children: const [
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Date',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'In Time',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Out Time',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Status',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),
              // List attendance
              ListView.builder(
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(), // Biar scroll-nya dari luar
                itemCount: dummyRecords.length,
                itemBuilder: (context, index) {
                  return AttendanceItem(record: dummyRecords[index]);
                },
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
