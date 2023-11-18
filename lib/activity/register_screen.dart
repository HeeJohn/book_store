import 'dart:convert';
import 'dart:io';
import 'package:db/activity/common/bottom_sheet.dart';
import 'package:db/activity/common/registered_book.dart';
import 'package:db/common/api/address.dart';
import 'package:db/common/api/models/book_model.dart';
import 'package:db/common/api/request.dart';
import 'package:db/common/const/color.dart';
import 'package:db/common/local_storage/const.dart';
import 'package:db/home/common/layout.dart';
import 'package:db/home/splash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController bookNameCTR = TextEditingController();
  TextEditingController bookPriceCTR = TextEditingController();
  TextEditingController bookPublishDateCTR = TextEditingController();
  TextEditingController bookPublisherCTR = TextEditingController();
  String? bookName, bookOwner, bookPublisher, bookPublishedDate, classCode;
  String? bookPrice, bookRGDate, className;
  List<int> stateNum = [2, 2, 2, 2, 2, 2];
  List<ValueChanged> onSliderChanged = [];
  int sum = 0;
  static const List<String> label = ['찢김', '하이라이트', '연필자국', '펜자국', '바램', '더러움'];
  late DateTime today;
  late String? sessionID;
  File? bookImage;

  void tapOnBookPhoto() {}
  void onBookTap(bookCode) {}
  void onDonePressed() {}
  void refresh(val) {
    setState(() {
      className = val;
    });
  }

  @override
  void initState() {
    today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    onSliderChanged.add((val) {
      setState(() {
        stateNum[0] = val;
      });
    });
    onSliderChanged.add((val) {
      setState(() {
        stateNum[1] = val;
      });
    });
    onSliderChanged.add((val) {
      setState(() {
        stateNum[2] = val;
      });
    });
    onSliderChanged.add((val) {
      setState(() {
        stateNum[3] = val;
      });
    });
    onSliderChanged.add((val) {
      setState(() {
        stateNum[4] = val;
      });
    });
    onSliderChanged.add((val) {
      setState(() {
        stateNum[5] = val;
      });
    });

    super.initState();
  }

  void onChanged(DateTime val) {
    setState(() {
      bookPublishedDate = '${val.year}-${val.month}-${val.day}';
    });
  }

  void pickDate() {
    showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            color: Colors.grey[100],
            height: MediaQuery.of(context).size.height / 3,
            child: CupertinoDatePicker(
              minimumDate: DateTime(1900, 1, 1),
              maximumDate: today,
              initialDateTime: today,
              mode: CupertinoDatePickerMode.date,
              onDateTimeChanged: (DateTime date) => onChanged(date),
            ),
          ),
        );
      },
    );
  }

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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(1000),
          side: const BorderSide(
            color: grey,
            width: 2,
          ),
        ),
        backgroundColor: Colors.white,
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
        onPressed: () => showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (BuildContext context) {
            return FloatingSheet(
              bookImage: bookImage,
              tapOnBookPhoto: tapOnBookPhoto,
              sum: sum,
              onSliderChanged: onSliderChanged,
              label: label,
              bookState: stateNum,
              className: className,
              refresh: refresh,
              comController: bookPublisherCTR,
              nameController: bookNameCTR,
              priceController: bookPriceCTR,
              publishedDate: bookPublishedDate,
              onDatePressed: pickDate,
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
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
        ),
        Expanded(
          child: FutureBuilder<List<RegisterdBook>?>(
            future: getBookInfo(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const BottomCircleProgressBar();
              }

              if (snapshot.data == null) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width * 1 / 10,
                  child: Image.asset(
                    'asset/img/writing.png',
                    fit: BoxFit.contain,
                  ),
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
