import 'package:flutter/material.dart';
import 'package:hr_attendance_tracker/models/profile_form_model.dart';
import 'package:hr_attendance_tracker/models/profile_model.dart';

class ProfileFormProvider with ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  String? _imageError;
  String? get imageError => _imageError;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Controllers
  final fullNameController = TextEditingController();
  final positionController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final locationController = TextEditingController();
  final bioController = TextEditingController();

  List<String> previousPositionEntries = [];

  ProfileForm formData = ProfileForm();
  Profile profileData = Profile(
    fullName: 'Muhammad Hidayat Tresnadi',
    position: 'Junior Mobile Developer',
    department: 'IT',
    email: 'john.doe@email.com',
    phone: '+62 812-3456-7890',
    location: 'Jakarta, Indonesia',
    bio:
        'Passionate mobile developer with 3+ years experience in Flutter and React Native. Love creating beautiful and functional mobile applications.',
    profilePhoto: 'assets/images/profile.jpg',
  );

  void initForm() {
    fullNameController.text = profileData.fullName;
    positionController.text = profileData.position;
    emailController.text = profileData.email;
    phoneController.text = profileData.phone;
    locationController.text = profileData.location;
    bioController.text = profileData.bio;
    formData.department = profileData.department;
    formData.profilePhoto = profileData.profilePhoto;
    notifyListeners();
  }

  void savedEmployeePosition(String name) {
    if (!previousPositionEntries.contains(name)) {
      previousPositionEntries.add(name);
    }
  }

  void setDepartment(String? value) {
    formData.department = value;
    notifyListeners();
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setImageError(String? error) {
    _imageError = error;
    notifyListeners();
  }

  bool validateForm() {
    final isValid = formKey.currentState?.validate() ?? false;

    // if (formData.profilePhoto == null) {
    //   _imageError = "Please select an image";
    // } else {
    //   _imageError = null;
    // }
    notifyListeners(); // biar UI rebuild dan error muncul
    return isValid && formData.profilePhoto != null;
  }

  Future<void> saveForm() async {
    setLoading(true);
    await Future.delayed(const Duration(seconds: 2));

    formData.fullName = fullNameController.text;
    formData.position = positionController.text;
    formData.email = emailController.text;
    formData.phone = phoneController.text;
    formData.location = locationController.text;
    formData.bio = bioController.text;

    final profile = formData.toProfile();
    profileData = profile;
    setLoading(false);
  }

  void resetForm() {
    formData = ProfileForm();
    fullNameController.clear();
    positionController.clear();
    emailController.clear();
    phoneController.clear();
    locationController.clear();
    bioController.clear();
    _imageError = null;
    notifyListeners();
  }

  @override
  void dispose() {
    fullNameController.dispose();
    positionController.dispose();
    emailController.dispose();
    locationController.dispose();
    bioController.dispose();
    super.dispose();
  }
}
