import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:camera_project/constants/colors.dart';
import 'package:camera_project/main.dart';
import 'package:camera_project/modules/image_capture_module/controller/images_manage.dart';
import 'package:camera_project/modules/image_capture_module/pages/image_file_page.dart';
import 'package:camera_project/modules/image_capture_module/services/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';

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
    controller = CameraController(camera[0], ResolutionPreset.medium);
    controller.setFlashMode(FlashMode.off);

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

  /// Captures the contents of a [RenderRepaintBoundary], converts it to a [Uint8List],
  /// and saves it to both the app's document directory and the gallery.
  Future<void> _captureAndSavePng() async {
    print("here");

    // Find the RenderRepaintBoundary using the current context
    RenderRepaintBoundary boundary =
        _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

    // Capture the image and convert it to a Uint8List
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List uint8List = byteData!.buffer.asUint8List();


    // Update the flag to indicate that a photo has been taken
      _imageController.isTakenphoto.value = true;
    // Save the image to the app's document directory
    // saveImageToAppDirectory(uint8List);
    // store image in firebase storage
    FirebaseStorageResponse()
        .uploadFile(uint8List, DateTime.now().toString(), widget.carNumber);
    // Save the image to the gallery
    final result = await ImageGallerySaver.saveImage(uint8List);
    print(result['filePath']);

    if (result['isSuccess']) {
      print('Image saved to gallery');
    } else {
      print('Failed to save image to gallery $result');
    }
  }

  /// Captures a picture using the given [controller] and [index],
  /// sets the image path in the image controller, and triggers the capture and save process.
  ///
  /// The [controller] represents the camera controller used to capture the image.
  /// The [index] indicates the index of the camera being used.
  Future<void> _takePicture(CameraController controller, int index) async {
    try {
      // Capture the picture using the provided controller
      final image = await controller.takePicture();
      print("image path is ${image.path}");

      // Set the image path in the image controller for the given index
      _imageController.setImagePath(image.path, index);

      

      // Wait for a short duration to allow the image to be set
      await Future.delayed(const Duration(milliseconds: 400));

      // Call _captureAndSavePng function after setting the image file
      await _captureAndSavePng();
    } catch (e) {
      print(e);
    }
  }

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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title: Text(
            widget.carNumber,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        body: Center(
          child: controller.value.isInitialized
              ? Column(
                  children: [
                    Stack(
                      children: [
                        Obx(
                          () => _imageController.images.isNotEmpty
                              ? _imageController
                                          .images[
                                              _imageController.counter.value]
                                          .values
                                          .first !=
                                      ""
                                  ? RepaintBoundary(
                                      key: _globalKey,
                                      child: Stack(
                                        children: [
                                          Container(
                                            alignment: Alignment.center,
                                            child: Image.file(
                                              File(_imageController
                                                  .images[_imageController
                                                      .counter.value]
                                                  .values
                                                  .first),
                                              height: 300,
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
                                  : Container()
                              : Container(),
                        ),
                        CameraViewWidget(
                          controller: controller,
                        ),
                        // Positioned(
                        //     top: 10,
                        //     left: 10,
                        //     child: IconButton(
                        //       icon: const Icon(Icons.cancel),
                        //       onPressed: () {
                        //         Get.back();
                        //       },
                        //     )),
                      ],
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    ImagesListView(),
                    Obx(() => ElevatedButton(
                          onPressed: _imageController.isTakenphoto.value
                              ? () async {
                                  _imageController.counter.value++;
                                  _imageController.images.add(
                                      {_imageController.counter.value: ""});
                                  int tempIndex =
                                      _imageController.counter.value;
                                  _imageController.isTakenphoto.value = false;
                                  await _takePicture(controller, tempIndex);
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _imageController.isTakenphoto.value
                                ? kPrimaryColor
                                : const ui.Color.fromARGB(255, 69, 116, 155),
                          ),
                          child: const Text('Capture Image'),
                        ))
                  ],
                )
              : const CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget ImagesListView() {
    return Obx(() {
      return SizedBox(
        height: 55,
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _imageController.images.length,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemBuilder: (context, index) {
              return _imageController.images[index].values.first != ""
                  ? InkWell(
                      onTap: () {
                        Get.to(ImagePage(
                          image_path:
                              _imageController.images[index].values.first,
                          car_number: widget.carNumber,
                        ));
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 2)),
                        child: Image.file(
                            File(_imageController.images[index].values.first)),
                      ),
                    )
                  : Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          color: const ui.Color.fromARGB(255, 212, 210, 210),
                          border: Border.all(color: Colors.grey, width: 2)));
            }),
      );
    });
  }
}

class CameraViewWidget extends StatelessWidget {
  final CameraController controller;
  const CameraViewWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final scale = 1 /
        (controller.value.aspectRatio *
            MediaQuery.of(context).size.aspectRatio);
    return Transform.scale(
      scale: 1,
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
