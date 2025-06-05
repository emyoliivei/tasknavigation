import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF8E24AA);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF8E24AA),
        centerTitle: true,
        automaticallyImplyLeading: false, // remove seta de voltar
        title: Text(
          'Relatórios',
          style: GoogleFonts.montserrat(
            color: const Color.fromARGB(255, 255, 255, 255),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                  ),
                ),
                DropdownButton<String>(
                  value: 'Todos',
                  items: const [
                    DropdownMenuItem(value: 'Todos', child: Text('Todos')),
                    DropdownMenuItem(value: 'Mensal', child: Text('Mensal')),
                    DropdownMenuItem(value: 'Semanal', child: Text('Semanal')),
                    DropdownMenuItem(value: 'Projetos', child: Text('Projetos')),
                  ],
                  onChanged: (value) {
                    // TODO: Implementar filtro real
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Lista de relatórios
            Expanded(
              child: ListView.builder(
                itemCount: 5, // Lista simulada
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: Text(
                        'Relatório ${index + 1}',
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        'Resumo do relatório ${index + 1}.',
                        style: GoogleFonts.montserrat(),
                      ),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) {
                          //  Implementar ações
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'ver',
                            child: Text('Ver Detalhes'),
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
                onPressed: () {
                  //  Criar novo relatório
                },
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
  

