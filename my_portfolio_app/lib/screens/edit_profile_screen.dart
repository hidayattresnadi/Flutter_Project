import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_portfolio_app/provider/profile_provider.dart';
import 'package:my_portfolio_app/widgets/form_text_field.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatelessWidget {
  final String name;
  final String profession;
  final String email;
  final String phone;
  final String address;
  final String bio;

  const EditProfileScreen({
    super.key,
    required this.name,
    required this.profession,
    required this.email,
    required this.phone,
    required this.address,
    required this.bio,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController namecontroller = TextEditingController(
      text: name,
    );
    final TextEditingController professionController = TextEditingController(
      text: profession,
    );
    final TextEditingController emailController = TextEditingController(
      text: email,
    );
    final TextEditingController phoneController = TextEditingController(
      text: phone,
    );
    final TextEditingController addressController = TextEditingController(
      text: address,
    );
    final TextEditingController bioController = TextEditingController(
      text: bio,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width > 1000
                  ? 700
                  : 500, // biar di layar besar formnya gak terlalu melebar
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Wrap(
                runSpacing:
                    MediaQuery.of(context).size.height *
                    0.04, // 4% tinggi layar
                children: [
                  buildFormTextField(
                    controller: namecontroller,
                    label: 'Edit name',
                  ),
                  buildFormTextField(
                    controller: professionController,
                    label: 'Edit profession',
                  ),
                  buildFormTextField(
                    controller: emailController,
                    label: 'Edit email',
                  ),
                  buildFormTextField(
                    controller: phoneController,
                    label: 'Edit phone',
                  ),
                  buildFormTextField(
                    controller: addressController,
                    label: 'Edit address',
                  ),
                  buildFormTextField(
                    controller: bioController,
                    label: 'Edit bio',
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final newName = namecontroller.text;
                      final newProfession = professionController.text;
                      final newEmail = emailController.text;
                      final newPhone = phoneController.text;
                      final newAddress = addressController.text;
                      final newBio = bioController.text;

                      if (newName.isNotEmpty) {
                        context.read<ProfileProvider>().updateProfile(
                          newName,
                          newProfession,
                          newEmail,
                          newPhone,
                          newAddress,
                          newBio,
                        );
                        Fluttertoast.showToast(
                          msg: 'data is update',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                        );
                        Navigator.pop(context);
                      }
                    },
                    child: Text('Save'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
