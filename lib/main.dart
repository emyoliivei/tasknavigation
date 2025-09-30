import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tasknavigation/screens/collaboration_screen.dart';
import 'package:tasknavigation/screens/criar_conta_screen.dart';
import 'package:tasknavigation/screens/esqueci_senha_screen.dart';
import 'package:tasknavigation/screens/home_screen.dart';
import 'package:tasknavigation/screens/login_screen.dart';
import 'package:tasknavigation/screens/projects_screen.dart';
import 'package:tasknavigation/screens/redefinirsenha_screen.dart';

import 'package:tasknavigation/screens/settings_screen.dart';
import 'package:tasknavigation/screens/tasks_screen.dart';
import 'package:tasknavigation/screens/validarcodigo_screen.dart';
import 'package:tasknavigation/screens/dashboard_screen.dart';
import 'package:tasknavigation/screens/equipe_screen.dart';

// Usando prefixos para evitar conflitos de nome

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pt_BR', null);
  runApp(const TaskNavigationApp());
}

class TaskNavigationApp extends StatelessWidget {
  const TaskNavigationApp({super.key});

  static final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Task Navigation',
          theme: ThemeData(
            primarySwatch: Colors.deepPurple,
            brightness: Brightness.light,
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF8E24AA),
              foregroundColor: Colors.white,
            ),
          ),
          darkTheme: ThemeData(
            primarySwatch: Colors.deepPurple,
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(0xFF222222),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF8E24AA),
              foregroundColor: Colors.white,
            ),
          ),
          themeMode: currentMode,
          locale: const Locale('pt', 'BR'),
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('pt', 'BR'),
          ],
          initialRoute: '/',
          routes: {
            '/': (context) => const HomeScreen(),
            '/login': (context) => const LoginScreen(),
            '/dashboard': (context) => const DashboardScreen(),
            '/equipe': (context) => const EntrarEquipeScreen(),
            '/tarefas': (context) => const TasksScreen(),
            '/projetos': (context) => const ProjectsScreen(),
            '/colaboracao': (context) => const CollaborationScreen(),
            '/configuracao': (context) => const SettingsScreen(),
            '/criarConta': (context) => const CriarContaScreen(),
            '/esqueciSenha': (context) => const EsqueciSenhaScreen(),
            '/validarCodigo': (context) => const ValidarCodigoScreen(),
            '/redefinirSenha': (context) => const RedefinirSenhaScreen(),
          },
        );
      },
    );
  }
}
