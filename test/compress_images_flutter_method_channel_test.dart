import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:compress_images_flutter/compress_images_flutter_method_channel.dart';

void main() {
  MethodChannelCompressImagesFlutter platform = MethodChannelCompressImagesFlutter();
  const MethodChannel channel = MethodChannel('compress_images_flutter');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
