import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/auth_provider.dart';
import '../providers/points_provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String? provinciaSelecionada;

  @override
  void initState() {
    super.initState();
    _carregarProvinciaSalva();
  }

  Future<void> _carregarProvinciaSalva() async {
    final prefs = await SharedPreferences.getInstance();
    final prov = prefs.getString('provinciaSelecionada');
    setState(() {
      provinciaSelecionada = prov;
    });
  }

  Future<void> _selecionarProvincia(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    final provincias = [
      'Maputo Cidade',
      'Maputo Província',
      'Gaza',
      'Inhambane',
      'Sofala',
      'Manica',
      'Tete',
      'Zambézia',
      'Nampula',
      'Niassa',
      'Cabo Delgado',
    ];

    showModalBottomSheet(
      context: context,
      builder: (_) {
        return ListView(
          children: provincias.map((provincia) {
            return ListTile(
              title: Text(provincia),
              onTap: () async {
                await prefs.setString('provinciaSelecionada', provincia);
                setState(() => provinciaSelecionada = provincia);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Província selecionada: $provincia')),
                );
              },
            );
          }).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final points = context.watch<PointsProvider>().points;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          Center(child: Text('Pts: $points', style: const TextStyle(fontSize: 16))),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await auth.logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Bem-vindo ao InfoPlus!', style: TextStyle(fontSize: 18)),
          const SizedBox(height: 24),
          if (provinciaSelecionada != null)
            Text('Província atual: $provinciaSelecionada'),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/jobs'),
            child: const Text('Ver Vagas'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/prices'),
            child: const Text('Ver Preços'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/rewards'),
            child: const Text('Trocar Pontos Por Brindes'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/historico'),
            child: const Text('Histórico de Consultas'),
          ),
          ElevatedButton(
            onPressed: () => _selecionarProvincia(context),
            child: const Text('Selecionar Província'),
          ),
          if (auth.isAdmin)
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/admin'),
              child: const Text('Painel do Administrador'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            ),
        ],
      ),
    );
  }
}