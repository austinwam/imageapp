import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const Homepage(),
    );
  }
}

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          // ListTile(
          //   title: const Text("camera"),
          //   onTap: () {
          //     Navigator.push<void>(
          //       context,
          //       MaterialPageRoute<void>(
          //         builder: (BuildContext context) => const Cameranationid(),
          //       ),
          //     );
          //   },
          // ),
          ListTile(
            title: const Text("overlay"),
            onTap: () async {
              await availableCameras().then(
                (value) => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CameraPage(
                      cameras: value,
                    ),
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

class CameraPage extends StatefulWidget {
  final List<CameraDescription>? cameras;
  const CameraPage({this.cameras, Key? key}) : super(key: key);

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  XFile? pictureFile;

  late CameraController controller;
  bool flash = false;

  @override
  void initState() {
    super.initState();
    controller = CameraController(
      widget.cameras![0],
      ResolutionPreset.max,
    );
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    if (!controller.value.isInitialized) {
      return const SizedBox(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: size.height * 30 / 100,
              width: size.width * 100 / 100,
              child: CameraPreview(controller),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () async {
                  pictureFile = await controller.takePicture();
                  setState(() {});
                },
                child: const Text('Capture Image'),
              ),
            ),
            if (pictureFile != null)
              Image.file(
                File(pictureFile!.path),
                height: 200,
              )
          ],
        ),
      ),
    );
  }
}
