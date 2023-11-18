import 'dart:io';

import 'package:flutter/material.dart';

class BookPhoto extends StatelessWidget {
  final void Function()? tapOnBookPhoto;
  final File? bookImage;
  final String url;
  final double height;
  const BookPhoto({
    super.key,
    required this.tapOnBookPhoto,
    required this.bookImage,
    required this.height,
    required this.url,
  });

  /*------------- request photo access permission -----------------*/
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: tapOnBookPhoto,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        height: height,
        alignment: Alignment.bottomCenter,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          image: DecorationImage(
            image: NetworkImage(url), //  FileImage(bookImage!),
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
