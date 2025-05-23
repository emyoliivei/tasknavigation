import 'package:flutter/material.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  List<Map<String, dynamic>> _tasks = [
    {
      'title': 'Tarefa 1',
      'deadline': DateTime.now().add(const Duration(days: 3)),
      'priority': 'Alta',
      'assignedTo': 'João Silva',
    },
    {
      'title': 'Tarefa 2',
      'deadline': DateTime.now().add(const Duration(days: 7)),
      'priority': 'Média',
      'assignedTo': 'Maria Oliveira',
    },
    {
      'title': 'Tarefa 3',
      'deadline': DateTime.now().add(const Duration(days: 1)),
      'priority': 'Baixa',
      'assignedTo': 'Pedro Santos',
    },
  ];

  List<Map<String, dynamic>> _filteredTasks = [];

  final _formKey = GlobalKey<FormState>();
  late String _editTitle;
  late DateTime _editDeadline;
  late String _editPriority;
  late String _editAssignedTo;

  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _filteredTasks = List.from(_tasks);
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

  void _deleteTask(int index) {
    setState(() {
      final taskToRemove = _filteredTasks[index];
      _tasks.remove(taskToRemove);
      _filteredTasks.removeAt(index);
    });
  }

  Future<void> _editTaskDialog({int? index}) async {
    Map<String, dynamic>? task;
    if (index != null) {
      task = _filteredTasks[index];
      _editTitle = task['title'];
      _editDeadline = task['deadline'];
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
          title: Text(index == null ? 'Nova Tarefa' : 'Editar Tarefa'),
          content: StatefulBuilder(
            builder: (context, setStateDialog) {
              return Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        initialValue: _editTitle,
                        decoration: const InputDecoration(labelText: 'Título'),
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Digite o título' : null,
                        onChanged: (value) => _editTitle = value,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text('Prazo: ${_editDeadline.toLocal().toString().split(' ')[0]}'),
                          ),
                          TextButton(
                            onPressed: () async {
                              DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: _editDeadline,
                                firstDate: DateTime.now().subtract(const Duration(days: 365)),
                                lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
                              );
                              if (picked != null) {
                                setStateDialog(() {
                                  _editDeadline = picked;
                                });
                              }
                            },
                            child: const Text('Selecionar'),
                          ),
                        ],
                      ),
                      DropdownButtonFormField<String>(
                        value: _editPriority,
                        items: const [
                          DropdownMenuItem(value: 'Alta', child: Text('Alta')),
                          DropdownMenuItem(value: 'Média', child: Text('Média')),
                          DropdownMenuItem(value: 'Baixa', child: Text('Baixa')),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setStateDialog(() {
                              _editPriority = value;
                            });
                          }
                        },
                        decoration: const InputDecoration(labelText: 'Prioridade'),
                      ),
                      TextFormField(
                        initialValue: _editAssignedTo,
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
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    if (index == null) {
                      _tasks.add({
                        'title': _editTitle,
                        'deadline': _editDeadline,
                        'priority': _editPriority,
                        'assignedTo': _editAssignedTo,
                      });
                    } else {
                      int taskIndex = _tasks.indexOf(task!);
                      _tasks[taskIndex] = {
                        'title': _editTitle,
                        'deadline': _editDeadline,
                        'priority': _editPriority,
                        'assignedTo': _editAssignedTo,
                      };
                    }
                    _filterTasks(_searchQuery); // Atualiza filtro após salvar
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  Widget _priorityColor(String priority) {
    switch (priority) {
      case 'Alta':
        return const Icon(Icons.flag, color: Colors.red);
      case 'Média':
        return const Icon(Icons.flag, color: Colors.orange);
      case 'Baixa':
        return const Icon(Icons.flag, color: Colors.green);
      default:
        return const Icon(Icons.flag, color: Colors.grey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Pesquisar tarefas',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _filterTasks,
            ),
          ),
          Expanded(
            child: _filteredTasks.isEmpty
                ? const Center(child: Text('Nenhuma tarefa encontrada'))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredTasks.length,
                    itemBuilder: (context, index) {
                      final task = _filteredTasks[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Text(
                            task['title'],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                  'Prazo: ${task['deadline'].toLocal().toString().split(' ')[0]}'),
                              Text('Atribuído a: ${task['assignedTo']}'),
                            ],
                          ),
                          leading: _priorityColor(task['priority']),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon:
                                    const Icon(Icons.edit, color: Colors.deepPurple),
                                onPressed: () => _editTaskDialog(index: index),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteTask(index),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _editTaskDialog(),
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add),
      ),
    );
  }
}
