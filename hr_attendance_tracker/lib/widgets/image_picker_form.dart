import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImagePickerExample extends StatefulWidget {
  final void Function(String?) onImageSelected;
  final String? initialImage;
  const ImagePickerExample({
    super.key,
    required this.onImageSelected,
    this.initialImage,
  });

  @override
  _ImagePickerExampleState createState() => _ImagePickerExampleState();
}

class _ImagePickerExampleState extends State<ImagePickerExample> {
  File? _image;
  final picker = ImagePicker();

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

      widget.onImageSelected(pickedFile.path);
    } else {
      setState(() {
        _image = null;
      });
      widget.onImageSelected(widget.initialImage);
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
          width: 200,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey[100],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Builder(
              builder: (_) {
                if (_image != null) {
                  // pilih dari gallery
                  return Image.file(
                    _image!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  );
                }

                if (widget.initialImage != null) {
                  // kalau ada data lama
                  if (widget.initialImage!.startsWith('assets/')) {
                    return Image.asset(
                      widget.initialImage!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    );
                  } else {
                    return Image.file(
                      File(widget.initialImage!),
                      fit: BoxFit.cover,
                      width: double.infinity,
                    );
                  }
                }

                // fallback default asset
                return Image.asset(
                  'assets/images/profile.jpg',
                  fit: BoxFit.cover,
                  width: double.infinity,
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 10),

        // Pick button
        Align(
          alignment: Alignment.bottomLeft,
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
        // if (_error != null)
        //   Padding(
        //     padding: const EdgeInsets.only(top: 8),
        //     child: Text(_error!, style: const TextStyle(color: Colors.red)),
        //   ),
      ],
    );
  }
}
