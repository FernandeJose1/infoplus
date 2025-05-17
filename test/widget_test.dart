import 'package:flutter_test/flutter_test.dart';
import 'package:infoplus/main.dart';

void main() {
  testWidgets('Teste do widget InfoPlusApp', (WidgetTester tester) async {
    // Construir o app diretamente
    await tester.pumpWidget(const InfoPlusApp());

    // Esperar para o frame renderizar
    await tester.pump();

    // Verificar se InfoPlusApp está na árvore de widgets
    expect(find.byType(InfoPlusApp), findsOneWidget);
  });
}