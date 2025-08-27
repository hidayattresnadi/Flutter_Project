import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_portfolio_app/provider/profile_provider.dart';
import 'package:my_portfolio_app/widgets/form_text_field.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => FormScreenState();
}

class FormScreenState extends State<EditProfileScreen> {
  @override
  void initState() {
    super.initState();

    final profileFormProvider = Provider.of<ProfileProvider>(
      context,
      listen: false,
    );
    profileFormProvider.initForm();
  }

  @override
  Widget build(BuildContext context) {
    final profileFormProvider = Provider.of<ProfileProvider>(context);
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
                    controller: profileFormProvider.namecontroller,
                    label: 'Edit name',
                  ),
                  buildFormTextField(
                    controller: profileFormProvider.professionController,
                    label: 'Edit profession',
                  ),
                  buildFormTextField(
                    controller: profileFormProvider.emailController,
                    label: 'Edit email',
                  ),
                  buildFormTextField(
                    controller: profileFormProvider.phoneController,
                    label: 'Edit phone',
                  ),
                  buildFormTextField(
                    controller: profileFormProvider.addressController,
                    label: 'Edit address',
                  ),
                  buildFormTextField(
                    controller: profileFormProvider.bioController,
                    label: 'Edit bio',
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ProfileProvider>().updateProfile();
                      // context.read<ProfileProvider>().dispose();
                      Fluttertoast.showToast(
                        msg: 'data is update',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                      );
                      Navigator.pop(context);
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
