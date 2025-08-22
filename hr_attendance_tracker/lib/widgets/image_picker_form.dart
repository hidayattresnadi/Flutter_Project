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
    final double size = 120;
    return Center(
      child: Stack(
        children: [
          // Circular Avatar
          CircleAvatar(
            radius: size / 2,
            backgroundColor: Colors.grey[200],
            backgroundImage: _image != null
                ? FileImage(_image!)
                : widget.initialImage != null
                ? (widget.initialImage!.startsWith('assets/')
                      ? AssetImage(widget.initialImage!) as ImageProvider
                      : FileImage(File(widget.initialImage!)))
                : const AssetImage('assets/images/profile.jpg'),
          ),

          // Edit button (bottom right)
          Positioned(
            bottom: 0,
            right: 4,
            child: InkWell(
              onTap: pickImage,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(
                  Icons.camera_alt,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
