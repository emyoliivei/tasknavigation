import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';

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
    _isDarkTheme = TaskNavigationApp.themeNotifier.value == ThemeMode.dark;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isDark ? const Color.fromARGB(255, 34, 34, 34) : Colors.white;

    final borderColor = isDark ? const Color(0xFF8E24AA) : const Color(0xFF8E24AA);

    final textColor = isDark ? Colors.white : Colors.black87;
    final secondaryTextColor = isDark ? const Color.fromARGB(255, 0, 0, 0) : const Color.fromARGB(255, 19, 17, 17);
    final switchActiveColor = Colors.deepPurpleAccent;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFF8E24AA),
        title: Text(
          'Configurações',
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: false,  // <- aqui remove a seta de voltar
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        // ignore: deprecated_member_use
                        ? Colors.deepPurpleAccent.withOpacity(0.6)
                        // ignore: deprecated_member_use
                        : const Color.fromARGB(255, 85, 78, 87).withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 64,
                backgroundColor:
                    isDark ? Colors.deepPurple.shade700 : const Color.fromARGB(255, 46, 46, 46),
                backgroundImage: _profileImage != null
                    ? FileImage(_profileImage!) as ImageProvider
                    : const AssetImage('assets/default_profile.png'),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.photo_camera),
              label: const Text('Trocar Foto de Perfil'),
              onPressed: _pickImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 219, 215, 219),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                elevation: 6,
                shadowColor: const Color.fromARGB(255, 184, 184, 184),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 36),
            TextFormField(
              initialValue: _userName,
              style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                labelText: 'Nome de Usuário',
                labelStyle: TextStyle(color: secondaryTextColor),
                prefixIcon: Icon(Icons.person, color: borderColor),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: borderColor, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: switchActiveColor, width: 3),
                ),
                fillColor: isDark ? const Color.fromARGB(255, 49, 49, 49) : Colors.deepPurple.shade50,
                filled: true,
              ),
              onChanged: (value) {
                setState(() {
                  _userName = value;
                });
              },
            ),
            const SizedBox(height: 36),
            SwitchListTile(
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
              secondary: Icon(Icons.dark_mode, color: borderColor),
              // ignore: deprecated_member_use
              activeColor: switchActiveColor,
            ),
            SwitchListTile(
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
              secondary: Icon(Icons.notifications, color: borderColor),
              activeColor: switchActiveColor,
            ),
          ],
        ),
      ),
    );
  }
}
