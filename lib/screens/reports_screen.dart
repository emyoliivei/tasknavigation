import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final Color primaryColor = const Color(0xFF8E24AA);

  List<Map<String, dynamic>> _reports = [
    {
      'title': 'Relatório Mensal - Maio',
      'summary': 'Resumo do relatório mensal de Maio.',
      'category': 'Mensal',
      'date': DateTime.now().subtract(const Duration(days: 3)),
    },
    {
      'title': 'Relatório Semanal - Semana 22',
      'summary': 'Resumo da semana 22.',
      'category': 'Semanal',
      'date': DateTime.now().subtract(const Duration(days: 10)),
    },
    {
      'title': 'Relatório de Projeto X',
      'summary': 'Status do Projeto X.',
      'category': 'Projetos',
      'date': DateTime.now().subtract(const Duration(days: 20)),
    },
  ];

  String _filter = 'Todos';
  List<Map<String, dynamic>> _filteredReports = [];

  @override
  void initState() {
    super.initState();
    _filteredReports = List.from(_reports);
  }

  void _filterReports(String category) {
    setState(() {
      _filter = category;
      if (category == 'Todos') {
        _filteredReports = List.from(_reports);
      } else {
        _filteredReports =
            _reports.where((r) => r['category'] == category).toList();
      }
    });
  }

  Future<void> _showReportDialog({int? index}) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    String title = index == null ? '' : _filteredReports[index]['title'];
    String summary = index == null ? '' : _filteredReports[index]['summary'];
    String category = index == null ? 'Mensal' : _filteredReports[index]['category'];
    DateTime date = index == null
        ? DateTime.now()
        : _filteredReports[index]['date'];

    final _formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDark ? Colors.grey[900] : Colors.white,
          title: Text(
            index == null ? 'Novo Relatório' : 'Editar Relatório',
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: StatefulBuilder(
            builder: (context, setStateDialog) {
              return Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        initialValue: title,
                        style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                        decoration: InputDecoration(
                          labelText: 'Título',
                          labelStyle:
                              TextStyle(color: isDark ? Colors.white70 : Colors.grey[700]),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: isDark ? Colors.white54 : Colors.grey),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: primaryColor),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Digite o título' : null,
                        onChanged: (value) => title = value,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        initialValue: summary,
                        maxLines: 3,
                        style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                        decoration: InputDecoration(
                          labelText: 'Resumo',
                          labelStyle:
                              TextStyle(color: isDark ? Colors.white70 : Colors.grey[700]),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: isDark ? Colors.white54 : Colors.grey),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: primaryColor),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Digite o resumo' : null,
                        onChanged: (value) => summary = value,
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: category,
                        items: const [
                          DropdownMenuItem(value: 'Mensal', child: Text('Mensal')),
                          DropdownMenuItem(value: 'Semanal', child: Text('Semanal')),
                          DropdownMenuItem(value: 'Projetos', child: Text('Projetos')),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setStateDialog(() {
                              category = value;
                            });
                          }
                        },
                        decoration: InputDecoration(
                          labelText: 'Categoria',
                          labelStyle:
                              TextStyle(color: isDark ? Colors.white70 : Colors.grey[700]),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: isDark ? Colors.white54 : Colors.grey),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: primaryColor),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        dropdownColor: isDark ? Colors.grey[900] : Colors.white,
                        style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Data: ${date.toLocal().toString().split(' ')[0]}',
                              style:
                                  TextStyle(color: isDark ? Colors.white70 : Colors.black87),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: date,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                                builder: (context, child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      colorScheme: isDark
                                          ? ColorScheme.dark(
                                              primary: primaryColor,
                                              onPrimary: Colors.white,
                                              surface: primaryColor,
                                              onSurface: Colors.white,
                                            )
                                          : ColorScheme.light(),
                                    ),
                                    child: child!,
                                  );
                                },
                              );
                              if (picked != null) {
                                setStateDialog(() {
                                  date = picked;
                                });
                              }
                            },
                            child: Text(
                              'Selecionar',
                              style: TextStyle(color: primaryColor),
                            ),
                          ),
                        ],
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
              child: Text(
                'Cancelar',
                style: TextStyle(color: isDark ? Colors.white70 : Colors.black87),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    if (index == null) {
                      _reports.add({
                        'title': title,
                        'summary': summary,
                        'category': category,
                        'date': date,
                      });
                    } else {
                      int realIndex = _reports.indexOf(_filteredReports[index]);
                      _reports[realIndex] = {
                        'title': title,
                        'summary': summary,
                        'category': category,
                        'date': date,
                      };
                    }
                    _filterReports(_filter);
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text(
                'Salvar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _deleteReport(int index) {
    setState(() {
      final reportToRemove = _filteredReports[index];
      _reports.remove(reportToRemove);
      _filterReports(_filter);
    });
  }

  void _viewDetails(int index) {
    final report = _filteredReports[index];
    showDialog(
      context: context,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark ? Colors.grey[900] : Colors.white,
          title: Text(
            report['title'],
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Text(
              report['summary'],
              style: TextStyle(color: isDark ? Colors.white70 : Colors.black87),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Fechar',
                style: TextStyle(color: isDark ? Colors.white70 : Colors.black87),
              ),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'Relatórios',
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Filtro de relatórios
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filtrar por:',
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),
                DropdownButton<String>(
                  value: _filter,
                  dropdownColor: isDark ? Colors.grey[900] : Colors.white,
                  items: const [
                    DropdownMenuItem(value: 'Todos', child: Text('Todos')),
                    DropdownMenuItem(value: 'Mensal', child: Text('Mensal')),
                    DropdownMenuItem(value: 'Semanal', child: Text('Semanal')),
                    DropdownMenuItem(value: 'Projetos', child: Text('Projetos')),
                  ],
                  onChanged: (value) {
                    if (value != null) _filterReports(value);
                  },
                  style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Lista de relatórios
            Expanded(
              child: _filteredReports.isEmpty
                  ? Center(
                      child: Text(
                        'Nenhum relatório encontrado.',
                        style: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _filteredReports.length,
                      itemBuilder: (context, index) {
                        final report = _filteredReports[index];
                        return Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            title: Text(
                              report['title'],
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Text(
                              report['summary'],
                              style: GoogleFonts.montserrat(),
                            ),
                            trailing: PopupMenuButton<String>(
                              onSelected: (value) {
                                if (value == 'ver') {
                                  _viewDetails(index);
                                } else if (value == 'deletar') {
                                  _deleteReport(index);
                                } else if (value == 'editar') {
                                  _showReportDialog(index: index);
                                }
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'ver',
                                  child: Text('Ver Detalhes'),
                                ),
                                const PopupMenuItem(
                                  value: 'editar',
                                  child: Text('Editar'),
                                ),
                                const PopupMenuItem(
                                  value: 'deletar',
                                  child: Text('Excluir'),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            // Botão de novo relatório
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showReportDialog(),
                icon: const Icon(Icons.add),
                label: Text(
                  'Novo Relatório',
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
