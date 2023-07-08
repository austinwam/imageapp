import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:imageapp/imageprovider.dart';
import 'package:provider/provider.dart';

import 'camareover/cameraover.dart';

class Cameranationid extends StatefulWidget {
  const Cameranationid({
    super.key,
  });

  @override
  State<Cameranationid> createState() => _CameranationidState();
}

class _CameranationidState extends State<Cameranationid> {
  OverlayFormat format = OverlayFormat.cardID3;
  @override
  Widget build(BuildContext context) {
    return Material(
      child: FutureBuilder<List<CameraDescription>?>(
        future: availableCameras(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data == null) {
              return const Align(
                  alignment: Alignment.center,
                  child: Text(
                    'No camera found',
                    style: TextStyle(color: Colors.black),
                  ));
            }
            return CameraOverlay(
                snapshot.data!.first, CardOverlay.byFormat(format),
                (XFile file) async {
              Provider.of<Imageprovider>(context, listen: false)
                  .editimage(file.path);

              File image =
                  File(file.path); // Or any other way to get a File instance.
              var decodedImage =
                  await decodeImageFromList(image.readAsBytesSync());
              print("width============${decodedImage.width}");
              print("height============${decodedImage.height}");

              Navigator.pop(context);
            },
                info:
                    'Position your national ID card within the rectangle and ensure the image is perfectly readable.',
                label: 'Scanning   of your ID Card');
          } else {
            return const Align(
                alignment: Alignment.center,
                child: Text(
                  'Fetching cameras',
                  style: TextStyle(color: Colors.black),
                ));
          }
        },
      ),
    );
  }
}
