class Employee {
  final String employeeId;
  final String fullName;
  final String? position;
  String? department;
  final String email;
  final String? phone;
  final String? location;
  final String? bio;
  String? profilePhoto;
  final String role;

  Employee({
    required this.employeeId,
    required this.fullName,
    this.position,
    this.department,
    required this.email,
    this.phone,
    this.location,
    this.bio,
    this.profilePhoto,
    required this.role,
  });

  factory Employee.fromMap(Map<String, dynamic> map) {
    return Employee(
      employeeId: map['employeeId'],
      fullName: map['name'],
      position: map['position'],
      department: map['department'],
      email: map['email'],
      phone: map['phone'],
      location: map['location'],
      bio: map['bio'],
      profilePhoto: map['photoUrl'],
      role: map['role'] ?? 'member',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'employeeId': employeeId,
      'name': fullName,
      'position': position,
      'department': department,
      'email': email,
      'phone': phone,
      'location': location,
      'bio': bio,
      'photoUrl': profilePhoto,
      'role': role,
      'createdAt': DateTime.now(),
    };
  }

  Employee copyWith({
    String? fullName,
    String? email,
    String? role,
    String? phone,
    String? location,
    String? bio,
    String? profilePhoto,
    String? position,
    String? department,
  }) {
    return Employee(
      employeeId: employeeId,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      bio: bio ?? this.bio,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      position: position ?? this.position,
      department: department ?? this.department,
    );
  }
}
