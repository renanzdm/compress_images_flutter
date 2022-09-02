import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'compress_images_flutter_platform_interface.dart';

/// An implementation of [CompressImagesFlutterPlatform] that uses method channels.
class MethodChannelCompressImagesFlutter extends CompressImagesFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('compress_images_flutter');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<String?> compressImage(String fileName, {int quality = 70}) async {
    final String? path = await methodChannel.invokeMethod<String>(
        'compress_image', {'file': fileName, 'quality': quality});
    return path;
  }
}
