import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../providers/auth_provider.dart';
import '../providers/user_provider.dart';
import '../models/user.dart' as app_user;

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  String? _selectedProvince;

  final List<String> provinces = [
    'Maputo Cidade',
    'Maputo Provincia',
    'Gaza',
    'Inhambane',
    'Manica',
    'Sofala',
    'Tete',
    'Zambézia',
    'Nampula',
    'Cabo Delgado',
    'Niassa',
  ];

  bool _isLoading = false;

  void _submit() async {
    if (!_formKey.currentState!.validate() || _selectedProvince == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor preencha todos os campos')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final userProvider = context.read<UserProvider>();
    final authProvider = context.read<AuthProvider>();
    final uuid = Uuid();

    final user = app_user.UserModel(
      id: uuid.v4(),
      name: _nameController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      province: _selectedProvince!,
    );

    try {
      await userProvider.registerUser(user);
      await authProvider.fetchUserProfile();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registro efetuado com sucesso!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro no registro: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro de Usuário')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nome completo'),
                validator: (value) => value == null || value.isEmpty ? 'Campo obrigatório' : null,
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Número de telefone'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Campo obrigatório';
                  if (!RegExp(r'^\+258\d{8,9}$').hasMatch(value.trim())) {
                    return 'Formato inválido (+258xxxxxxxxx)';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Província'),
                items: provinces
                    .map((prov) => DropdownMenuItem(value: prov, child: Text(prov)))
                    .toList(),
                onChanged: (val) => setState(() => _selectedProvince = val),
                validator: (value) => value == null ? 'Selecione a província' : null,
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _submit,
                      child: const Text('Registrar'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}