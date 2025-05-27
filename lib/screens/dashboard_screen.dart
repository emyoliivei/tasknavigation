import 'package:flutter/material.dart';
import 'package:tasknavigation/screens/tasks_screen.dart';
import 'package:tasknavigation/screens/settings_screen.dart';  // importar aqui

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  static const List<String> _titles = [
    'Tarefas',
    'Projetos',
    'Relatórios',
    'Documentos',
    'Configuração',
  ];

  static final List<Widget> _pages = [
    const TasksScreen(),
    Center(child: Text('Página de Projetos', style: TextStyle(fontSize: 24))),
    Center(child: Text('Página de Relatórios', style: TextStyle(fontSize: 24))),
    Center(child: Text('Página de Documentos', style: TextStyle(fontSize: 24))),
    const SettingsScreen(),  // Aqui é a SettingsScreen de verdade
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _logout() {
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        backgroundColor: Colors.deepPurple,
        actions: [
          TextButton(
            onPressed: _logout,
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Stack(
        children: [
          _pages[_selectedIndex],
          Positioned(
            bottom: 10,
            left: 16,
            child: Row(
              children: [
                Icon(Icons.account_circle, color: Colors.deepPurple[300], size: 28),
                const SizedBox(width: 8),
                Text(
                  'Usuário: João Silva',
                  style: TextStyle(
                    color: Colors.deepPurple[300],
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.deepPurple[200],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_outline),
            label: 'Tarefas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder_open),
            label: 'Projetos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            label: 'Relatórios',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description_outlined),
            label: 'Documentos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Configuração',
          ),
        ],
      ),
    );
  }
}
