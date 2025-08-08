import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;

  bool _loading = false;
  String? _erro;

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
    _usuarioController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  void _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _erro = null;
    });

    // Simulação de login local
    await Future.delayed(const Duration(seconds: 1)); // efeito de "carregando"

    setState(() {
      _loading = false;
    });

    if (_usuarioController.text.trim() == "admin" &&
        _senhaController.text.trim() == "1234") {
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      setState(() {
        _erro = 'Usuário ou senha inválidos';
      });
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
                colors: [
                  Color.fromARGB(255, 76, 26, 122),
                  Color.fromARGB(255, 104, 24, 126),
                ],
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
                        Icon(Icons.lock_outline, size: 60, color: primaryColor),
                        const SizedBox(height: 20),
                        Text(
                          'Login',
                          style: GoogleFonts.montserrat(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Usuário
                        TextFormField(
                          controller: _usuarioController,
                          decoration: _buildInputDecoration('Usuário', Icons.person_outline),
                          validator: (value) =>
                              value == null || value.isEmpty ? 'Informe o usuário' : null,
                        ),
                        const SizedBox(height: 16),

                        // Senha
                        TextFormField(
                          controller: _senhaController,
                          obscureText: true,
                          decoration: _buildInputDecoration('Senha', Icons.lock_outline),
                          validator: (value) =>
                              value == null || value.length < 4 ? 'Senha muito curta' : null,
                        ),
                        const SizedBox(height: 20),

                        if (_erro != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Text(
                              _erro!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),

                        // Botão Entrar
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: _loading
                              ? const Center(child: CircularProgressIndicator())
                              : ElevatedButton(
                                  onPressed: _login,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  child: Text(
                                    'Entrar',
                                    style: GoogleFonts.montserrat(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                        ),

                        const SizedBox(height: 16),

                        // Criar conta
                        TextButton(
                          onPressed: () => Navigator.pushReplacementNamed(context, '/criarConta'),
                          child: Text(
                            'Criar conta',
                            style: GoogleFonts.montserrat(
                              color: primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                        // Esqueci minha senha
                        TextButton(
                          onPressed: () => Navigator.pushNamed(context, '/esqueciSenha'),
                          child: Text(
                            'Esqueci minha senha',
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
