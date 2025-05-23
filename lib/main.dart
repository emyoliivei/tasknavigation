import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/tasks_screen.dart';
import 'screens/projects_screen.dart';
import 'screens/reports_screen.dart';
import 'screens/documents_screen.dart';
import 'screens/settings_screen.dart';

void main() {
  runApp(const TaskNavigationApp());
}

class TaskNavigationApp extends StatelessWidget {
  const TaskNavigationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Navigation',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/login': (context) => LoginScreen(),
        '/dashboard': (context) => DashboardScreen(),

        // Rotas individuais das páginas do dashboard
        '/tarefas': (context) => const TasksScreen(),
        '/projetos': (context) => const ProjectsScreen(),
        '/relatorios': (context) => const ReportsScreen(),
        '/documentos': (context) => const DocumentsScreen(),
        '/configuracao': (context) => const SettingsScreen(),
      },
    );
  }
}

