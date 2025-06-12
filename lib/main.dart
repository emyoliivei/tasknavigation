import 'package:flutter/material.dart';
import 'package:tasknavigation/screens/esqueci_senha_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/tasks_screen.dart';
import 'screens/projects_screen.dart';
import 'screens/reports_screen.dart';
import 'screens/collaboration_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/criar_conta_screen.dart';




void main() {
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
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
            brightness: Brightness.light,
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),
          themeMode: currentMode,
          initialRoute: '/',
          routes: {
            '/': (context) => const HomeScreen(),
            '/login': (context) => const LoginScreen(),
            '/dashboard': (context) => const DashboardScreen(),
            '/tarefas': (context) => const TasksScreen(),
            '/projetos': (context) => ProjectsScreen(),
            '/relatorios': (context) => const ReportsScreen(),
            '/colaboracao': (context) => CollaborationScreen(),
            '/configuracao': (context) => const SettingsScreen(),
            '/criarConta': (context) => const CriarContaScreen(),
            '/esqueciSenha': (context) => const EsqueciSenhaScreen(),


            
          },
        );
      },
    );
  }
}
