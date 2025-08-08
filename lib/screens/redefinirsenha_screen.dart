import 'package:flutter/material.dart';

class RedefinirSenhaScreen extends StatefulWidget {
  const RedefinirSenhaScreen({super.key});

  @override
  State<RedefinirSenhaScreen> createState() => _RedefinirSenhaScreenState();
}

class _RedefinirSenhaScreenState extends State<RedefinirSenhaScreen> {
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Redefinir Senha'),
        centerTitle: true,
        automaticallyImplyLeading: false,  // Remove a seta de voltar
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Digite sua nova senha e confirme.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _senhaController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Nova Senha',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock_outline),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _confirmarSenhaController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirmar Nova Senha',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock_reset),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Salvar Nova Senha'),
            ),
          ],
        ),
      ),
    );
  }
}
