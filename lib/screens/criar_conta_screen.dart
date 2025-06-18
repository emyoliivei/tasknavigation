import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CriarContaScreen extends StatefulWidget {
  const CriarContaScreen({super.key});

  @override
  State<CriarContaScreen> createState() => _CriarContaScreenState();
}

class _CriarContaScreenState extends State<CriarContaScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeInAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nomeController.dispose();
    _emailController.dispose();
    _usuarioController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  void _criarConta() {
    if (_formKey.currentState!.validate()) {
      // Simula sucesso na criação
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Conta criada com sucesso!')),
      );
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF8E24AA);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [ Color.fromARGB(255, 76, 26, 122),
              Color.fromARGB(255, 104, 24, 126),],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          FadeTransition(
            opacity: _fadeInAnimation,
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.person_add_alt_1, size: 60, color: primaryColor),
                        const SizedBox(height: 20),
                        Text(
                          'Criar Conta',
                          style: GoogleFonts.montserrat(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Nome
                        TextFormField(
                          controller: _nomeController,
                          decoration: _buildInputDecoration('Nome completo', Icons.person),
                          validator: (value) => value == null || value.isEmpty ? 'Informe seu nome' : null,
                        ),
                        const SizedBox(height: 16),

                        // Email
                        TextFormField(
                          controller: _emailController,
                          decoration: _buildInputDecoration('Email', Icons.email_outlined),
                          validator: (value) => value == null || !value.contains('@') ? 'Email inválido' : null,
                        ),
                        const SizedBox(height: 16),

                        // Usuário
                        TextFormField(
                          controller: _usuarioController,
                          decoration: _buildInputDecoration('Usuário', Icons.person_outline),
                          validator: (value) => value == null || value.isEmpty ? 'Informe o usuário' : null,
                        ),
                        const SizedBox(height: 16),

                        // Senha
                        TextFormField(
                          controller: _senhaController,
                          obscureText: true,
                          decoration: _buildInputDecoration('Senha', Icons.lock_outline),
                          validator: (value) => value == null || value.length < 4 ? 'Senha muito curta' : null,
                        ),
                        const SizedBox(height: 28),

                        // Botão Cadastrar
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _criarConta,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            ),
                            child: Text(
                              'Cadastrar',
                              style: GoogleFonts.montserrat(fontSize: 18, color: Colors.white),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Voltar ao login
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'Voltar ao Login',
                            style: GoogleFonts.montserrat(
                              color: primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: const Color(0xFF8E24AA)),
      filled: true,
      fillColor: Colors.deepPurple.shade50,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFF8E24AA), width: 2),
      ),
    );
  }
}
