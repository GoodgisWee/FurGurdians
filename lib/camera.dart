import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  Future<File?> _takePhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      return File(pickedFile.path);
    } else {
      print('No image selected.');
      return null;
    }
  }

  Future<String?> _uploadPhoto(File file) async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child('photos/${DateTime.now().toIso8601String()}.jpg');
      final uploadTask = storageRef.putFile(file);
      final snapshot = await uploadTask.whenComplete(() => {});
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading photo: $e');
      return null;
    }
  }

  Future<void> _savePhotoMetadata(String url) async {
    try {
      await FirebaseFirestore.instance.collection('photos').add({
        'url': url,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error saving photo metadata: $e');
    }
  }

  Future<void> _takeAndUploadPhoto() async {
    final file = await _takePhoto();
    if (file != null) {
      final url = await _uploadPhoto(file);
      if (url != null) {
        await _savePhotoMetadata(url);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flutter Photo Gallery')),
      body: Center(
        child: ElevatedButton(
          onPressed: _takeAndUploadPhoto,
          child: Text('Take Photo'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PhotoGallery()),
          );
        },
        child: Icon(Icons.photo),
      ),
    );
  }
}

class PhotoGallery extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Photo Gallery')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('photos').orderBy('timestamp', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final photos = snapshot.data!.docs;

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0,
            ),
            itemCount: photos.length,
            itemBuilder: (context, index) {
              final photo = photos[index];
              return Image.network(photo['url'], fit: BoxFit.cover);
            },
          );
        },
      ),
    );
  }
}
