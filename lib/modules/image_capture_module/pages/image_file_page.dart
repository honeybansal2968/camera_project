import 'dart:io';

import 'package:camera_project/constants/colors.dart';
import 'package:camera_project/modules/image_capture_module/pages/camera_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImagePage extends StatelessWidget {
  String image_path;
  String car_number;
  ImagePage({super.key, required this.image_path, required this.car_number});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        leading: IconButton(
          icon: const Icon(Icons.cancel_outlined),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            child: Image.file(
              File(image_path),
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 10,
            child: Text(
              car_number,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12.0,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 10,
            child: Text(
              formatDateTimeString(DateTime.now().toString()),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12.0,
              ),
            ),
          )
        ],
      ),
    );
  }
}
