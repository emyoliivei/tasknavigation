import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  List<Map<String, dynamic>> projects = [];
  bool isLoading = true;

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _prazoController = TextEditingController();

  String? _status;
  String? _prioridade;

  final List<String> _statusOptions = ["Pendente", "Em andamento", "Concluído"];
  final List<String> _prioridadeOptions = ["Baixa", "Média", "Alta"];

  @override
  void initState() {
    super.initState();
    _loadProjects();
  }

  // 🔹 CARREGAR PROJETOS
  Future<void> _loadProjects() async {
    setState(() => isLoading = true);
    try {
      final data = await ApiService.getData("/projetos");
      setState(() {
        projects = List<Map<String, dynamic>>.from(data);
      });
    } catch (e) {
      debugPrint("Erro ao carregar projetos: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  // 🔹 ADICIONAR PROJETO
  Future<void> _addProject() async {
    if (_nomeController.text.isEmpty) return;

    final newProject = {
      "nome": _nomeController.text,
      "descricao": _descricaoController.text,
      "status": _status,
      "prioridade": _prioridade,
      "prazo": _prazoController.text,
    };

    try {
      await ApiService.postData("/projetos", newProject);
      _clearForm();
      _loadProjects();
    } catch (e) {
      debugPrint("Erro ao criar projeto: $e");
    }
  }

  // 🔹 ATUALIZAR PROJETO
  Future<void> _updateProject(int id, Map<String, dynamic> updatedProject) async {
    try {
      await ApiService.putData("/projetos/$id", updatedProject);
      _loadProjects();
    } catch (e) {
      debugPrint("Erro ao atualizar projeto: $e");
    }
  }

  // 🔹 DELETAR PROJETO
  Future<void> _deleteProject(int id) async {
    try {
      await ApiService.deleteData("/projetos/$id");
      _loadProjects();
    } catch (e) {
      debugPrint("Erro ao deletar projeto: $e");
    }
  }

  // 🔹 LIMPAR FORM
  void _clearForm() {
    _nomeController.clear();
    _descricaoController.clear();
    _prazoController.clear();
    _status = null;
    _prioridade = null;
  }

  // 🔹 DIALOG - CRIAR
  void _showAddProjectDialog() {
    _clearForm();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Novo Projeto"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: "Título"),
              ),
              TextField(
                controller: _descricaoController,
                decoration: const InputDecoration(labelText: "Descrição"),
              ),
              DropdownButtonFormField<String>(
                value: _status,
                items: _statusOptions
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (v) => setState(() => _status = v),
                decoration: const InputDecoration(labelText: "Status"),
              ),
              DropdownButtonFormField<String>(
                value: _prioridade,
                items: _prioridadeOptions
                    .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                    .toList(),
                onChanged: (v) => setState(() => _prioridade = v),
                decoration: const InputDecoration(labelText: "Prioridade"),
              ),
              TextField(
                controller: _prazoController,
                decoration: const InputDecoration(labelText: "Prazo (YYYY-MM-DD)"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
          ElevatedButton(
            onPressed: () {
              _addProject();
              Navigator.pop(context);
            },
            child: const Text("Salvar"),
          ),
        ],
      ),
    );
  }

  // 🔹 DIALOG - EDITAR
  void _showEditProjectDialog(Map<String, dynamic> project) {
    _nomeController.text = project["nome"] ?? "";
    _descricaoController.text = project["descricao"] ?? "";
    _status = project["status"];
    _prioridade = project["prioridade"];
    _prazoController.text = project["prazo"] ?? "";

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Editar Projeto"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: "Título"),
              ),
              TextField(
                controller: _descricaoController,
                decoration: const InputDecoration(labelText: "Descrição"),
              ),
              DropdownButtonFormField<String>(
                value: _status,
                items: _statusOptions
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (v) => setState(() => _status = v),
                decoration: const InputDecoration(labelText: "Status"),
              ),
              DropdownButtonFormField<String>(
                value: _prioridade,
                items: _prioridadeOptions
                    .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                    .toList(),
                onChanged: (v) => setState(() => _prioridade = v),
                decoration: const InputDecoration(labelText: "Prioridade"),
              ),
              TextField(
                controller: _prazoController,
                decoration: const InputDecoration(labelText: "Prazo (YYYY-MM-DD)"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
          ElevatedButton(
            onPressed: () {
              final updatedProject = {
                "nome": _nomeController.text,
                "descricao": _descricaoController.text,
                "status": _status,
                "prioridade": _prioridade,
                "prazo": _prazoController.text,
              };
              _updateProject(project["idProjeto"], updatedProject);
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
          : projects.isEmpty
              ? const Center(child: Text("Nenhum projeto cadastrado"))
              : ListView.builder(
                  itemCount: projects.length,
                  itemBuilder: (context, index) => Card(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: ListTile(
                      title: Text(projects[index]["nome"] ?? "Sem nome"),
                      subtitle: Text(projects[index]["descricao"] ?? "Sem descrição"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _showEditProjectDialog(projects[index]),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.redAccent),
                            onPressed: () => _deleteProject(projects[index]['idProjeto']),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddProjectDialog,
        heroTag: 'projectsFAB',
        child: const Icon(Icons.add),
      ),
    );
  }
}
