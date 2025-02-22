import 'package:colornestle/pages/panorama_screen.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../utils/config.dart';
import '../utils/interior_image_api.dart';

class MarkedObject {
  final List<Offset> points;  // List of coordinates (x, y)
  final double area;          // The area of the object (in percentage)
  final String label;         // Label for the object
  final Path path;            // Path (optional, could be used for drawing)

  MarkedObject({
    required this.points,
    required this.area,
    required this.label,
    required this.path,
  });

  // Convert the MarkedObject to JSON format with coordinates as required
  Map<String, dynamic> toJson() {
    return {
      'coordinates': points
          .map((point) => {
                'x': double.parse(point.dx.toStringAsFixed(2)), // Format x coordinate
                'y': double.parse(point.dy.toStringAsFixed(2)), // Format y coordinate
              })
          .toList(),
    };
  }
}

class PhotoMarkingApp extends StatefulWidget {
  const PhotoMarkingApp({super.key});

  @override
  _PhotoMarkingAppState createState() => _PhotoMarkingAppState();
}

class _PhotoMarkingAppState extends State<PhotoMarkingApp> {
  List<MarkedObject> _markedObjects = [];
  String name = "Charitha Adikari";
  String email = "defaultEmail@example.com";
  File? _image;
  bool _hasSeenGuidelines = false; 
  //final List<MarkedObject> _markedObjects = [];
  final List<Offset> _currentPoints = [];
  bool _isMarking = false;
  final TextEditingController _labelController = TextEditingController();
  Size? _imageSize;

  @override
  void dispose() {
    _labelController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    //_pickImage(); // Automatically open the camera when the page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showGuidelinesDialog(); // Show guidelines first
    });
  }

  String generateJsonData() {
    final List<Map<String, dynamic>> objectsData =
        _markedObjects.map((obj) => obj.toJson()).toList();
    final Map<String, dynamic> exportData = {
      'image_info': {
        'width': _imageSize?.width ?? 0,
        'height': _imageSize?.height ?? 0,
        'timestamp': DateTime.now().toIso8601String(),
      },
      'marked_objects': objectsData,
    };
    return const JsonEncoder.withIndent('  ').convert(exportData);
  }

  Future<void> _showGuidelinesDialog() async {
    if (!_hasSeenGuidelines) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            'Image Capture Guidelines',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Colors.black87,
            ),
          ),
          content: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildGuidelineItem(Icons.wb_sunny_outlined, 'Ensure good lighting in the room'),
                _buildGuidelineItem(Icons.stay_current_portrait, 'Hold your phone steady and parallel to the wall'),
                _buildGuidelineItem(Icons.crop_landscape, 'Capture the entire room in landscape mode'),
                _buildGuidelineItem(Icons.highlight_off, 'Avoid reflections and shadows if possible'),
                _buildGuidelineItem(Icons.visibility, 'Make sure objects are clearly visible'),
                const SizedBox(height: 16),
                const Text(
                  'After capturing:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
                _buildGuidelineItem(Icons.touch_app, 'Tap points to mark objects'),
                _buildGuidelineItem(Icons.category, 'Connect at least 3 points to form an area'),
                _buildGuidelineItem(Icons.label, 'Label each marked object'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _hasSeenGuidelines = true;
                });
                _pickImage();
              },
              child: const Text(
                'Skip',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _hasSeenGuidelines = true;
                });
                _pickImage();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: const Text(
                'Got it!',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      _pickImage();
    }
  }

  Widget _buildGuidelineItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Future<int?> _uploadImage(File imageFile, String email) async {
  //   try {
  //     final now = DateTime.now();
  //     final fileName =
  //         'image_${now.year}-${now.month}-${now.day}_${now.hour}-${now.minute}-${now.second}.jpg';
  //     final uri = Uri.parse('${Config.baseUrl}/api/images/room');
  //     final request = http.MultipartRequest('POST', uri);

  //     // Add the image file
  //     final file = await http.MultipartFile.fromPath('file', imageFile.path,
  //         filename: fileName);
  //     request.files.add(file);

  //     // Add email field
  //     request.fields['email'] = email;

  //     final response = await request.send();

  //     if (response.statusCode == 200) {
  //       final responseBody = await response.stream.bytesToString();
  //       final responseData = jsonDecode(responseBody);
  //       final imageId = responseData['interiorImageId'];

  //       logger.i('Image uploaded successfully, Image ID: $imageId');

  //       return imageId; // Return the image ID
  //     } else {
  //       logger.e('Failed to upload image: ${response.statusCode}');
  //       return null;
  //     }
  //   } catch (e) {
  //     logger.e('Error during image upload: $e');
  //     return null;
  //   }
  // }

  Future<Map<String, dynamic>?> _uploadImage(
  File imageFile,
  String email,
  double roomWidth,
  double roomHeight,
  List<Map<String, dynamic>> markedObjects,
) async {
  try {
    final now = DateTime.now();
    final fileName = 'image_${now.year}-${now.month}-${now.day}_${now.hour}-${now.minute}-${now.second}.jpg';
    final uri = Uri.parse('${Config.baseUrl}/api/images/room');
    final request = http.MultipartRequest('POST', uri);

    // Add the image file
    final file = await http.MultipartFile.fromPath('file', imageFile.path, filename: fileName);
    request.files.add(file);

    // Add other fields
    request.fields['email'] = email;
    request.fields['roomWidth'] = roomWidth.toString();
    request.fields['roomHeight'] = roomHeight.toString();
    request.fields['markedObjects'] = jsonEncode(markedObjects);

    // Send the request
    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final responseData = jsonDecode(responseBody);
      return responseData;
    } else {
      throw Exception('Server responded with ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error during upload: $e');
  }
}


  Future<void> _saveJsonFile() async {
    if (_markedObjects.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No objects marked yet')),
      );
      return;
    }

    try {
      final directory = await getApplicationDocumentsDirectory();
      final fileName =
          'marked_objects_${DateTime.now().millisecondsSinceEpoch}.json';
      final file = File('${directory.path}/$fileName');
      await file.writeAsString(generateJsonData());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('JSON saved: ${file.path}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving JSON: $e')),
      );
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1920,
      maxHeight: 1080,
      imageQuality: 90,
    );

    if (pickedFile != null) {
      final File image = File(pickedFile.path);
      final decodedImage = await decodeImageFromList(await image.readAsBytes());

      setState(() {
        _image = image;
        _markedObjects.clear();
        _currentPoints.clear();
        _imageSize = Size(
          decodedImage.width.toDouble(),
          decodedImage.height.toDouble(),
        );
      });
    }
  }

  double _calculateArea(List<Offset> points) {
    if (points.length < 3) return 0;

    double area = 0;
    for (int i = 0; i < points.length; i++) {
      int j = (i + 1) % points.length;
      area += points[i].dx * points[j].dy;
      area -= points[j].dx * points[i].dy;
    }
    area = area.abs() / 2;

    if (_imageSize != null) {
      final imageArea = _imageSize!.width * _imageSize!.height;
      return (area / imageArea) * 100;
    }
    return area;
  }

  Path _createPath(List<Offset> points) {
    final path = Path();
    if (points.isEmpty) return path;

    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    path.close();
    return path;
  }

  void _startNewMarking() {
    setState(() {
      _isMarking = true;
      _currentPoints.clear();
    });
  }

  void _finishMarking() {
    if (_currentPoints.length >= 3) {
      final path = _createPath(_currentPoints);

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Add Object Label'),
          content: TextField(
            controller: _labelController,
            decoration: const InputDecoration(
              labelText: 'Enter object label',
              hintText: 'e.g., Car, Person, Building',
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _currentPoints.clear();
                  _isMarking = false;
                });
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_labelController.text.isNotEmpty) {
                  setState(() {
                    _markedObjects.add(MarkedObject(
                      points: List.from(_currentPoints),
                      area: _calculateArea(_currentPoints),
                      label: _labelController.text,
                      path: path,
                    ));
                    _currentPoints.clear();
                    _isMarking = false;
                  });
                  _labelController.clear();
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      );
    } else {
      setState(() {
        _currentPoints.clear();
        _isMarking = false;
      });
    }
  }

  // Future<Map<String, dynamic>> analyzeComplexity(
  //     int imageId, String email, double roomWidth, double roomHeight) async {
  //   // Check for required parameters first
  //   if (imageId == null || email == null || email.isEmpty) {
  //     throw Exception('Invalid imageId or email');
  //   }

  //   try {
  //     // Validate image and marked objects
  //     if (_image == null) {
  //       throw Exception('No image selected');
  //     }

  //     if (_markedObjects == null || _markedObjects.isEmpty) {
  //       throw Exception('No objects marked');
  //     }

  //     if (_imageSize == null) {
  //       throw Exception('Image size not available');
  //     }

  //     // Prepare the marked objects data with null safety
  //     final List<Map<String, dynamic>> objectsData = _markedObjects
  //         .where((obj) =>
  //             obj != null && obj.points != null) // Filter out null objects
  //         .map((obj) {
  //       return {
  //         'coordinates': obj.points
  //             .where((point) => point != null) // Filter out null points
  //             .map((point) => {
  //                   'x': point.dx,
  //                   'y': point.dy,
  //                 })
  //             .toList(),
  //       };
  //     }).toList();

  //     // Check if we have valid objects after filtering
  //     if (objectsData.isEmpty) {
  //       throw Exception('No valid marked objects found');
  //     }

  //     // Convert image to base64 with null check
  //     final bytes = await _image!.readAsBytes();
  //     if (bytes == null || bytes.isEmpty) {
  //       throw Exception('Failed to read image bytes');
  //     }
  //     final base64Image = base64Encode(bytes);

  //     // Prepare the request data
  //     final requestData = {
  //       'image': base64Image,
  //       'image_id': imageId,
  //       'email': email,
  //       'room_width': roomWidth,
  //       'room_height': roomHeight,
  //       'marked_objects': objectsData,
  //     };

  //     // Send request to Flask API
  //     final response = await http.post(
  //       Uri.parse('http://10.0.2.2:5000/analyze_complexity'),
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode(requestData),
  //     );

  //     if (response.statusCode == 200) {
  //       final decodedResponse = jsonDecode(response.body);
  //       if (decodedResponse == null) {
  //         throw Exception('Received null response from server');
  //       }
  //       return decodedResponse;
  //     } else {
  //       throw Exception('Failed to analyze complexity: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     logger.e('Error analyzing complexity: $e');
  //     rethrow;
  //   }
  // }

// Modified _showSaveDialog function with proper null safety
  // Future<void> _showSaveDialog() async {
  //   if (!mounted) return; // Check if widget is mounted

  //   final shouldSave = await showDialog<bool>(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: const Text('Save and Analyze'),
  //       content: const Text('Do you want to save and analyze the image?'),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.of(context).pop(false),
  //           child: const Text('No'),
  //         ),
  //         TextButton(
  //           onPressed: () => Navigator.of(context).pop(true),
  //           child: const Text('Yes'),
  //         ),
  //       ],
  //     ),
  //   );

  //   if (shouldSave == true && _image != null && mounted) {
  //     final TextEditingController widthController = TextEditingController();
  //     final TextEditingController heightController = TextEditingController();

  //     final dimensionsProvided = await showDialog<bool>(
  //       context: context,
  //       builder: (context) => AlertDialog(
  //         title: const Text('Room Dimensions'),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             TextField(
  //               controller: widthController,
  //               keyboardType: TextInputType.number,
  //               decoration: const InputDecoration(
  //                 labelText: 'Room Width (m)',
  //               ),
  //             ),
  //             TextField(
  //               controller: heightController,
  //               keyboardType: TextInputType.number,
  //               decoration: const InputDecoration(
  //                 labelText: 'Room Height (m)',
  //               ),
  //             ),
  //           ],
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.of(context).pop(false),
  //             child: const Text('Cancel'),
  //           ),
  //           ElevatedButton(
  //             onPressed: () => Navigator.of(context).pop(true),
  //             child: const Text('Submit'),
  //           ),
  //         ],
  //       ),
  //     );

  //     if (dimensionsProvided == true) {
  //       final roomWidth = double.tryParse(widthController.text) ?? 0;
  //       final roomHeight = double.tryParse(heightController.text) ?? 0;

  //       if (roomWidth <= 0 || roomHeight <= 0) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(content: Text('Invalid room dimensions entered')),
  //         );
  //         return;
  //       }

  //       try {
  //         // Show loading dialog
  //         if (!mounted) return;
  //         showDialog(
  //           context: context,
  //           barrierDismissible: false,
  //           builder: (context) =>
  //               const Center(child: CircularProgressIndicator()),
  //         );

  //         // Upload image and get ID
  //         final imageIdUpload = await _uploadImage(_image!, email);
  //         if (imageIdUpload == null) {
  //           throw Exception('Failed to upload image');
  //         }

  //         final imageId = await getImageIdByEmail(email);
  //         if (imageId == null) {
  //           throw Exception('Failed to get valid Image ID');
  //         }

  //         // Analyze complexity with room dimensions
  //         final complexityResults =
  //             await analyzeComplexity(imageId, email, roomWidth, roomHeight);

  //         // Hide loading dialog
  //         if (!mounted) return;
  //         Navigator.of(context).pop();

  //         // Show results dialog
  //         if (!mounted) return;
  //         await showDialog(
  //           context: context,
  //           builder: (context) => AlertDialog(
  //             title: const Text('Analysis Results'),
  //             content: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
                
  //                 Text(
  //                     'Final Complexity Score: ${(complexityResults['final_complexity_score'] ?? 0).toStringAsFixed(2)}'),
  //                 Text(
  //                     'Complexity Level: ${complexityResults['complexity_level'] ?? 'Unknown'}'),
  //               ],
  //             ),
  //             actions: [
  //               TextButton(
  //                 onPressed: () {
  //                   Navigator.of(context).pop();
  //                   if (mounted && imageId != null) {
  //                     Navigator.of(context)
  //                         .pushNamed('/preferenceform', arguments: {
  //                       'name': name,
  //                       'email': email,
  //                       'imageid': imageId,
  //                       'complexity_results': complexityResults,
  //                     });
  //                   }
  //                 },
  //                 child: const Text('OK'),
  //               ),
  //             ],
  //           ),
  //         );
  //       } catch (e) {
  //         // Hide loading dialog if showing
  //         if (mounted) {
  //           Navigator.of(context).pop();

  //           // Show error dialog
  //           await showDialog(
  //             context: context,
  //             builder: (context) => AlertDialog(
  //               title: const Text('Error'),
  //               content: Text('Failed to analyze image: $e'),
  //               actions: [
  //                 TextButton(
  //                   onPressed: () => Navigator.of(context).pop(),
  //                   child: const Text('OK'),
  //                 ),
  //               ],
  //             ),
  //           );
  //         }
  //       }
  //     }
  //   }
  // }

  

  // Update the _showSaveDialog method
  Future<void> _showSaveDialog() async {
    if (!mounted) return;

    final shouldSave = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Save and Analyze'),
        content: const Text('Do you want to save and analyze the image?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    if (shouldSave == true && _image != null && mounted) {
      // Room dimensions dialog logic...
      final TextEditingController widthController = TextEditingController();
      final TextEditingController heightController = TextEditingController();

      final dimensionsProvided = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Room Dimensions'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: widthController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Room Width (m)',
                ),
              ),
              TextField(
                controller: heightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Room Height (m)',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Submit'),
            ),
          ],
        ),
      );

      if (dimensionsProvided == true) {
        final roomWidth = double.tryParse(widthController.text) ?? 0;
        final roomHeight = double.tryParse(heightController.text) ?? 0;

        if (roomWidth <= 0 || roomHeight <= 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid room dimensions entered')),
          );
          return;
        }

        try {
          // Show loading dialog
          if (!mounted) return;
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const Center(child: CircularProgressIndicator()),
          );

          // Prepare marked objects data
          final markedObjectsData = _markedObjects.map((obj) => obj.toJson()).toList();

          // Upload data
          final response = await _uploadImage(_image!, email, roomWidth, roomHeight, markedObjectsData);
          
          // Close loading dialog
          Navigator.of(context).pop();

          if (response != null) {
            // Show success toast
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Image uploaded successfully!'),
                duration: Duration(seconds: 2),
              ),
            );

            // Navigate to preference form
            Future.delayed(const Duration(seconds: 2), () {
              Navigator.of(context).pushReplacementNamed(
                '/preferenceform',
                arguments: {
                  'email': email,
                  'imageId': response['interiorImageId'],
                  'imageUrl': response['imageUrl'],
                },
              );
            });
          }
        } catch (e) {
          // Close loading dialog and show error
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to upload: $e')),
          );
        }
      }
    }
  }


  void _showMarkedObjects() {
    if (_markedObjects.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No objects marked yet')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Marked Objects'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ..._markedObjects.asMap().entries.map((entry) {
                final index = entry.key + 1;
                final object = entry.value;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$index. ${object.label}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('Points: ${object.points.length}'),
                      Text('Area: ${object.area.toStringAsFixed(2)}% of image'),
                      const Text('Coordinates:',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      ...object.points.map((point) => Text(
                          '  (${point.dx.toStringAsFixed(1)}, ${point.dy.toStringAsFixed(1)})')),
                    ],
                  ),
                );
              }),
              const Divider(),
              const Text(
                'JSON Data:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  generateJsonData(),
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              _saveJsonFile();
              Navigator.pop(context);
            },
            child: const Text('Export JSON'),
          ),
        ],
      ),
    );
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

    return Theme(
      data: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.black,
          iconTheme: IconThemeData(color: Colors.white),
        ),
      ),

      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Mark Objects',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          actions: _buildAppBarActions(),
        ),
        body: _buildBody(),
        floatingActionButton: _buildFloatingActionButtons(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
  List<Widget> _buildAppBarActions() {
    return [
      IconButton(
        icon: const Icon(Icons.list_alt_rounded, size: 28),
        onPressed: _showMarkedObjects,
        tooltip: 'Show Marked Objects',
      ),
      IconButton(
        icon: const Icon(Icons.save_alt_rounded, size: 28),
        onPressed: _saveJsonFile,
        tooltip: 'Export JSON',
      ),
    ];
  }

  Widget _buildFloatingActionButtons() {
    if (_image == null) return Container();

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton.extended(
            onPressed: _isMarking ? _finishMarking : _startNewMarking,
            label: Text(_isMarking ? 'Finish' : 'Mark'),
            icon: Icon(_isMarking ? Icons.check : Icons.edit),
            backgroundColor: Colors.blue,
            heroTag: 'mark',
          ),
          FloatingActionButton.extended(
            onPressed: _showSaveDialog,
            label: const Text('Upload'),
            icon: const Icon(Icons.upload_rounded),
            backgroundColor: Colors.green,
            heroTag: 'upload',
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_image == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      );
    }

    return GestureDetector(
      onTapDown: _isMarking
          ? (details) {
              setState(() {
                _currentPoints.add(details.localPosition);
              });
            }
          : null,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.file(
            _image!,
            fit: BoxFit.contain,
          ),
          CustomPaint(
            painter: PolygonMarker(
              markedObjects: _markedObjects,
              currentPoints: _currentPoints,
              isMarking: _isMarking,
            ),
          ),
        ],
      ),
    );
  }
}

class PolygonMarker extends CustomPainter {
  final List<MarkedObject> markedObjects;
  final List<Offset> currentPoints;
  final bool isMarking;

  PolygonMarker({
    required this.markedObjects,
    required this.currentPoints,
    required this.isMarking,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint polygonPaint = Paint()
      ..color = Colors.blue.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final Paint fillPaint = Paint()
      ..color = Colors.blue.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final Paint pointPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
    );

    // Draw existing marked objects
    for (final object in markedObjects) {
      canvas.drawPath(object.path, fillPaint);
      canvas.drawPath(object.path, polygonPaint);

      // Draw label
      textPainter.text = TextSpan(
        text: object.label,
        style: TextStyle(
          color: Colors.white,
          backgroundColor: Colors.blue.withOpacity(0.7),
          fontSize: 16,
        ),
      );
      textPainter.layout();
      if (object.points.isNotEmpty) {
        textPainter.paint(
          canvas,
          Offset(object.points[0].dx, object.points[0].dy - 20),
        );
      }
    }

    // Draw current points and lines
    if (currentPoints.isNotEmpty && isMarking) {
      // Draw points
      for (final point in currentPoints) {
        canvas.drawCircle(point, 4, pointPaint);
      }

      // Draw lines between points
      final path = Path();
      path.moveTo(currentPoints[0].dx, currentPoints[0].dy);
      for (int i = 1; i < currentPoints.length; i++) {
        path.lineTo(currentPoints[i].dx, currentPoints[i].dy);
      }
      if (currentPoints.length > 2) {
        path.close();
      }
      canvas.drawPath(path, polygonPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
