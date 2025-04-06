import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/student.dart';
import '../services/api_service.dart';

class ScannerScreen extends StatefulWidget {
  final Function(Student) onStudentFound;

  const ScannerScreen({
    super.key,
    required this.onStudentFound,
  });

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final MobileScannerController controller = MobileScannerController();
  bool _isLoading = false;
  String? _error;
  String? _lastScannedCode;
  final _manualIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      _requestCameraPermission();
    }
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    if (!status.isGranted) {
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  Future<void> _fetchStudent(String id) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      print('Fetching student with ID: $id'); // Debug log
      final student = await ApiService().getStudent(id);
      print('Student found: ${student.fullname}'); // Debug log
      if (mounted) {
        widget.onStudentFound(student);
        Navigator.pop(context);
      }
    } catch (e) {
      print('Error fetching student: $e'); // Debug log
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _handleManualSubmit() {
    if (_manualIdController.text.isNotEmpty) {
      _fetchStudent(_manualIdController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: kIsWeb
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'QR Code scanning is not available on web.',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _manualIdController,
                    decoration: InputDecoration(
                      labelText: 'Enter Student ID',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: _handleManualSubmit,
                      ),
                    ),
                    onSubmitted: (_) => _handleManualSubmit(),
                  ),
                  const SizedBox(height: 20),
                  if (_isLoading)
                    const CircularProgressIndicator()
                  else if (_error != null)
                    Text(
                      _error!,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  flex: 5,
                  child: Stack(
                    children: [
                      MobileScanner(
                        controller: controller,
                        onDetect: (capture) {
                          final List<Barcode> barcodes = capture.barcodes;
                          for (final barcode in barcodes) {
                            if (barcode.rawValue != null && 
                                barcode.rawValue != _lastScannedCode) {
                              _lastScannedCode = barcode.rawValue;
                              _fetchStudent(barcode.rawValue!);
                            }
                          }
                        },
                      ),
                      CustomPaint(
                        painter: ScannerOverlay(
                          borderColor: Theme.of(context).colorScheme.primary,
                        ),
                        child: const SizedBox.expand(),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_isLoading)
                          const CircularProgressIndicator()
                        else if (_error != null)
                          Text(
                            _error!,
                            style: const TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          )
                        else
                          const Text(
                            'Position the QR code within the frame',
                            style: TextStyle(fontSize: 16),
                          ),
                        if (_lastScannedCode != null)
                          Text(
                            'Last scanned: $_lastScannedCode',
                            style: const TextStyle(fontSize: 14),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    _manualIdController.dispose();
    super.dispose();
  }
}

// Custom painter for scanner overlay
class ScannerOverlay extends CustomPainter {
  final Color borderColor;

  ScannerOverlay({required this.borderColor});

  @override
  void paint(Canvas canvas, Size size) {
    final double scanArea = size.width * 0.7;
    final double left = (size.width - scanArea) / 2;
    final double top = (size.height - scanArea) / 2;
    final double right = left + scanArea;
    final double bottom = top + scanArea;

    final Paint borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    final Path path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRect(Rect.fromLTRB(left, top, right, bottom));

    canvas.drawPath(path, Paint()..color = Colors.black54);
    canvas.drawRect(
        Rect.fromLTRB(left, top, right, bottom), borderPaint);

    // Draw corner markers
    const double markerLength = 20;
    
    // Top left corner
    canvas.drawLine(Offset(left, top + markerLength), Offset(left, top), borderPaint);
    canvas.drawLine(Offset(left, top), Offset(left + markerLength, top), borderPaint);

    // Top right corner
    canvas.drawLine(Offset(right - markerLength, top), Offset(right, top), borderPaint);
    canvas.drawLine(Offset(right, top), Offset(right, top + markerLength), borderPaint);

    // Bottom left corner
    canvas.drawLine(Offset(left, bottom - markerLength), Offset(left, bottom), borderPaint);
    canvas.drawLine(Offset(left, bottom), Offset(left + markerLength, bottom), borderPaint);

    // Bottom right corner
    canvas.drawLine(Offset(right - markerLength, bottom), Offset(right, bottom), borderPaint);
    canvas.drawLine(Offset(right, bottom), Offset(right, bottom - markerLength), borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 