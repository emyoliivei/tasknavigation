import 'package:flutter/material.dart';
import 'package:tasknavigation/screens/tasks_screen.dart';
import 'package:tasknavigation/screens/projects_screen.dart';
import 'package:tasknavigation/screens/collaboration_screen.dart';
import 'package:tasknavigation/screens/settings_screen.dart';
import 'package:tasknavigation/screens/equipe_screen.dart'; // Tela de equipe

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  final List<int> _navigationStack = [0];

  // ✅ Ordem das páginas corresponde exatamente às abas
  final List<Widget> _pages = const [
    EntrarEquipeScreen(),
    TasksScreen(),
    ProjectsScreen(),
    CollaborationScreen(),
    SettingsScreen(),
  ];

  final List<String> _titles = [
    "Equipe",
    "Tarefas",
    "Projetos",
    "Colaboração",
    "Configurações"
  ];

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      _navigationStack.add(index);
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  Future<bool> _onWillPop() async {
    if (_navigationStack.length > 1) {
      setState(() {
        _navigationStack.removeLast();
        _selectedIndex = _navigationStack.last;
      });
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
       
        body: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),
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
      ),
    );
  }
}
