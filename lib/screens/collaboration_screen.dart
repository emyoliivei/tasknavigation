import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CollaborationScreen extends StatelessWidget {
  const CollaborationScreen({super.key});

  final List<Map<String, String>> departments = const [
    {
      'name': 'Recursos Humanos',
      'description': 'Responsável pela gestão de pessoas, recrutamento e treinamento.',
      'chief': 'Ana Paula Souza',
      'email': 'ana.souza@empresa.com',
      'bio': 'Ana Paula tem 10 anos de experiência em RH e é especialista em desenvolvimento organizacional.',
    },
    {
      'name': 'Financeiro',
      'description': 'Gerencia o orçamento, pagamentos e contabilidade da empresa.',
      'chief': 'Carlos Eduardo Lima',
      'email': 'carlos.lima@empresa.com',
      'bio': 'Carlos é contador formado e lidera o setor financeiro com foco em eficiência e transparência.',
    },
    {
      'name': 'Tecnologia da Informação (TI)',
      'description': 'Cuida da infraestrutura tecnológica e suporte técnico.',
      'chief': 'Mariana Ribeiro',
      'email': 'mariana.ribeiro@empresa.com',
      'bio': 'Mariana é engenheira de software com vasta experiência em infraestrutura e suporte.',
    },
  ];

  Color _priorityColor(String priority) {
    switch (priority) {
      case 'Alta':
        return Colors.redAccent;
      case 'Média':
        return Colors.orangeAccent;
      case 'Baixa':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF673AB7),
        title: Text(
          'Colaboração Institucional',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: departments.length,
        itemBuilder: (context, index) {
          final dept = departments[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dept['name'] ?? '',
                    style: GoogleFonts.montserrat(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF4A148C),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    dept['description'] ?? '',
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  const Divider(height: 24, thickness: 1),
                  Text(
                    'Chefe do Setor:',
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF7B1FA2),
                    ),
                  ),
                  Text(
                    dept['chief'] ?? '',
                    style: GoogleFonts.montserrat(fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Email:',
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF7B1FA2),
                    ),
                  ),
                  Text(
                    dept['email'] ?? '',
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      color: Colors.blue.shade700,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Biografia:',
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF7B1FA2),
                    ),
                  ),
                  Text(
                    dept['bio'] ?? '',
                    style: GoogleFonts.montserrat(
                      fontSize: 15,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
