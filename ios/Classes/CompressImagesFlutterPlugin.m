#import "CompressImagesFlutterPlugin.h"
#if __has_include(<compress_images_flutter/compress_images_flutter-Swift.h>)
#import <compress_images_flutter/compress_images_flutter-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "compress_images_flutter-Swift.h"
#endif

@implementation CompressImagesFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftCompressImagesFlutterPlugin registerWithRegistrar:registrar];
}
@end
