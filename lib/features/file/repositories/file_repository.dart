import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FileRepository {
  final FirebaseStorage firebaseStorage;

  const FileRepository({required this.firebaseStorage});

  Future<String> uploadFile(String path, File file) async {
    final uploadTask = await firebaseStorage.ref(path).putFile(
        file, SettableMetadata(customMetadata: {"originalFileName": file.path.split('/').last}));
    final downloadUrl = await uploadTask.ref.getDownloadURL();

    return downloadUrl;
  }
}
