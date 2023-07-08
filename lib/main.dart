import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:imageapp/camera.dart';
import 'package:imageapp/imageprovider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Imageprovider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Sizer',
          theme: ThemeData.light(),
          home: const Homepage(),
        );
      },
    );
  }
}

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Imageprovider>(builder: (context, imagedata, _) {
      return Scaffold(
        appBar: AppBar(),
        body: Container(
          color: Colors.grey,
          height: 100.h,
          width: 100.w,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  child: imagedata.isloading == true
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : Column(
                          children: [
                            SizedBox(
                                child: imagedata.imagepath != null
                                    ? Image.file(File(imagedata.imagepath!))
                                    : null),
                            SizedBox(
                                child: imagedata.cimagepath != null
                                    ? Image.file(File(imagedata.cimagepath!))
                                    : null),
                            SizedBox(
                                child: imagedata.faces != null
                                    ? Text("face ===${imagedata.faces}")
                                    : null),
                            SizedBox(
                                child: imagedata.rtext != null
                                    ? Text("text ===${imagedata.rtext}")
                                    : null),
                          ],
                        ),
                ),
                ListTile(
                  title: const Text("camera"),
                  onTap: () {
                    Navigator.push<void>(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) =>
                            const Cameranationid(),
                      ),
                    );
                  },
                ),
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
          ),
        ),
      );
    });
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
    final deviceRatio = size.width / size.height;

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
            Transform.scale(
              scale: controller.value.aspectRatio / deviceRatio,
              child: Center(
                child: AspectRatio(
                  aspectRatio: controller.value.aspectRatio,
                  child: CameraPreview(controller),
                ),
              ),
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
