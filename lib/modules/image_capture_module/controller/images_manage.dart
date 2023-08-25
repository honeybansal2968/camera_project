
import 'dart:io';

import 'package:get/get.dart';

class ImageController extends GetxController {
  Rx<int> counter = Rx<int>(-1);
  // var imageFile = Rx<File?>(null);
  RxList<Map<int,String>> images=<Map<int,String>>[].obs;
  RxBool isTakenphoto=true.obs;
  // void setImageFile(File? file) {
  //   imageFile.value = file;
  // }
  void setImagePath(String file,int index){
    images[index]={index:file};
  }
}
