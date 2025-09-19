import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

class CameraWithMapScreen2 extends StatefulWidget {
  final List<CameraDescription> cameras;
  const CameraWithMapScreen2({super.key, required this.cameras});

  @override
  _CameraWithMapScreenState createState() => _CameraWithMapScreenState();
}

class _CameraWithMapScreenState extends State<CameraWithMapScreen2> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool _isPictureDone = false;
  XFile? _capturedImage;

  Position? _position;
  String? _address;

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
      if (!status.isGranted) return;

      await _initializeControllerFuture;
      final XFile file = await _controller.takePicture();
      setState(() {
        _capturedImage = file;
        _isPictureDone = true;
      });

      await _getLocation();
    } catch (e) {
      print("Error taking photo: $e");
    }
  }

  Future<void> _getLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) return;

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
      final response = await http.get(
        url,
        headers: {"User-Agent": "flutter_app"},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() => _address = data['display_name']);
      }
    } catch (e) {
      print("Error fetching address: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber.shade900,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                _isPictureDone ? "Preview & Location" : "Clock In",
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
                  // Preview foto
                  Expanded(
                    flex: 2,
                    child: Image.file(
                      File(_capturedImage!.path),
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),

                  // Map lokasi
                  Expanded(
                    flex: 2,
                    child: _position == null
                        ? const Center(child: CircularProgressIndicator())
                        : FlutterMap(
                            options: MapOptions(
                              initialCenter: LatLng(
                                _position!.latitude,
                                _position!.longitude,
                              ),
                              initialZoom: 16,
                            ),
                            children: [
                              TileLayer(
                                urlTemplate:
                                    "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                                userAgentPackageName:
                                    "com.example.hr_attendance_tracker",
                              ),
                              MarkerLayer(
                                markers: [
                                  Marker(
                                    point: LatLng(
                                      _position!.latitude,
                                      _position!.longitude,
                                    ),
                                    width: 80,
                                    height: 80,
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

                  // Alamat
                  if (_address != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "📍 $_address",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                  // Tombol aksi
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              _capturedImage = null;
                              _isPictureDone = false;
                              _position = null;
                              _address = null;
                            });
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text("Retake"),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            // TODO: kirim foto + lokasi ke server
                            print("Foto: ${_capturedImage!.path}");
                            print(
                              "Lat: ${_position?.latitude}, Lng: ${_position?.longitude}",
                            );
                            print("Alamat: $_address");
                          },
                          icon: const Icon(Icons.check),
                          label: const Text("Confirm"),
                        ),
                      ],
                    ),
                  ),
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
