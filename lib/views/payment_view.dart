import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/payment_provider.dart';
import '../providers/consulta_historico_provider.dart';
import '../providers/points_provider.dart';
import '../models/consulta_historico.dart';
import '../widgets/loading_widget.dart';

class PaymentView extends StatefulWidget {
  const PaymentView({Key? key}) : super(key: key);

  @override
  _PaymentViewState createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  bool _processing = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _processPayment();
  }

  Future<void> _processPayment() async {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final tipo = args['tipo'] as String;
    final valor = args['valor'] as int;
    final pontos = args['pontos'] as int;
    final destino = args['destino'] as String;

    final auth = context.read<AuthProvider>();
    final payment = context.read<PaymentProvider>();
    final historicoProvider = context.read<ConsultaHistoricoProvider>();
    final pointsProvider = context.read<PointsProvider>();
    final phone = auth.firebaseUser?.phoneNumber ?? '';

    await payment.pay(valor.toDouble(), phone);

    if (payment.response != null && payment.response!.contains('USSD enviado')) {
      final userId = auth.firebaseUser!.uid;
      final historico = ConsultaHistorico(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        tipo: tipo,
        timestamp: DateTime.now(),
      );

      await historicoProvider.salvar(historico);
      await pointsProvider.addPoints(userId, pontos);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pagamento confirmado! Você ganhou $pontos pontos.')),
      );
      Navigator.pushReplacementNamed(context, destino);
    } else {
      setState(() => _processing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(payment.response ?? 'Erro ao realizar pagamento')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pagamento')),
      body: Center(
        child: _processing
            ? const LoadingWidget()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Pagamento não concluído'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Tentar Novamente'),
                  ),
                ],
              ),
      ),
    );
  }
}