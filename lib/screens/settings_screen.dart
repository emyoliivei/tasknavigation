import 'package:flutter/material.dart';
import 'dart:io';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkTheme = false;
  bool _notificationsEnabled = true;
  String _userName = "Usuário";
  File? _profileImage;

  // Método simulado para selecionar imagem (substitua com image_picker se quiser)
  Future<void> _pickImage() async {
    // Aqui você pode usar image_picker futuramente
    // Simulando seleção de imagem: apenas remove imagem atual
    setState(() {
      _profileImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/dashboard');
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Foto de perfil
            CircleAvatar(
              radius: 60,
              backgroundImage: _profileImage != null
                  ? FileImage(_profileImage!) as ImageProvider<Object>
                  : const AssetImage('assets/default_profile.png'),
              backgroundColor: Colors.grey[200],
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              icon: const Icon(Icons.photo_camera),
              label: const Text('Trocar Foto de Perfil'),
              onPressed: _pickImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Editar nome do usuário
            TextFormField(
              initialValue: _userName,
              decoration: InputDecoration(
                labelText: 'Nome de Usuário',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.person),
              ),
              onChanged: (value) {
                setState(() {
                  _userName = value;
                });
              },
            ),
            const SizedBox(height: 24),

            // Switch tema claro / escuro
            SwitchListTile(
              title: const Text('Tema Escuro'),
              value: _isDarkTheme,
              onChanged: (bool value) {
                setState(() {
                  _isDarkTheme = value;
                  // Aqui você pode ativar o tema escuro global futuramente
                });
              },
              secondary: const Icon(Icons.dark_mode),
              activeColor: Colors.deepPurple,
            ),

            // Switch notificações
            SwitchListTile(
              title: const Text('Notificações'),
              value: _notificationsEnabled,
              onChanged: (bool value) {
                setState(() {
                  _notificationsEnabled = value;
                  // Aqui você pode ativar/desativar notificações
                });
              },
              secondary: const Icon(Icons.notifications),
              activeColor: Colors.deepPurple,
            ),
          ],
        ),
      ),
    );
  }
}
