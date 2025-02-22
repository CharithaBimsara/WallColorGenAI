import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'package:colornestle/utils/config.dart';
import 'package:lottie/lottie.dart';

import '../../widgets/button.dart';
import '../../widgets/custom_popup.dart';
import '../../utils/interior_image_api.dart';

class GenerateImage extends StatefulWidget {
  const GenerateImage({super.key});

  @override
  GenerateImageState createState() => GenerateImageState();
}

class GenerateImageState extends State<GenerateImage> {
  String name = "Charitha Adikari";
  String email = "defaultEmail@example.com";
  int? imageid;

  List<Color> _colors = [];
  List<Map<String, String>> _generatedPalette = [];

  bool _isSaved = false;
  bool _hasRated = false;
  int? _selectedColorIndex;
  double _rating = 0.0;
  bool _colorsFromApi = false;

  

  // Predefined color categories with their RGB values
  final Map<String, List<int>> colorCategories = {
    'red': [255, 0, 0],
    'green': [0, 255, 0],
    'blue': [0, 0, 255],
    'yellow': [255, 255, 0],
    'pink': [255, 192, 203],
    'purple': [128, 0, 128],
    'magenta': [255, 0, 255],
    'grey': [128, 128, 128],
    'white': [255, 255, 255],
    'black': [0, 0, 0],
    'brown': [165, 42, 42],
    'orange': [255, 165, 0],
    'turquoise': [64, 224, 208],
    'teal': [0, 128, 128],
    'lavender': [230, 230, 250],
    'navy': [0, 0, 128],
    'beige': [245, 245, 220],
    'coral': [255, 127, 80],
    'mint': [62, 180, 137],
    'peach': [255, 229, 180],
    'gold': [255, 215, 0],
    'silver': [192, 192, 192],
  };

   Future<bool> _onWillPop() async {
    Navigator.pushReplacementNamed(
      context, 
      '/home',
      arguments: {
        'name': name,
        'email': email,
        'imageid': imageid,
      },
    );
    return false; // Prevents default back button behavior
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final Map<String, dynamic>? args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      setState(() {
        name = args['name'] ?? "Charitha Adikari";
        email = args['email'] ?? "defaultEmail@example.com";
        imageid = args['imageid'];
      });

        // Handle the palette format from the API
        if (args['generatedPalette'] != null && args['generatedPalette'].isNotEmpty) {
          List<dynamic> paletteData = args['generatedPalette'];
          _generatedPalette = paletteData
              .map((color) => {
                    'colorName': color['colorName'] as String,
                    'hexValue': color['hexValue'] as String,
                  })
              .toList();

          // Convert hex colors to Color objects
          _colors = _generatedPalette
              .map((color) => _hexToColor(color['hexValue']!))
              .toList();

          _colorsFromApi = false;
    
        } else {
          // If generated palette is empty, fetch colors from API
          await _fetchColorsFromApi();
          _colorsFromApi = true;
        }
        setState(() {});
      }
    });
  }

  Future<void> _fetchImageId() async {
  try {
    // Fetch image ID using email
    imageid = await getImageIdByEmail(email);
    print('Fetched image ID: $imageid');
    setState(() {}); // Trigger UI update if needed
  } catch (e) {
    print('Failed to fetch image ID: $e');
    Fluttertoast.showToast(
      msg: "Failed to fetch image ID. Please try again.",
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
    rethrow; // Allow the error to propagate if needed
  }
}

Future<void> _fetchColorsFromApi() async {
  try {
    // Ensure image ID is fetched first
    if (imageid == null) {
      await _fetchImageId();
    }

    if (imageid == null) {
      throw Exception('Image ID is still null after fetch attempt');
    }

    print('Fetching colors for image ID: $imageid and email: $email');
    final url = Uri.parse('${Config.baseUrl}/api/colorCode/colors/$email/$imageid');
    
    // Add headers for content type
    final headers = {'Content-Type': 'application/json'};
    final response = await http.get(url, headers: headers);

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      // Check if response body is empty
      if (response.body.isEmpty) {
        throw Exception('Empty response received from server');
      }

      // Parse response body
      dynamic decodedResponse;
      try {
        decodedResponse = jsonDecode(response.body);
      } catch (e) {
        print('JSON decode error: $e');
        throw Exception('Failed to parse server response');
      }

      // Handle different response formats
      List<String> colorCodes;
      if (decodedResponse is List) {
        colorCodes = decodedResponse.map((item) => item.toString()).toList();
      } else if (decodedResponse is String) {
        // If response is a single string, try to parse it as JSON
        try {
          var parsed = jsonDecode(decodedResponse);
          if (parsed is List) {
            colorCodes = parsed.map((item) => item.toString()).toList();
          } else {
            throw Exception('Unexpected response format');
          }
        } catch (e) {
          // If it's not JSON, split by comma if it's a comma-separated string
          colorCodes = decodedResponse.split(',').map((s) => s.trim()).toList();
        }
      } else {
        throw Exception('Unexpected response format');
      }

      // Clear existing data
      _generatedPalette = [];
      _colors = [];

      // Process each color code
      for (String hexCode in colorCodes) {
        // Clean the hex code
        String formattedHex = hexCode.trim();
        formattedHex = formattedHex.replaceAll('"', '');  // Remove any quotes
        formattedHex = formattedHex.startsWith('#') ? formattedHex : '#$formattedHex';

        try {
          // Convert hex to color
          Color color = _hexToColor(formattedHex);

          // Get color name based on category
          String colorName = _categorizeHexColor(formattedHex).toUpperCase();

          // Add to generated palette
          _generatedPalette.add({
            'colorName': colorName,
            'hexValue': formattedHex,
          });

          // Add to colors list
          _colors.add(color);
        } catch (e) {
          print('Error processing color code $formattedHex: $e');
          continue;  // Skip invalid color codes
        }
      }

      if (_colors.isEmpty) {
        throw Exception('No valid colors were processed');
      }

      setState(() {});
    } else {
      throw Exception('Failed to load colors: ${response.statusCode}');
    }
  } catch (e) {
    print('Error in _fetchColorsFromApi: $e');
    Fluttertoast.showToast(
      msg: "Failed to load colors. Please try again.",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}

  Color _hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) {
      hex = 'FF' + hex;
    }
    return Color(int.parse(hex, radix: 16));
  }

  
  String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).padLeft(6, '0').substring(2).toUpperCase()}';
  }

  // Function to convert hex code to RGB values
  Map<String, int> hexToRgb(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length != 6) throw ArgumentError('Invalid hex color');
    return {
      'r': int.parse(hex.substring(0, 2), radix: 16),
      'g': int.parse(hex.substring(2, 4), radix: 16),
      'b': int.parse(hex.substring(4, 6), radix: 16),
    };
  }

  // Function to calculate the Euclidean distance between two colors
  double calculateDistance(List<int> color1, Map<String, int> color2) {
    return sqrt(pow(color1[0] - color2['r']!, 2) +
        pow(color1[1] - color2['g']!, 2) +
        pow(color1[2] - color2['b']!, 2));
  }

  // Function to categorize the color
  String categorizeColor(Map<String, int> rgb) {
    double minDistance = double.infinity;
    String closestCategory = 'Unknown';

    colorCategories.forEach((category, color) {
      double distance = calculateDistance(color, rgb);
      if (distance < minDistance) {
        minDistance = distance;
        closestCategory = category;
      }
    });

    return closestCategory;
  }

  String _categorizeHexColor(String hexColor) {
    try {
      final rgb = hexToRgb(hexColor);
      return categorizeColor(rgb);
    } catch (e) {
      return 'Invalid color code';
    }
  }

  Future<void> _save() async {
    if (_isSaved) {
      _showAlreadySavedMessage();
      return;
    }

    final bool? proceed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Warning'),
          content: Text('After saving, you cannot retry and save this color again. However, you can try different images anytime. Do you want to proceed?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text('Proceed'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (proceed != true) return;

    if (!_hasRated) {
      // Show rating dialog and continue with save after rating
      final rating = await _showRatingDialog();
      if (rating != null) {
        setState(() {
          _rating = rating;
          _hasRated = true;
        });
        // Continue with save operation
        await _performSave();
      }
      return;
    }

    // If already rated, proceed with save directly
    await _performSave();
  }

Future<void> _performSave() async {
    if (imageid == null || _selectedColorIndex == null) {
      _showSaveFailMessage();
      return;
    }

    String selectedColorHex = _generatedPalette[_selectedColorIndex!]['hexValue']!;
    String colorGroup = _categorizeHexColor(selectedColorHex);

    try {
      await createColorPallet(
        email,
        imageid!,
        selectedColorHex,
        colorGroup,
        _rating.toString(),
        _generatedPalette.map((color) => color['hexValue']!).toList(),
      );

      setState(() {
        _isSaved = true;
      });

      _showSuccessMessage();
    } catch (e) {
      print('Error saving color palette: $e');
      _showSaveFailMessage();
    }
  }
  Future<void> createColorPallet(
    String email,
    int interiorImageId,
    String selectedColor,
    String colorGroup,
    String rating,
    List<String> colorCodes,
  ) async {
    final url = Uri.parse('${Config.baseUrl}/api/color_pallet_generate');

    // Construct query parameters
    final queryParameters = {
      'email': email,
      'interiorImageId': interiorImageId.toString(),
      'selectedColor': selectedColor,
      'colorGroup': colorGroup,
      'rating': rating,
    };

    // Append query parameters to URL
    final uri = url.replace(queryParameters: queryParameters);

    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode(colorCodes);

    try {
      final response = await http.post(uri, headers: headers, body: body);

      if (response.statusCode == 200) {
        //print('Generation complete');
      } else {
        //print('Failed to generate color pallet: ${response.body}');
      }
    } catch (e) {
      //print('Error occurred while processing: $e');
    }
  }

   void _showAlreadySavedMessage() {
    Fluttertoast.showToast(
      msg: "This color is already saved. You can try different images for new colors.",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void _showSuccessMessage() {
    Fluttertoast.showToast(
      msg: "Item saved successfully.",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void _showSaveFailMessage() {
    Fluttertoast.showToast(
      msg: "Failed to save the item. Please try again.",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

 Future<double?> _showRatingDialog() async {
    return showDialog<double>(
      context: context,
      builder: (BuildContext context) {
        return RatingDialog();
      },
    );
  }

  void _showColorDetailsBottomSheet() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoPopupSurface(
          child: Container(
            width: double.infinity,
            height: 400,
            padding: EdgeInsets.all(20),
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: _colors[_selectedColorIndex!],
                      borderRadius: BorderRadius.circular(15)),
                  child: Align(
                    alignment: Alignment.center,
                    child: Lottie.asset(
                      'assets/Lottie/Animation - 1720264601003 (1).json',
                      width: 100,
                      height: 100,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  _generatedPalette[_selectedColorIndex!]['colorName']!,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  _generatedPalette[_selectedColorIndex!]['hexValue']!,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.red,
                  ),
                ),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (!_colorsFromApi) // Only show Save button if colors are not from API
                      Material(
                        child: CustomButton(
                          text: 'Save',
                          height: 40,
                          width: _colorsFromApi ? 300 : 150, // Full width if only one button
                          onTap: _save,
                        ),
                      ),

                    Material(
                      child: CustomButton(
                        text: 'Visualize',
                        height: 40,
                        width: _colorsFromApi ? 365 : 150, // Full width if only one button
                        onTap: () {

                          Navigator.pop(context);
                          String selectedColorHex =
                              _generatedPalette[_selectedColorIndex!]
                                  ['hexValue']!;
                          Navigator.pushNamed(
                            context,
                            '/P2PVideo',
                            arguments: {
                              'selectedColor': selectedColorHex,
                              'name': name,
                              'email': email,
                              'imageid': imageid,
                            },

                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showRegenerateConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomPopup(
          title: 'Confirm',
          content: 'Are you sure you want to regenerate colors?',
          buttonOneText: 'Yes',
          buttonTwoText: 'No',
          onButtonOnePressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed('/colormatcher', arguments: {
              'imageid': imageid,
              'name': name,
              'email': email,
            });
          },
          onButtonTwoPressed: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
         appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.transparent),
            onPressed: () {
              Navigator.pushReplacementNamed(
                context, 
                '/home',
                arguments: {
                  'name': name,
                  'email': email,
                  'imageid': imageid,
                },
              );
            },
          ),
        ),
        backgroundColor: Colors.white,
        body: _colors.isEmpty
            ? Center(child: CircularProgressIndicator())
            : GridView.builder(
                padding: EdgeInsets.symmetric(vertical: 40, horizontal: 10),
      
              
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                  childAspectRatio: 1
                ),
                itemCount: _colors.length,
                itemBuilder: (context, index) {
                  if (index >= _generatedPalette.length) {
                    return Container(); // Return empty container if invalid
                  }
                  return LayoutBuilder(
                    
                    builder: (context, constraints) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedColorIndex = index;
                          });
                          _showColorDetailsBottomSheet();
                        },
                        
                        child: Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: _colors[index],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        _generatedPalette[index]['colorName'] ??
                                            '',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        _generatedPalette[index]['hexValue'] ??
                                            '',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(vertical: 4),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: _selectedColorIndex == index
                                        ? Colors.green[100]
                                        : Colors.grey[100],
                                  ),
                                  child: Text(
                                    'Select',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: _selectedColorIndex == index
                                          ? Colors.green
                                          : Colors.grey[600],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
        bottomNavigationBar: BottomAppBar(
          height: 30,
          shape: CircularNotchedRectangle(),
          notchMargin: 5.0,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: (_isSaved || _colorsFromApi)

            ? null  // Hide the button when saved
            : ClipRRect(
                borderRadius: BorderRadius.circular(50.0),
                child: FloatingActionButton(
                  onPressed: _showRegenerateConfirmationDialog,
                  tooltip: 'Regenerate Colors',
                  child: Icon(Icons.restart_alt_sharp),
                ),
              ),
      ),
    );
  }
}

class RatingDialog extends StatefulWidget {
  const RatingDialog({super.key});

  @override
  RatingDialogState createState() => RatingDialogState();
}

class RatingDialogState extends State<RatingDialog> {
  double _rating = 0.0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Rate this'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RatingBar.builder(
            initialRating: 0,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              setState(() {
                _rating = rating;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          child: Text('Submit'),
          onPressed: () {
            Navigator.of(context).pop(_rating);
          },
        ),
        TextButton(
          child: Text('Skip'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
