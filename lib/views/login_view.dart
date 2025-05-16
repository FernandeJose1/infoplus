import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/points_provider.dart';
import '../widgets/loading_widget.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: auth.loading
          ? const LoadingWidget()
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _phoneController,
                    decoration: const InputDecoration(labelText: 'Telefone'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => auth.sendCode(_phoneController.text),
                    child: const Text('Enviar código'),
                  ),
                  if (auth.verificationId != null) ...[
                    const SizedBox(height: 16),
                    TextField(
                      controller: _codeController,
                      decoration: const InputDecoration(labelText: 'Código SMS'),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () async {
                        await auth.verifyCode(_codeController.text);
                        if (auth.firebaseUser != null) {
                          // Após login, carregar pontos
                          final userId = auth.firebaseUser!.uid;
                          await context.read<PointsProvider>().loadPoints(userId);
                          Navigator.pushReplacementNamed(context, '/home');
                        }
                      },
                      child: const Text('Verificar'),
                    ),
                  ],
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: const Text('Não tem conta? Registre-se aqui'),
                  ),
                ],
              ),
            ),
    );
  }
}