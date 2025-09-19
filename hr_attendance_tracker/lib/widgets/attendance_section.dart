import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';

class AttendanceSection extends StatelessWidget {
  final String title;
  final String? photoUrl;
  final String time;
  final String status;
  final String type;
  final double? latitude;
  final double? longitude;
  final String? address;

  const AttendanceSection({
    super.key,
    required this.title,
    required this.photoUrl,
    required this.time,
    required this.status,
    required this.type,
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // TITLE
        Text(
          title,
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 25),

        Text(
          'Attendance Photo',
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 15),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            photoUrl != null && photoUrl!.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      photoUrl!,
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  )
                : const Icon(Icons.image_not_supported, size: 50),

            const SizedBox(width: 30),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Time:",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(time, style: const TextStyle(fontSize: 18)),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Text(
                        "Status:",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(status, style: GoogleFonts.poppins(fontSize: 18)),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Text(
                        "Type:",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(type, style: GoogleFonts.poppins(fontSize: 18)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 25),

        if (latitude != null && longitude != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              height: 200,
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: LatLng(latitude!, longitude!),
                  initialZoom: 16,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                    userAgentPackageName: "com.example.hr_attendance_tracker",
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: LatLng(latitude!, longitude!),
                        width: 60,
                        height: 60,
                        child: const Icon(
                          Icons.location_pin,
                          color: Colors.red,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

        const SizedBox(height: 20),

        address != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Location:",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(address!, style: GoogleFonts.poppins(fontSize: 14)),
                ],
              )
            : const Center(child: CircularProgressIndicator()),
      ],
    );
  }
}
