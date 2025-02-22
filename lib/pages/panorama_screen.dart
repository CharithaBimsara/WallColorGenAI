import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:colornestle/utils/config.dart';

import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;

import '../models/images_stitch.dart';

final logger = Logger();

class PanoramaScreen extends StatefulWidget {
  const PanoramaScreen({super.key});

  @override
  PanoramaScreenState createState() => PanoramaScreenState();
}

class PanoramaScreenState extends State<PanoramaScreen> {
  String name = "Charitha Adikari";
  String email = "defaultEmail@example.com";

  CameraController? _controller;
  List<CameraDescription>? _cameras;
  final List<File> _imageFiles = [];
  bool _isCapturing = false;
  bool _isProcessing = false;
  bool _isFlashOn = false;
  Timer? _captureTimer;
  img.Image? _stitchedImage;
  Color _buttonColor = Colors.green;
  String? _stitchedImagePath;
  int _currentStep = 0;

  // Define your guidelines here
  final List<String> _guidelines = [
    "First tap the CAMERA BUTTON\nto start caputre image",
    "Move the camera left or right side",
    "Tap the\nRETRY button to Capture again",
    // Add more as needed
  ];
  void _nextGuideline() {
    if (_currentStep < _guidelines.length - 1) {
      setState(() {
        _currentStep++;
      });
    } else {
      setState(() {
        _currentStep = _guidelines.length;
      });
    }
  }

  void _skipGuidelines() {
    setState(() {
      _currentStep = _guidelines.length;
    });
  }

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera([bool wideAngle = false]) async {
    _cameras = await availableCameras();
    final selectedCamera = wideAngle
        ? _cameras?.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.back)
        : _cameras?.first;

    _controller = CameraController(
      selectedCamera!,
      ResolutionPreset.high,
      enableAudio: false,
    );

    await _controller?.initialize();
    setState(() {});
  }

  Future<void> _switchCamera() async {
    if (_cameras == null || _cameras!.isEmpty) return;

    final lensDirection = _controller?.description.lensDirection;
    CameraDescription newCamera;

    if (lensDirection == CameraLensDirection.front) {
      newCamera = _cameras!.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.back);
    } else {
      newCamera = _cameras!.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front);
    }

    await _controller?.dispose();

    _controller = CameraController(
      newCamera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    await _controller?.initialize();
    setState(() {});
  }

  void _startAutoCapture() {
    if (_isCapturing) return;

    setState(() {
      _isCapturing = true;
      _buttonColor = Colors.red;
    });

    _captureTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (_controller != null &&
          _controller!.value.isInitialized &&
          !_isProcessing) {
        _isProcessing = true;
        try {
          final image = await _controller!.takePicture();
          final orientedImage =
              await _correctImageOrientation(File(image.path), 90);

          setState(() {
            _imageFiles.add(orientedImage);
          });

          // Limit the number of images in memory
          if (_imageFiles.length > 10) {
            _imageFiles.removeAt(0);
          }

          if (_imageFiles.length > 1) {
            await _stitchImages();
          } else {
            setState(() {
              _stitchedImage = img.decodeImage(orientedImage.readAsBytesSync());
            });
          }
        } catch (e) {
          logger.e('Error capturing image: $e');
        } finally {
          _isProcessing = false;
        }
      }
    });
  }

  void _stopAutoCapture() {
  _captureTimer?.cancel();
  setState(() {
    _isCapturing = false;
    _buttonColor = Colors.green;
  });

  // Ensure the dialog is shown only after stitching is complete
  if (_stitchedImagePath != null) {
    Future.delayed(const Duration(seconds: 2), () {
      _showSaveDialog();
    });
  } else {
    // Add a listener for when stitching is complete
    _stitchImages().then((_) {
      if (_stitchedImagePath != null) {
        _showSaveDialog();
      } else {
        logger.e("Stitched image path is null after stitching.");
      }
    }).catchError((error) {
      logger.e("Error during stitching: $error");
    });
  }
}


  void _retryCapture() {
    setState(() {
      _imageFiles.clear();
      _stitchedImage = null;
      _stitchedImagePath = null;
    });
  }

  void _toggleFlash() {
    if (_controller != null) {
      setState(() {
        _isFlashOn = !_isFlashOn;
      });
      _controller!.setFlashMode(
        _isFlashOn ? FlashMode.torch : FlashMode.off,
      );
    }
  }

  

  Future<int?> _uploadImage(File imageFile, String email) async {
    final now = DateTime.now();
    final fileName =
        'image_${now.year}-${now.month}-${now.day}_${now.hour}-${now.minute}-${now.second}.jpg';
    final uri = Uri.parse('${Config.baseUrl}/api/images/room');
    final request = http.MultipartRequest('POST', uri);
    final file = await http.MultipartFile.fromPath('file', imageFile.path,
        filename: fileName);
    request.files.add(file);
    request.fields['email'] = email;

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final responseData = jsonDecode(responseBody);
      final imageid = responseData['interiorImageId'];

      logger.i('Image uploaded successfully: $responseBody');

      // Return the imageid
      return imageid;
    } else {
      logger.e('Failed to upload image: ${response.statusCode}');
      return null;
    }
  }

  Future<void> _showSaveDialog() async {
  final shouldSave = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Save Image'),
        content: Text('Do you want to mark objects in the panorama image?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text('Yes'),
          ),
        ],
      );
    },
  );

  if (shouldSave == true && _stitchedImagePath != null) {
    final imageid = await _uploadImage(File(_stitchedImagePath!), email);

    if (imageid != null) {
      // Navigate to the object marking page
      Navigator.of(context).pushNamed('/objectmarking', arguments: {
        'imagePath': _stitchedImagePath!,
        'imageid': imageid,
        'email': email,
        'name': name,
      });
    }
  }
}


  Future<File> _correctImageOrientation(
      File imageFile, int rotationDegrees) async {
    final Completer<File> completer = Completer();
    final originalBytes = await imageFile.readAsBytes();

    ReceivePort receivePort = ReceivePort();
    await Isolate.spawn(_correctOrientationIsolate, {
      'imageBytes': originalBytes,
      'rotationDegrees': rotationDegrees,
      'sendPort': receivePort.sendPort,
    });

    receivePort.listen((data) {
      if (data is File) {
        completer.complete(data);
      } else if (data is String && data == 'error') {
        completer.completeError('Image orientation correction failed.');
      }
    });

    return completer.future;
  }

  static void _correctOrientationIsolate(Map<String, dynamic> params) {
    final originalBytes = params['imageBytes'] as Uint8List;
    final rotationDegrees = params['rotationDegrees'] as int;
    final SendPort sendPort = params['sendPort'] as SendPort;

    final originalImage = img.decodeImage(originalBytes);
    img.Image? orientedImage;

    if (originalImage != null) {
      orientedImage = img.copyRotate(originalImage, rotationDegrees);
      final orientedBytes = img.encodeJpg(orientedImage);

      final tempDir = Directory.systemTemp;
      final tempFile =
          File('${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg');
      tempFile.writeAsBytesSync(orientedBytes);

      sendPort.send(tempFile);
    } else {
      sendPort.send('error');
    }
  }

  Future<void> _stitchImages() async {
    final directory = await getApplicationDocumentsDirectory();
    final outputPath = "${directory.path}/stitched_image.jpg";
    final imagesPathToStitch = _imageFiles.map((file) => file.path).toList();

    final Completer<void> completer = Completer();
    ReceivePort receivePort = ReceivePort();
    await Isolate.spawn(_stitchImagesInIsolate, {
      'imagePaths': imagesPathToStitch,
      'stitchedImagePath': outputPath,
      'sendPort': receivePort.sendPort,
    });

    receivePort.listen((data) {
      if (data == 'done') {
        completer.complete();
        setState(() {
          _stitchedImage = img.decodeImage(File(outputPath).readAsBytesSync());
          _stitchedImagePath = outputPath;
        });
      } else if (data == 'error') {
        completer.completeError('Image stitching failed.');
      }
    });

    await completer.future;
  }

  static void _stitchImagesInIsolate(Map<String, dynamic> params) async {
    final List<String> imagePaths = List<String>.from(params['imagePaths']);
    final String stitchedImagePath = params['stitchedImagePath'];
    final SendPort sendPort = params['sendPort'] as SendPort;

    final ImagesStitch stitcher = ImagesStitch();
    await stitcher.stitchImages(imagePaths, stitchedImagePath, false,
        (resultPath) {
      if (resultPath == stitchedImagePath) {
        sendPort.send('done');
      } else {
        sendPort.send('error');
      }
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    _captureTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    // If args is not null, update name and email
    if (args != null) {
      name = args['name'] ?? "Charitha Adikari";
      email = args['email'] ?? "defaultEmail@example.com";
    }

    return Scaffold(
      body: Stack(
        children: [
          if (_controller != null && _controller!.value.isInitialized)
            Positioned.fill(
              child: CameraPreview(_controller!),
            ),
          if (_currentStep < _guidelines.length)
            Positioned.fill(
              child: Container(
                color: Colors.black54,
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 150,
                      width: 300,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            _guidelines[_currentStep],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15.0,
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 0),
                                ),
                                onPressed: _skipGuidelines,
                                child: Text("Skip",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w900)),
                              ),
                              SizedBox(width: 20.0),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 0),
                                ),
                                onPressed: _nextGuideline,
                                child: Text('Next',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.green,
                                        fontWeight: FontWeight.w900)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (_stitchedImage != null)
            Positioned(
              bottom: 150,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: double.infinity,
                  height: 100,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.memory(
                      Uint8List.fromList(img.encodeJpg(_stitchedImage!)),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 150,
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 100),

                  FloatingActionButton(
                    heroTag: 'switchCamera',
                    onPressed: _switchCamera,
                    child: Icon(Icons.switch_camera),
                  ),

                  Expanded(
                    child: SizedBox(
                      width: 80,
                      height: 80,
                      child: FloatingActionButton(
                        heroTag: 'capture',
                        onPressed: () {
                          if (_isCapturing) {
                            _stopAutoCapture();
                          } else {
                            _startAutoCapture();
                          }
                        },
                        backgroundColor: Colors.white,
                        elevation: 5,
                        highlightElevation: 10,
                        shape: CircleBorder(),
                        child: Container(
                          height: 70,
                          width: 70,
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _buttonColor,
                          ),
                          child: Icon(
                            _isCapturing ? Icons.stop : Icons.camera,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Add space between buttons
                  FloatingActionButton(
                    heroTag: 'retry',
                    onPressed: _retryCapture,
                    backgroundColor: Colors.black,
                    child: Icon(
                      Icons.refresh,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 50),
                ],
              ),
            ),
          ),
          Positioned(
            top: 100,
            right: 20,
            child: FloatingActionButton(
              heroTag: 'flash',
              onPressed: _toggleFlash,
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: Icon(
                _isFlashOn ? Icons.flash_on : Icons.flash_off,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
