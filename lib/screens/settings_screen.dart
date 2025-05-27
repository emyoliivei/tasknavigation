import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// Importa para acessar o themeNotifier
import '../main.dart';  

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

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // Inicializa o estado do switch conforme o tema atual
    _isDarkTheme = TaskNavigationApp.themeNotifier.value == ThemeMode.dark;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundImage: _profileImage != null
                ? FileImage(_profileImage!) as ImageProvider
                : const AssetImage('assets/default_profile.png'),
            backgroundColor: const Color.fromARGB(255, 49, 48, 48),
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
          SwitchListTile(
            title: const Text('Tema Escuro'),
            value: _isDarkTheme,
            onChanged: (bool value) {
              setState(() {
                _isDarkTheme = value;
                TaskNavigationApp.themeNotifier.value =
                    value ? ThemeMode.dark : ThemeMode.light;
              });
            },
            secondary: const Icon(Icons.dark_mode),
            activeColor: Colors.deepPurple,
          ),
          SwitchListTile(
            title: const Text('Notificações'),
            value: _notificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
            secondary: const Icon(Icons.notifications),
            activeColor: Colors.deepPurple,
          ),
        ],
      ),
    );
  }
}
