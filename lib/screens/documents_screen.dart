import 'package:flutter/material.dart';

class DocumentsScreen extends StatefulWidget {
  @override
  _DocumentsScreenState createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  List<Map<String, String>> documents = [
    {
      'title': 'Documento 1',
      'project': 'Fazer planilha',
      'date': '2025-05-27',
    },
  ];

  String filter = '';

  void _addDocument() {
    setState(() {
      documents.add({
        'title': 'Novo Documento',
        'project': 'Novo Projeto',
        'date': DateTime.now().toString().split(' ')[0],
      });
    });
  }

  void _deleteDocument(int index) {
    setState(() {
      documents.removeAt(index);
    });
  }

  void _uploadDocument() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Upload simulado')),
    );
  }

  void _downloadDocument(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Download de "${documents[index]['title']}"')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredDocs = documents
        .where((doc) => doc['title']!.toLowerCase().contains(filter.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/relatorios');
          },
        ),
        title: Text(''),
        actions: [
          IconButton(
            icon: Icon(Icons.upload_file),
            onPressed: _uploadDocument,
            tooltip: 'Upload de Documento',
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _addDocument,
            tooltip: 'Adicionar Documento',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Filtrar documentos',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => setState(() => filter = value),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredDocs.length,
              itemBuilder: (context, index) {
                final doc = filteredDocs[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(doc['title']!),
                    subtitle: Text('Projeto: ${doc['project']} \nData: ${doc['date']}'),
                    isThreeLine: true,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.download),
                          onPressed: () => _downloadDocument(index),
                          tooltip: 'Download',
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteDocument(index),
                          tooltip: 'Deletar',
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
    );
  }
}
