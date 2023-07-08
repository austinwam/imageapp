import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import 'imageutil.dart';

class Imageprovider with ChangeNotifier {
  bool? isloading;
  String? imagepath;
  String? cimagepath;
  String? faces;
  String? rtext;

  void setimage(val) {
    imagepath = val;
    notifyListeners();
  }

  void setcimage(val) {
    cimagepath = val;
    notifyListeners();
  }

  void setload(val) {
    isloading = val;
    notifyListeners();
  }

  void setface(data) {
    faces = data;
    notifyListeners();
  }

  void settext(data) {
    rtext = data;
    notifyListeners();
  }

  Future<void> editimage(imagepath) async {
    setload(true);
    File efile = await CropperService().cropImageFile(File(imagepath!));
    // await processImage(efile.path);
    processnationalid(efile.path);
    processImage(efile.path);
    setcimage(efile.path);
    setload(false);
  }

  Future<void> processImage(image) async {
    setload(true);
    final inputImage = InputImage.fromFilePath(image);
    final FaceDetector faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        enableContours: true,
        enableLandmarks: true,
      ),
    );
    final faces = await faceDetector.processImage(inputImage);
    setface(faces.toString());
    for (final face in faces) {
      print("face======$face");
    }

    setload(false);
  }

  Future<void> processnationalid(image) async {
    final inputImage = InputImage.fromFilePath(image);
    final TextRecognizer textRecognizer =
        TextRecognizer(script: TextRecognitionScript.latin);
    final recognizedText = await textRecognizer.processImage(inputImage);
    var text = 'Recognized text:\n\n${recognizedText.text}';
    settext(text);
    print(text);
  }
}
