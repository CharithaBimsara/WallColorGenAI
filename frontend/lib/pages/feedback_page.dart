import 'dart:io';
import 'package:colornestle/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image/image.dart' as img;
import '../utils/config.dart';
import '../widgets/sidebar_drawer.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({
    super.key,
  });

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String name = "Defaultuser";
  String email = "user@gmail.com";
  XFile? _imageFile;
  final picker = ImagePicker();
  final _textEditingController = TextEditingController();
  String answer1 = "Satisfied 😀";
  String answer2 = "Yes, I have already applied them.";
  String answer3 = "Very helpful.";
  String answer4 = "Good";

  String question1 = "How satisfied are you with the color suggestions provided by the app?";
  String question2 = "Do you really apply these to your walls or planning to do so?";
  String question3 = "How helpful did you find the app in choosing colors based on room texture?";
  String question4 = "How is the overall color suggestion of the app?";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    name = args?['name'] ?? "null";
    email = args?['email'] ?? "charithabimsara@gmail.com";
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await picker.pickImage(source: source);
      if (pickedFile != null) {
        File imageFile = File(pickedFile.path);
        img.Image? image = img.decodeImage(imageFile.readAsBytesSync());

        // Resize the image if necessary
        if (image != null) {
          img.Image resizedImage = img.copyResize(image, width: 800); // Resize to a width of 800 pixels
          File resizedFile = File(pickedFile.path)..writeAsBytesSync(img.encodeJpg(resizedImage));

          if (!mounted) return; // Check if the widget is still mounted

          setState(() {
            _imageFile = XFile(resizedFile.path);
          });
        }
      }
      
      if (!mounted) return; // Check if the widget is still mounted
      Navigator.pop(context); // Close the bottom sheet after picking an image
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error picking image: $e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () => _pickImage(ImageSource.gallery),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.grey[200],
                          child: Icon(Icons.photo_library, size: 30, color: Colors.black),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text('Gallery', style: TextStyle(color: Colors.black)),
                    ],
                  ),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () => _pickImage(ImageSource.camera),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.grey[200],
                          child: Icon(Icons.photo_camera, size: 30, color: Colors.black),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text('Camera', style: TextStyle(color: Colors.black)),
                    ],
                  ),
                ],
              ),
              
            ],
          ),
        );
      },
    );
  }

  Future<void> _uploadImageAndData() async {
    var url = Uri.parse('${Config.baseUrl}/file/uploadFileComment');
    try {
      var request = http.MultipartRequest('POST', url);

      if (_imageFile != null) {
        var fileStream = http.ByteStream(File(_imageFile!.path).openRead());
        var length = await File(_imageFile!.path).length();
        var multipartFile = http.MultipartFile(
          'file',
          fileStream,
          length,
          filename: _imageFile!.path.split('/').last,
        );
        request.files.add(multipartFile);
      }

      request.fields['question1'] = answer1;
      request.fields['question2'] = answer2;
      request.fields['question3'] = answer3;
      request.fields['question4'] = answer4;
      request.fields['userInput'] = _textEditingController.text;
      request.fields['email'] = email;

      var response = await request.send();

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: 'Thank you for your feedback.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
      } else {
        Fluttertoast.showToast(
          msg: 'Failed to upload data. Please try again.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error uploading data: $e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  Widget buildDropDownSelector({
    required String title,
    required String currentValue,
    required List<String> options,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10.0),
        DropdownButtonFormField<String>(
          value: currentValue,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            filled: false,
          ),
          items: options.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: onChanged,
        ),
        const SizedBox(height: 20.0),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: TransparentAppBarPage.getAppBar('Feedback', _scaffoldKey),
      drawer: SidebarDrawer(name: name, email: email),
      body: Container(
        padding: EdgeInsets.all(16),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(255, 216, 39, 39)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              buildDropDownSelector(
                title: question1,
                currentValue: answer1,
                options: ['Satisfied 😀', 'Neutral😐', 'Dissatisfied☹️'],
                onChanged: (newValue) {
                  setState(() {
                    answer1 = newValue!;
                  });
                },
              ),
              buildDropDownSelector(
                title: question2,
                currentValue: answer2,
                options: [
                  'Yes, I have already applied them.',
                  'Yes, I plan to apply them soon',
                  'Maybe, I\'m still deciding.',
                  'No, I do not intend to apply them.'
                ],
                onChanged: (newValue) {
                  setState(() {
                    answer2 = newValue!;
                  });
                },
              ),
              buildDropDownSelector(
                title: question3,
                currentValue: answer3,
                options: [
                  'Very helpful.',
                  'Moderately helpful.',
                  'Slightly helpful.',
                  'Not helpful at all.'
                ],
                onChanged: (newValue) {
                  setState(() {
                    answer3 = newValue!;
                  });
                },
              ),
              buildDropDownSelector(
                title: question4,
                currentValue: answer4,
                options: ['Good', 'Average', 'Poor'],
                onChanged: (newValue) {
                  setState(() {
                    answer4 = newValue!;
                  });
                },
              ),
              Divider(
                height: 20,
                color: Colors.grey,
                thickness: 1,
                indent: 1,
                endIndent: 10,
              ),
              _imageFile == null
                  ? Text(
                      'No image selected.',
                      style: TextStyle(color: Colors.black),
                    )
                  : Image.file(
                      File(_imageFile!.path),
                      width: 319,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
              SizedBox(height: 20),
              TextField(
                controller: _textEditingController,
                decoration: InputDecoration(
                  hintText: 'We highly appreciate your suggestions. Feel free to write anything.',
                  hintStyle: TextStyle(color: Colors.black54),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: TextStyle(color: Colors.black),
                maxLines: 3,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton.icon(
                    onPressed: () => _showBottomSheet(context),
                    icon: Icon(Icons.photo_library),
                    label: Text('Select Image'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _uploadImageAndData,
                    icon: Icon(Icons.upload_file),
                    label: Text('Submit Feedback'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.red,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
