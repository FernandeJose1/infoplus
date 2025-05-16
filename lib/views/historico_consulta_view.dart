import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/consulta_historico_provider.dart';

class HistoricoConsultasView extends StatefulWidget {
  const HistoricoConsultasView({super.key});

  @override
  State<HistoricoConsultasView> createState() => _HistoricoConsultasViewState();
}

class _HistoricoConsultasViewState extends State<HistoricoConsultasView> {
  @override
  void initState() {
    super.initState();
    final auth = context.read<AuthProvider>();
    final provider = context.read<ConsultaHistoricoProvider>();
    provider.carregarHistorico(auth.firebaseUser!.uid);
  }

  @override
  Widget build(BuildContext context) {
    final consultas = context.watch<ConsultaHistoricoProvider>().consultas;

    return Scaffold(
      appBar: AppBar(title: const Text('Histórico de Consultas (24h)')),
      body: consultas.isEmpty
          ? const Center(child: Text('Nenhuma consulta recente.'))
          : ListView.builder(
              itemCount: consultas.length,
              itemBuilder: (_, i) {
                final c = consultas[i];
                return ListTile(
                  leading: Icon(
                    c.tipo == 'vaga' ? Icons.work : Icons.price_change,
                  ),
                  title: Text('Consulta de ${c.tipo == 'vaga' ? 'vagas' : 'preços'}'),
                  subtitle: Text('${c.timestamp}'),
                );
              },
            ),
    );
  }
}