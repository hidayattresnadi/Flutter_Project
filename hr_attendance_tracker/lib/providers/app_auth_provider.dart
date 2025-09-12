import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hr_attendance_tracker/providers/employee_provider.dart';
import 'package:hr_attendance_tracker/services/auth_service.dart';

class AppAuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  User? _user;
  String? _errorMessage;
  bool _isLoading = false;

  User? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  Future<bool> signInWithEmail(
    String email,
    String password,
    EmployeeProvider employeeProvider,
  ) async {
    _setLoading(true);
    try {
      _user = await _authService.signInWithEmail(email, password);
      if (user != null) {
        // load profile
        await employeeProvider.loadEmployee(_user!.uid);
        _user = user;
      }

      _errorMessage = null;
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

  Future<bool> registerWithEmail(
    String email,
    String password,
    String position,
    String department,
    String fullName,
    EmployeeProvider employeeProvider,
  ) async {
    _setLoading(true);
    try {
      _user = await _authService.registerWithEmail(
        email,
        password,
        fullName,
        position,
        department,
      );
      _errorMessage = null;
      // simpan ke provider jika bukan add user dari admin
      if (employeeProvider.employee!.role != "admin") {
        await employeeProvider.loadEmployee(_user!.uid);
      }

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

  Future<void> signOut() async {
    await _authService.signOut();
    _user = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
