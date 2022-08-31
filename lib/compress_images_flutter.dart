import 'dart:io';

import 'compress_images_flutter_platform_interface.dart';

class CompressImagesFlutter {
  Future<String?> getPlatformVersion() {
    return CompressImagesFlutterPlatform.instance.getPlatformVersion();
  }

  Future<File?> compressImage(String fileName, {int percentage = 70, int quality = 70, int targetWidth = 0, int targetHeight = 0}) async {
    final String? pathFile = await CompressImagesFlutterPlatform.instance
        .compressImage(fileName, quality: quality, percentage: percentage, targetHeight: targetHeight, targetWidth: targetWidth);
    if (pathFile != null) {
      return File(pathFile);
    }

    return null;
  }
}
