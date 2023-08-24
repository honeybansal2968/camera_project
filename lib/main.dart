import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image/image.dart' as img;

late List<CameraDescription> _cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  _cameras = await availableCameras();
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CameraApp(),
    );
  }
}

class CameraApp extends StatefulWidget {
  /// Default Constructor
  const CameraApp({super.key});

  @override
  State<CameraApp> createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  late CameraController controller;

  @override
  void initState() {
    super.initState();
    controller = CameraController(_cameras[0], ResolutionPreset.low);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  

  Future<void> _capturePhoto(BuildContext context) async {
    try {
      
      final XFile file = await controller.takePicture();
      print("taken picutre");
      final modifiedFile = await _addTextToPhoto(file.path, 'Hello, Flutter!');
      print("taken picutrdsfdsafde");

      print(modifiedFile.path);
      await saveImageToGallery(modifiedFile.path);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DisplayPhotoScreen(modifiedFile.path),
        ),
      );
    } catch (e) {
      print('Error capturing photo: $e');
    }
  }

  Future<void> saveImageToGallery(String imagePath) async {
    final result = await GallerySaver.saveImage(imagePath);
    print('Image saved to gallery: $result');
  }

 
   Future<File> _addTextToPhoto(String photoPath, String text) async {
 
var decodeImg = img.decodeImage(File(photoPath).readAsBytesSync())!;
   
  print("here");
    img.drawString(decodeImg,DateTime.now().toString(),font: img.arial24);
  print("here1");

    final appDocDir = await getApplicationDocumentsDirectory();
    final modifiedFilePath = '${appDocDir.path}/modified_photo.png';
    final modifiedFile = File(modifiedFilePath);
    await modifiedFile.writeAsBytes(img.encodePng(decodeImg));

    return modifiedFile;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera Screen'),
      ),
      body: Center(
        child: controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: CameraPreview(controller),
              )
            : CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _capturePhoto(context),
        child: Icon(Icons.camera),
      ),
    );}
}

class DisplayPhotoScreen extends StatelessWidget {
  final String photoPath;

  DisplayPhotoScreen(this.photoPath);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modified Photo'),
      ),
      body: Center(
        child: Image.file(File(photoPath)),
      ),
    );
  }
}
