import 'package:flutter/material.dart';

class MonthDropdown extends StatelessWidget {
  final selectedMonth = "August 2025";
  final months = [
    "January 2025",
    "February 2025",
    "March 2025",
    "April 2025",
    "May 2025",
    "June 2025",
    "July 2025",
    "August 2025",
    "September 2025",
    "October 2025",
    "November 2025",
    "December 2025",
  ];

  MonthDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: DropdownButtonFormField<String>(
        value: selectedMonth,
        menuMaxHeight: 100,
        isExpanded: true,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade800),
          ),
        ),
        items: months.map((month) {
          return DropdownMenuItem(value: month, child: Text(month));
        }).toList(),
        onChanged: (value) {},
        selectedItemBuilder: (context) {
          return months.map((month) {
            return Row(
              children: [
                Icon(
                  Icons.calendar_month_outlined,
                  size: 18,
                  color: Colors.black,
                ),
                SizedBox(width: 8),
                Text(month),
              ],
            );
          }).toList();
        },
      ),
    );
  }
}
