import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class UserModel {
  final String id;
  final String phoneNumber;
  final String name;
  final String province;
  final String role;
  final int points;

  /// Construtor principal
  const UserModel({
    required this.id,
    required this.phoneNumber,
    required this.name,
    required this.province,
    this.role = 'user',
    this.points = 0,
  });

  /// Construtor para criação a partir de um Map (Firestore)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      phoneNumber: map['phoneNumber'] as String,
      name: map['name'] as String,
      province: map['province'] as String,
      role: map['role'] as String? ?? 'user',
      points: map['points'] as int? ?? 0,
    );
  }

  /// Construtor para criação a partir de um usuário do Firebase Auth
  factory UserModel.fromFirebaseUser(firebase_auth.User user) {
    return UserModel(
      id: user.uid,
      phoneNumber: user.phoneNumber ?? '',
      name: '',
      province: '',
      role: 'user',
      points: 0,
    );
  }

  /// Construtor para testes (opcional)
  factory UserModel.test({
    String? id,
    String? phoneNumber,
    String? name,
    String? province,
  }) {
    return UserModel(
      id: id ?? 'test-id-${DateTime.now().millisecondsSinceEpoch}',
      phoneNumber: phoneNumber ?? '+258841234567',
      name: name ?? 'Test User',
      province: province ?? 'Maputo',
    );
  }

  /// Converte o modelo para Map (para Firestore)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'phoneNumber': phoneNumber,
      'name': name,
      'province': province,
      'role': role,
      'points': points,
    };
  }

  /// Cópia com alterações (padrão copyWith)
  UserModel copyWith({
    String? id,
    String? phoneNumber,
    String? name,
    String? province,
    String? role,
    int? points,
  }) {
    return UserModel(
      id: id ?? this.id,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      name: name ?? this.name,
      province: province ?? this.province,
      role: role ?? this.role,
      points: points ?? this.points,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel &&
        other.id == id &&
        other.phoneNumber == phoneNumber &&
        other.name == name &&
        other.province == province &&
        other.role == role &&
        other.points == points;
  }

  @override
  int get hashCode {
    return Object.hash(id, phoneNumber, name, province, role, points);
  }

  @override
  String toString() {
    return 'UserModel('
        'id: $id, '
        'phoneNumber: $phoneNumber, '
        'name: $name, '
        'province: $province, '
        'role: $role, '
        'points: $points)';
  }
}