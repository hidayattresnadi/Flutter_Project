import 'package:flutter/material.dart';
import 'package:my_portfolio_app/models/profile_model.dart';

class ProfileProvider extends ChangeNotifier {
  final Profile profile = Profile(
    name: "Muhammad Hidayat Tresnadi",
    profession: "Mobile Developer",
    email: "john.doe@email.com",
    phone: "+62 812-3456-7890",
    address: "Jakarta, Indonesia",
    bio:
        "Passionate mobile developer with 3+ years experience in Flutter and React Native. Love creating beautiful and functional mobile applications.",
  );

  final TextEditingController namecontroller = TextEditingController();
  final TextEditingController professionController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  void initForm() {
    namecontroller.text = profile.name;
    professionController.text = profile.profession;
    emailController.text = profile.email;
    phoneController.text = profile.phone;
    addressController.text = profile.address;
    bioController.text = profile.bio;
  }

  @override
  void dispose() {
    namecontroller.dispose();
    professionController.dispose();
    addressController.dispose();
    emailController.dispose();
    phoneController.dispose();
    bioController.dispose();
    super.dispose();
  }

  void updateProfile() {
    profile.name = namecontroller.text;
    profile.profession = professionController.text;
    profile.email = emailController.text;
    profile.phone = phoneController.text;
    profile.address = addressController.text;
    profile.bio = bioController.text;
    notifyListeners();
  }
}
