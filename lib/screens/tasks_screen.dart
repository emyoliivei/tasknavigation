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
  late String _editAssignedTo;

  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  Future<String?> _getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('deileluna11@gmail.com');
  }

  Future<void> _fetchTasks() async {
    setState(() => _loading = true);
    String? email = await _getUserEmail();
    if (email == null) {
      setState(() => _loading = false);
      return;
    }

    final tasks = await ApiService.getTasks(email);
    setState(() {
      _tasks = tasks ?? [];
      _filteredTasks = List.from(_tasks);
      _loading = false;
    });
  }

  void _filterTasks(String query) {
    setState(() {
      _searchQuery = query;
      _filteredTasks = _tasks.where((task) {
        final titleLower = task['title'].toLowerCase();
        final searchLower = query.toLowerCase();
        return titleLower.contains(searchLower);
      }).toList();
    });
  }

  void _deleteTask(int index) async {
    final taskToRemove = _filteredTasks[index];

    // Chamar API para deletar tarefa (precisa implementar no backend)
    // await ApiService.deleteTask(taskToRemove['id']);

    setState(() {
      _tasks.remove(taskToRemove);
      _filteredTasks.removeAt(index);
    });
  }

  Future<void> _editTaskDialog({int? index}) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Map<String, dynamic>? task;
    if (index != null) {
      task = _filteredTasks[index];
      _editTitle = task['title'];
      _editDeadline = DateTime.parse(task['deadline']);
      _editPriority = task['priority'];
      _editAssignedTo = task['assignedTo'];
    } else {
      _editTitle = '';
      _editDeadline = DateTime.now().add(const Duration(days: 1));
      _editPriority = 'Média';
      _editAssignedTo = '';
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
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // === Título ===
                      TextFormField(
                        initialValue: _editTitle,
                        style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                        decoration: InputDecoration(labelText: 'Título'),
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Digite o título' : null,
                        onChanged: (value) => _editTitle = value,
                      ),
                      const SizedBox(height: 12),
                      // === Prazo ===
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
                              if (picked != null) {
                                setStateDialog(() => _editDeadline = picked);
                              }
                            },
                            child: const Text('Selecionar', style: TextStyle(color: Color(0xFF8E24AA))),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // === Prioridade ===
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
                      const SizedBox(height: 12),
                      // === Responsável ===
                      TextFormField(
                        initialValue: _editAssignedTo,
                        style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                        decoration: const InputDecoration(labelText: 'Atribuído a'),
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Digite o responsável' : null,
                        onChanged: (value) => _editAssignedTo = value,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8E24AA)),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    if (index == null) {
                      _tasks.add({
                        'title': _editTitle,
                        'deadline': _editDeadline.toIso8601String(),
                        'priority': _editPriority,
                        'assignedTo': _editAssignedTo,
                      });
                    } else {
                      int taskIndex = _tasks.indexOf(task!);
                      _tasks[taskIndex] = {
                        'title': _editTitle,
                        'deadline': _editDeadline.toIso8601String(),
                        'priority': _editPriority,
                        'assignedTo': _editAssignedTo,
                      };
                    }
                    _filterTasks(_searchQuery);
                  });
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
                // === Pesquisa ===
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                    decoration: InputDecoration(labelText: 'Pesquisar tarefas', prefixIcon: const Icon(Icons.search)),
                    onChanged: _filterTasks,
                  ),
                ),
                // === Lista de tarefas ===
                Expanded(
                  child: _filteredTasks.isEmpty
                      ? const Center(child: Text('Nenhuma tarefa encontrada'))
                      : RefreshIndicator(
                          onRefresh: _fetchTasks,
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
                                  title: Text(task['title'], style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.w600)),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Prazo: ${DateTime.parse(task['deadline']).toLocal().toString().split(' ')[0]}'),
                                        Text('Atribuído a: ${task['assignedTo']}'),
                                      ],
                                    ),
                                  ),
                                  leading: _priorityColor(task['priority']),
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
