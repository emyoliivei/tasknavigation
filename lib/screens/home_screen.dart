import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 76, 26, 122),
              Color.fromARGB(255, 104, 24, 126),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // LOGO MAIOR
                  SizedBox(
                    width: 230,
                    height: 230,
                    child: Image.asset(
                      'assets/logo_moderna.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Texto com fonte League Spartan
                  Text(
                    'Task Navigation',
                    style: GoogleFonts.leagueSpartan(
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Subtítulo com fonte Sans Serif clean
                  Text(
                    'Seja bem-vindo(a) à Task Navigation! a plataforma ideal para gerenciar as tarefas administrativas do seu aplicativo. Com uma interface intuitiva, você pode organizar, monitorar e otimizar processos de forma eficiente.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.openSans(
                      textStyle: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 36),

                  // Botão estiloso
                  ElevatedButton.icon(
                    icon: const Icon(Icons.arrow_forward),
                    label: Text(
                      'Get Started',
                      style: GoogleFonts.openSans(
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF8E24AA),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 8,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
