import 'dart:io';
import 'package:flutter/cupertino.dart';
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
  String? _uploadedImageUrl;
  int? _configId;

  final ImagePicker _picker = ImagePicker();
  final TextEditingController _userNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  @override
  void dispose() {
    _userNameController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    if (userId == null) return;

    final savedUserName = prefs.getString('userName') ?? '';
    final config = await ApiService.getUserConfig(userId);

    setState(() {
      if (config != null) {
        _configId = config['id'];
        _isDarkTheme = config['tema'] == 'dark';
        _notificationsEnabled = config['notificacoes'] ?? true;

        _userName = savedUserName.isNotEmpty
            ? savedUserName
            : (config['usuario']?['nome'] ?? '');
        _userNameController.text = _userName;

        final fotoPath = config['fotoPerfil'];
        if (fotoPath != null && fotoPath.isNotEmpty) {
          if (fotoPath.startsWith("http")) {
            _uploadedImageUrl = fotoPath;
          } else {
            _profileImage = File(fotoPath);
          }
        }
      } else {
        _isDarkTheme = TaskNavigationApp.themeNotifier.value == ThemeMode.dark;
        _userNameController.text = savedUserName;
      }

      TaskNavigationApp.themeNotifier.value =
          _isDarkTheme ? ThemeMode.dark : ThemeMode.light;
    });
  }

  Future<void> _pickImage() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
        _uploadedImageUrl = null;
      });
    }
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    if (userId == null) return;

    prefs.setString('userName', _userNameController.text);

    String? imageUrl = _uploadedImageUrl;
    if (_profileImage != null) {
      imageUrl = _profileImage!.path;
    }

    final config = {
      "id": _configId,
      "usuario": {"id": userId, "nome": _userNameController.text},
      "tema": _isDarkTheme ? "dark" : "light",
      "notificacoes": _notificationsEnabled,
      "fotoPerfil": imageUrl ?? "",
    };

    try {
      final savedConfig = await ApiService.saveUserConfig(config);
      setState(() {
        _configId = savedConfig['id'];
        _uploadedImageUrl = imageUrl;
        _profileImage = null;
      });
      if (mounted) {
        showCupertinoDialog(
          context: context,
          builder: (_) => CupertinoAlertDialog(
            title: const Text("Sucesso"),
            content: const Text("Configurações salvas com sucesso!"),
            actions: [
              CupertinoDialogAction(
                child: const Text("OK"),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        showCupertinoDialog(
          context: context,
          builder: (_) => CupertinoAlertDialog(
            title: const Text("Erro"),
            content: Text("Erro ao salvar configurações: $e"),
            actions: [
              CupertinoDialogAction(
                child: const Text("OK"),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      }
    }
  }

  Future<void> _logout() async {
    await ApiService.logout();
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = _isDarkTheme
        ? CupertinoColors.black
        : const Color(0xFFF5F5F5); // cinza clarinho no claro
    final cardColor = _isDarkTheme ? const Color(0xFF3A3A3A) : CupertinoColors.white;
    final primaryColor = const Color(0xFFAB47BC);
    final accentColor = CupertinoColors.systemRed;
    final textColor = _isDarkTheme ? CupertinoColors.white : CupertinoColors.black;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text(
          "Configurações",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: backgroundColor,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // FOTO DE PERFIL
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.15),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 70,
                  backgroundColor: _isDarkTheme
                      ? CupertinoColors.darkBackgroundGray
                      : CupertinoColors.inactiveGray,
                  backgroundImage: _profileImage != null
                      ? FileImage(_profileImage!) as ImageProvider
                      : (_uploadedImageUrl != null
                          ? NetworkImage(_uploadedImageUrl!) as ImageProvider
                          : const AssetImage('assets/default_profile.png')),
                ),
              ),
              const SizedBox(height: 16),

              // BOTÃO TROCAR FOTO - PRETO NO CLARO
              CupertinoButton(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Text(
                  'Trocar Foto',
                  style: TextStyle(
                      color: _isDarkTheme ? CupertinoColors.white : CupertinoColors.black,
                      fontWeight: FontWeight.w600),
                ),
                onPressed: _pickImage,
              ),
              const SizedBox(height: 32),

              // NOME DE USUÁRIO
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: CupertinoTextField(
                  placeholder: 'Nome de Usuário',
                  controller: _userNameController,
                  style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
                  prefix: Icon(CupertinoIcons.person, color: primaryColor),
                ),
              ),
              const SizedBox(height: 24),

              // TEMA ESCURO
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Tema Escuro',
                        style: TextStyle(color: textColor, fontWeight: FontWeight.w600)),
                    CupertinoSwitch(
                      value: _isDarkTheme,
                      onChanged: (value) {
                        setState(() {
                          _isDarkTheme = value;
                          TaskNavigationApp.themeNotifier.value =
                              value ? ThemeMode.dark : ThemeMode.light;
                        });
                      },
                      activeColor: primaryColor,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // NOTIFICAÇÕES
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Notificações',
                        style: TextStyle(color: textColor, fontWeight: FontWeight.w600)),
                    CupertinoSwitch(
                      value: _notificationsEnabled,
                      onChanged: (value) => setState(() => _notificationsEnabled = value),
                      activeColor: primaryColor,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // BOTÕES SALVAR E LOGOUT
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CupertinoButton.filled(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(CupertinoIcons.check_mark_circled_solid, size: 20),
                        SizedBox(width: 6),
                        Text("Salvar Alterações"),
                      ],
                    ),
                    onPressed: _saveSettings,
                  ),
                  CupertinoButton(
                    color: accentColor,
                    child: const Text(
                      "Logout",
                      style: TextStyle(color: CupertinoColors.white),
                    ),
                    onPressed: _logout,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
