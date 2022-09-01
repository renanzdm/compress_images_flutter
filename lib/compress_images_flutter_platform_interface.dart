import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'compress_images_flutter_method_channel.dart';

abstract class CompressImagesFlutterPlatform extends PlatformInterface {
  /// Constructs a CompressImagesFlutterPlatform.
  CompressImagesFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static CompressImagesFlutterPlatform _instance = MethodChannelCompressImagesFlutter();

  /// The default instance of [CompressImagesFlutterPlatform] to use.
  ///
  /// Defaults to [MethodChannelCompressImagesFlutter].
  static CompressImagesFlutterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [CompressImagesFlutterPlatform] when
  /// they register themselves.
  static set instance(CompressImagesFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String?> compressImage(String fileName, {int percentage = 70, int quality = 70, int targetWidth = 0, int targetHeight = 0}) {
    throw UnimplementedError('compressImage() has not been implemented.');
  }
}