import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_portfolio_app/provider/profile_provider.dart';
import 'package:my_portfolio_app/services/auth_service.dart';

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
    ProfileProvider profileProvider,
  ) async {
    _setLoading(true);
    try {
      _user = await _authService.signInWithEmail(email, password);
      if (user != null) {
        // load profile
        await profileProvider.loadProfile(_user!.uid);
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
    ProfileProvider profileProvider,
  ) async {
    _setLoading(true);
    try {
      _user = await _authService.registerWithEmail(email, password);
      _errorMessage = null;
      // simpan ke provider jika bukan add user dari admin
      if (profileProvider.profile!.role != "admin") {
        await profileProvider.loadProfile(_user!.uid);
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

  Future<bool> signInWithGoogle(ProfileProvider profileProvider) async {
    _setLoading(true);
    try {
      _user = await _authService.signInWithGoogle();
      _errorMessage = null;
      await profileProvider.loadProfile(_user!.uid);
      notifyListeners();
      return _user != null;
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
