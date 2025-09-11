import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_portfolio_app/provider/profile_provider.dart';
import 'package:my_portfolio_app/widgets/form_text_field.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  final String? uid;
  const EditProfileScreen({super.key, this.uid});

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

    if (widget.uid != null) {
      profileFormProvider.loadProfileEditedUser(widget.uid!);
    } else {
      final uid = profileFormProvider.profile?.uid;
      if (uid != null) {
        profileFormProvider.loadProfile(uid);
      }
    }
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
                  Center(
                    child: Text(
                      'Edit Profile',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  buildFormTextField(
                    controller: profileFormProvider.nameController,
                    label: 'Edit name',
                  ),
                  buildFormTextField(
                    controller: profileFormProvider.professionController,
                    label: 'Edit profession',
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
                  buildFormTextField(
                    controller: profileFormProvider.photoController,
                    label: 'Edit photo url',
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        bool success;
                        if (widget.uid != null) {
                          success = await context
                              .read<ProfileProvider>()
                              .updateProfileOtherUser();
                        } else {
                          success = await context
                              .read<ProfileProvider>()
                              .updateProfile();
                        }

                        if (success) {
                          Fluttertoast.showToast(
                            msg: 'data is update',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                          );
                          if (context.mounted) {
                            Navigator.pop(context);
                          } else {
                            if (context.mounted) {
                              final errorMessage = context
                                  .read<ProfileProvider>()
                                  .errorMessage;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('$errorMessage')),
                              );
                            }
                          }
                        }
                      },
                      child: Text('Save'),
                    ),
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
