import 'dart:io';

import 'package:db/activity/common/book_photo.dart';
import 'package:db/common/api/address.dart';
import 'package:db/common/api/request.dart';
import 'package:db/common/local_storage/const.dart';
import 'package:db/home/common/layout.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class BookScreen extends StatefulWidget {
  const BookScreen({super.key});

  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  File? _image;
  File? myImage;
  final picker = ImagePicker();
  final String userImage =
      "https://cdn.pixabay.com/photo/2018/04/27/03/50/portrait-3353699_1280.jpg";
  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);

        uploadImage(_image!);
      } else {
        print('------No image selected.------');
      }
    });
  }

  // take photo
  Future getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);

        uploadImage(_image!);
      } else {
        print('-----No image selected.------');
      }
    });
  }

  Future<void> _requestPermissions() async {
    final cameraPermissionStatus = await Permission.camera.status;
    if (cameraPermissionStatus.isDenied) {
      await Permission.storage.request();

      if (cameraPermissionStatus.isDenied) {
        await openAppSettings();
      }
    } else if (cameraPermissionStatus.isPermanentlyDenied) {
      await openAppSettings();
    } else {
      print("check camera permission");
    }

    final storagePermissionStatus = await Permission.photos.status;
    if (storagePermissionStatus.isDenied) {
      await Permission.photos.request();
      if (storagePermissionStatus.isDenied) {
        await openAppSettings();
      }
    } else if (storagePermissionStatus.isPermanentlyDenied) {
      await openAppSettings();
    } else {
      print("check storage permission");
    }
  }

  Future<void> downloadAndCacheImage(String imageURL) async {
    final cacheManager = DefaultCacheManager();

    //Download the image if not already cached
    final fileInfo = await cacheManager.getFileFromCache(imageURL);
    if (fileInfo == null || !fileInfo.file.existsSync()) {
      final myImage = await cacheManager.downloadFile(imageURL);
      if (myImage.file.existsSync()) {
        setState(() {
          this.myImage = myImage.file;
          print(myImage.file.path);
          print('--------${myImage.file.path}');
        });
        return;
      }
    }
    setState(() {
      myImage = fileInfo!.file;
    });
  }

  Future<void> uploadImage(File imageFile) async {
    var sendImage = ApiService();

    var formData = FormData.fromMap({
      'file': MultipartFile.fromFile(
        imageFile.path,
      ),
    });

    final sessionID = await storage.read(key: sessionIDLS);
    if (sessionID != null) {
      final response =
          await sendImage.postRequest(sessionID, imageURL, formData);
      sendImage.reponseMessageCheck(response);
    }
  }

  void tapOnPhoto() {
    {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Profile Photo'),
            content: const Text('select your photo'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  getImageFromCamera();
                  //here
                },
                child: const Text('camera'),
              ),
              TextButton(
                onPressed: () {
                  getImageFromGallery();
                  //here
                },
                child: const Text('gallery'),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('close'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(children: [
      ProfilePhoto(
        tapOnProfilePhoto: tapOnPhoto,
        userImage: myImage,
      ),
    ]);
  }
}
