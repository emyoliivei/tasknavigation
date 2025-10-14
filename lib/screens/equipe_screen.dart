import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class EntrarEquipeScreen extends StatefulWidget {
  const EntrarEquipeScreen({super.key});

  @override
  State<EntrarEquipeScreen> createState() => _EntrarEquipeScreenState();
}

class _EntrarEquipeScreenState extends State<EntrarEquipeScreen> {
  final TextEditingController _codigoController = TextEditingController();
  bool isLoading = false;

  Map<String, dynamic>? equipe;
  List<dynamic> membros = [];

  @override
  void initState() {
    super.initState();
    _carregarEquipeSalva();
  }

  Future<void> _carregarEquipeSalva() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    if (userId == null) return;

    final equipeJson = prefs.getString('equipe_$userId');
    if (equipeJson != null) {
      final data = jsonDecode(equipeJson);
      setState(() {
        equipe = data;
        membros = data['membros'] ?? [];
      });
    }
  }

  Future<void> _salvarEquipe(int userId, Map<String, dynamic> equipeData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('equipe_$userId', jsonEncode(equipeData));
  }

  Future<void> _entrarEquipe() async {
    final codigo = _codigoController.text.trim();
    if (codigo.isEmpty) {
      _mostrarMensagem('Por favor, insira o código da equipe');
      return;
    }

    setState(() => isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');
      if (userId == null) {
        _mostrarMensagem('Erro: usuário não encontrado');
        return;
      }

      final response = await ApiService.postData(
        '/equipes/entrar',
        {"codigoConvite": codigo},
      );

      final equipeData =
          response['equipe'] ?? {'nome': 'Equipe', 'descricao': 'Sem descrição'};

      setState(() {
        equipe = equipeData;
        membros = equipeData['membros'] ?? [];
      });
      await _salvarEquipe(userId, equipeData);

      _mostrarMensagem('Você entrou na equipe com sucesso!');
      _codigoController.clear();
    } catch (e) {
      debugPrint("Erro ao entrar na equipe: $e");
      _mostrarMensagem('Código inválido ou erro ao entrar na equipe');
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _mostrarMensagem(String mensagem) {
    showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: const Text('Aviso'),
        content: Text(mensagem),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final primaryColor = const Color(0xFFB9A1FA);
    final backgroundColor =
        isDark ? const Color.fromARGB(255, 36, 36, 36) : CupertinoColors.systemGroupedBackground;
    final cardColor =
        isDark ? const Color.fromARGB(255, 27, 27, 27) : CupertinoColors.systemBackground;
    final textColor = isDark ? Colors.white : Colors.black;

    return CupertinoPageScaffold(
      backgroundColor: backgroundColor,
      navigationBar: const CupertinoNavigationBar(
        middle: Text(
          'Entrar na Equipe',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Campo de código + botão
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? Colors.black.withOpacity(0.3)
                          : Colors.grey.withOpacity(0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: CupertinoTextField(
                        controller: _codigoController,
                        placeholder: 'Código da Equipe',
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 14),
                        style: TextStyle(color: textColor),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color.fromARGB(255, 45, 45, 45)
                              : CupertinoColors.systemGrey6,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    CupertinoButton.filled(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      onPressed: isLoading ? null : _entrarEquipe,
                      child: isLoading
                          ? const CupertinoActivityIndicator(color: Colors.white)
                          : const Icon(CupertinoIcons.arrow_right),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Equipe e membros
              if (equipe != null)
                Expanded(
                  child: ListView(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              equipe!['nome'] ?? '',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              equipe!['descricao'] ?? 'Sem descrição',
                              style: TextStyle(
                                fontSize: 16,
                                color: textColor.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Membros da Equipe:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (membros.isEmpty)
                        Text(
                          'Nenhum membro ainda',
                          style: TextStyle(color: textColor.withOpacity(0.7)),
                        )
                      else
                        ...membros.map(
                          (membro) => Container(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                              color: cardColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              leading: const Icon(
                                CupertinoIcons.person,
                                color: CupertinoColors.inactiveGray,
                              ),
                              title: Text(
                                membro['nome'] ?? 'Sem nome',
                                style: TextStyle(color: textColor),
                              ),
                              subtitle: Text(
                                membro['email'] ?? '',
                                style: TextStyle(
                                    color: textColor.withOpacity(0.7)),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
