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

  void updateProfile(
    String name,
    String profession,
    String email,
    String phone,
    String address,
    String bio,
  ) {
    profile.name = name;
    profile.profession = profession;
    profile.email = email;
    profile.phone = phone;
    profile.address = address;
    profile.bio = bio;
    notifyListeners();
  }
}
