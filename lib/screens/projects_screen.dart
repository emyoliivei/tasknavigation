import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProjectsScreen extends StatefulWidget {
  @override
  _ProjectsScreenState createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  List<Map<String, String>> projects = [
    {
      'title': 'Projeto 1',
      'project': 'Fazer planilha',
      'date': '2025-05-27',
    },
  ];

  String filter = '';
  final _formKey = GlobalKey<FormState>();
  String _editTitle = '';
  String _editProject = '';
  DateTime _editDate = DateTime.now();

  bool get isDark => Theme.of(context).brightness == Brightness.dark;

  void _openProjectDialog({int? index}) {
    if (index != null) {
      _editTitle = projects[index]['title']!;
      _editProject = projects[index]['project']!;
      _editDate = DateTime.tryParse(projects[index]['date']!) ?? DateTime.now();
    } else {
      _editTitle = '';
      _editProject = '';
      _editDate = DateTime.now();
    }

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: isDark ? Colors.deepPurple[900] : Colors.white,
          title: Text(
            index == null ? 'Novo Projeto' : 'Editar Projeto',
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: _editTitle,
                  style: TextStyle(color: isDark ? Colors.white : Colors.black),
                  decoration: InputDecoration(
                    labelText: 'Título',
                    labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.grey[700]),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: isDark ? Colors.white54 : Colors.grey),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: const Color(0xFF8E24AA)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Digite o título' : null,
                  onChanged: (value) => _editTitle = value,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: _editProject,
                  style: TextStyle(color: isDark ? Colors.white : Colors.black),
                  decoration: InputDecoration(
                    labelText: 'Nome do Projeto',
                    labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.grey[700]),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: isDark ? Colors.white54 : Colors.grey),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: const Color(0xFF8E24AA)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Digite o nome' : null,
                  onChanged: (value) => _editProject = value,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Data: ${_editDate.toString().split(' ')[0]}',
                        style: TextStyle(color: isDark ? Colors.white70 : Colors.black87),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _editDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: isDark
                                    ? const ColorScheme.dark(
                                        primary: Color(0xFF8E24AA),
                                        onPrimary: Colors.white,
                                        surface: Color(0xFF8E24AA),
                                        onSurface: Colors.white,
                                      )
                                    : const ColorScheme.light(),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (picked != null) {
                          setState(() => _editDate = picked);
                        }
                      },
                      child: Text(
                        'Selecionar Data',
                        style: TextStyle(color: const Color(0xFF8E24AA)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar',
                  style: TextStyle(color: isDark ? Colors.white70 : Colors.black87)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8E24AA)),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    final projectData = {
                      'title': _editTitle,
                      'project': _editProject,
                      'date': _editDate.toString().split(' ')[0],
                    };
                    if (index == null) {
                      projects.add(projectData);
                    } else {
                      projects[index] = projectData;
                    }
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

  void _deleteProject(int index) {
    setState(() => projects.removeAt(index));
  }

  void _uploadProject() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Upload simulado')),
    );
  }

  void _downloadProject(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Download de "${projects[index]['title']}"')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = projects.where((p) {
      final query = filter.toLowerCase();
      return p['title']!.toLowerCase().contains(query) ||
          p['project']!.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF8E24AA),
        title: Text(
          'Projetos',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,  // Removendo seta de voltar
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              style: TextStyle(color: isDark ? Colors.white : Colors.black87),
              decoration: InputDecoration(
                labelText: 'Buscar projeto',
                labelStyle: TextStyle(color: isDark ? Colors.grey : const Color.fromARGB(255, 63, 60, 60)),
                prefixIcon: Icon(Icons.search, color: isDark ? Colors.white : Colors.black),
                filled: isDark,
                fillColor: isDark ? Colors.white10 : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) => setState(() => filter = value),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final project = filtered[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: isDark ? Colors.grey[850] : Colors.grey[100],
                  child: ListTile(
                    title: Text(
                      project['title'] ?? '',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.grey[300] : Colors.black,
                      ),
                    ),
                    subtitle: Text(
                      '${project['project']} - ${project['date']}',
                      style: TextStyle(
                        color: isDark ? Colors.grey[400] : Colors.black87,
                      ),
                    ),
                    leading: Icon(
                      Icons.folder,
                      color: isDark ? Colors.grey[300] : Colors.deepPurple,
                    ),
                    trailing: PopupMenuButton<String>(
                      icon: Icon(
                        Icons.more_vert,
                        color: isDark ? Colors.grey[300] : Colors.deepPurple,
                      ),
                      onSelected: (value) {
                        if (value == 'edit') {
                          _openProjectDialog(index: index);
                        } else if (value == 'delete') {
                          _deleteProject(index);
                        } else if (value == 'download') {
                          _downloadProject(index);
                        } else if (value == 'upload') {
                          _uploadProject();
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: 'edit', child: Text('Editar')),
                        const PopupMenuItem(value: 'upload', child: Text('Upload')),
                        const PopupMenuItem(value: 'download', child: Text('Download')),
                        const PopupMenuItem(value: 'delete', child: Text('Deletar')),
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
        onPressed: () => _openProjectDialog(),
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add),
      ),
    );
  }
}


