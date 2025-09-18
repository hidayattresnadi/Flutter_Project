class Profile {
  final String uid; // Firebase Auth UID = document ID
  final String name;
  final String? profession;
  final String email;
  final String? phone;
  final String? address;
  final String? bio;
  final String? photo; // simpan path foto (String)
  final String role; // 'admin' atau 'member'
  final String? github;
  final String? linkedIn;

  Profile({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
    this.profession,
    this.phone,
    this.address,
    this.bio,
    this.photo,
    this.github,
    this.linkedIn,
  });
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'profession': profession,
      'email': email,
      'phone': phone,
      'address': address,
      'bio': bio,
      'photo': photo,
      'role': role,
      'createdAt': DateTime.now(),
      'github': github,
      'linkedIn': linkedIn,
    };
  }

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      uid: map['uid'],
      name: map['name'],
      profession: map['profession'],
      email: map['email'],
      phone: map['phone'],
      address: map['address'],
      bio: map['bio'],
      photo: map['photo'],
      role: map['role'] ?? 'member',
      github: map['github'],
      linkedIn: map['linkedIn'],
    );
  }
}
