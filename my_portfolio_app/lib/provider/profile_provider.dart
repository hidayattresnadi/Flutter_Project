import 'package:flutter/material.dart';
import 'package:my_portfolio_app/models/profile_model.dart';
import 'package:my_portfolio_app/services/profile_service.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileService _profileService = ProfileService();

  Profile? _profile;
  Profile? _editUser;
  List<Profile> _profiles = [];
  String? _errorMessage;
  bool _isLoading = false;

  Profile? get profile => _profile;
  Profile? get editUser => _editUser;
  List<Profile> get profiles => _profiles;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  final formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController professionController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController photoController = TextEditingController();

  // load profile from Firestore
  Future<void> loadProfile(String uid) async {
    _setLoading(true);
    try {
      // if (_profile?.uid != uid) {
      //   _editUser = await _profileService.getUserProfile(uid);
      //   if (_editUser != null) {
      //     assignDataProfile(_editUser);
      //   }
      // } else {
      _profile = await _profileService.getUserProfile(uid);
      if (_profile != null) {
        assignDataProfile(_profile);
      }

      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // load profile from Firestore
  Future<void> loadProfileEditedUser(String uid) async {
    _setLoading(true);
    try {
      _editUser = await _profileService.getUserProfile(uid);
      if (_editUser != null) {
        assignDataProfile(_editUser);
      }

      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  void assignDataProfile(Profile? profileData) {
    nameController.text = profileData!.name;
    professionController.text = profileData.profession ?? '';
    phoneController.text = profileData.phone ?? '';
    addressController.text = profileData.address ?? '';
    bioController.text = profileData.bio ?? '';
    photoController.text = profileData.photo ?? '';
  }

  // get all data from API
  Future<void> fetchUsers() async {
    _errorMessage = null;
    _isLoading = true;
    _profiles = [];

    await Future.delayed(const Duration(seconds: 2));
    // notifyListeners();

    try {
      _profiles = await _profileService.getUserProfiles();
    } catch (e) {
      _errorMessage = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  // update profile ke Firestore
  Future<bool> updateProfile() async {
    if (_profile == null) return false;
    // if (!formKey.currentState!.validate()) return;

    _setLoading(true);
    try {
      final updated = Profile(
        uid: _profile!.uid,
        email: _profile!.email,
        name: nameController.text,
        profession: professionController.text,
        phone: phoneController.text,
        address: addressController.text,
        bio: bioController.text,
        photo: photoController.text,
        role: _profile!.role,
      );

      await _profileService.updateUserProfile(updated);
      _profile = updated;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // update profile ke Firestore
  Future<bool> updateProfileOtherUser() async {
    if (_editUser == null) return false;
    // if (!formKey.currentState!.validate()) return;

    _setLoading(true);
    try {
      final updated = Profile(
        uid: _editUser!.uid,
        email: _editUser!.email,
        name: nameController.text,
        profession: professionController.text,
        phone: phoneController.text,
        address: addressController.text,
        bio: bioController.text,
        photo: photoController.text,
        role: _editUser!.role,
      );

      await _profileService.updateUserProfile(updated);
      _editUser = updated;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // delete profile ke Firestore
  Future<bool> deleteUser(String uid) async {
    _setLoading(true);
    try {
      await _profileService.deleteUserProfile(uid);
      // hapus juga dari list lokal biar UI langsung update
      _profiles.removeWhere((profile) => profile.uid == uid);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void clearProfile() {
    _profile = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  @override
  void dispose() {
    nameController.dispose();
    professionController.dispose();
    phoneController.dispose();
    addressController.dispose();
    bioController.dispose();
    photoController.dispose();
    super.dispose();
  }
}
