import 'package:camera_project/constants/colors.dart';
import 'package:camera_project/modules/image_capture_module/pages/camera_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VehicleDetailPage extends StatelessWidget {
  VehicleDetailPage({super.key});
  TextEditingController vehicleController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title: const Text("Vehicle Details"),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: vehicleController,
                  autofocus: false,
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: kPrimaryColor),
                    ),
                    border: OutlineInputBorder(),
                    labelText: 'Vehicle Number',
                    labelStyle: TextStyle(color: kPrimaryColor),
                    hintText: 'Enter Vehicle Number',
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () {
                      Get.to(CameraApp(carNumber: vehicleController.text.trim(),));
                    },
                    child: const Text("Capture"))
              ],
            ),
          ),
        ));
  }
}
