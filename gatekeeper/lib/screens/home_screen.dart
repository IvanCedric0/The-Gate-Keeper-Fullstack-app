import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/student.dart';
import '../services/api_service.dart';
import 'scanner_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _idController = TextEditingController();
  final _apiService = ApiService();
  Student? _student;
  bool _isLoading = false;
  String? _error;
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    _checkConnection();
  }

  Future<void> _checkConnection() async {
    final isConnected = await _apiService.testConnection();
    setState(() {
      _isConnected = isConnected;
    });
    if (!isConnected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cannot connect to server. Please check your network connection.'),
          duration: Duration(seconds: 5),
        ),
      );
    }
  }

  Future<void> _fetchStudent(String id) async {
    if (id.isEmpty) return;

    setState(() {
      _isLoading = true;
      _error = null;
      _student = null;
    });

    try {
      final student = await _apiService.getStudent(id);
      setState(() {
        _student = student;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _logEntry() async {
    if (_student == null) return;

    try {
      await _apiService.logEntry(_student!.id.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Entry logged successfully')),
      );
      _fetchStudent(_student!.id.toString()); // Refresh student data
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to log entry: ${e.toString()}')),
      );
    }
  }

  Future<void> _logExit() async {
    if (_student == null) return;

    try {
      await _apiService.logExit(_student!.id.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Exit logged successfully')),
      );
      _fetchStudent(_student!.id.toString()); // Refresh student data
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to log exit: ${e.toString()}')),
      );
    }
  }

  void _openScanner() async {
    final result = await Navigator.push<Student>(
      context,
      MaterialPageRoute(
        builder: (context) => ScannerScreen(
          onStudentFound: (student) {
            setState(() {
              _student = student;
              _isLoading = false;
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gate Keeper'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!_isConnected)
              Container(
                padding: const EdgeInsets.all(8.0),
                color: Colors.red.shade100,
                child: const Text(
                  'Not connected to server',
                  style: TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _idController,
                    decoration: InputDecoration(
                      labelText: 'Enter Student ID',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () => _fetchStudent(_idController.text),
                      ),
                    ),
                    onSubmitted: (_) => _fetchStudent(_idController.text),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _openScanner,
                  icon: const Icon(Icons.qr_code_scanner),
                  label: const Text('Scan'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_error != null)
              Center(
                child: Text(
                  _error!,
                  style: const TextStyle(color: Colors.red),
                ),
              )
            else if (_student != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Student Photo
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: CachedNetworkImage(
                              imageUrl: _student!.photo,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                width: 100,
                                height: 100,
                                color: Colors.grey[300],
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                width: 100,
                                height: 100,
                                color: Colors.grey[300],
                                child: const Icon(Icons.person, size: 50),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Student Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _student!.fullname,
                                  style: Theme.of(context).textTheme.headlineSmall,
                                ),
                                const SizedBox(height: 8),
                                Text('ID: ${_student!.id}'),
                                Text('Major: ${_student!.major}'),
                                Text('Status: ${_student!.status}'),
                                if (_student!.lastEntry != null)
                                  Text(
                                    'Last Entry: ${_student!.lastEntry!.toLocal().toString()}',
                                  ),
                                if (_student!.lastExit != null)
                                  Text(
                                    'Last Exit: ${_student!.lastExit!.toLocal().toString()}',
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: _logEntry,
                            child: const Text('Log Entry'),
                          ),
                          ElevatedButton(
                            onPressed: _logExit,
                            child: const Text('Log Exit'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _idController.dispose();
    super.dispose();
  }
} 