import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:test_tflite/classifier.dart';
import 'package:test_tflite/constants.dart';

class DogDetectionPage extends StatefulWidget {
  const DogDetectionPage({super.key});

  @override
  State<DogDetectionPage> createState() => _DogDetectionScreenState();
}

class _DogDetectionScreenState extends State<DogDetectionPage> {
  final Classifier classifier = Classifier();
  List<dynamic> predictedResults = [];
  bool hasPredicted = false;
  File? filePath;
  String label = Constants.introLabel;
  String content = Constants.introContent;
  bool isLoading = false;

  @override
  void initState() {
    classifier.tfLteInit();
    super.initState();
  }

  @override
  void dispose() {
    classifier.tfLteDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          Constants.pageTitle,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    filePath != null
                        ? CircleAvatar(
                            radius: 100,
                            backgroundImage: FileImage(filePath!),
                          )
                        : const CircleAvatar(
                            radius: 100,
                            backgroundImage: AssetImage('assets/dog_bg.jpg'),
                          ),
                    const SizedBox(height: 20),
                    Text(
                      label,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    Text(
                      content,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 20),
                    if (hasPredicted) breedMatchContainer(predictedResults),
                    const SizedBox(
                      height: 50,
                    )
                  ],
                ),
              ),
            ),
      bottomNavigationBar: isLoading
          ? const SizedBox()
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: customButton(
                      icon: Icons.camera,
                      label: Constants.takePhotoText,
                      onTap: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.gallery);

                        if (image == null) return;

                        final imageCrop = await cropImages(image);
                        XFile croppedXFile = XFile(imageCrop.path);
                        setState(() {
                          isLoading = true;
                        });
                        await onTakeImageDone(croppedXFile);
                        setState(() {
                          isLoading = false;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: customButton(
                      icon: Icons.image,
                      label: Constants.gallery,
                      onTap: () async {
                        final ImagePicker picker = ImagePicker();

                        final XFile? image =
                            await picker.pickImage(source: ImageSource.gallery);

                        if (image == null) return;
                        final imageCrop = await cropImages(image);
                        XFile croppedXFile = XFile(imageCrop.path);
                        setState(() {
                          isLoading = true;
                        });
                        await onTakeImageDone(croppedXFile);
                        setState(() {
                          isLoading = false;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget breedMatchContainer(List<dynamic> predictedResults) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Constants.grey1,
      ),
      child: Column(
        children: [
          for (var breedMatch in predictedResults)
            breedMatchWidget(
              label: breedMatch['label'],
              confidence: breedMatch['confidence'],
            ),
        ],
      ),
    );
  }

  Widget breedMatchWidget({required String label, required double confidence}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.replaceAll('_', ' '),
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    LinearPercentIndicator(
                      width: 200.0,
                      lineHeight: 8.0,
                      barRadius: const Radius.circular(5),
                      percent: confidence,
                      padding: EdgeInsets.zero,
                      progressColor: Colors.deepPurple,
                    ),
                    Text(
                      '${(confidence * 100).toStringAsFixed(1)}% Match',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget customButton(
      {IconData? icon, required String label, void Function()? onTap}) {
    return SizedBox(
      height: 48.0,
      child: Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey,
                  offset: Offset(1.0, 2.0),
                  blurRadius: 8.0,
                  spreadRadius: 2.0)
            ]),
        child: Stack(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: 48.0,
                  height: 48.0,
                  alignment: Alignment.centerLeft,
                  decoration: const BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Icon(
                      icon,
                      color: Colors.white,
                    ),
                  ),
                ),
                Expanded(
                    child: Center(
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: Colors.deepPurple,
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )),
              ],
            ),
            SizedBox.expand(
              child: Material(
                type: MaterialType.transparency,
                child: InkWell(onTap: onTap),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> onTakeImageDone(XFile image) async {
    var imageMap = File(image.path);
    setState(() {
      filePath = imageMap;
    });

    final isDog = await classifier.getImageLabels(image);
    if (!isDog) {
      setState(() {
        label = Constants.noDogLabel;
        content = Constants.noDogContent;
        predictedResults = [];
        hasPredicted = false;
      });
      return;
    }
    predictedResults = await classifier.predict(image) ?? [];
    if (predictedResults.isNotEmpty) {
      setState(() {
        hasPredicted = true;
        var newLabel = '';
        if (predictedResults[0]['label'] != null) {
          newLabel =
              predictedResults[0]['label'].toString().replaceAll('_', ' ');
        }
        label = newLabel;
        content = Constants.resultText;
      });
    }
    return;
  }

  Future<CroppedFile> cropImages(XFile image) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: image.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
      maxHeight: 224,
      maxWidth: 224,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.purpleAccent,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: true,
        ),
        IOSUiSettings(
          title: 'Crop Image',
        ),
      ],
    );

    return croppedFile!;
  }
}
