// tasks_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  List<Map<String, dynamic>> tasks = [];
  List<Map<String, dynamic>> projects = [];
  bool isLoading = true;

  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  Map<String, dynamic>? _selectedProject;

  @override
  void initState() {
    super.initState();
    _loadTasks();
    _loadProjects();
  }

  // 🔹 CARREGAR TAREFAS
  Future<void> _loadTasks() async {
    setState(() {
      isLoading = true;
    });
    try {
      final data = await ApiService.getData("/tarefas");
      setState(() {
        tasks = List<Map<String, dynamic>>.from(data);
      });
    } catch (e) {
      debugPrint("Erro ao carregar tarefas: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // 🔹 CARREGAR PROJETOS
  Future<void> _loadProjects() async {
    try {
      final data = await ApiService.getData("/projetos");
      setState(() {
        projects = List<Map<String, dynamic>>.from(data);
        if (projects.isNotEmpty) _selectedProject = projects[0];
      });
    } catch (e) {
      debugPrint("Erro ao carregar projetos: $e");
    }
  }

  // 🔹 ADICIONAR TAREFA
  Future<void> _addTask() async {
    if (_tituloController.text.isEmpty || _selectedProject == null) return;

    final newTask = {
      "titulo": _tituloController.text,
      "descricao": _descricaoController.text,
      "idProjeto": _selectedProject!["idProjeto"], // só o ID
      "status": "Pendente",
      "prioridade": "Média",
    };

    try {
      await ApiService.postData("/tarefas", newTask);
      _tituloController.clear();
      _descricaoController.clear();
      _loadTasks();
    } catch (e) {
      debugPrint("Erro ao criar tarefa: $e");
    }
  }

  // 🔹 ATUALIZAR TAREFA
  Future<void> _updateTask(int id, Map<String, dynamic> updatedTask) async {
    final taskToSend = {
      "titulo": updatedTask["titulo"],
      "descricao": updatedTask["descricao"],
      "status": updatedTask["status"] ?? "Pendente",
      "prioridade": updatedTask["prioridade"] ?? "Média",
      "idProjeto": updatedTask["idProjeto"], // só o ID
    };

    try {
      await ApiService.putData("/tarefas/$id", taskToSend);
      _loadTasks();
    } catch (e) {
      debugPrint("Erro ao atualizar tarefa: $e");
    }
  }

  // 🔹 DELETAR TAREFA
  Future<void> _deleteTask(int id) async {
    try {
      await ApiService.deleteData("/tarefas/$id");
      _loadTasks();
    } catch (e) {
      debugPrint("Erro ao deletar tarefa: $e");
    }
  }

  // 🔹 DIALOGS
  void _showAddTaskDialog() {
    _tituloController.clear();
    _descricaoController.clear();
    _selectedProject = projects.isNotEmpty ? projects[0] : null;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Nova Tarefa"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _tituloController,
              decoration: const InputDecoration(labelText: "Título da tarefa"),
            ),
            TextField(
              controller: _descricaoController,
              decoration: const InputDecoration(labelText: "Descrição"),
            ),
            const SizedBox(height: 10),
            DropdownButton<Map<String, dynamic>>(
              isExpanded: true,
              value: _selectedProject,
              items: projects
                  .map((proj) => DropdownMenuItem(
                        value: proj,
                        child: Text(proj["nome"] ?? "Projeto sem nome"),
                      ))
                  .toList(),
              onChanged: (proj) {
                setState(() => _selectedProject = proj);
              },
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
          ElevatedButton(
            onPressed: () {
              _addTask();
              Navigator.pop(context);
            },
            child: const Text("Adicionar"),
          ),
        ],
      ),
    );
  }

  void _showEditTaskDialog(Map<String, dynamic> task) {
    _tituloController.text = task["titulo"] ?? "";
    _descricaoController.text = task["descricao"] ?? "";

    _selectedProject = projects.isNotEmpty
        ? projects.firstWhere(
            (proj) => proj["idProjeto"] == task["projeto"]?["idProjeto"],
            orElse: () => projects[0],
          )
        : null;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Editar Tarefa"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _tituloController,
              decoration: const InputDecoration(labelText: "Título da tarefa"),
            ),
            TextField(
              controller: _descricaoController,
              decoration: const InputDecoration(labelText: "Descrição"),
            ),
            const SizedBox(height: 10),
            DropdownButton<Map<String, dynamic>>(
              isExpanded: true,
              value: _selectedProject,
              items: projects
                  .map((proj) => DropdownMenuItem(
                        value: proj,
                        child: Text(proj["nome"] ?? "Projeto sem nome"),
                      ))
                  .toList(),
              onChanged: (proj) {
                setState(() => _selectedProject = proj);
              },
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
          ElevatedButton(
            onPressed: () {
              final updatedTask = {
                "titulo": _tituloController.text,
                "descricao": _descricaoController.text,
                "idProjeto": _selectedProject?["idProjeto"], // só o ID
                "status": task["status"] ?? "Pendente",
                "prioridade": task["prioridade"] ?? "Média",
              };
              _updateTask(task["idTarefa"], updatedTask);
              Navigator.pop(context);
            },
            child: const Text("Salvar"),
          ),
        ],
      ),
    );
  }

  // 🔹 BUILD
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : tasks.isEmpty
              ? const Center(child: Text("Nenhuma tarefa cadastrada"))
              : ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) => Card(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: ListTile(
                      title: Text(tasks[index]["titulo"] ?? "Sem título"),
                      subtitle: Text(tasks[index]["descricao"] ?? "Sem descrição"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _showEditTaskDialog(tasks[index]),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.redAccent),
                            onPressed: () => _deleteTask(tasks[index]['idTarefa']),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        heroTag: 'tasksFAB',
        child: const Icon(Icons.add),
      ),
    );
  }
}
