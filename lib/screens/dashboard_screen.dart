import 'package:flutter/material.dart';
import 'package:tasknavigation/screens/tasks_screen.dart';
import 'package:tasknavigation/screens/projects_screen.dart';
import 'package:tasknavigation/screens/collaboration_screen.dart';
import 'package:tasknavigation/screens/settings_screen.dart';
import 'package:tasknavigation/screens/equipe_screen.dart'; // ✅ Tela de Equipe

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const EntrarEquipeScreen(), // ✅ Equipe
    const TasksScreen(),        // ✅ Tarefas (com FAB interno)
    const ProjectsScreen(),     // ✅ Projetos
    const CollaborationScreen(),// ✅ Colaboração
    const SettingsScreen(),     // ✅ Configurações
  ];

  final List<String> _titles = [
    "Equipe",
    "Gestão de Tarefas",
    "Projetos",
    "Colaboração",
    "Configurações"
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        centerTitle: true,
      ),
      body: _pages[_selectedIndex],
      // ✅ Não precisamos de FAB aqui, pois TasksScreen já tem o seu próprio
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Equipe',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_outline),
            label: 'Tarefas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder_open),
            label: 'Projetos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Colaboração',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Configurações',
          ),
        ],
      ),
    );
  }
}
