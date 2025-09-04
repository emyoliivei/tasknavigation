import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  List<Map<String, dynamic>> _tasks = [];
  List<Map<String, dynamic>> _filteredTasks = [];
  bool _loading = true;

  final _formKey = GlobalKey<FormState>();
  late String _editTitle;
  late DateTime _editDeadline;
  late String _editPriority;

  int? _userId;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadUserAndTasks();
  }

  Future<void> _loadUserAndTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('userId');

    if (id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuário não encontrado. Faça login novamente.')),
      );
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    _userId = id;

    setState(() => _loading = true);
    final tasks = await ApiService.getTasks();

    if (tasks == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sessão expirada. Faça login novamente.')),
      );
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    setState(() {
      _tasks = tasks;
      _filteredTasks = List.from(_tasks);
      _loading = false;
    });
  }

  void _filterTasks(String query) {
    setState(() {
      _searchQuery = query;
      _filteredTasks = _tasks.where((task) {
        final titleLower = task['titulo'].toString().toLowerCase();
        final searchLower = query.toLowerCase();
        return titleLower.contains(searchLower);
      }).toList();
    });
  }

  void _deleteTask(int index) async {
    final taskToRemove = _filteredTasks[index];
    if (taskToRemove['idTarefa'] != null) {
      await ApiService.deleteTask(taskToRemove['idTarefa']);
    }
    setState(() {
      _tasks.remove(taskToRemove);
      _filteredTasks.removeAt(index);
    });
  }

  Future<void> _editTaskDialog({int? index}) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuário não encontrado. Faça login novamente.')),
      );
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    if (index != null) {
      final task = _filteredTasks[index];
      _editTitle = task['titulo'];
      _editDeadline = DateTime.parse(task['prazo']);
      _editPriority = task['prioridade'];
    } else {
      _editTitle = '';
      _editDeadline = DateTime.now().add(const Duration(days: 1));
      _editPriority = 'Média';
    }

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDark ? Colors.grey[900] : Colors.white,
          title: Text(index == null ? 'Nova Tarefa' : 'Editar Tarefa'),
          content: StatefulBuilder(
            builder: (context, setStateDialog) {
              return Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      initialValue: _editTitle,
                      style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                      decoration: const InputDecoration(labelText: 'Título'),
                      validator: (value) => value == null || value.isEmpty ? 'Digite o título' : null,
                      onChanged: (value) => _editTitle = value,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: Text('Prazo: ${_editDeadline.toLocal().toString().split(' ')[0]}')),
                        TextButton(
                          onPressed: () async {
                            DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: _editDeadline,
                              firstDate: DateTime.now().subtract(const Duration(days: 365)),
                              lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
                            );
                            if (picked != null) setStateDialog(() => _editDeadline = picked);
                          },
                          child: const Text('Selecionar', style: TextStyle(color: Color(0xFF8E24AA))),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _editPriority,
                      items: const [
                        DropdownMenuItem(value: 'Alta', child: Text('Alta')),
                        DropdownMenuItem(value: 'Média', child: Text('Média')),
                        DropdownMenuItem(value: 'Baixa', child: Text('Baixa')),
                      ],
                      onChanged: (value) {
                        if (value != null) setStateDialog(() => _editPriority = value);
                      },
                      decoration: const InputDecoration(labelText: 'Prioridade'),
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8E24AA)),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final tarefaData = {
                    'titulo': _editTitle,
                    'descricao': '',
                    'prazo': _editDeadline.toIso8601String().split('T')[0],
                    'status': 'Pendente',
                    'prioridade': _editPriority,
                    'usuario': {'idUsuario': _userId},
                  };

                  await ApiService.createTask(tarefaData);
                  await _loadUserAndTasks();
                  Navigator.pop(context);
                }
              },
              child: const Text('Salvar', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Widget _priorityColor(String priority) {
    switch (priority) {
      case 'Alta':
        return const Icon(Icons.flag, color: Colors.redAccent);
      case 'Média':
        return const Icon(Icons.flag, color: Colors.orangeAccent);
      case 'Baixa':
        return const Icon(Icons.flag, color: Colors.green);
      default:
        return const Icon(Icons.flag, color: Colors.grey);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF8E24AA),
        title: Text('Tarefas', style: GoogleFonts.montserrat(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                    decoration: const InputDecoration(
                      labelText: 'Pesquisar tarefas',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: _filterTasks,
                  ),
                ),
                Expanded(
                  child: _filteredTasks.isEmpty
                      ? const Center(child: Text('Nenhuma tarefa encontrada'))
                      : RefreshIndicator(
                          onRefresh: _loadUserAndTasks,
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            itemCount: _filteredTasks.length,
                            itemBuilder: (context, index) {
                              final task = _filteredTasks[index];
                              return Card(
                                elevation: 3,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(12),
                                  title: Text(task['titulo'], style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.w600)),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Prazo: ${task['prazo']}'),
                                        Text('Atribuído a: ${task['usuario']?['nome'] ?? ''}'),
                                      ],
                                    ),
                                  ),
                                  leading: _priorityColor(task['prioridade']),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(icon: const Icon(Icons.edit, color: Colors.deepPurple), onPressed: () => _editTaskDialog(index: index)),
                                      IconButton(icon: const Icon(Icons.delete, color: Colors.redAccent), onPressed: () => _deleteTask(index)),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _editTaskDialog(),
        backgroundColor: const Color(0xFF673AB7),
        child: const Icon(Icons.add),
      ),
    );
  }
}
