import 'package:flutter/material.dart';
import 'package:hr_attendance_tracker/widgets/month_dropdown.dart';

Widget buildTabAttendance() {
  // Data dummy
  final List<Map<String, String>> items = [
    {
      'date': '13 Aug 2025',
      'clock_out_info': 'Clock out at 13 Aug 2025 06:00 PM',
      'is_approved': 'Approved',
    },
    {
      'date': '14 Aug 2025',
      'clock_out_info': 'Clock out at 14 Aug 2025 05:30 PM',
      'is_approved': 'Pending',
    },
    {
      'date': '15 Aug 2025',
      'clock_out_info': 'Clock out at 15 Aug 2025 07:00 PM',
      'is_approved': 'Rejected',
    },
  ];
  return SingleChildScrollView(
    padding: const EdgeInsets.all(20),
    child: Column(
      children: [
        // Padding(padding: EdgeInsets.all(20), child: MonthDropdown()),
        MonthDropdown(),
        const SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                items[index]['date']!,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(items[index]['clock_out_info']!),
                  SizedBox(height: 4),
                  Text(
                    items[index]['is_approved']!,
                    style: TextStyle(
                      color: items[index]['is_approved'] == 'Approved'
                          ? Colors.green
                          : items[index]['is_approved'] == 'Pending'
                          ? Colors.orange
                          : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              trailing: Icon(Icons.arrow_forward_ios),
            );
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
  );
}
