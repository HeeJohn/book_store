import 'dart:io';

import 'package:flutter/material.dart';

class ProfilePhoto extends StatelessWidget {
  final void Function()? tapOnProfilePhoto;
  final File? userImage;

  const ProfilePhoto({
    super.key,
    required this.tapOnProfilePhoto,
    required this.userImage,
  });

  /*------------- request photo access permission -----------------*/
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: tapOnProfilePhoto,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        height: 400,
        alignment: Alignment.bottomCenter,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          image: userImage == null
              ? null
              : DecorationImage(
                  image: FileImage(userImage!),
                  fit: BoxFit.cover,
                ),
        ),
        //Adds black gradient from bottom to top to image
        child: Container(
          width: double.infinity,
          alignment: Alignment.bottomCenter,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.0),
                Colors.black.withOpacity(0.1),
                Colors.black.withOpacity(0.2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
