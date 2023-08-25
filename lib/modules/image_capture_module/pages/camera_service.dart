import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:camera_project/constants/colors.dart';
import 'package:camera_project/main.dart';
import 'package:camera_project/modules/image_capture_module/controller/images_manage.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image/image.dart' as img;

class CameraApp extends StatefulWidget {
  String carNumber;

  /// Default Constructor
  CameraApp({super.key, required this.carNumber});

  @override
  State<CameraApp> createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  GlobalKey _globalKey = GlobalKey();
  late CameraController controller;

  final ImageController _imageController = Get.put(ImageController());

  @override
  void initState() {
    super.initState();
    _globalKey = GlobalKey();
    controller = CameraController(camera[0], ResolutionPreset.low);
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

  Future<void> _captureAndSavePng() async {
    print("here");
    RenderRepaintBoundary boundary =
        _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List uint8List = byteData!.buffer.asUint8List();

    final result = await ImageGallerySaver.saveImage(uint8List);

    if (result['isSuccess']) {
      print('Image saved to gallery');
    } else {
      print('Failed to save image to gallery');
    }
  }

  Future<void> _takePicture(CameraController controller) async {
    try {
      final image = await controller.takePicture();
      _imageController.isTakenphoto.value = true;
      _imageController.setImageFile(File(image.path));
      await Future.delayed(const Duration(milliseconds: 400));
      // Call _captureAndSavePng function after setting the image file
      await _captureAndSavePng();
    } catch (e) {
      print(e);
    }
  }

  // Future<void> saveImageToGallery(String imagePath) async {
  //   final result = await GallerySaver.saveImage(imagePath);
  //   print('Image saved to gallery: $result');
  // }

  // Future<File> _addTextToPhoto(String photoPath, String text) async {
  //   var decodeImg = img.decodeImage(File(photoPath).readAsBytesSync())!;

  //   print("here");
  //   img.drawString(decodeImg, DateTime.now().toString(),
  //       font: img.arial14, x: 20, y: 40);
  //   print("here1");

  //   final appDocDir = await getApplicationDocumentsDirectory();
  //   final modifiedFilePath = '${appDocDir.path}/${DateTime.now()}.png';
  //   final modifiedFile = File(modifiedFilePath);
  //   await modifiedFile.writeAsBytes(img.encodePng(decodeImg));

  //   return modifiedFile;
  // }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(widget.carNumber),
      ),
      body: Center(
        child: controller.value.isInitialized
            ? Column(
                children: [
                  Stack(
                    children: [
                      Obx(
                        () => _imageController.imageFile.value != null
                            ? RepaintBoundary(
                                key: _globalKey,
                                child: Stack(
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      child: Image.file(
                                        _imageController.imageFile.value!,
                                        height: 250,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const Positioned(
                                      bottom: 0,
                                      left: 10,
                                      child: Text(
                                        "DL1023",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12.0,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 10,
                                      child: Text(
                                        formatDateTimeString(
                                            DateTime.now().toString()),
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 12.0,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            : Container(),
                      ),
                      CameraViewWidget(
                        controller: controller,
                      ),
                    ],
                  ),
                 Obx(() =>  ElevatedButton(
                    
                    onPressed: _imageController.isTakenphoto.value ?() async {
                      _imageController.isTakenphoto.value = false;
                      await _takePicture(controller);
                    }:null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _imageController.isTakenphoto.value?kPrimaryColor:const ui.Color.fromARGB(255, 191, 215, 235),
                    ),
                    child: const Text('Capture Image'),
                  ))
                ],
              )
            : const CircularProgressIndicator(),
      ),
     
    );
  }
}
class CameraViewWidget extends StatelessWidget {
  final CameraController controller;
  const CameraViewWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: CameraPreview(controller),
    );
  }
}

String formatDateTimeString(String dateTimeString,
    {String format = 'y MMM d HH:mm a'}) {
  DateTime dateTime = DateTime.parse(dateTimeString);
  String formattedDateTime = DateFormat(format).format(dateTime);
  return formattedDateTime;
}
