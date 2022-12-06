import 'dart:io';
import 'dart:typed_data';

import 'compress_images_flutter_platform_interface.dart';

class CompressImagesFlutter {
  Future<String?> getPlatformVersion() {
    return CompressImagesFlutterPlatform.instance.getPlatformVersion();
  }

  Future<File?> compressImage(String fileName, {int quality = 70}) async {
    final String? pathFile = await CompressImagesFlutterPlatform.instance
        .compressImage(fileName, quality: quality);
    if (pathFile != null) {
      return File(pathFile);
    }
    return null;
  }

  Future<String> rotateImage(String filePath, {double degree = 90}) async {
   return await CompressImagesFlutterPlatform.instance.rotateImage(filePath,degree: degree);
  }
}
