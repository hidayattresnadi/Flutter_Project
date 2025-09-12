import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hr_attendance_tracker/models/employee_model.dart';
import 'package:hr_attendance_tracker/services/employee_service.dart';

class EmployeeProvider with ChangeNotifier {
  final EmployeeService _employeeService = EmployeeService();

  List<Employee> _employees = [];
  Employee? _employee;
  Employee? _editEmployee;
  String? _errorMessage;
  String? _imageError;
  String? _selectedDepartment;
  bool _isLoading = false;

  Employee? get employee => _employee;
  Employee? get editEmployee => _editEmployee;
  List<Employee> get employees => _employees;
  String? get errorMessage => _errorMessage;
  String? get imageError => _imageError;
  bool get isLoading => _isLoading;
  String? get selectedDepartment => _selectedDepartment;

  final formKey = GlobalKey<FormState>();

  // Controllers
  final fullNameController = TextEditingController();
  final positionController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final locationController = TextEditingController();
  final bioController = TextEditingController();

  List<String> previousPositionEntries = [];

  // load employee from Firestore
  Future<void> loadEmployee(String uid) async {
    _setLoading(true);
    try {
      _employee = await _employeeService.getEmployee(uid);
      if (_employee != null) {
        assignDataEmployee(_employee);
      }

      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // load employee edited data from Firestore
  Future<void> loadEmployeeEditedUser(String uid) async {
    _setLoading(true);
    try {
      _editEmployee = await _employeeService.getEmployee(uid);
      if (_editEmployee != null) {
        assignDataEmployee(_editEmployee);
      }

      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // get all data from API
  Future<void> fetchEmployees() async {
    _errorMessage = null;
    _isLoading = true;
    _employees = [];

    await Future.delayed(const Duration(seconds: 2));
    // notifyListeners();

    try {
      _employees = await _employeeService.getEmployees();
    } catch (e) {
      _errorMessage = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> updateEmployee() async {
    if (_employee == null) return false;
    if (!formKey.currentState!.validate()) return false;

    _setLoading(true);
    try {
      String? pathPhoto;

      if (_employee!.profilePhoto != null &&
          !_employee!.profilePhoto!.startsWith('http')) {
        // upload file lokal
        pathPhoto = await uploadProfilePhoto(
          File(_employee!.profilePhoto ?? ''),
          null,
        );
      } else {
        // pakai URL lama
        pathPhoto = _employee!.profilePhoto;
      }

      final updated = Employee(
        employeeId: _employee!.employeeId,
        email: _employee!.email,
        fullName: fullNameController.text,
        position: positionController.text,
        phone: phoneController.text,
        location: locationController.text,
        bio: bioController.text,
        department: _employee!.department,
        profilePhoto: pathPhoto,
        role: _employee!.role,
      );

      await _employeeService.updateEmployee(updated);
      _employee = updated;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateOtherEmployee() async {
    if (_editEmployee == null) return false;
    if (!formKey.currentState!.validate()) return false;

    _setLoading(true);
    String? pathPhoto;

    if (_editEmployee!.profilePhoto != null &&
        !_editEmployee!.profilePhoto!.startsWith('http')) {
      // upload file dari lokal
      pathPhoto = await uploadProfilePhoto(
        File(_editEmployee!.profilePhoto ?? ''),
        editEmployee!.employeeId,
      );
    } else {
      // pakai URL lama
      pathPhoto = _editEmployee!.profilePhoto;
    }
    try {
      final updated = Employee(
        employeeId: _editEmployee!.employeeId,
        email: _editEmployee!.email,
        fullName: fullNameController.text,
        position: positionController.text,
        phone: phoneController.text,
        location: locationController.text,
        bio: bioController.text,
        department: _editEmployee!.department,
        profilePhoto: pathPhoto,
        role: _editEmployee!.role,
      );

      await _employeeService.updateEmployee(updated);
      _editEmployee = updated;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> deleteEmployee(String uid) async {
    _setLoading(true);
    try {
      await _employeeService.deleteEmployee(uid);
      // hapus juga dari list lokal biar UI langsung update
      _employees.removeWhere((employee) => employee.employeeId == uid);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<String?> uploadProfilePhoto(File file, String? employeeId) async {
    if (_employee == null) return null;

    _isLoading = true;
    notifyListeners();

    try {
      final targetId = employeeId ?? _employee!.employeeId;
      final url = await _employeeService.uploadProfilePhoto(targetId, file);

      // kasih cacheBuster biar url fresh
      final freshUrl = "$url?v=${DateTime.now().millisecondsSinceEpoch}";

      if (employeeId == null) {
        final updatedProfile = _employee!.copyWith(profilePhoto: freshUrl);
        await _employeeService.updateEmployee(updatedProfile);
        _employee = updatedProfile;
        notifyListeners();
      } else {
        final updatedProfile = _editEmployee!.copyWith(profilePhoto: freshUrl);
        await _employeeService.updateEmployee(updatedProfile);
        _editEmployee = updatedProfile;
        notifyListeners();
      }

      return freshUrl;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearEmployee() {
    _employee = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void assignDataEmployee(Employee? employeeData) {
    fullNameController.text = employeeData!.fullName;
    positionController.text = employeeData.position ?? '';
    emailController.text = employeeData.email;
    phoneController.text = employeeData.phone ?? '';
    locationController.text = employeeData.location ?? '';
    bioController.text = employeeData.bio ?? '';
  }

  void savedEmployeePosition(String name) {
    if (!previousPositionEntries.contains(name)) {
      previousPositionEntries.add(name);
    }
  }

  // untuk edit employee department
  void setDepartment(String? value) {
    if (_employee != null && _editEmployee == null) {
      _employee!.department = value;
    } else if (_editEmployee != null) {
      _editEmployee!.department = value;
    }
    notifyListeners();
  }

  // untuk add employee department

  void setDepartmentNewEmployee(String? value) {
    _selectedDepartment = value;
    notifyListeners();
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setImageError(String? error) {
    _imageError = error;
    notifyListeners();
  }

  bool validateForm(String? employeeId) {
    final isValid = formKey.currentState?.validate() ?? false;

    bool hasPhoto;

    if (employeeId == null) {
      hasPhoto = _employee?.profilePhoto != null;
    } else {
      hasPhoto = _editEmployee?.profilePhoto != null;
    }

    notifyListeners(); // biar UI rebuild dan error muncul

    return isValid && hasPhoto;
  }

  // void resetForm() {
  //   formData = ProfileForm();
  //   fullNameController.clear();
  //   positionController.clear();
  //   emailController.clear();
  //   phoneController.clear();
  //   locationController.clear();
  //   bioController.clear();
  //   _imageError = null;
  // }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  @override
  void dispose() {
    fullNameController.dispose();
    positionController.dispose();
    emailController.dispose();
    locationController.dispose();
    bioController.dispose();
    super.dispose();
  }
}
