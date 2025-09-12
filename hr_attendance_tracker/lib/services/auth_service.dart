import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hr_attendance_tracker/models/employee_model.dart';
import 'package:hr_attendance_tracker/services/employee_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final EmployeeService _employeeService = EmployeeService();

  // Sign in with Email & Password
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? "Login failed";
    }
  }

  // Register with Email & Password
  Future<User?> registerWithEmail(
    String email,
    String password,
    String fullName,
    String position,
    String department,
  ) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // buat employee default di Firestore
      final user = credential.user;
      if (user != null) {
        final employee = Employee(
          employeeId: user.uid,
          fullName: fullName,
          email: user.email!,
          role: "member",
          position: position,
          department: department,
        );
        await _employeeService.createEmployee(employee);
      }

      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? "Register failed";
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  // Get current user
  User? get currentUser => _auth.currentUser;
}
