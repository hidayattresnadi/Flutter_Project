import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/profile_model.dart';

class ProfileService {
  final CollectionReference profiles = FirebaseFirestore.instance.collection(
    'users',
  );

  Future<void> createUserProfile(Profile profile) async {
    try {
      await profiles.doc(profile.uid).set(profile.toMap());
    } catch (e) {
      print(e);
    }
  }

  Future<Profile?> getUserProfile(String uid) async {
    final doc = await profiles.doc(uid).get();
    if (doc.exists) {
      return Profile.fromMap(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<List<Profile>> getUserProfiles() async {
    try {
      QuerySnapshot snapshot = await profiles.get();

      return snapshot.docs.map((doc) {
        return Profile.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print('Error fetching profiles: $e');
      throw Exception("Failed to load projects");
    }
  }

  Future<void> updateUserProfile(Profile profile) async {
    await profiles.doc(profile.uid).update(profile.toMap());
  }

  Future<void> deleteUserProfile(String uid) async {
    try {
      await profiles.doc(uid).delete();
    } catch (e) {
      print("Error deleting user: $e");
      rethrow;
    }
  }

  Future<bool> checkUserExists(String uid) async {
    final doc = await profiles.doc(uid).get();
    return doc.exists;
  }
}
