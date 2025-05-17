import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infoplus/main.dart';
import 'package:provider/provider.dart';
import 'package:infoplus/providers/auth_provider.dart';
import 'package:infoplus/providers/payment_provider.dart';
import 'package:infoplus/providers/points_provider.dart';
import 'package:infoplus/providers/consulta_historico_provider.dart';

void main() {
  testWidgets('Teste do InfoPlusApp com providers simulados', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => PaymentProvider()),
          ChangeNotifierProvider(create: (_) => PointsProvider()),
          ChangeNotifierProvider(create: (_) => ConsultaHistoricoProvider()),
        ],
        child: const InfoPlusApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(InfoPlusApp), findsOneWidget);
  });
}