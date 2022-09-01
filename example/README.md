## Add import
```import 'package:compress_images_flutter/compress_images_flutter.dart';```

## Create instance of Lib 
```final CompressImagesFlutter compressImagesFlutter = CompressImagesFlutter();```


## Call with a path your image, the quality parameter if not informed the default will be 70

```
File? compressedPhoto = await compressImagesFlutter
                          .compressImage(photo!.path, quality: 30);
```
