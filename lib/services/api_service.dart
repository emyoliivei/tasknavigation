import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Base URL: muda conforme se é web (localhost) ou mobile (IP da máquina)
 static String get baseUrl {
  // Para Web
  if (kIsWeb) return 'http://192.168.0.10:8080';
  // Para Mobile
  return 'http://172.19.1.156:8080';
}


  // 🔹 Cabeçalhos HTTP
  // Se 'withAuth' for true, adiciona token JWT no header Authorization
  static Future<Map<String, String>> _getHeaders({bool withAuth = true}) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (withAuth) {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token'); // token JWT armazenado
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token'; // 🔑 Token enviado no header
        print('🔑 Token completo: $token');
      }
    }
    return headers;
  }

  // 🔹 LOGIN
  static Future<Map<String, dynamic>> login(String email, String senha) async {
    final url = Uri.parse('$baseUrl/usuarios/login');
    print("🔹 LOGIN: enviando $email / $senha");
    try {
      final response = await http.post(
        url,
        headers: await _getHeaders(withAuth: false),
        body: jsonEncode({'email': email, 'senha': senha}),
      );
      print("🔹 LOGIN response: ${response.statusCode} ${response.body}");
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = jsonDecode(response.body);
        final prefs = await SharedPreferences.getInstance();
        if (data['token'] != null) await prefs.setString('token', data['token']);
        if (data['usuario']?['id'] != null) await prefs.setInt('userId', data['usuario']['id']);
        return data;
      }
      return {'error': 'HTTP ${response.statusCode}: ${response.body}'};
    } catch (e) {
      return {'error': 'Falha na conexão: $e'};
    }
  }

  // 🔹 REGISTRO
  static Future<Map<String, dynamic>> register(
      String nome, String email, String senha, {bool isWebLogin = false}) async {
    final url = Uri.parse('$baseUrl/usuarios');
    print("🔹 REGISTER: enviando $nome / $email");
    try {
      final response = await http.post(
        url,
        headers: await _getHeaders(withAuth: false),
        body: jsonEncode({
          'nome': nome,
          'email': email,
          'senha': senha,
          'isWebLogin': false,
        }),
      );
      print("🔹 REGISTER response: ${response.statusCode} ${response.body}");
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body);
      }
      return {'error': 'HTTP ${response.statusCode}: ${response.body}'};
    } catch (e) {
      return {'error': 'Falha na conexão: $e'};
    }
  }

  // 🔹 LOGOUT
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('userId');
    print("🔹 LOGOUT realizado");
  }

  // 🔹 TAREFAS CRUD
  static Future<Map<String, dynamic>> createTask(Map<String, dynamic> tarefa) async {
    final url = Uri.parse('$baseUrl/tarefas');
    final headers = await _getHeaders();
    print("🔹 CREATE TASK headers: $headers");
    final response = await http.post(url, headers: headers, body: jsonEncode(tarefa));
    if (response.statusCode >= 200 && response.statusCode < 300) return jsonDecode(response.body);
    throw Exception('Erro ao criar tarefa: ${response.statusCode}');
  }

  static Future<List<Map<String, dynamic>>> getTasks() async {
    final url = Uri.parse('$baseUrl/tarefas');
    final headers = await _getHeaders();
    final response = await http.get(url, headers: headers);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final decoded = jsonDecode(response.body);
      return decoded is List ? List<Map<String, dynamic>>.from(decoded) : [];
    }
    throw Exception('Erro ao buscar tarefas: ${response.statusCode}');
  }

  static Future<Map<String, dynamic>> updateTask(int id, Map<String, dynamic> tarefa) async {
    final url = Uri.parse('$baseUrl/tarefas/$id');
    final headers = await _getHeaders();
    final response = await http.put(url, headers: headers, body: jsonEncode(tarefa));
    if (response.statusCode >= 200 && response.statusCode < 300) return jsonDecode(response.body);
    throw Exception('Erro ao atualizar tarefa: ${response.statusCode}');
  }

  static Future<void> deleteTask(int id) async {
    final url = Uri.parse('$baseUrl/tarefas/$id');
    final headers = await _getHeaders();
    final response = await http.delete(url, headers: headers);
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Erro ao deletar tarefa: ${response.statusCode}');
    }
  }

  // 🔹 PROJETOS CRUD
  static Future<List<Map<String, dynamic>>> getProjects() async {
    final url = Uri.parse('$baseUrl/projetos');
    final response = await http.get(url, headers: await _getHeaders());
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final decoded = jsonDecode(response.body);
      return decoded is List ? List<Map<String, dynamic>>.from(decoded) : [];
    }
    return [];
  }

  static Future<Map<String, dynamic>> createProject(Map<String, dynamic> project) async {
    final url = Uri.parse('$baseUrl/projetos');
    final response = await http.post(url, headers: await _getHeaders(), body: jsonEncode(project));
    if (response.statusCode >= 200 && response.statusCode < 300) return jsonDecode(response.body);
    return {'error': 'HTTP ${response.statusCode}: ${response.body}'};
  }

  static Future<Map<String, dynamic>> updateProject(int projectId, Map<String, dynamic> project) async {
    final url = Uri.parse('$baseUrl/projetos/$projectId');
    final response = await http.put(url, headers: await _getHeaders(), body: jsonEncode(project));
    if (response.statusCode >= 200 && response.statusCode < 300) return jsonDecode(response.body);
    return {'error': 'HTTP ${response.statusCode}: ${response.body}'};
  }

  static Future<bool> deleteProject(int projectId) async {
    final url = Uri.parse('$baseUrl/projetos/$projectId');
    final response = await http.delete(url, headers: await _getHeaders());
    return response.statusCode == 200 || response.statusCode == 204;
  }

  // 🔹 CONVIDAR COLABORADOR
  static Future<Map<String, dynamic>> convidarColaborador(int equipeId, String email) async {
    final url = Uri.parse('$baseUrl/equipes/$equipeId/convidar');
    final headers = await _getHeaders();
    print("🔹 Enviando convite: $email para equipe $equipeId");

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode({"email": email}),
    );

    print("🔹 CONVIDAR response: ${response.statusCode} ${response.body}");

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    }
    return {"error": "HTTP ${response.statusCode}: ${response.body}"};
  }

  // 🔹 MÉTODOS GENÉRICOS (para endpoints extras)
  static Future<List<dynamic>> getData(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await http.get(url, headers: await _getHeaders());
    if (response.statusCode >= 200 && response.statusCode < 300) return jsonDecode(response.body);
    throw Exception('Erro ao buscar dados: ${response.statusCode}');
  }

  static Future<dynamic> postData(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await http.post(url, headers: await _getHeaders(), body: jsonEncode(data));
    if (response.statusCode >= 200 && response.statusCode < 300) return jsonDecode(response.body);
    throw Exception('Erro ao criar: ${response.statusCode}');
  }

  static Future<dynamic> putData(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await http.put(url, headers: await _getHeaders(), body: jsonEncode(data));
    if (response.statusCode >= 200 && response.statusCode < 300) return jsonDecode(response.body);
    throw Exception('Erro ao atualizar: ${response.statusCode}');
  }

  static Future<void> deleteData(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await http.delete(url, headers: await _getHeaders());
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Erro ao deletar: ${response.statusCode}');
    }
  }
}
