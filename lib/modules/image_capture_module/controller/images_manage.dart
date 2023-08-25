
import 'dart:io';

import 'package:get/get.dart';

class ImageController extends GetxController {
  var imageFile = Rx<File?>(null);
  RxBool isTakenphoto=true.obs;
  void setImageFile(File? file) {
    imageFile.value = file;
  }
}
