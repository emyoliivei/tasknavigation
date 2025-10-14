// tasks_screen.dart (modo iOS com botão add Cupertino)
import 'package:flutter/cupertino.dart';
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

  Future<void> _loadTasks() async {
    setState(() => isLoading = true);
    try {
      final data = await ApiService.getData("/tarefas");
      setState(() {
        tasks = List<Map<String, dynamic>>.from(data);
      });
    } catch (e) {
      debugPrint("Erro ao carregar tarefas: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

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

  Future<void> _addTask() async {
    if (_tituloController.text.isEmpty || _selectedProject == null) return;

    final newTask = {
      "titulo": _tituloController.text,
      "descricao": _descricaoController.text,
      "idProjeto": _selectedProject!["idProjeto"],
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

  Future<void> _updateTask(int id, Map<String, dynamic> updatedTask) async {
    final taskToSend = {
      "titulo": updatedTask["titulo"],
      "descricao": updatedTask["descricao"],
      "status": updatedTask["status"] ?? "Pendente",
      "prioridade": updatedTask["prioridade"] ?? "Média",
      "idProjeto": updatedTask["idProjeto"],
    };

    try {
      await ApiService.putData("/tarefas/$id", taskToSend);
      _loadTasks();
    } catch (e) {
      debugPrint("Erro ao atualizar tarefa: $e");
    }
  }

  Future<void> _deleteTask(int id) async {
    try {
      await ApiService.deleteData("/tarefas/$id");
      _loadTasks();
    } catch (e) {
      debugPrint("Erro ao deletar tarefa: $e");
    }
  }

  void _showAddTaskDialog() {
    _tituloController.clear();
    _descricaoController.clear();
    _selectedProject = projects.isNotEmpty ? projects[0] : null;

    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text("Nova Tarefa"),
        content: Column(
          children: [
            const SizedBox(height: 10),
            CupertinoTextField(
              controller: _tituloController,
              placeholder: "Título da tarefa",
            ),
            const SizedBox(height: 10),
            CupertinoTextField(
              controller: _descricaoController,
              placeholder: "Descrição",
            ),
            const SizedBox(height: 10),
            CupertinoPicker(
              itemExtent: 32.0,
              onSelectedItemChanged: (index) {
                setState(() => _selectedProject = projects[index]);
              },
              children: projects
                  .map((proj) =>
                      Text(proj["nome"] ?? "Projeto sem nome"))
                  .toList(),
            ),
          ],
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text("Cancelar"),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text("Adicionar"),
            onPressed: () {
              _addTask();
              Navigator.pop(context);
            },
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
            (proj) =>
                proj["idProjeto"] == task["projeto"]?["idProjeto"],
            orElse: () => projects[0],
          )
        : null;

    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text("Editar Tarefa"),
        content: Column(
          children: [
            const SizedBox(height: 10),
            CupertinoTextField(
              controller: _tituloController,
              placeholder: "Título da tarefa",
            ),
            const SizedBox(height: 10),
            CupertinoTextField(
              controller: _descricaoController,
              placeholder: "Descrição",
            ),
            const SizedBox(height: 10),
            CupertinoPicker(
              itemExtent: 32.0,
              onSelectedItemChanged: (index) {
                setState(() => _selectedProject = projects[index]);
              },
              children: projects
                  .map((proj) =>
                      Text(proj["nome"] ?? "Projeto sem nome"))
                  .toList(),
            ),
          ],
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text("Cancelar"),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text("Salvar"),
            onPressed: () {
              final updatedTask = {
                "titulo": _tituloController.text,
                "descricao": _descricaoController.text,
                "idProjeto": _selectedProject?["idProjeto"],
                "status": task["status"] ?? "Pendente",
                "prioridade": task["prioridade"] ?? "Média",
              };
              _updateTask(task["idTarefa"], updatedTask);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final backgroundColor = isDark
        ? const Color.fromARGB(255, 36, 36, 36)
        : Colors.white;

    final cardColor = isDark
        ? const Color.fromARGB(255, 27, 27, 27)
        : CupertinoColors.systemBackground;

    final textColor = isDark ? Colors.white : Colors.black;

    return CupertinoPageScaffold(
      backgroundColor: backgroundColor,
      navigationBar: const CupertinoNavigationBar(
        middle: Text(
          'Tarefas',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            isLoading
                ? const Center(child: CupertinoActivityIndicator())
                : tasks.isEmpty
                    ? Center(
                        child: Text(
                          "Nenhuma tarefa cadastrada",
                          style: GoogleFonts.montserrat(
                            color: textColor.withOpacity(0.7),
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          final task = tasks[index];
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                              color: cardColor,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: isDark
                                      ? Colors.black.withOpacity(0.3)
                                      : Colors.grey.withOpacity(0.2),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ListTile(
                              title: Text(
                                task["titulo"] ?? "Sem título",
                                style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w600,
                                  color: textColor,
                                ),
                              ),
                              subtitle: Text(
                                task["descricao"] ?? "Sem descrição",
                                style: GoogleFonts.montserrat(
                                  color: textColor.withOpacity(0.8),
                                ),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CupertinoButton(
                                    padding: EdgeInsets.zero,
                                    child: const Icon(
                                      CupertinoIcons.pencil,
                                      color: CupertinoColors.activeBlue,
                                    ),
                                    onPressed: () =>
                                        _showEditTaskDialog(tasks[index]),
                                  ),
                                  CupertinoButton(
                                    padding: EdgeInsets.zero,
                                    child: const Icon(
                                      CupertinoIcons.delete,
                                      color: CupertinoColors.destructiveRed,
                                    ),
                                    onPressed: () =>
                                        _deleteTask(tasks[index]['idTarefa']),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
            Positioned(
              bottom: 20,
              right: 20,
              child: CupertinoButton.filled(
                padding: const EdgeInsets.all(16),
                borderRadius: BorderRadius.circular(30),
                child: const Icon(CupertinoIcons.add),
                onPressed: _showAddTaskDialog,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
