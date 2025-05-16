class User {
  final String id;
  final String phoneNumber;
  final String name;
  final String province;
  final String role;
  final int points; // novo campo

  User({
    required this.id,
    required this.phoneNumber,
    required this.name,
    required this.province,
    this.role = 'user',
    this.points = 0,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'phoneNumber': phoneNumber,
        'name': name,
        'province': province,
        'role': role,
        'points': points,
      };

  factory User.fromMap(Map<String, dynamic> m) => User(
        id: m['id'],
        phoneNumber: m['phoneNumber'],
        name: m['name'],
        province: m['province'],
        role: m['role'] ?? 'user',
        points: m['points'] ?? 0,
      );
}