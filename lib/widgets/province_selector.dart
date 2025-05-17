import 'package:flutter/material.dart';

class ProvinceSelector extends StatelessWidget {
  final String selected;
  final void Function(String?) onChanged;

  const ProvinceSelector({required this.selected, required this.onChanged, super.key});

  static const List<String> provinces = [
    'Cabo Delgado', 'Gaza', 'Inhambane', 'Manica', 'Maputo',
    'Maputo Cidade', 'Nampula', 'Niassa', 'Sofala',
    'Tete', 'Zambézia'
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selected,
      items: provinces.map((prov) {
        return DropdownMenuItem(value: prov, child: Text(prov));
      }).toList(),
      onChanged: onChanged,
    );
  }
}