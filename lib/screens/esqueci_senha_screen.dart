import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';

class EsqueciSenhaScreen extends StatefulWidget {
  const EsqueciSenhaScreen({super.key});

  @override
  State<EsqueciSenhaScreen> createState() => _EsqueciSenhaScreenState();
}

class _EsqueciSenhaScreenState extends State<EsqueciSenhaScreen> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final Color primaryColor = const Color(0xFF8E24AA);
  bool isLoading = false;

  Future<void> _enviarRecuperacao() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);
    final email = _emailController.text.trim();

    try {
      final response = await ApiService.solicitarRecuperacao(email);
      setState(() => isLoading = false);

      if (response['success'] == true ||
          (response['message']?.toString().toLowerCase().contains('enviado') ?? false)) {
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text("Sucesso"),
            content: Text(response['message'] ?? 'Link de recuperação enviado.'),
            actions: [
              CupertinoDialogAction(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/validarCodigo');
                },
              ),
            ],
          ),
        );
      } else {
        _mostrarErro(response['message'] ?? 'Erro ao enviar e-mail.');
      }
    } catch (e) {
      setState(() => isLoading = false);
      _mostrarErro('Falha na conexão com o servidor.');
    }
  }

  void _mostrarErro(String mensagem) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text("Erro"),
        content: Text(mensagem),
        actions: [
          CupertinoDialogAction(
            child: const Text("OK"),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    final Color backgroundColor =
        isDark ? const Color(0xFF1C1C1E) : const Color(0xFFF2F2F7);

    return CupertinoPageScaffold(
      backgroundColor: backgroundColor,
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          'Recuperar Senha',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        backgroundColor:
            isDark ? const Color(0xFF2C2C2E) : CupertinoColors.systemGrey6,
        border: null,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  "Digite seu e-mail para recuperar a senha",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),
                const SizedBox(height: 24),
                CupertinoTextFormFieldRow(
                  controller: _emailController,
                  placeholder: 'E-mail',
                  keyboardType: TextInputType.emailAddress,
                  prefix: Icon(
                    CupertinoIcons.mail,
                    color: primaryColor,
                  ),
                  style: GoogleFonts.montserrat(
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF2C2C2E)
                        : CupertinoColors.systemGrey6,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe seu e-mail';
                    }
                    if (!value.contains('@')) {
                      return 'E-mail inválido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: CupertinoButton(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(16),
                    onPressed: isLoading ? null : _enviarRecuperacao,
                    child: isLoading
                        ? const CupertinoActivityIndicator(color: Colors.white)
                        : Text(
                            'Enviar link de recuperação',
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
