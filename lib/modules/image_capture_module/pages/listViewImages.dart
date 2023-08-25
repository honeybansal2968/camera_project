// import 'package:camera_project/modules/image_capture_module/controller/images_manage.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class ImagesListView extends StatelessWidget {
//   ImagesListView({super.key});
//   ImageManage imageManageController = Get.put(ImageManage());
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Scaffold(
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           imageManageController.count = imageManageController.count + 1;
//           imageManageController.temp.add("item");
//         },
//         child: const Icon(Icons.add),
//       ),
//       body: SafeArea(
//         child: SizedBox(
//           height: 58,
//           width: size.width,
//           child: Obx(() => ListView.builder(
//               itemCount: imageManageController.temp.length,
//               scrollDirection: Axis.horizontal,
//               itemBuilder: (context, index) {
//                 return Container(
//                   height: 58,
//                   width: 58,
//                   color: Colors.blue,
//                   margin: const EdgeInsets.all(8),
//                   child: const Text("helo"),
//                 );
//               })),
//         ),
//       ),
//     );
//   }
// }
