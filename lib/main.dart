import 'package:camera/camera.dart';
import 'package:camera_project/modules/vehicle_details_module/pages/vehicle_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

late List<CameraDescription> camera;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  camera = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Widget to Image',
      home: VehicleDetailPage(),
    );
  }
}
