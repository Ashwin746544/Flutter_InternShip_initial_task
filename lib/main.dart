import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internship_task/showData.dart';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File image;
  String _imageUrl;
  var _isLoading = false;
  final String api =
      'https://backend-test-zypher.herokuapp.com/uploadImageforMeasurement';
  void _pickImage(BuildContext context) async {
    ImagePicker _picker = ImagePicker();
    setState(() {
      _isLoading = !_isLoading;
    });
    var pickedImagefile = await _picker.getImage(
        source: ImageSource.camera, preferredCameraDevice: CameraDevice.front);
    if (pickedImagefile == null) {
      setState(() {
        _isLoading = !_isLoading;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please capture photo to proceed further!')));
      return;
    }
    setState(() {
      image = File(pickedImagefile.path);
    });
    var ref = FirebaseStorage.instance
        .ref()
        .child('user_image')
        .child(pickedImagefile.path.split("/").last);
    await ref.putFile(image);
    _imageUrl = await ref.getDownloadURL();
    var response = await http.post(Uri.parse(api),
        body: json.encode({'imageURL': _imageUrl}));
    var data = json.decode(response.body)['d'];
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ShowData(
                  data: data,
                )));
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Internship Task'),
      ),
      body: Center(
          child: _isLoading != true
              ? TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.blue, primary: Colors.white),
                  child: Text('Upload Image'),
                  onPressed: () {
                    _pickImage(context);
                  },
                )
              : CircularProgressIndicator()),
    );
  }
}
