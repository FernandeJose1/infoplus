import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infoplus/main.dart'; // Corrigido o caminho de importação

void main() {
  testWidgets('Teste do widget InfoPlusApp', (WidgetTester tester) async {
    // Construir nosso app
    await tester.pumpWidget(
      const MaterialApp(
        home: InfoPlusApp(),
      ),
    );

    // Verificar que o app inicia
    await tester.pump();
    expect(find.byType(InfoPlusApp), findsOneWidget);
  });
}