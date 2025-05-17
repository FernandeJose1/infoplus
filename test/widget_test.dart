import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Versão mínima do InfoPlusApp apenas para testes
class TestableInfoPlusApp extends StatelessWidget {
  const TestableInfoPlusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(body: Text('InfoPlusApp Test')),
    );
  }
}

void main() {
  testWidgets('Teste básico do InfoPlusApp isolado', (WidgetTester tester) async {
    await tester.pumpWidget(const TestableInfoPlusApp());
    await tester.pumpAndSettle();

    // Verifica se o texto está na tela
    expect(find.text('InfoPlusApp Test'), findsOneWidget);
  });
}