import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/price_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/province_selector.dart';

class PriceListView extends StatefulWidget {
  const PriceListView({super.key});

  @override
  State<PriceListView> createState() => _PriceListViewState();
}

class _PriceListViewState extends State<PriceListView> {
  String selectedProvince = 'Maputo';

  @override
  void initState() {
    super.initState();
    _carregarProvincia();
    Future.microtask(() {
      Navigator.pushReplacementNamed(
        context,
        '/payment',
        arguments: {
          'tipo': 'preco',
          'valor': 2,
          'pontos': 2,
          'destino': '/prices',
        },
      );
    });
  }

  Future<void> _carregarProvincia() async {
    final prefs = await SharedPreferences.getInstance();
    final prov = prefs.getString('provinciaSelecionada') ?? 'Maputo';
    setState(() => selectedProvince = prov);
    await context.read<PriceProvider>().fetchPrices(prov);
  }

  @override
  Widget build(BuildContext context) {
    final prices = context.watch<PriceProvider>().pricesByProvince(selectedProvince);

    return Scaffold(
      appBar: AppBar(title: const Text('Preços')),
      body: Column(
        children: [
          ProvinceSelector(
            selected: selectedProvince,
            onChanged: (val) async {
              setState(() => selectedProvince = val);
              await context.read<PriceProvider>().fetchPrices(val);
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: prices.length,
              itemBuilder: (_, i) {
                final price = prices[i];
                return ListTile(
                  title: Text(price.item),
                  subtitle: Text(price.province),
                  trailing: Text('${price.value.toStringAsFixed(2)} Mts'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}