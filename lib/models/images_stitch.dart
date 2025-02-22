import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';

class ImagesStitch {
  final dynamicLibrary = Platform.isAndroid
      ? DynamicLibrary.open("libOpenCV_ffi.so")
      : DynamicLibrary.process();

  Future<void> stitchImages(
      final List<String> imagesPathToStitch,
      final String imagePathToCreate,
      final bool isVertical,
      final Function onCompleted) async {
    final stitchFunction = dynamicLibrary.lookupFunction<
        Void Function(Pointer<Utf8>, Pointer<Utf8>, Pointer<Utf8>),
        void Function(Pointer<Utf8>, Pointer<Utf8>, Pointer<Utf8>)>('stitch');
    stitchFunction(
      imagesPathToStitch.toString().toNativeUtf8(),
      imagePathToCreate.toNativeUtf8(),
      isVertical.toString().toNativeUtf8(),
    );
    onCompleted(imagePathToCreate);
  }
}
