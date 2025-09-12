import 'package:flutter/material.dart';
import 'package:hr_attendance_tracker/providers/app_auth_provider.dart';
import 'package:hr_attendance_tracker/providers/employee_provider.dart';
import 'package:hr_attendance_tracker/routes.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AppAuthProvider>(context);
    final employeeProvider = Provider.of<EmployeeProvider>(
      context,
      listen: false,
    );

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/uag_logo.png", height: 100),
              const SizedBox(height: 20),

              // EMAIL INPUT
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email),
                  hintText: "Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 15,
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // PASSWORD INPUT
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock),
                  hintText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 15,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // LOGIN BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[800],
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () async {
                    final email = _emailController.text.trim();
                    final password = _passwordController.text.trim();
                    final success = await authProvider.signInWithEmail(
                      email,
                      password,
                      employeeProvider,
                    );

                    if (success && employeeProvider.employee != null) {
                      if (employeeProvider.employee!.role == "admin") {
                        Navigator.pushReplacementNamed(
                          context,
                          AppRoutes.admindashboard,
                        );
                      } else {
                        Navigator.pushReplacementNamed(context, AppRoutes.home);
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            authProvider.errorMessage ?? "Login failed",
                          ),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    "Sign in with Email",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
