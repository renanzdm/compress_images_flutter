import 'package:compress_images_flutter/compress_images_flutter.dart';
import 'package:compress_images_flutter/compress_images_flutter_method_channel.dart';
import 'package:compress_images_flutter/compress_images_flutter_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockCompressImagesFlutterPlatform
    with MockPlatformInterfaceMixin
    implements CompressImagesFlutterPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<String?> compressImage(String fileName,
      {int percentage = 70,
      int quality = 70,
      int targetWidth = 0,
      int targetHeight = 0}) {
    // TODO: implement compressImage
    throw UnimplementedError();
  }
}

void main() {
  final CompressImagesFlutterPlatform initialPlatform =
      CompressImagesFlutterPlatform.instance;

  test('$MethodChannelCompressImagesFlutter is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelCompressImagesFlutter>());
  });

  test('getPlatformVersion', () async {
    CompressImagesFlutter compressImagesFlutterPlugin = CompressImagesFlutter();
    MockCompressImagesFlutterPlatform fakePlatform =
        MockCompressImagesFlutterPlatform();
    CompressImagesFlutterPlatform.instance = fakePlatform;

    expect(await compressImagesFlutterPlugin.getPlatformVersion(), '42');
  });
}
