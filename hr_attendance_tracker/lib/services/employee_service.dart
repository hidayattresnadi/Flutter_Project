import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/employee_model.dart';

class EmployeeService {
  final CollectionReference employees = FirebaseFirestore.instance.collection(
    'Employees',
  );

  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> createEmployee(Employee employee) async {
    try {
      await employees.doc(employee.employeeId).set(employee.toMap());
    } catch (e) {
      print(e);
    }
  }

  Future<Employee?> getEmployee(String uid) async {
    final doc = await employees.doc(uid).get();
    if (doc.exists) {
      return Employee.fromMap(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<List<Employee>> getEmployees() async {
    try {
      QuerySnapshot snapshot = await employees.get();

      return snapshot.docs.map((doc) {
        return Employee.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print('Error fetching employees: $e');
      throw Exception("Failed to load projects");
    }
  }

  Future<void> updateEmployee(Employee employee) async {
    await employees.doc(employee.employeeId).update(employee.toMap());
  }

  Future<void> deleteEmployee(String uid) async {
    try {
      await employees.doc(uid).delete();
    } catch (e) {
      print("Error deleting user: $e");
      rethrow;
    }
  }

  Future<bool> checkUserExists(String uid) async {
    final doc = await employees.doc(uid).get();
    return doc.exists;
  }

  /// Upload foto ke Supabase Storage dan simpan URL ke Firestore
  Future<String> uploadProfilePhoto(String uid, File file) async {
    final fileName = "$uid.jpg";

    // Upload ke Supabase Storage
    await _supabase.storage
        .from('profile-photos')
        .upload(fileName, file, fileOptions: const FileOptions(upsert: true));

    // Ambil URL public
    final url = _supabase.storage.from('profile-photos').getPublicUrl(fileName);

    // Update Firestore dengan URL foto
    await employees.doc(uid).update({'photoUrl': url});

    return url;
  }
}
