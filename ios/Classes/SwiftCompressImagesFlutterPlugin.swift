import Flutter
import UIKit
import AVFoundation


public class SwiftCompressImagesFlutterPlugin: NSObject, FlutterPlugin{
    static let CHANNEL_NAME = "compress_images_flutter"
    
    public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: CHANNEL_NAME, binaryMessenger: registrar.messenger())
    let instance = SwiftCompressImagesFlutterPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      var _arguments = call.self.arguments as? Dictionary<String, Any>
      
        
      if(call.method == "compress_image"){
          let fileExtension : String = ".jpg"
          let qualityArgument:Int = _arguments?["quality"] as? Int ?? 100;
          let fileArgument:String  = _arguments?["file"] as? String  ??  "";
          let uncompressedFileUrl = URL(string: fileArgument) ;
          let fileName:String  = uncompressedFileUrl?.deletingPathExtension().path as? String ?? ""
          let uuid: String = UUID().uuidString;
          let tempFileName : String =  String(format:"%@%@%@", fileName, uuid, fileExtension);
          
        
          let path = uncompressedFileUrl?.path ?? ""
          let data = FileManager().contents(atPath: path)
            
          let img = UIImage(data: data ?? Data())
          if(img != nil){
              let uiImage: Data? =  compressImage(image: img!,quality:Double(qualityArgument) * 0.01)
              if(uiImage != nil){
                  let succes = FileManager().createFile(atPath: tempFileName, contents: uiImage , attributes: nil)
                  if(succes){
                    result(tempFileName)
                  }
         
              }
          }
          
      }
      
  }
    
    func compressImage(image: UIImage,quality:Double) -> Data? {
        let image = image.jpegData(compressionQuality: quality)
        return image
            
    }
   	
}

