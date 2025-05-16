import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'config/env.dart';
import 'providers/connectivity_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/payment_provider.dart';
import 'providers/sync_provider.dart';
import 'providers/job_provider.dart';
import 'providers/price_provider.dart';
import 'providers/reward_provider.dart';
import 'providers/admin_provider.dart';
import 'providers/user_provider.dart';
import 'providers/consulta_historico_provider.dart'; // NOVO
import 'providers/points_provider.dart'; // NOVO

import 'views/splash_view.dart';
import 'views/login_view.dart';
import 'views/home_view.dart';
import 'views/payment_view.dart';
import 'views/job_list_view.dart';
import 'views/price_list_view.dart';
import 'views/reward_view.dart';
import 'views/admin_view.dart';
import 'views/register_view.dart';
import 'views/historico_consultas_view.dart'; // NOVO

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Env.load();
  runApp(const InfoPlusApp());
}

class InfoPlusApp extends StatelessWidget {
  const InfoPlusApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: () => ConnectivityProvider()),
        ChangeNotifierProvider(create: () => AuthProvider()),
        ChangeNotifierProvider(create: () => PaymentProvider()),
        ChangeNotifierProvider(create: () => SyncProvider()),
        ChangeNotifierProvider(create: () => JobProvider()),
        ChangeNotifierProvider(create: () => PriceProvider()),
        ChangeNotifierProvider(create: () => RewardProvider()),
        ChangeNotifierProvider(create: () => AdminProvider()),
        ChangeNotifierProvider(create: () => UserProvider()),
        ChangeNotifierProvider(create: () => ConsultaHistoricoProvider()), // NOVO
        ChangeNotifierProvider(create: (_) => PointsProvider()), // NOVO
      ],
      child: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          return MaterialApp(
            title: 'InfoPlus',
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: ThemeMode.system,
            initialRoute: '/',
            onGenerateRoute: (settings) {
              Widget page;

              switch (settings.name) {
                case '/':
                  page = const SplashView();
                  break;
                case '/login':
                  page = const LoginView();
                  break;
                case '/register':
                  page = const RegisterView();
                  break;
                case '/home':
                  page = auth.firebaseUser == null ? const LoginView() : const HomeView();
                  break;
                case '/payment':
                  page = auth.firebaseUser == null ? const LoginView() : const PaymentView();
                  break;
                case '/jobs':
                  page = auth.firebaseUser == null ? const LoginView() : const JobListView();
                  break;
                case '/prices':
                  page = auth.firebaseUser == null ? const LoginView() : const PriceListView();
                  break;
                case '/rewards':
                  page = auth.firebaseUser == null ? const LoginView() : const RewardView();
                  break;
                case '/historico': // NOVO
                  page = auth.firebaseUser == null ? const LoginView() : const HistoricoConsultasView();
                  break;
                case '/admin':
                  page = (auth.firebaseUser != null && auth.isAdmin) ? const AdminView() : const HomeView();
                  break;
                default:
                  page = const SplashView();
              }
              return MaterialPageRoute(builder: (_) => page);
            },
          );
        },
      ),
    );
  }
}