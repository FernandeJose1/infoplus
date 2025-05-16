import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/consulta_historico_provider.dart';
import '../models/consulta_historico.dart';

class AdminView extends StatelessWidget {
  const AdminView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final historicoProvider = context.watch<ConsultaHistoricoProvider>();
    final List<ConsultaHistorico> historicos = historicoProvider.consultas;

    if (!auth.isAdmin) {
      return const Scaffold(
        body: Center(child: Text('Acesso restrito')),
      );
    }

    // Estatísticas gerais
    final totalConsultas = historicos.length;
    final totalLucro = historicos.fold<double>(
      0,
      (sum, h) => sum + (h.tipo == 'vaga' ? 3.0 : 2.0),
    );

    // Filtra apenas o mês atual
    final now = DateTime.now();
    final inicioMes = DateTime(now.year, now.month, 1);
    final mensais = historicos.where((h) => h.timestamp.isAfter(inicioMes)).toList();

    final totalConsultasMensal = mensais.length;
    final lucroMensal = mensais.fold<double>(
      0,
      (sum, h) => sum + (h.tipo == 'vaga' ? 3.0 : 2.0),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Painel do Administrador')),
      body: RefreshIndicator(
        onRefresh: historicoProvider.fetchHistorico,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 16),
              child: ListTile(
                leading: const Icon(Icons.pie_chart),
                title: const Text('Resumo Geral'),
                subtitle: Text(
                  'Total consultas: $totalConsultas\n'
                  'Lucro total: ${totalLucro.toStringAsFixed(2)} Mts',
                ),
              ),
            ),
            Card(
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 16),
              child: ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('Resumo Mensal'),
                subtitle: Text(
                  'Consultas este mês: $totalConsultasMensal\n'
                  'Lucro este mês: ${lucroMensal.toStringAsFixed(2)} Mts',
                ),
              ),
            ),
            const Divider(),
            ListTile(
              title: const Text('Gerir Vagas'),
              trailing: const Icon(Icons.work),
              onTap: () => Navigator.pushNamed(context, '/jobs'),
            ),
            ListTile(
              title: const Text('Gerir Preços'),
              trailing: const Icon(Icons.price_change),
              onTap: () => Navigator.pushNamed(context, '/prices'),
            ),
            ListTile(
              title: const Text('Gerir Recompensas'),
              trailing: const Icon(Icons.card_giftcard),
              onTap: () => Navigator.pushNamed(context, '/rewards'),
            ),
            ListTile(
              title: const Text('Ver Histórico de Consultas'),
              trailing: const Icon(Icons.history),
              onTap: () => Navigator.pushNamed(context, '/historico'),
            ),
          ],
        ),
      ),
    );
  }
}