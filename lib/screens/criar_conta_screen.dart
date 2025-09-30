  import 'package:flutter/material.dart';
  import 'package:google_fonts/google_fonts.dart';
  import '../services/api_service.dart';

  class CriarContaScreen extends StatefulWidget {
    const CriarContaScreen({super.key});

    @override
    State<CriarContaScreen> createState() => _CriarContaScreenState();
  }

  class _CriarContaScreenState extends State<CriarContaScreen> {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController _nomeController = TextEditingController();
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _usuarioController = TextEditingController();
    final TextEditingController _senhaController = TextEditingController();
    final TextEditingController _confirmSenhaController = TextEditingController();

    void _criarConta() async {
      if (!_formKey.currentState!.validate()) return;

      if (_senhaController.text != _confirmSenhaController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('As senhas não conferem')),
        );
        return;
      }

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );
final res = await ApiService.register(
  _nomeController.text,
  _emailController.text,
  _senhaController.text,
);


      Navigator.pop(context);

      if (res is Map && res.containsKey('error')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res['error'])),
        );
      } else {
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
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha((0.95 * 255).round()),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha((0.15 * 255).round()),
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
                    TextFormField(
                      controller: _nomeController,
                      decoration: const InputDecoration(
                        labelText: 'Nome',
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Informe seu nome' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      validator: (value) =>
                          value == null || !value.contains('@') ? 'Email inválido' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _usuarioController,
                      decoration: const InputDecoration(
                        labelText: 'Usuário',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Informe o usuário' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _senhaController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Senha',
                        prefixIcon: Icon(Icons.lock_outline),
                      ),
                      validator: (value) =>
                          value == null || value.length < 4 ? 'Senha muito curta' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _confirmSenhaController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Confirmar Senha',
                        prefixIcon: Icon(Icons.lock_outline),
                      ),
                      validator: (value) =>
                          value == null || value.length < 4 ? 'Senha muito curta' : null,
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _criarConta,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          'Cadastrar',
                          style: GoogleFonts.montserrat(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
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
      );
    }
  }
