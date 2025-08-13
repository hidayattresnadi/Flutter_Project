import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AttendanceRecord {
  final String date;
  final String day;
  final String checkIn;
  final String checkOut;
  final String status;

  AttendanceRecord({
    required this.date,
    required this.day,
    required this.checkIn,
    required this.checkOut,
    required this.status,
  });
}

final List<AttendanceRecord> dummyRecords = [
  // AttendanceRecord(
  //   date: 'date',
  //   day: '',
  //   checkIn: 'check in',
  //   checkOut: 'check out',
  //   status: 'status',
  // ),
  AttendanceRecord(
    date: 'Aug 1, 2022',
    day: 'Monday',
    checkIn: '08:00',
    checkOut: '17:00',
    status: 'Present',
  ),
  AttendanceRecord(
    date: 'Aug 2, 2022',
    day: 'Monday',
    checkIn: '08:05',
    checkOut: '17:10',
    status: 'Present',
  ),
  AttendanceRecord(
    date: 'Aug 3, 2022',
    day: 'Monday',
    checkIn: '08:15',
    checkOut: '16:50',
    status: 'Present',
  ),
  AttendanceRecord(
    date: 'Aug 4, 2022',
    day: 'Monday',
    checkIn: '-',
    checkOut: '-',
    status: 'Absent',
  ),
  AttendanceRecord(
    date: 'Aug 5, 2022',
    day: 'Monday',
    checkIn: '08:10',
    checkOut: '17:00',
    status: 'Present',
  ),
  AttendanceRecord(
    date: 'Aug 6, 2022',
    day: 'Monday',
    checkIn: '08:20',
    checkOut: '17:30',
    status: 'Present',
  ),
  AttendanceRecord(
    date: 'Aug 7, 2022',
    day: 'Monday',
    checkIn: '-',
    checkOut: '-',
    status: 'Absent',
  ),
];

class AttendanceItem extends StatelessWidget {
  final AttendanceRecord record;
  const AttendanceItem({super.key, required this.record});

  static const double dateWidth = 90;
  static const double smallColWidth = 80;
  static const double statusWidth = 90;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = screenWidth < 390 ? 12 : 14;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // DATE (column supaya bisa ada date + day)
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // di Row
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [
                Text(
                  record.date,
                  style: TextStyle(
                    fontSize: record.day.isNotEmpty ? 13 : 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (record.day.isNotEmpty) const SizedBox(height: 4),
                if (record.day.isNotEmpty)
                  Text(record.day, style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),

          // spacing antar kolom (opsional)
          const SizedBox(width: 8),

          // CHECK IN
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // di Row
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [
                Text(
                  record.checkIn,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: record.day.isNotEmpty
                        ? FontWeight.normal
                        : FontWeight.bold,
                  ),
                ),
                if (record.day.isNotEmpty) const SizedBox(height: 4),
                if (record.day.isNotEmpty)
                  Text('', style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // CHECK OUT
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // di Row
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [
                Text(
                  record.checkOut,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: record.day.isNotEmpty
                        ? FontWeight.normal
                        : FontWeight.bold,
                  ),
                ),
                if (record.day.isNotEmpty) const SizedBox(height: 4),
                if (record.day.isNotEmpty)
                  Text('', style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // STATUS (SELALU Column supaya struktur sama di header & row)
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (record.status !=
                    'status') // kalau bukan header, tampilkan icon
                  Icon(
                    record.status == 'Present'
                        ? Icons.check_circle
                        : Icons.cancel,
                    size: 18,
                    color: record.status == 'Present'
                        ? Colors.green
                        : Colors.red,
                  ),
                if (record.status != 'status') const SizedBox(height: 4),
                Text(
                  record.status,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: record.day.isNotEmpty
                        ? FontWeight.normal
                        : FontWeight.bold,
                  ),
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
                      flex: 1,
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
                itemCount: dummyRecords.length,
                itemBuilder: (context, index) {
                  return AttendanceItem(record: dummyRecords[index]);
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
