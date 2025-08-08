import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EsqueciSenhaScreen extends StatefulWidget {
  const EsqueciSenhaScreen({super.key});

  @override
  State<EsqueciSenhaScreen> createState() => _EsqueciSenhaScreenState();
}

class _EsqueciSenhaScreenState extends State<EsqueciSenhaScreen> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final Color primaryColor = const Color(0xFF8E24AA);

  void _enviarRecuperacao() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Link de recuperação enviado para o e-mail.')),
      );
      Navigator.pushNamed(context, '/validarCodigo');  // Aqui está a mudança
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Remove a seta de voltar
        backgroundColor: primaryColor,
        centerTitle: true,
        title: Text(
          'Recuperar Senha',
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Centraliza verticalmente
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Digite seu e-mail para recuperar a senha",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(fontSize: 16),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center, // Centraliza o texto do campo
                  decoration: InputDecoration(
                    labelText: 'E-mail',
                    labelStyle: GoogleFonts.montserrat(),
                    prefixIcon: Icon(Icons.email_outlined, color: primaryColor),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                    filled: true,
                    fillColor: Colors.deepPurple.shade50,
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
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _enviarRecuperacao,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: Text(
                      'Enviar link de recuperação',
                      style: GoogleFonts.montserrat(fontSize: 16, color: Colors.white),
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
