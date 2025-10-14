import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../main.dart';
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

  @override
  void initState() {
    super.initState();
    _loadProjects();
  }

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

  Future<void> _addProject() async {
    if (_nomeController.text.isEmpty) return;

    final newProject = {
      "nome": _nomeController.text,
      "descricao": _descricaoController.text,
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

  Future<void> _updateProject(int id, Map<String, dynamic> updatedProject) async {
    try {
      await ApiService.putData("/projetos/$id", updatedProject);
      _loadProjects();
    } catch (e) {
      debugPrint("Erro ao atualizar projeto: $e");
    }
  }

  Future<void> _deleteProject(int id) async {
    try {
      await ApiService.deleteData("/projetos/$id");
      _loadProjects();
    } catch (e) {
      debugPrint("Erro ao deletar projeto: $e");
    }
  }

  void _clearForm() {
    _nomeController.clear();
    _descricaoController.clear();
    _prazoController.clear();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate = DateTime.tryParse(_prazoController.text) ?? DateTime.now();

    showCupertinoModalPopup(
      context: context,
      builder: (_) => CupertinoPopupSurface(
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 260,
            child: Column(
              children: [
                Expanded(
                  child: CupertinoDatePicker(
                    initialDateTime: initialDate,
                    mode: CupertinoDatePickerMode.date,
                    onDateTimeChanged: (DateTime newDate) {
                      _prazoController.text = newDate.toIso8601String().split('T')[0];
                    },
                  ),
                ),
                CupertinoButton(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: const Text("OK", style: TextStyle(color: Color(0xFFAB47BC))),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAddProjectDialog() {
    _clearForm();
    showCupertinoDialog(
      context: context,
      builder: (context) => _buildProjectDialog(title: "Novo Projeto", onSave: _addProject),
    );
  }

  void _showEditProjectDialog(Map<String, dynamic> project) {
    _nomeController.text = project["nome"] ?? "";
    _descricaoController.text = project["descricao"] ?? "";
    _prazoController.text = project["prazo"] ?? "";

    showCupertinoDialog(
      context: context,
      builder: (context) => _buildProjectDialog(
        title: "Editar Projeto",
        onSave: () {
          final updatedProject = {
            "nome": _nomeController.text,
            "descricao": _descricaoController.text,
            "prazo": _prazoController.text,
          };
          _updateProject(project["idProjeto"], updatedProject);
        },
      ),
    );
  }

  Widget _buildProjectDialog({required String title, required VoidCallback onSave}) {
    final isDark = TaskNavigationApp.themeNotifier.value == ThemeMode.dark;
    final cardColor = isDark ? CupertinoColors.darkBackgroundGray : CupertinoColors.white;
    final textColor = isDark ? CupertinoColors.white : CupertinoColors.black;

    return CupertinoAlertDialog(
      title: Text(title, style: TextStyle(color: textColor)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          CupertinoTextField(
            controller: _nomeController,
            placeholder: "Título",
            style: TextStyle(color: textColor),
            prefix: Padding(
              padding: const EdgeInsets.only(left: 6.0),
              child: Icon(CupertinoIcons.textformat, color: const Color(0xFFAB47BC)),
            ),
            decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(12)),
          ),
          const SizedBox(height: 10),
          CupertinoTextField(
            controller: _descricaoController,
            placeholder: "Descrição",
            style: TextStyle(color: textColor),
            maxLines: 2,
            prefix: Padding(
              padding: const EdgeInsets.only(left: 6.0),
              child: Icon(CupertinoIcons.doc_text, color: const Color(0xFFAB47BC)),
            ),
            decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(12)),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () => _selectDate(context),
            child: AbsorbPointer(
              child: CupertinoTextField(
                controller: _prazoController,
                placeholder: "Data do projeto",
                style: TextStyle(color: textColor),
                prefix: Padding(
                  padding: const EdgeInsets.only(left: 6.0),
                  child: Icon(CupertinoIcons.calendar, color: const Color(0xFFAB47BC)),
                ),
                decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
      actions: [
        CupertinoDialogAction(child: const Text("Cancelar"), onPressed: () => Navigator.pop(context)),
        CupertinoDialogAction(isDefaultAction: true, child: const Text("Salvar"), onPressed: () {
          onSave();
          Navigator.pop(context);
        }),
      ],
    );
  }

  Widget _buildProjectTile(Map<String, dynamic> project) {
    final prazo = project["prazo"] ?? "";
    final descricao = project["descricao"] ?? "";
    final isDark = TaskNavigationApp.themeNotifier.value == ThemeMode.dark;
    final cardColor = isDark ? CupertinoColors.darkBackgroundGray : CupertinoColors.white;
    final textColor = isDark ? CupertinoColors.white : CupertinoColors.black;
    final subtitleColor = isDark ? CupertinoColors.systemGrey : CupertinoColors.systemGrey2;

    return Container(
      decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        leading: CircleAvatar(
          radius: 18,
          backgroundColor: const Color(0xFFAB47BC),
          child: const Icon(CupertinoIcons.folder_fill, color: Colors.white, size: 18),
        ),
        title: Text(project["nome"] ?? "Sem nome", style: TextStyle(fontWeight: FontWeight.w600, color: textColor)),
        subtitle: Text(
          descricao.isNotEmpty ? "$descricao\nPrazo: $prazo" : "Prazo: $prazo",
          style: TextStyle(color: subtitleColor),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () => _showEditProjectDialog(project),
              child: const Icon(CupertinoIcons.pencil, color: Color(0xFFAB47BC)),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () => _deleteProject(project['idProjeto']),
              child: const Icon(CupertinoIcons.delete, color: CupertinoColors.systemRed),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = TaskNavigationApp.themeNotifier.value == ThemeMode.dark;
    final backgroundColor = isDark ? CupertinoColors.black : CupertinoColors.systemGroupedBackground;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          "Projetos",
          style: TextStyle(fontWeight: FontWeight.w600, color: isDark ? CupertinoColors.white : CupertinoColors.black),
        ),
        backgroundColor: backgroundColor,
      ),
      child: SafeArea(
        child: Stack(
          children: [
            Container(
              color: backgroundColor,
              child: isLoading
                  ? const Center(child: CupertinoActivityIndicator())
                  : ListView(
                      children: [
                        const SizedBox(height: 16),
                        if (projects.isEmpty)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Text(
                                "Nenhum projeto cadastrado",
                                style: TextStyle(color: CupertinoColors.systemGrey),
                              ),
                            ),
                          ),
                        for (var project in projects) _buildProjectTile(project),
                        const SizedBox(height: 100),
                      ],
                    ),
            ),
            Positioned(
              bottom: 30,
              right: 20,
              child: GestureDetector(
                onTap: _showAddProjectDialog,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFAB47BC),
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: const Color(0xFFAB47BC).withOpacity(0.4), blurRadius: 10, offset: const Offset(0, 3))],
                  ),
                  child: const Icon(CupertinoIcons.add, color: Colors.white, size: 28),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
