import 'dart:convert';
import 'package:colornestle/pages/navpages/generate_image.dart';
import 'package:colornestle/utils/interior_image_api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utils/config.dart';
import 'navpages/main_page.dart';

class ColorMatcher extends StatefulWidget {
  const ColorMatcher({super.key});

  @override
  State<ColorMatcher> createState() => ColorMatcherState();
}

class ColorMatcherState extends State<ColorMatcher>
    with SingleTickerProviderStateMixin {
  String name = "";
  String email = "defaultEmail@example.com";
  int imageid = 0;

  int _animationStage = 0;
  bool isLoading = true;
  bool dataExists = false;

  late AnimationController _colorAnimationController;
  late Animation<Color?> _colorAnimation;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args != null) {
      if (mounted) {
        setState(() {
          name = args['name'] ?? "Charitha Adikari";
          email = args['email'] ?? "defaultEmail@example.com";
          imageid = int.tryParse(args['imageid']?.toString() ?? '0') ?? 0;
        });
      }
    }

    _checkClientData();
  }

  @override
  void initState() {
    super.initState();
    _colorAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _colorAnimation = ColorTween(
      begin: Colors.blue,
      end: Colors.red,
    ).animate(_colorAnimationController);
  }

  Future<void> _checkClientData() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

    try {
      // Fetch the latest image ID from the server
      final latestImageId = await getImageIdByEmail(email);

      if (latestImageId == null || latestImageId == 0) {
        if (mounted) {
          setState(() {
            _animationStage = 2; // Set to "No data found" stage
            dataExists = false;
            isLoading = false;
          });
        }

        // Wait for 3 seconds to show "No data found" message
        await Future.delayed(Duration(seconds: 3));

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MainPage(),
              settings: RouteSettings(
                arguments: {
                  'name': name,
                  'email': email,
                  'imageid': 0,
                  'initialIndex': 2,
                },
              ),
            ),
          );
        }
        return;
      }

      if (mounted) {
        setState(() {
          imageid = latestImageId;
          dataExists = true;
          isLoading = false;
        });
      }

      _startAnimationSequence();
    } catch (e) {
      debugPrint('Error fetching image ID: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  bool isGenerating = false;

  Future<void> _generateColorPalette() async {
  if (isGenerating || !mounted) return;
  
  setState(() {
    isGenerating = true;
  });

  try {
    final latestImageId = await getImageIdByEmail(email);
    if (latestImageId == null || latestImageId == 0) {
      throw Exception('No valid image ID found');
    }
    
    if (!mounted) return;
    
    final uri = Uri.parse('${Config.baseUrl}/api/color_pallet_generate/generate');
    final body = json.encode({
      "email": email,
      "interiorImageId":latestImageId.toString()
    });

    final headers = {'Content-Type': 'application/json'};
    final response = await http.post(uri, body: body, headers: headers);

    if (!mounted) return;

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['status'] == 'success') {
        final palette = responseData['palette'];
        debugPrint('Color palette generated successfully: $palette');

        // Complete the animation sequence
        for (var stage = 3; stage <= 7; stage++) {
          if (!mounted) return;
          setState(() => _animationStage = stage);
          await Future.delayed(Duration(seconds: 3));
        }

        // Navigate to GenerateImage with the generated palette
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => GenerateImage(),
              settings: RouteSettings(
                arguments: {
                  'name': name,
                  'email': email,
                  'imageid': latestImageId,
                  'generatedPalette': palette, // Pass the palette
                },
              ),
            ),
          );
        }
      } 
        
        else {
          print('Failed to generate color palette: ${responseData['message']}');
          debugPrint('Error in palette generation: ${responseData['message']}');
          
          if (mounted) {
            setState(() {
              _animationStage = 3; // Set to "Color generation failed" stage
            });

            // Wait for 3 seconds to show error message
            await Future.delayed(Duration(seconds: 3));

            if (mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MainPage(),
                  settings: RouteSettings(
                    arguments: {
                      'name': name,
                      'email': email,
                      'imageid': latestImageId,
                      'initialIndex': 2,
                    },
                  ),
                ),
              );
            }
            return;
          }
        }
      } else {
        if (mounted) {
          setState(() {
            _animationStage = 3;
          });

          // Wait for 3 seconds to show error message
          await Future.delayed(Duration(seconds: 3));

          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MainPage(),
                settings: RouteSettings(
                  arguments: {
                    'name': name,
                    'email': email,
                    'imageid': latestImageId,
                    'initialIndex': 2,
                  },
                ),
              ),
            );
          }
        }
        return;
      }
    } catch (e) {
      debugPrint('Error during palette generation: $e');
      if (mounted) {
        setState(() {
          _animationStage = 3;
        });

        // Wait for 3 seconds to show error message
        await Future.delayed(Duration(seconds: 3));

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MainPage(),
              settings: RouteSettings(
                arguments: {
                  'name': name,
                  'email': email,
                  'imageid': imageid,
                  'initialIndex': 2,
                },
              ),
            ),
          );
        }
      }
    } finally {
      if (mounted) {
        setState(() {
          isGenerating = false;
        });
      }
    }
  }

  void _startAnimationSequence() async {
    if (!dataExists || isGenerating || !mounted) return;

    try {
      // Get latest image ID before starting animation sequence
      final latestImageId = await getImageIdByEmail(email);
      if (latestImageId == null || latestImageId == 0) {
        throw Exception('No valid image ID found');
      }

      if (!mounted) return;

      setState(() {
        imageid = latestImageId;
      });

      // Start animation sequence
      setState(() => _animationStage = 1);
      await Future.delayed(Duration(seconds: 3));
      if (!mounted) return;

      // Call color palette generation
      await _generateColorPalette();
      if (!mounted) return;

      // Continue with remaining animation stages
      for (var stage = 3; stage <= 7; stage++) {
        setState(() => _animationStage = stage);
        await Future.delayed(Duration(seconds: 3));
        if (!mounted) return;
      }

      await Future.delayed(Duration(seconds: 2));
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainPage(),
          settings: RouteSettings(
            arguments: {
              'name': name,
              'email': email,
              'imageid': imageid,
              'initialIndex': 2,
            },
          ),
        ),
      );
    } catch (e) {
      debugPrint('Error in animation sequence: $e');
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainPage(),
            settings: RouteSettings(
              arguments: {
                'name': name,
                'email': email,
                'imageid': imageid,
                'initialIndex': 2,
              },
            ),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _colorAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      name = args['name'] ?? "Charitha Adikari";
      email = args['email'] ?? "defaultEmail@example.com";
      imageid = int.tryParse(args['imageid']?.toString() ?? '0') ?? 0;
    }

    return Scaffold(
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _colorAnimation,
                    builder: (context, child) {
                      return Container(
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                          color: _colorAnimation.value ?? Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: CircularProgressIndicator(
                          strokeWidth: 10,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Color.fromARGB(255, 255, 255, 255)),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 80),
                  AnimatedSwitcher(
                    duration: const Duration(seconds: 1),
                    child: Container(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        textAlign: TextAlign.center,
                        _animationStage == 0
                            ? 'Collecting Data...'
                            : _animationStage == 2
                                ? 'No data found...'
                                : _animationStage == 3
                                    ? '................'
                                    : _animationStage == 4
                                        ? 'Using Algorithms...'
                                        : _animationStage == 5
                                            ? 'Detecting texture...'
                                            : _animationStage == 6
                                                ? 'Calculating Room Complexity...'
                                                : _animationStage == 7
                                                    ? 'Color Matching...'
                                                    : _animationStage == 8
                                                        ? 'Color Match Successful...'
                                                        : _animationStage == 9
                                                            ? 'Redirecting to Visualize page...'
                                                            : '',
                        key: ValueKey<int>(_animationStage),
                        style: TextStyle(
                            fontSize: 30,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
