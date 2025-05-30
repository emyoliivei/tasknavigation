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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: const Color(0xFF8E24AA), // Roxo mais visível
        title: Text(
          'Colaboração Institucional',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
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
            color: isDark
                ? theme.colorScheme.surfaceVariant
                : const Color(0xFF8E24AA), // Roxo mais claro e legível
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
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    dept['description'] ?? '',
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  const Divider(height: 24, thickness: 1, color: Colors.white38),
                  Text(
                    'Chefe do Setor:',
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    dept['chief'] ?? '',
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Email:',
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    dept['email'] ?? '',
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      color: Colors.white,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Biografia:',
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    dept['bio'] ?? '',
                    style: GoogleFonts.montserrat(
                      fontSize: 15,
                      fontStyle: FontStyle.italic,
                      color: Colors.white70,
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
