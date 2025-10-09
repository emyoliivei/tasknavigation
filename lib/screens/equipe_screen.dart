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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insira o código da equipe')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');
      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro: usuário não encontrado')),
        );
        return;
      }

      final response = await ApiService.postData(
        '/equipes/entrar',
        {"codigoConvite": codigo},
      );

      final equipeData = response['equipe'] ?? {'nome': 'Equipe', 'descricao': 'Sem descrição'};

      setState(() {
        equipe = equipeData;
        membros = equipeData['membros'] ?? [];
      });
      await _salvarEquipe(userId, equipeData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Você entrou na equipe com sucesso!')),
      );
      _codigoController.clear();
    } catch (e) {
      debugPrint("Erro ao entrar na equipe: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Código inválido ou erro ao entrar na equipe')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFFB9A1FA); // tom de roxo claro
    final secondaryColor = const Color(0xFFF3F4F6);

    return Scaffold(
   
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Card de entrada de código
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _codigoController,
                      decoration: const InputDecoration(
                        hintText: 'Código da Equipe',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    ),
                    onPressed: isLoading ? null : _entrarEquipe,
                    child: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : const Icon(Icons.arrow_forward, color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            // Card da equipe
            if (equipe != null)
              Expanded(
                child: ListView(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            equipe!['nome'] ?? '',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryColor),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            equipe!['descricao'] ?? 'Sem descrição',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Membros da Equipe:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    if (membros.isEmpty)
                      const Text('Nenhum membro ainda')
                    else
                      ...membros.map((membro) => Container(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                              color: primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              leading: const Icon(Icons.person, color: Colors.black54),
                              title: Text(membro['nome'] ?? 'Sem nome'),
                              subtitle: Text(membro['email'] ?? ''),
                            ),
                          )),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
