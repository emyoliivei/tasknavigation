// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import '../services/api_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkTheme = false;
  bool _notificationsEnabled = true;
  String _userName = "";
  File? _profileImage;
  int? _configId;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _isDarkTheme = TaskNavigationApp.themeNotifier.value == ThemeMode.dark;
    _loadSettings();
  }

  // -------------------- CARREGAR CONFIGURAÇÕES --------------------
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    if (userId == null) return;

    final config = await ApiService.getUserConfig(userId);
    if (config != null) {
      setState(() {
        _configId = config['id'];
        _isDarkTheme = config['tema'] == 'dark';
        _notificationsEnabled = config['notificacoes'] ?? true;
        _userName = config['usuario']?['nome'] ?? '';
        final fotoPath = config['fotoPerfil'];
        if (fotoPath != null && fotoPath.isNotEmpty) {
          _profileImage = File(fotoPath);
        }
      });
    }
  }

  // -------------------- SALVAR CONFIGURAÇÕES --------------------
  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    if (userId == null) return;

    final config = {
      "id": _configId,
      "usuario": {"id": userId, "nome": _userName},
      "tema": _isDarkTheme ? "dark" : "light",
      "notificacoes": _notificationsEnabled,
      "fotoPerfil": _profileImage?.path ?? "",
    };

    try {
      final savedConfig = await ApiService.saveUserConfig(config);
      setState(() {
        _configId = savedConfig['id'];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Configurações salvas com sucesso!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar configurações: $e')),
      );
    }
  }

  // -------------------- ESCOLHER FOTO --------------------
  Future<void> _pickImage() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF1F1F1F) : const Color(0xFFF7F7F7);
    final cardColor = isDark ? const Color(0xFF2A2A2A) : Colors.white;
    final primaryColor = Colors.deepPurpleAccent;
    final textColor = isDark ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // -------------------- FOTO DE PERFIL --------------------
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 64,
                  backgroundColor: primaryColor.withOpacity(0.3),
                  backgroundImage: _profileImage != null
                      ? FileImage(_profileImage!) as ImageProvider
                      : const AssetImage('assets/default_profile.png'),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.photo_camera),
                label: const Text('Trocar Foto'),
                onPressed: _pickImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor.withOpacity(0.1),
                  foregroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  elevation: 0,
                  textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 36),

              // -------------------- NOME DE USUÁRIO --------------------
              Container(
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextFormField(
                  initialValue: _userName,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Nome de Usuário',
                    labelStyle: TextStyle(color: textColor.withOpacity(0.7)),
                    prefixIcon: Icon(Icons.person, color: primaryColor),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _userName = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 36),

              // -------------------- TEMA ESCURO --------------------
              Card(
                color: cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 2,
                child: SwitchListTile(
                  title: Text(
                    'Tema Escuro',
                    style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
                  ),
                  value: _isDarkTheme,
                  onChanged: (bool value) {
                    setState(() {
                      _isDarkTheme = value;
                      TaskNavigationApp.themeNotifier.value =
                          value ? ThemeMode.dark : ThemeMode.light;
                    });
                  },
                  secondary: Icon(Icons.dark_mode, color: primaryColor),
                  thumbColor: MaterialStateProperty.all(primaryColor),
                  trackColor: MaterialStateProperty.all(primaryColor.withOpacity(0.3)),
                ),
              ),
              const SizedBox(height: 16),

              // -------------------- NOTIFICAÇÕES --------------------
              Card(
                color: cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 2,
                child: SwitchListTile(
                  title: Text(
                    'Notificações',
                    style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
                  ),
                  value: _notificationsEnabled,
                  onChanged: (bool value) {
                    setState(() {
                      _notificationsEnabled = value;
                    });
                  },
                  secondary: Icon(Icons.notifications, color: primaryColor),
                  thumbColor: MaterialStateProperty.all(primaryColor),
                  // ignore: deprecated_member_use
                  trackColor: MaterialStateProperty.all(primaryColor.withOpacity(0.3)),
                ),
              ),
              const SizedBox(height: 36),

              // -------------------- BOTÃO SALVAR --------------------
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('Salvar Configurações'),
                onPressed: _saveSettings,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
