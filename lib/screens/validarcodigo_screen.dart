import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ValidarCodigoScreen extends StatefulWidget {
  const ValidarCodigoScreen({super.key});

  @override
  State<ValidarCodigoScreen> createState() => _ValidarCodigoScreenState();
}

class _ValidarCodigoScreenState extends State<ValidarCodigoScreen> {
  final TextEditingController _codigoController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final Color primaryColor = const Color(0xFF8E24AA);

  void _validarCodigo() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushNamed(context, '/redefinirSenha');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Validar Código',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w600,
            color: Colors.white, // texto branco
          ),
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Digite o código que enviamos para o seu e-mail.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(fontSize: 16),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _codigoController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Código',
                    prefixIcon: Icon(Icons.lock_outline, color: primaryColor),
                    filled: true,
                    fillColor: Colors.deepPurple.shade50,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: primaryColor, width: 2),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe o código';
                    }
                    if (value.length < 4) {
                      return 'Código inválido';
                    }
                    return null;
                  },
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _validarCodigo,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: Text(
                      'Validar Código',
                      style: GoogleFonts.montserrat(fontSize: 18, color: Colors.white),
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
