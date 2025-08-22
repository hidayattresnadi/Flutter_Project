import 'package:hr_attendance_tracker/models/profile_model.dart';

class ProfileForm {
  String? fullName;
  String? position;
  String? department;
  String? email;
  String? phone;
  String? location;
  String? bio;
  String? profilePhoto;

  ProfileForm({
    this.fullName = '',
    this.position = '',
    this.department,
    this.email,
    this.phone,
    this.location,
    this.bio,
    this.profilePhoto,
  });

  Profile toProfile() {
    return Profile(
      fullName: fullName ?? 'Unknown',
      position: position ?? 'Unknown',
      department: department ?? 'Unknown',
      email: email ?? 'Unknown',
      phone: phone ?? 'Unknown',
      location: location ?? 'Unknown',
      bio: bio ?? 'Unknown',
      profilePhoto: profilePhoto ?? 'Unknown',
    );
  }
}
