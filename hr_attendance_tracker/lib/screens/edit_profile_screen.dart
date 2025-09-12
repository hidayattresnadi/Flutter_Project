import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hr_attendance_tracker/providers/employee_provider.dart';
import 'package:hr_attendance_tracker/widgets/image_picker_form.dart';
import 'package:hr_attendance_tracker/widgets/text_form_field.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

class UpdateProfileScreen extends StatefulWidget {
  final String? employeeId;
  const UpdateProfileScreen({super.key, this.employeeId});

  @override
  State<UpdateProfileScreen> createState() => FormScreenState();
}

class FormScreenState extends State<UpdateProfileScreen> {
  @override
  void initState() {
    super.initState();

    // Panggil initForm dari provider
    final employeeProvider = Provider.of<EmployeeProvider>(
      context,
      listen: false,
    );
    if (widget.employeeId != null) {
      employeeProvider.loadEmployeeEditedUser(widget.employeeId!);
    } else {
      final employeeId = employeeProvider.employee?.employeeId;
      if (employeeId != null) {
        employeeProvider.loadEmployee(employeeId);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final employeeProvider = Provider.of<EmployeeProvider>(context);
    final phoneFormatter = MaskTextInputFormatter(
      mask: '+62 ###-####-####',
      filter: {"#": RegExp(r'[0-9]')},
    );

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.amber.shade900,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Edit Profile',
              style: GoogleFonts.pacifico(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            Text(
              DateFormat('MMMM dd, yyyy').format(DateTime.now()),
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        centerTitle: false,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
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
                  key: employeeProvider.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Judul Form
                      Center(
                        child: Text(
                          "Profile Form",
                          style: Theme.of(context).textTheme.headlineLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF004966),
                              ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Image Picker
                      ImagePickerExample(
                        onImageSelected: (path) async {
                          if (widget.employeeId != null) {
                            employeeProvider.editEmployee?.profilePhoto = path;
                          } else {
                            employeeProvider.employee?.profilePhoto = path;
                          }
                        },
                        initialImage: widget.employeeId != null
                            ? employeeProvider.editEmployee?.profilePhoto
                            : employeeProvider.employee?.profilePhoto,
                      ),
                      const SizedBox(height: 50),
                      // Full Name
                      CustomTextFormField(
                        label: 'Full Name',
                        controller: employeeProvider.fullNameController,
                        keyboardType: TextInputType.multiline,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'full name cannot be empty';
                          }

                          if (value.length < 3) {
                            return 'minimal 3 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Position
                      Autocomplete<String>(
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          if (textEditingValue.text.isEmpty) {
                            return const Iterable<String>.empty();
                          }
                          return employeeProvider.previousPositionEntries.where(
                            (name) => name.toLowerCase().startsWith(
                              textEditingValue.text.toLowerCase(),
                            ),
                          );
                        },
                        onSelected: (String selection) {
                          employeeProvider.savedEmployeePosition(selection);
                        },
                        fieldViewBuilder:
                            (
                              BuildContext context,
                              TextEditingController textEditingController,
                              FocusNode focusNode,
                              VoidCallback onFieldSubmitted,
                            ) {
                              // sinkronisasi controller provider dengan field controller
                              textEditingController.text =
                                  employeeProvider.positionController.text;

                              return TextFormField(
                                controller: textEditingController,
                                focusNode: focusNode,
                                decoration: const InputDecoration(
                                  labelText: 'Position',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(14.0),
                                    ),
                                  ),
                                ),
                                onChanged: (value) {
                                  employeeProvider.positionController.text =
                                      value; // sync
                                },
                                onFieldSubmitted: (_) => onFieldSubmitted(),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter position';
                                  }
                                  return null;
                                },
                              );
                            },
                      ),
                      const SizedBox(height: 16),

                      // Department Dropdown
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Department',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(14.0),
                            ),
                          ),
                        ),
                        value: widget.employeeId != null
                            ? employeeProvider.editEmployee?.department
                            : employeeProvider.employee?.department,
                        items: ['IT', 'HR', 'Safety', 'Analayst']
                            .map(
                              (department) => DropdownMenuItem(
                                value: department,
                                child: Text(department),
                              ),
                            )
                            .toList(),
                        onChanged: employeeProvider.setDepartment,
                        validator: (value) =>
                            value == null ? 'Please select a department' : null,
                      ),
                      const SizedBox(height: 16),
                      // email
                      CustomTextFormField(
                        label: 'Email',
                        controller: employeeProvider.emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email cannot be empty';
                          }

                          if (!value.contains('@')) {
                            return 'Enter a valid email';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        inputFormatters: [phoneFormatter],
                        controller: employeeProvider.phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(14.0),
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Phone number cannot be empty';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // location
                      CustomTextFormField(
                        label: 'Location',
                        controller: employeeProvider.locationController,
                        keyboardType: TextInputType.multiline,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'location cannot be empty';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Bio
                      CustomTextFormField(
                        label: 'Bio',
                        controller: employeeProvider.bioController,
                        keyboardType: TextInputType.multiline,
                        // maxLines: 3,
                      ),

                      const SizedBox(height: 20),

                      // Submit
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey,
                            ),
                            onPressed: () async {
                              final shouldUpdate = await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Cancel'),
                                  content: const Text('Discard changes?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(ctx).pop(false),
                                      child: const Text('No'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () =>
                                          Navigator.of(ctx).pop(true),
                                      child: const Text('Yes'),
                                    ),
                                  ],
                                ),
                              );

                              if (!context.mounted) return;
                              if (shouldUpdate == true) {
                                // employeeProvider.resetForm();
                                Navigator.pop(context);
                              }
                            },
                            child: const Text('Cancel'),
                          ),
                          const SizedBox(width: 25),
                          ElevatedButton(
                            onPressed: () async {
                              if (employeeProvider.validateForm(
                                widget.employeeId,
                              )) {
                                widget.employeeId != null
                                    ? await employeeProvider
                                          .updateOtherEmployee()
                                    : await employeeProvider.updateEmployee();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Profile updated successfully!',
                                    ),
                                  ),
                                );
                                if (!employeeProvider.previousPositionEntries
                                    .contains(
                                      employeeProvider.positionController.text,
                                    )) {
                                  employeeProvider.savedEmployeePosition(
                                    employeeProvider.positionController.text,
                                  );
                                }
                                // employeeProvider.resetForm();
                                if (context.mounted) {
                                  Navigator.of(context).pop(false);
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Please fill all fields (and select a photo if required).",
                                    ),
                                  ),
                                );
                              }
                            },
                            child: employeeProvider.isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text('Submit'),
                          ),
                        ],
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
