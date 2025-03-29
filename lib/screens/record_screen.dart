import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';
import '../widgets/media_tab_control.dart';

class RecordScreen extends StatefulWidget {
  const RecordScreen({super.key});

  @override
  _RecordScreenState createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  int _selectedTabIndex = 0;
  final List<String> _tabLabels = ['Picture', 'Video', 'Audio', 'Text'];
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  bool _isCameraInitialized = false;
  bool _isFrontCamera = false;
  bool _isFlashOn = false;
  
  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    // Request camera permissions
    final cameraPermission = await Permission.camera.request();
    if (cameraPermission != PermissionStatus.granted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Camera permission is required')),
      );
      return;
    }

    // Get available cameras
    try {
      _cameras = await availableCameras();
      
      // Initialize with rear camera by default
      if (_cameras.isNotEmpty) {
        await _setupCamera(_cameras.first);
      }
    } catch (e) {
      debugPrint('Error initializing camera: $e');
    }
  }
  
  Future<void> _setupCamera(CameraDescription camera) async {
    if (_cameraController != null) {
      await _cameraController!.dispose();
    }

    _cameraController = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    try {
      await _cameraController!.initialize();
      setState(() {
        _isCameraInitialized = true;
      });
    } catch (e) {
      debugPrint('Error initializing camera controller: $e');
    }
  }

  Future<void> _toggleCamera() async {
    if (_cameras.length < 2) return;
    
    _isFrontCamera = !_isFrontCamera;
    
    final newCamera = _isFrontCamera 
        ? _cameras.firstWhere((camera) => camera.lensDirection == CameraLensDirection.front)
        : _cameras.firstWhere((camera) => camera.lensDirection == CameraLensDirection.back);
    
    await _setupCamera(newCamera);
  }

  Future<void> _toggleFlash() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }
    
    if (_isFrontCamera) {
      // Front camera typically doesn't have flash
      return;
    }
    
    setState(() {
      _isFlashOn = !_isFlashOn;
    });
    
    try {
      await _cameraController!.setFlashMode(
        _isFlashOn ? FlashMode.torch : FlashMode.off,
      );
    } catch (e) {
      debugPrint('Error toggling flash: $e');
    }
  }

  Future<void> _takePicture() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    try {
      final XFile photo = await _cameraController!.takePicture();

      // Get application documents directory
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String dirPath = '${appDir.path}/Pictures';
      
      // Create the directory if it doesn't exist
      await Directory(dirPath).create(recursive: true);
      
      // Generate a unique file name
      final String fileName = path.basename(photo.path);
      final String filePath = '$dirPath/$fileName';
      
      // Copy the image to app's documents directory
      final File newFile = File(filePath);
      await newFile.writeAsBytes(await photo.readAsBytes());
      
      // Show a success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Picture saved to: $filePath')),
        );
      }
    } catch (e) {
      debugPrint('Error taking picture: $e');
    }
  }
  
  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Record'),
        elevation: 0,
        backgroundColor: Colors.white,
        titleTextStyle: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          // iOS-style segmented tab control
          MediaTabControl(
            selectedIndex: _selectedTabIndex,
            onTabChanged: (index) {
              setState(() {
                _selectedTabIndex = index;
              });
            },
            tabLabels: _tabLabels,
          ),
          
          // Tab content
          Expanded(
            child: IndexedStack(
              index: _selectedTabIndex,
              children: [
                _buildPictureTab(),
                const Center(child: Text('Video Tab - Coming Soon')),
                const Center(child: Text('Audio Tab - Coming Soon')),
                const Center(child: Text('Text Tab - Coming Soon')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPictureTab() {
    return Stack(
      children: [
        // Camera preview
        _isCameraInitialized
            ? Center(
                child: AspectRatio(
                  aspectRatio: _cameraController!.value.aspectRatio,
                  child: CameraPreview(_cameraController!),
                ),
              )
            : const Center(child: CircularProgressIndicator()),
            
        // Camera controls overlay
        if (_isCameraInitialized)
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Top controls (flash, settings)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Flash toggle button
                      IconButton(
                        icon: Icon(
                          _isFlashOn ? Icons.flash_on : Icons.flash_off,
                          color: Colors.white,
                          size: 28,
                        ),
                        onPressed: _toggleFlash,
                      ),
                      
                      // Settings or options button
                      IconButton(
                        icon: const Icon(
                          Icons.settings,
                          color: Colors.white,
                          size: 28,
                        ),
                        onPressed: () {
                          // Handle settings
                        },
                      ),
                    ],
                  ),
                ),
                
                // Bottom controls (camera button, camera switch)
                Padding(
                  padding: const EdgeInsets.only(bottom: 32.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Placeholder for symmetry
                      const SizedBox(width: 60),
                      
                      // Camera capture button (Apple style)
                      GestureDetector(
                        onTap: _takePicture,
                        child: Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 4,
                            ),
                          ),
                          child: Container(
                            margin: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                      
                      // Camera switch button
                      IconButton(
                        icon: const Icon(
                          Icons.flip_camera_ios,
                          color: Colors.white,
                          size: 36,
                        ),
                        onPressed: _toggleCamera,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
