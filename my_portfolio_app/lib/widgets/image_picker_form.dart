import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImagePickerExample extends StatefulWidget {
  final void Function(String?) onImageSelected;
  const ImagePickerExample({super.key, required this.onImageSelected});

  @override
  _ImagePickerExampleState createState() => _ImagePickerExampleState();
}

class _ImagePickerExampleState extends State<ImagePickerExample> {
  File? _image;
  final picker = ImagePicker();
  String? _error;

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _error = null;
      });

      widget.onImageSelected(pickedFile.path);
    } else {
      setState(() {
        _error = "No image selected";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Preview box
        Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey[100],
          ),
          child: _image != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    _image!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                )
              : Center(
                  child: Text(
                    "No image selected",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
        ),
        const SizedBox(height: 10),

        // Pick button
        Align(
          alignment: Alignment.bottomRight,
          child: ElevatedButton.icon(
            onPressed: pickImage,
            icon: const Icon(Icons.photo_library),
            label: const Text("Pick Image"),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        if (_error != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(_error!, style: const TextStyle(color: Colors.red)),
          ),
      ],
    );
  }
}
