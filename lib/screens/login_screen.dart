import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
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
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  void _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _erro = null;
    });

    final result = await ApiService.login(
      _emailController.text.trim(),
      _senhaController.text.trim(),
    );

    setState(() {
      _loading = false;
    });

    if (result == null) {
      setState(() {
        _erro = 'Falha na conexão com o servidor';
      });
    } else if (result['error'] != null) {
      setState(() {
        _erro = result['error'];
      });
    } else {
      final prefs = await SharedPreferences.getInstance();
      if (result['token'] != null) {
        await prefs.setString('token', result['token']);
      }
      if (result['usuario'] != null && result['usuario']['id'] != null) {
        await prefs.setInt('userId', result['usuario']['id']);
      }

      Navigator.pushReplacementNamed(context, '/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF7B1FA2); // Roxo um pouco mais suave

    return CupertinoPageScaffold(
      child: Stack(
        children: [
          // 🔹 Gradiente suave
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF7B1FA2),
                  Color(0xFF9C27B0),
                  Color(0xFFBA68C8),
                ],
              ),
            ),
          ),
          FadeTransition(
            opacity: _fadeInAnimation,
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemBackground.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(CupertinoIcons.lock, size: 60, color: primaryColor),
                        const SizedBox(height: 18),
                        Text(
                          'Login',
                          style: GoogleFonts.montserrat(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                        const SizedBox(height: 28),

                        // Email
                        CupertinoTextFormFieldRow(
                          controller: _emailController,
                          placeholder: 'Digite seu email',
                          prefix: const Icon(CupertinoIcons.mail, color: Color(0xFF7B1FA2)),
                          validator: (value) =>
                              value == null || !value.contains('@') ? 'Email inválido' : null,
                          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                          decoration: BoxDecoration(
                            color: CupertinoColors.secondarySystemBackground,
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Senha
                        CupertinoTextFormFieldRow(
                          controller: _senhaController,
                          placeholder: 'Senha',
                          obscureText: true,
                          prefix: const Icon(CupertinoIcons.lock, color: Color(0xFF7B1FA2)),
                          validator: (value) =>
                              value == null || value.length < 4 ? 'Senha muito curta' : null,
                          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                          decoration: BoxDecoration(
                            color: CupertinoColors.secondarySystemBackground,
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        const SizedBox(height: 20),

                        if (_erro != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Text(
                              _erro!,
                              style: const TextStyle(color: CupertinoColors.systemRed),
                            ),
                          ),

                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: _loading
                              ? const Center(child: CupertinoActivityIndicator())
                              : CupertinoButton.filled(
                                  borderRadius: BorderRadius.circular(22),
                                  color: primaryColor,
                                  onPressed: _login,
                                  child: Text(
                                    'Entrar',
                                    style: GoogleFonts.montserrat(
                                      fontSize: 18,
                                      color: CupertinoColors.white,
                                    ),
                                  ),
                                ),
                        ),

                        const SizedBox(height: 16),

                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () => Navigator.pushReplacementNamed(context, '/criarConta'),
                          child: Text(
                            'Criar conta',
                            style: GoogleFonts.montserrat(
                              color: primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                        CupertinoButton(
                          padding: EdgeInsets.zero,
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
}
