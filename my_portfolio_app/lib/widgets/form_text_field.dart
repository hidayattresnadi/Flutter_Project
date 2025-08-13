import 'package:flutter/material.dart';

Widget buildFormTextField({
  required TextEditingController controller,
  required String label,
}) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(14.0)),
      ),
    ),
    maxLines: null, // biar tinggi menyesuaikan teks
    keyboardType: TextInputType.multiline,
  );
}
