import 'package:flutter/cupertino.dart';
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

    // mesmo cinza escuro da tela de configurações
    final backgroundColor = isDark
        ? const Color.fromARGB(255, 36, 36, 36)
        : CupertinoColors.systemGroupedBackground;
    final navBarColor = isDark
        ? const Color.fromARGB(255, 36, 36, 36)
        : CupertinoColors.systemGrey6;
    final cardColor = isDark
        ? const Color.fromARGB(255, 27, 27, 27)
        : CupertinoColors.systemBackground;
    final primaryTextColor = isDark ? Colors.white : Colors.black;
    final secondaryTextColor = isDark ? Colors.white70 : Colors.black87;
    final labelTextColor = isDark ? Colors.white : Colors.black;

    return CupertinoPageScaffold(
      backgroundColor: backgroundColor,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: navBarColor.withOpacity(0.95),
        border: Border.all(color: Colors.transparent),
        middle: const Text(
          'Colaboração',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      child: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemCount: departments.length,
          itemBuilder: (context, index) {
            final dept = departments[index];
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
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
                        color: primaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      dept['description'] ?? '',
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        color: secondaryTextColor,
                      ),
                    ),
                    const Divider(height: 24, thickness: 0.8),
                    Text(
                      'Chefe do Setor:',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w600,
                        color: labelTextColor,
                      ),
                    ),
                    Text(
                      dept['chief'] ?? '',
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        color: secondaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Email:',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w600,
                        color: labelTextColor,
                      ),
                    ),
                    Text(
                      dept['email'] ?? '',
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        color: secondaryTextColor,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Biografia:',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w600,
                        color: labelTextColor,
                      ),
                    ),
                    Text(
                      dept['bio'] ?? '',
                      style: GoogleFonts.montserrat(
                        fontSize: 15,
                        fontStyle: FontStyle.italic,
                        color: secondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
