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

  Map<String, dynamic>? equipe; // Dados da equipe
  List<dynamic> membros = [];    // Lista de membros da equipe

  @override
  void initState() {
    super.initState();
    _carregarEquipeSalva();
  }

  // 🔹 Carrega equipe salva no SharedPreferences
Future<void> _carregarEquipeSalva() async {
  final prefs = await SharedPreferences.getInstance();
  final userId = prefs.getInt('userId'); // pega id salvo no login
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


  // 🔹 Salva equipe no SharedPreferences
Future<void> _salvarEquipe(int userId, Map<String, dynamic> equipeData) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('equipe_$userId', jsonEncode(equipeData));
}


  // 🔹 ENTRAR EM EQUIPE
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

      final response = await ApiService.postData('/equipes/entrar', {"codigoConvite": codigo});

      final equipeData = response['equipe'] ?? {'nome': 'Equipe', 'descricao': 'Sem descrição'};

      // Salva no estado e no SharedPreferences
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
    return Scaffold(
      appBar: AppBar(title: const Text("Entrar em Equipe")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _codigoController,
                  decoration: const InputDecoration(
                    labelText: 'Código da Equipe',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _entrarEquipe,
                    child: isLoading
                        ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : const Text('Entrar na Equipe', style: TextStyle(fontSize: 16)),
                  ),
                ),
                const SizedBox(height: 32),
                if (equipe != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                equipe!['nome'] ?? 'Equipe sem nome',
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                equipe!['descricao'] ?? 'Sem descrição',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Membros da Equipe:',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      if (membros.isEmpty)
                        const Text('Nenhum membro ainda')
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: membros.length,
                          itemBuilder: (context, index) {
                            final membro = membros[index];
                            return Card(
                              child: ListTile(
                                leading: const Icon(Icons.person),
                                title: Text(membro['nome'] ?? 'Sem nome'),
                                subtitle: Text(membro['email'] ?? ''),
                              ),
                            );
                          },
                        ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
