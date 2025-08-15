import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AttendanceCard extends StatelessWidget {
  final String dateText;
  final String? timeText;
  final String? loggedHours;
  final String? sinceText;
  final String workingHours;
  final String buttonText;
  final Color buttonColor;
  final VoidCallback onPressed;
  final bool showButton;
  final bool autoSizeDate;

  const AttendanceCard({
    super.key,
    required this.dateText,
    this.timeText,
    this.loggedHours,
    this.sinceText,
    required this.workingHours,
    required this.buttonText,
    required this.buttonColor,
    required this.onPressed,
    this.showButton = true,
    this.autoSizeDate = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            autoSizeDate
                ? AutoSizeText(
                    dateText,
                    minFontSize: 12,
                    maxFontSize: 20,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                  )
                : Text(
                    dateText,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
            if (timeText != null) ...[
              const SizedBox(height: 2),
              Text(
                timeText!,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
            if (loggedHours != null) ...[
              const SizedBox(height: 2),
              Text(
                'LOGGED HOURS',
                style: GoogleFonts.poppins(fontSize: 17, color: Colors.grey),
              ),
              const SizedBox(height: 10),
              Text(
                loggedHours!,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
            if (sinceText != null)
              Text(
                sinceText!,
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey),
              ),
            const SizedBox(height: 10),
            Text(
              'WORKING HOURS',
              style: GoogleFonts.poppins(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              workingHours,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (showButton) ...[
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  child: Text(
                    buttonText,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
