import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hr_attendance_tracker/providers/attendance_record_provider.dart';
import 'package:hr_attendance_tracker/providers/employee_provider.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class CameraWithMapScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  final bool? isClockOut;
  const CameraWithMapScreen({
    super.key,
    required this.cameras,
    this.isClockOut,
  });

  @override
  _CameraWithMapScreenState createState() => _CameraWithMapScreenState();
}

class _CameraWithMapScreenState extends State<CameraWithMapScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool _isPictureDone = false;
  XFile? _capturedImage;
  String time24 = DateFormat('HH:mm').format(DateTime.now());

  Position? _position;
  String? _address;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.cameras[0], ResolutionPreset.high);
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _takePhoto() async {
    try {
      var status = await Permission.camera.request();

      if (status.isGranted) {
        try {
          await _initializeControllerFuture;
          // stop dulu biar buffer gak bentrok
          await _controller.pausePreview();

          final XFile file = await _controller.takePicture();

          setState(() {
            _capturedImage = file;
            _isPictureDone = true;
          });

          await _getLocation();
        } catch (e) {
          print("Error taking photo: $e");
        }
      } else if (status.isDenied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Camera permission denied ❌",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      } else if (status.isPermanentlyDenied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Camera permanently denied. Open settings",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
        await openAppSettings();
      }
    } catch (e) {
      print("Error taking photo: $e");
    } finally {
      // kalau kamu mau preview lanjut lagi setelah retake
      if (mounted && !_isPictureDone) {
        await _controller.resumePreview();
      }
    }
  }

  Future<void> _getLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "❌ Location service is disabled",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Location denied.",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Location permanently denied. Open settings",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
      await openAppSettings();
    }

    Position pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() => _position = pos);
    await _getAddressFromLatLng(pos.latitude, pos.longitude);
  }

  Future<void> _getAddressFromLatLng(double lat, double lon) async {
    final url = Uri.parse(
      "https://nominatim.openstreetmap.org/reverse?lat=$lat&lon=$lon&format=json",
    );
    try {
      setState(() => _isLoading = true);
      final response = await http.get(
        url,
        headers: {"User-Agent": "flutter_app"},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() => _address = data['display_name']);
      }
      setState(() => _isLoading = false);
    } catch (e) {
      print("Error fetching address: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final attendanceRecordProvider = context.watch<AttendanceRecordProvider>();
    final employeeProvider = context.watch<EmployeeProvider>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber.shade900,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                widget.isClockOut == true ? "Clock Out" : "Clock In",
                style: GoogleFonts.pacifico(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 20,
                ),
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
      ),
      body: _isPictureDone
          ? SafeArea(
              child: Column(
                children: [
                  // Foto full height
                  Expanded(
                    child: Image.file(
                      File(_capturedImage!.path),
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),

                  // Alamat (hasil reverse geocode)
                  if (_isLoading) ...[
                    const SizedBox(height: 20),
                    const CircularProgressIndicator(),
                  ] else if (_address != null) ...[
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Colors.red,
                            size: 40,
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Text(
                              _address ?? "",
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              // overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.access_time,
                            color: Colors.green,
                            size: 40,
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Text(
                              time24,
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              // overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Tombol aksi
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () async {
                              setState(() {
                                _capturedImage = null;
                                _isPictureDone = false;
                                _position = null;
                                _address = null;
                              });
                              await _controller.resumePreview();
                            },
                            icon: const Icon(Icons.refresh),
                            label: const Text("Retake"),
                          ),
                          ElevatedButton.icon(
                            onPressed: () async {
                              if (widget.isClockOut == false) {
                                bool success = await attendanceRecordProvider
                                    .addAttendance(
                                      employeeProvider.employee?.employeeId ??
                                          '',
                                      File(_capturedImage!.path),
                                      _position?.latitude ?? 0.0,
                                      _position?.longitude ?? 0.0,
                                    );

                                if (success) {
                                  Fluttertoast.showToast(
                                    msg: 'success clock in',
                                    backgroundColor: Colors.green,
                                    textColor: Colors.white,
                                  );
                                  if (context.mounted) {
                                    Navigator.pop(context);
                                  }
                                } else {
                                  if (context.mounted) {
                                    final errorMessage = context
                                        .read<AttendanceRecordProvider>()
                                        .errorMessage;
                                    Fluttertoast.showToast(
                                      msg: '$errorMessage',
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                    );
                                  }
                                }
                              } else if (widget.isClockOut == true) {
                                bool success = await attendanceRecordProvider
                                    .updateAttandance(
                                      employeeProvider.employee?.employeeId ??
                                          '',
                                      File(_capturedImage!.path),
                                      _position?.latitude ?? 0.0,
                                      _position?.longitude ?? 0.0,
                                    );

                                if (success) {
                                  Fluttertoast.showToast(
                                    msg: 'success clock out',
                                    backgroundColor: Colors.green,
                                    textColor: Colors.white,
                                  );
                                  if (context.mounted) {
                                    Navigator.pop(context);
                                  }
                                } else {
                                  if (context.mounted) {
                                    final errorMessage = context
                                        .read<AttendanceRecordProvider>()
                                        .errorMessage;
                                    Fluttertoast.showToast(
                                      msg: '$errorMessage',
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                    );
                                  }
                                }
                              }

                              // print("Foto: ${_capturedImage!.path}");
                              // print(
                              //   "Lat: ${_position?.latitude}, Lng: ${_position?.longitude}",
                              // );
                              // print("Alamat: $_address");
                            },
                            icon: const Icon(Icons.check),
                            label: const Text("Confirm"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            )
          : SafeArea(
              child: Stack(
                children: [
                  FutureBuilder<void>(
                    future: _initializeControllerFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return SizedBox.expand(
                          child: CameraPreview(_controller),
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton.icon(
                        onPressed: _takePhoto,
                        icon: const Icon(Icons.camera_alt),
                        label: const Text("Take Photo"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
