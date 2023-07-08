import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class CropperService {
  static const _side = 1000;

  Future<File> cropImageFile(
    File file,
  ) async {
    final image = await img.decodeImageFile(file.path);
    if (image == null) throw Exception('Unable to decode image');
    final croppedImage = img.copyResizeCropSquare(image, size: _side);
    // img.Image destImage =
    //     img.copyCrop(image, x: x, y: y, width: width, height: height);

    final croppedFile = await _convertImageToFile(croppedImage, file.path);
    print("croppedFile==========${croppedFile.path}");
    print("croppedFile==========${croppedFile.path}");
    return croppedFile;
  }

  Future<File> sizeImage(File file, x, y, width, height) async {
    final image = await img.decodeImageFile(file.path);
    if (image == null) throw Exception('Unable to decode image');
    final croppedImage = img.copyResizeCropSquare(image, size: _side);
    // img.Image destImage =
    //     img.copyCrop(croppedImage, x: x, y: y, width: width, height: height);

    final croppedFile = await _convertImageToFile(croppedImage, file.path);
    print("croppedFile==========${croppedFile.path}");
    print("croppedFile==========${croppedFile.path}");
    return croppedFile;
  }

  Future<File> _convertImageToFile(img.Image image, String path) async {
    final newPath = await _croppedFilePath(path);
    final jpegBytes = img.encodeJpg(image);
    final convertedFile = await File(newPath).writeAsBytes(jpegBytes);
    await File(path).delete();
    return convertedFile;
  }

  Future<String> _croppedFilePath(String path) async {
    final tempDir = await getTemporaryDirectory();
    return p.join(
      tempDir.path,
      '${p.basenameWithoutExtension(path)}_compressed.jpg',
    );
  }
}
