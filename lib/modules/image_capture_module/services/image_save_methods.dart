import 'dart:io';
import 'dart:typed_data';

import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

class ImageSaveMethods {
  /// Saves the provided image bytes to the app's directory structure using a custom folder hierarchy.
  ///
  /// The [imageBytes] parameter contains the raw image data to be saved. The [carNumber]
  /// parameter is used to create a custom folder within the app's directory structure.
  /// The image is saved with a file name generated from the current timestamp.
  Future<void> saveImageToAppDirectory(
      Uint8List imageBytes, String carNumber) async {
    Directory? directory;

    // Get the app's document directory
    directory = await getExternalStorageDirectory();
    String newPath = "";

    print(directory);

    List<String> paths = directory!.path.split("/");
    for (int x = 1; x < paths.length; x++) {
      String folder = paths[x];
      if (folder != "0") {
        newPath += "/$folder";
      } else {
        newPath += "/$folder";
        break;
      }
    }

    String picturesPath = "$newPath/Pictures";
    directory = Directory(picturesPath);

    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    if (await directory.exists()) {
      newPath = "$picturesPath/$carNumber";
      directory = Directory(newPath);

      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      if (await directory.exists()) {
        File saveFile = File("${directory.path}/${DateTime.now()}.png");

        await saveFile.writeAsBytes(imageBytes);
        print('Image saved to: $saveFile');

        // Uncomment the following line if you want to save to the gallery as well
        // await ImageGallerySaver.saveFile(saveFile.path, isReturnPathOfIOS: true);
      }

      // Uncomment the following line if you want to save to the gallery as well
      // await ImageGallerySaver.saveFile(saveFile.path, isReturnPathOfIOS: true);
    }
  }

  Future<void> saveImageToGallery(String imagePath, String carNumber) async {
    final result = await GallerySaver.saveImage("$carNumber/$imagePath");
    print('Image saved to gallery: $result');
  }
}
