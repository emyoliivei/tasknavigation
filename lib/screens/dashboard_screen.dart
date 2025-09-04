import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasknavigation/screens/tasks_screen.dart';
import 'package:tasknavigation/screens/settings_screen.dart';
import 'package:tasknavigation/screens/collaboration_screen.dart';
import 'package:tasknavigation/screens/projects_screen.dart';
import 'package:tasknavigation/screens/reports_screen.dart';
import 'package:tasknavigation/services/api_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = [
    const TasksScreen(),
    ProjectsScreen(),
    ReportsScreen(),
    CollaborationScreen(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _criarTarefaDialog() async {
    final tituloController = TextEditingController();
    final descricaoController = TextEditingController();
    DateTime? prazo;
    String prioridade = 'MÉDIA';
    String status = 'PENDENTE';

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          title: const Text('Criar Tarefa'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: tituloController,
                  decoration: const InputDecoration(labelText: 'Título'),
                ),
                TextField(
                  controller: descricaoController,
                  decoration: const InputDecoration(labelText: 'Descrição'),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text('Prazo: '),
                    TextButton(
                      onPressed: () async {
                        final dataSelecionada = await showDatePicker(
                          context: context,
                          locale: const Locale('pt', 'BR'),
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );

                        if (dataSelecionada != null) {
                          setStateDialog(() {
                            prazo = dataSelecionada;
                          });
                        }
                      },
                      child: Text(
                        prazo != null
                            ? '${prazo!.day.toString().padLeft(2, '0')}/${prazo!.month.toString().padLeft(2, '0')}/${prazo!.year}' // exibição DD/MM/YYYY
                            : 'Selecionar data',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                DropdownButtonFormField<String>(
                  value: prioridade,
                  decoration: const InputDecoration(labelText: 'Prioridade'),
                  items: ['BAIXA', 'MÉDIA', 'ALTA'].map((p) {
                    return DropdownMenuItem(value: p, child: Text(p));
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) prioridade = value;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (prazo == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Escolha uma data para o prazo!')),
                  );
                  return;
                }
                

                final prefs = await SharedPreferences.getInstance();
                final userId = prefs.getInt('userId') ?? 1;


                final res = await ApiService.createTask({
                  "titulo": tituloController.text,
                  "descricao": descricaoController.text,
                  "prazo": prazo!.toIso8601String().split('T')[0], // envio YYYY-MM-DD
                  "status": status,
                  "prioridade": prioridade,
                  "idUsuario": userId,
                  "idProjeto": 1,
                });
                

                Navigator.pop(context);

                if (res.containsKey('error')) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Falha: ${res['error']}')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Tarefa criada com sucesso!')),
                  );
                  setState(() {}); // atualizar tela principal se necessário
                }
              },
              child: const Text('Criar'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
      ),
      body: _pages[_selectedIndex],
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        onPressed: _criarTarefaDialog,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary,
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
            icon: Icon(Icons.bar_chart),
            label: 'Relatórios',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
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
