import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

class CountryView extends StatefulWidget {
  @override
  _CountryViewState createState() => _CountryViewState();
}

class _CountryViewState extends State<CountryView> {
  File _image;
  File _imageToUndo;

  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    _requestPermission();
  }

  _requestPermission() async {
    var statuses = await [
      Permission.storage,
    ].request();

    final info = statuses[Permission.storage].toString();
    print(info);
  }

  Future _openCamera() async {
    Navigator.pop(context);
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      _image = File(pickedFile.path);
    });
  }

  Future _openGallery() async {
    Navigator.pop(context);
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile.path);
    });
  }

  Future _cropImage() async {
    _imageToUndo = _image;

    final croppedFile = await ImageCropper.cropImage(
        sourcePath: _image.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(minimumAspectRatio: 1.0));

    setState(() {
      _image = croppedFile ?? _image;
    });
  }

  Future _undoImage() async {
    setState(() {
      _image = _imageToUndo;
    });
  }

  Future _saveImage() async {
    final result = await ImageGallerySaver.saveFile(_image.path);
  }

  void _settingModalButtonSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        builder: (context) => Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.camera),
                    title: const Text('Camera'),
                    onTap: _openCamera,
                  ),
                  ListTile(
                    leading: const Icon(Icons.photo_album),
                    title: const Text('Gallery'),
                    onTap: _openGallery,
                  ),
                ],
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Image Scan App'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Expanded(
              child: Center(
                child: _image == null
                    ? Text('No image selected.')
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 10.0),
                        child: Image.file(_image),
                      ),
              ),
            ),
            Builder(
                builder: (context) => Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Visibility(
                          child: FloatingActionButton(
                            child: Icon(Icons.crop),
                            tooltip: 'Crop Image',
                            onPressed: () {
                              _cropImage();
                            },
                          ),
                          visible: _image != null,
                        ),
                        Visibility(
                          child: FloatingActionButton(
                            child: Icon(Icons.undo),
                            tooltip: 'Undo Image',
                            onPressed: () {
                              _undoImage();
                            },
                          ),
                          visible: _image != null,
                        ),
                        Visibility(
                          child: FloatingActionButton(
                            child: Icon(Icons.save_alt),
                            tooltip: 'Save Image',
                            onPressed: () {
                              _saveImage();
                            },
                          ),
                          visible: _image != null,
                        ),
                        FloatingActionButton(
                          child: Icon(Icons.add),
                          tooltip: 'Add Image',
                          onPressed: () {
                            _settingModalButtonSheet(context);
                          },
                        ),
                      ],
                    )))
          ],
        ));
  }
}
