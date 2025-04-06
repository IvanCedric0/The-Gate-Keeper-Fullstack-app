import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/student.dart';

class ApiService {
  // Use localhost for web and IP address for mobile
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:3000/api';
    } else {
      // Use 10.0.2.2 for emulator, and your computer's IP for physical device
      // You can find your IP by running 'ipconfig' on Windows or 'ifconfig' on Mac/Linux
      return 'http://192.168.1.5:3000/api';  // Replace with your computer's IP address
    }
  }

  // Test function to check server connectivity
  Future<bool> testConnection() async {
    try {
      print('Attempting to connect to: $baseUrl/students/107678');
      final response = await http.get(
        Uri.parse('$baseUrl/students/107678'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      return response.statusCode == 200;
    } catch (e) {
      print('Connection test failed with error: $e');
      print('Error type: ${e.runtimeType}');
      return false;
    }
  }

  Future<Student> getStudent(String id) async {
    print('Fetching student with ID: $id from $baseUrl/students/$id');
    final response = await http.get(
      Uri.parse('$baseUrl/students/$id'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );
    
    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');
    
    if (response.statusCode == 200) {
      return Student.fromJson(json.decode(response.body));
    } else {
      throw Exception('Student not found');
    }
  }

  Future<void> logEntry(String id) async {
    print('Logging entry for student ID: $id');
    final response = await http.post(
      Uri.parse('$baseUrl/students/$id/entry'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: json.encode({'entry_time': DateTime.now().toIso8601String()}),
    );

    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Failed to log entry');
    }
  }

  Future<void> logExit(String id) async {
    print('Logging exit for student ID: $id');
    final response = await http.post(
      Uri.parse('$baseUrl/students/$id/exit'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: json.encode({'exit_time': DateTime.now().toIso8601String()}),
    );

    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Failed to log exit');
    }
  }
} 