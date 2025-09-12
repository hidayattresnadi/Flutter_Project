import 'package:flutter/material.dart';
import 'package:hr_attendance_tracker/providers/app_auth_provider.dart';
import 'package:hr_attendance_tracker/providers/employee_provider.dart';
import 'package:hr_attendance_tracker/routes.dart';
import 'package:provider/provider.dart';

class RegisterUserScreen extends StatefulWidget {
  const RegisterUserScreen({super.key});

  @override
  State<RegisterUserScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _positionController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

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
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width > 1000 ? 700 : 500,
            ),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Judul Form
                      Center(
                        child: Text(
                          "Register Employee",
                          style: Theme.of(context).textTheme.headlineLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF004966),
                              ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Full Name
                      TextFormField(
                        controller: _fullNameController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.person),
                          hintText: "Full Name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? "Enter username" : null,
                      ),
                      const SizedBox(height: 15),

                      // Position
                      TextFormField(
                        controller: _positionController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.badge),
                          hintText: "Position",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? "Enter position" : null,
                      ),
                      const SizedBox(height: 15),

                      // Department Dropdown
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.apartment),
                          labelText: 'Department',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(14.0),
                            ),
                          ),
                        ),
                        value: employeeProvider.selectedDepartment,
                        items: ['IT', 'HR', 'Safety', 'Analayst']
                            .map(
                              (department) => DropdownMenuItem(
                                value: department,
                                child: Text(department),
                              ),
                            )
                            .toList(),
                        onChanged: employeeProvider.setDepartmentNewEmployee,
                        validator: (value) =>
                            value == null ? 'Please select a department' : null,
                      ),
                      const SizedBox(height: 15),

                      // Email
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.email),
                          hintText: "Email",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? "Enter email" : null,
                      ),
                      const SizedBox(height: 15),

                      // Password
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock),
                          hintText: "Password",
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        validator: (value) => value!.length < 6
                            ? "Password must be 6+ chars"
                            : null,
                      ),
                      const SizedBox(height: 20),

                      // Register Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade800,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: _isLoading
                              ? null
                              : () async {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() => _isLoading = true);
                                    try {
                                      final success = await authProvider
                                          .registerWithEmail(
                                            _emailController.text.trim(),
                                            _passwordController.text.trim(),
                                            _positionController.text.trim(),
                                            employeeProvider
                                                    .selectedDepartment ??
                                                '',
                                            _fullNameController.text,
                                            employeeProvider,
                                          );

                                      if (success &&
                                          employeeProvider.employee != null) {
                                        Navigator.pushReplacementNamed(
                                          context,
                                          AppRoutes.admindashboard,
                                        );
                                      }
                                    } catch (e) {
                                      print(e);
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text("Register failed: $e"),
                                        ),
                                      );
                                    } finally {
                                      setState(() => _isLoading = false);
                                    }
                                  }
                                },
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  "Register",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
