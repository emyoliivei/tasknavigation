import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // IP da sua máquina na rede local
  static const String baseUrl = 'http://192.168.56.1:8080';

  // LOGIN
  static Future<Map<String, dynamic>?> login(String email, String senha) async {
    final url = Uri.parse('$baseUrl/usuarios/login');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'senha': senha}),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {'error': 'HTTP ${response.statusCode}: ${response.body}'};
      }
    } catch (e) {
      return {'error': 'Falha na conexão: $e'};
    }
  }

  // CADASTRO
  static Future<Map<String, dynamic>?> register(
      String nome, String email, String usuario, String senha) async {
    final url = Uri.parse('$baseUrl/usuarios');
    try {
      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'nome': nome,
              'email': email,
              'usuario': usuario,
              'senha': senha,
            }),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 201 || response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {'error': 'HTTP ${response.statusCode}: ${response.body}'};
      }
    } catch (e) {
      return {'error': 'Falha na conexão: $e'};
    }
  }

  // BUSCAR TAREFAS
  static Future<List<Map<String, dynamic>>?> getTasks(String email) async {
    final url = Uri.parse('$baseUrl/tarefas?email=$email'); // ajustar endpoint da sua API
    try {
      final response = await http.get(url).timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(jsonDecode(response.body));
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
