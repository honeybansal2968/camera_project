import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

final firebase_storage.FirebaseStorage storage =
    firebase_storage.FirebaseStorage.instance;

class FirebaseStorageResponse {
  Future<String> uploadFile(
      Uint8List? bytes, String fileName, String folderName) async {
    try {
      final path = 'images/$folderName/$fileName';
      final metadata = firebase_storage.SettableMetadata(
          contentType: 'image/png',
          customMetadata: {'picked-file-path': 'images/$folderName/$fileName'});
      firebase_storage.TaskSnapshot snapshot1 =
          await storage.ref(path).putData(bytes!, metadata);
      String downloadUrl = await snapshot1.ref.getDownloadURL();
      return downloadUrl;
    } on firebase_storage.FirebaseException catch (e) {
      print('Error uploading profile picture: $e');
      return '';
    }
  }
}
