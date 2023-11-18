import 'dart:convert';

import 'package:db/activity/common/bottom_sheet.dart';
import 'package:db/activity/common/registered_book.dart';
import 'package:db/common/api/address.dart';
import 'package:db/common/api/models/book_model.dart';
import 'package:db/common/api/request.dart';
import 'package:db/common/local_storage/const.dart';
import 'package:db/home/common/layout.dart';
import 'package:db/home/common/top_image.dart';
import 'package:db/home/splash.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late String? sessionID;
  void onBookTap(bookCode) {}
  void onDonePressed() {}
  Future<List<RegisterdBook>?> getBookInfo() async {
    ApiService registeredBook = ApiService();
    sessionID = await storage.read(key: sessionIDLS);
    if (sessionID != null) {
      final response =
          await registeredBook.getRequest(sessionID!, registeredBookURL);
      if ('success' == await registeredBook.reponseMessageCheck(response)) {
        final List<Map<String, String>> books =
            jsonDecode(response!.data['data']);
        List<BookModel> registeredBooks =
            books.map((e) => BookModel.fromJson(e)).toList();

        return registeredBooks
            .map(
              (e) => RegisterdBook(
                name: e.bookName,
                bookImage: e.bookImage,
                date: e.bookRGDate,
                onTap: () => onBookTap,
                price: e.bookPrice,
              ),
            )
            .toList();
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      floatingActionButton: FloatingActionButton(
        onPressed: () => showModalBottomSheet(
          backgroundColor: Colors.white,
          barrierColor: Colors.white,
          isScrollControlled: true,
          context: context,
          builder: (BuildContext context) {
            return FloatingSheet(
              title: "책을 등록하세요",
              onDonePressed: onDonePressed,
            );
          },
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(30),
            ),
          ),
        ),
      ),
      children: [
        const Text(
          "등록된 책 리스트",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
        ),
        FutureBuilder<List<RegisterdBook>?>(
          future: getBookInfo(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const BottomCircleProgressBar();
            }

            if (snapshot.data == null) {
              return SizedBox(
                width: MediaQuery.of(context).size.width * 1 / 5,
                child: const TopImage(),
              );
            }

            return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                return snapshot.data![index];
              },
            );
          },
        ),
      ],
    );
  }
}
