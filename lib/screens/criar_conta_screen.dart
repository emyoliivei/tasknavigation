import 'package:flutter/cupertino.dart';
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
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _confirmSenhaController = TextEditingController();

  void _criarConta() async {
    if (!_formKey.currentState!.validate()) return;

    if (_senhaController.text != _confirmSenhaController.text) {
      showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
          title: const Text('Erro'),
          content: const Text('As senhas não conferem'),
          actions: [
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
      return;
    }

    showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CupertinoActivityIndicator()),
    );

    final res = await ApiService.register(
      _nomeController.text,
      _emailController.text,
      _senhaController.text,
    );

    Navigator.pop(context);

    if (res is Map && res.containsKey('error')) {
      showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
          title: const Text('Erro'),
          content: Text(res['error']),
          actions: [
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    } else {
      showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
          title: const Text('Sucesso'),
          content: const Text('Conta criada com sucesso!'),
          actions: [
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF8E24AA);

    return CupertinoPageScaffold(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF6A1B9A),
              Color(0xFF8E24AA),
              Color(0xFFBA68C8),
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: CupertinoColors.systemBackground.withOpacity(0.95),
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
                    Icon(CupertinoIcons.person_add, size: 60, color: primaryColor),
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
                    CupertinoTextFormFieldRow(
                      controller: _nomeController,
                      placeholder: 'Nome',
                      prefix: const Icon(CupertinoIcons.person),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Informe seu nome' : null,
                      padding:
                          const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                      decoration: BoxDecoration(
                        color: CupertinoColors.secondarySystemBackground,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      textInputAction: TextInputAction.next,
                      cursorColor: primaryColor,
                      keyboardAppearance: Brightness.light,
                    ),
                    const SizedBox(height: 16),

                    // Email
                    CupertinoTextFormFieldRow(
                      controller: _emailController,
                      placeholder: 'Email',
                      prefix: const Icon(CupertinoIcons.mail),
                      validator: (value) =>
                          value == null || !value.contains('@')
                              ? 'Email inválido'
                              : null,
                      padding:
                          const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                      decoration: BoxDecoration(
                        color: CupertinoColors.secondarySystemBackground,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      cursorColor: primaryColor,
                      keyboardAppearance: Brightness.light,
                    ),
                    const SizedBox(height: 16),

                    // Senha
                    CupertinoTextFormFieldRow(
                      controller: _senhaController,
                      placeholder: 'Senha',
                      obscureText: true,
                      prefix: const Icon(CupertinoIcons.lock),
                      validator: (value) =>
                          value == null || value.length < 4
                              ? 'Senha muito curta'
                              : null,
                      padding:
                          const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                      decoration: BoxDecoration(
                        color: CupertinoColors.secondarySystemBackground,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      textInputAction: TextInputAction.next,
                      cursorColor: primaryColor,
                      keyboardAppearance: Brightness.light,
                    ),
                    const SizedBox(height: 16),

                    // Confirmar senha
                    CupertinoTextFormFieldRow(
                      controller: _confirmSenhaController,
                      placeholder: 'Confirmar Senha',
                      obscureText: true,
                      prefix: const Icon(CupertinoIcons.lock),
                      validator: (value) =>
                          value == null || value.length < 4
                              ? 'Senha muito curta'
                              : null,
                      padding:
                          const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                      decoration: BoxDecoration(
                        color: CupertinoColors.secondarySystemBackground,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      textInputAction: TextInputAction.done,
                      cursorColor: primaryColor,
                      keyboardAppearance: Brightness.light,
                    ),
                    const SizedBox(height: 28),

                    // Botão Cadastrar
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: CupertinoButton.filled(
                        borderRadius: BorderRadius.circular(20),
                        color: primaryColor,
                        onPressed: _criarConta,
                        child: Text(
                          'Cadastrar',
                          style: GoogleFonts.montserrat(
                            fontSize: 18,
                            color: CupertinoColors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Voltar ao login
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () =>
                          Navigator.pushReplacementNamed(context, '/login'),
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
    );
  }
}
