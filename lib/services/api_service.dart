import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart'; // Para kIsWeb

class ApiService {
  // 🔹 Base URL dependendo do ambiente
  static String get baseUrl {
    if (kIsWeb) {
      // Web - use localhost ou IP da máquina
      return 'http://localhost:8080'; // ou 'http://172.19.2.225:8080' se precisar do IP da rede
    } else {
      // Mobile
      // Android emulator
      return defaultTargetPlatform == TargetPlatform.android
          ? 'http://10.0.2.2:8080'
          : 'http://172.19.2.225:8080'; // iOS ou dispositivo físico
    }
  }

  // 🔹 Cabeçalhos com token
  static Future<Map<String, String>> _getHeaders({bool withAuth = true}) async {
    final headers = {'Content-Type': 'application/json'};
    if (withAuth) {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  // 🔹 LOGIN
  static Future<Map<String, dynamic>> login(String email, String senha) async {
    final url = Uri.parse('$baseUrl/usuarios/login');
    try {
      final response = await http
          .post(url, headers: await _getHeaders(withAuth: false), body: jsonEncode({'email': email, 'senha': senha}))
          .timeout(const Duration(seconds: 15));

      print('LOGIN response: ${response.statusCode} - ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = jsonDecode(response.body);
        final prefs = await SharedPreferences.getInstance();
        if (data['token'] != null) await prefs.setString('token', data['token']);
        if (data['usuario'] != null && data['usuario']['id'] != null) await prefs.setInt('userId', data['usuario']['id']);
        return data;
      } else {
        return {'error': 'HTTP ${response.statusCode}: ${response.body}'};
      }
    } catch (e) {
      return {'error': 'Falha na conexão: $e'};
    }
  }

  // 🔹 CRIAR TAREFA
  static Future<Map<String, dynamic>> createTask(Map<String, dynamic> tarefa) async {
    final url = Uri.parse('$baseUrl/tarefas');
    try {
      final headers = await _getHeaders();
      print('Criando tarefa com headers: $headers e body: $tarefa');

      final response = await http.post(url, headers: headers, body: jsonEncode(tarefa)).timeout(const Duration(seconds: 15));

      print('CREATE TASK response: ${response.statusCode} - ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body);
      } else {
        return {'error': 'HTTP ${response.statusCode}: ${response.body}'};
      }
    } catch (e) {
      print('Erro ao criar tarefa: $e');
      return {'error': 'Falha na conexão: $e'};
    }
  }

  // 🔹 LISTAR TAREFAS
  static Future<List<Map<String, dynamic>>> getTasks() async {
    final url = Uri.parse('$baseUrl/tarefas');
    try {
      final headers = await _getHeaders();
      final response = await http.get(url, headers: headers).timeout(const Duration(seconds: 15));
      print('GET TASKS response: ${response.statusCode} - ${response.body}');

      final decoded = jsonDecode(response.body);
      if (decoded is List) return List<Map<String, dynamic>>.from(decoded);
      return [];
    } catch (e) {
      print('Erro ao listar tarefas: $e');
      return [];
    }
  }

  // 🔹 DELETAR TAREFA
  static Future<bool> deleteTask(int tarefaId) async {
    final url = Uri.parse('$baseUrl/tarefas/$tarefaId');
    try {
      final headers = await _getHeaders();
      final response = await http.delete(url, headers: headers).timeout(const Duration(seconds: 15));
      print('DELETE TASK response: ${response.statusCode}');
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print('Erro ao deletar tarefa: $e');
      return false;
    }
  }

  // 🔹 LOGOUT
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('userId');
  }

  static Future register(String text, String text2, String text3, String text4) async {}
}
