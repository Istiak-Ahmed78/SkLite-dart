import 'dart:convert';
import 'dart:io';
import 'package:example/image_utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sklite/SVM/SVM.dart';
import 'package:sklite/utils/io.dart';

class ScannerScreen extends StatefulWidget {
  @override
  _ScannerScreenState createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  bool initialized = false;
  File? imageFile;
  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {}

  Future<void> pickImage() async {
    ImagePicker().pickImage(source: ImageSource.gallery).then((value) {
      imageFile = value?.path == null ? null : File(value!.path);
      setState(() {});
    });
  }

  Future<void> predictUsingSVM(File imageFile) async {
    String modelData = await loadModel('assets/peddy_model.json');
    List<double>? input = await ImageUtils.convertImageToData(imageFile);
    if (input == null) {
      print('Something is wrong with image resizing');
      return;
    }
    final svmModel = SVC.fromMap(json.decode(modelData));
    int result = svmModel.predict(input);
    print(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Camera Demo'),
      ),
      body: Center(
        child: imageFile == null
            ? ElevatedButton(
                onPressed: pickImage,
                child: Text('Choose image'),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.7,
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Image.file(
                      imageFile!,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(onPressed: () => predictUsingSVM(imageFile!), child: Text('Predict')),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(onPressed: pickImage, child: Text('Reselect')),
                ],
              ),
      ),
    );
  }
}
