import 'dart:io';

import 'package:compress_images_flutter/compress_images_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final CompressImagesFlutter compressImagesFlutter = CompressImagesFlutter();
  XFile? photo;
  double photoLengthCompressed = 0;
  double photoLengthNormal = 0;
  final ImagePicker _picker = ImagePicker();
  File? newPhoto;
  File? compressedPhoto;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextButton(
                    onPressed: () async {
                      photo = await _picker.pickImage(
                          source: ImageSource.camera, maxWidth: 1600);
                      newPhoto = File(photo!.path);
                      compressedPhoto = await compressImagesFlutter
                          .compressImage(photo!.path, quality: 30);
                      photoLengthCompressed =
                          (((compressedPhoto!.readAsBytesSync().lengthInBytes) *
                                      1.0) /
                                  1024) /
                              1024;
                      photoLengthNormal =
                          (((newPhoto!.readAsBytesSync().lengthInBytes) * 1.0) /
                                  1024) /
                              1024;
                      setState(() {});
                    },
                    child: const Text("Take Photo")),
                TextButton(
                    onPressed: () async {
                      photo = await _picker.pickImage(
                          source: ImageSource.gallery, maxWidth: 1600);
                      newPhoto = File(photo!.path);
                      compressedPhoto = await compressImagesFlutter
                          .compressImage(photo!.path, quality: 30);
                      photoLengthCompressed =
                          (((compressedPhoto!.readAsBytesSync().lengthInBytes) *
                                      1.0) /
                                  1024) /
                              1024;
                      photoLengthNormal =
                          (((newPhoto!.readAsBytesSync().lengthInBytes) * 1.0) /
                                  1024) /
                              1024;
                      setState(() {});
                    },
                    child: const Text("Galery Photo")),
                Text(
                    'Foto reduzida ${photoLengthCompressed.toStringAsFixed(4)} mb'),
                Text('Foto normal ${photoLengthNormal.toStringAsFixed(4)} mb'),
                if (compressedPhoto != null) Image.file(compressedPhoto!),
                if (newPhoto != null) Image.file(newPhoto!),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
