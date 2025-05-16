import 'package:flutter_test/flutter_test.dart';
import 'package:infoplus/models/user.dart';

void main() {
  group('User model', () {
    test('toMap e fromMap funcionam corretamente', () {
      final user = User(
        id: '123',
        name: 'Joana',
        phoneNumber: '+258841234567',
        province: 'Maputo',
      );

      final map = user.toMap();
      final fromMap = User.fromMap(map);

      expect(fromMap.id, user.id);
      expect(fromMap.name, user.name);
      expect(fromMap.phoneNumber, user.phoneNumber);
      expect(fromMap.province, user.province);
    });
  });
}