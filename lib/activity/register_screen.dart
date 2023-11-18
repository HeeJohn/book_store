import 'dart:convert';

import 'package:db/activity/common/bottm_sheet.dart';
import 'package:db/activity/common/registered_book.dart';
import 'package:db/common/api/address.dart';
import 'package:db/common/api/models/registered_book_model.dart';
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

  Future<List<RegisterdBook>?> getBookInfo() async {
    ApiService registeredBook = ApiService();
    sessionID = await storage.read(key: sessionIDLS);
    if (sessionID != null) {
      final response =
          await registeredBook.getRequest(sessionID!, registeredBookURL);
      if ('success' == await registeredBook.reponseMessageCheck(response)) {
        final List<Map<String, String>> books =
            jsonDecode(response!.data['data']);
        List<RegisteredBookModel> registeredBooks =
            books.map((e) => RegisteredBookModel.fromJson(e)).toList();

        return registeredBooks
            .map(
              (e) => RegisterdBook(
                name: e.rbName,
                bookImage: e.rbImage,
                date: e.rbDate,
                onTap: () => onBookTap,
                price: e.rbPrice,
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
          isScrollControlled: true,
          context: context,
          builder: (BuildContext context) {
            return FloatingSheet(
              title: "책을 등록하세요",
              onDonePressed: () {},
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
        Expanded(
          child: FutureBuilder<List<RegisterdBook>?>(
            future: getBookInfo(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const BottomCircleProgressBar();
              }

              if (snapshot.data == null) {
                return const Center(
                  child: TopImage(),
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
        ),
      ],
    );
  }
}
