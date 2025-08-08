import 'package:flutter/material.dart';

class ValidarCodigoScreen extends StatefulWidget {
  const ValidarCodigoScreen({super.key});

  @override
  State<ValidarCodigoScreen> createState() => _ValidarCodigoScreenState();
}

class _ValidarCodigoScreenState extends State<ValidarCodigoScreen> {
  final _codigoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Validar Código'),
        centerTitle: true,
        automaticallyImplyLeading: false,  // Remove a seta de voltar
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Digite o código que enviamos para o seu e-mail.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _codigoController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Código',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/redefinirSenha');
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Validar Código'),
            ),
          ],
        ),
      ),
    );
  }
}
