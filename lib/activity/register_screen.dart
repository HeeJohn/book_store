import 'dart:convert';
import 'dart:io';
import 'package:db/activity/common/bottom_sheet.dart';
import 'package:db/activity/common/registered_book.dart';
import 'package:db/common/api/address.dart';
import 'package:db/common/api/models/book_model.dart';
import 'package:db/common/api/models/class_model.dart';
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
  TextEditingController bookAuthorCTR = TextEditingController();
  String? bookName, bookPublishDate;
  int? classCode;
  String? bookPrice, bookRGDate, className;
  List<int> stateNum = List<int>.filled(label.length, 0);
  Map<int, ClassModel> recomClassModels = {};
  List<void Function(double, int)> polledValue = [];
  int sum = 0;
  static const List<String> label = ['찢김', '하이라이트', '연필자국', '펜자국', '바램', '더러움'];
  late DateTime today;
  late String? sessionID;
  late List<BookModel> registeredBooks;
  void onBookTap() {}

  void onDonePressed() async {
    if (bookPublishDate != null && classCode != null) {
      Map<String, dynamic> bookData = {
        'publisher': bookPublisherCTR.text,
        'name': bookNameCTR.text,
        'price': bookPriceCTR.text,
        'bookPublishedDate': bookPublishDate,
        'author': bookAuthorCTR.text,
        'classCode': classCode!,
        'bookStateList': stateNum,
        'upload_time':
            "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}-${DateTime.now().hour}-${DateTime.now().minute}",
      };
      print(bookData);
      final bookSend = ApiService();
      final sessionID = await storage.read(key: sessionIDLS);

      if (sessionID != null) {
        final response = await bookSend.postRequest(
            sessionID, addBookURL, jsonEncode(bookData));
        if ('success' == await bookSend.reponseMessageCheck(response)) {
          setState(() {
            Navigator.of(context).pop();
          });
        }
      }
    }
  }

  void onSearchRecomTap(val, classCode) {
    setState(() {
      className = val;
      this.classCode = classCode;
      print(className);
      print(this.classCode);
    });
  }

  Future<bool> onSearchChanged(String? val, SearchController controller) async {
    recomClassModels.clear();
    ApiService classInfo = ApiService();
    if (sessionID != null) {
      dynamic response = await classInfo
          .postRequest(sessionID!, tableSearchURL, {'text': val});
      if ('success' == await classInfo.reponseMessageCheck(response)) {
        dynamic received = await jsonDecode(response!.data);
        if (await received['data'] != null) {
          int size = await received['data'].length;
          if (size != 0) {
            print(received['data'][0]);
            for (int i = 0; i < size; i++) {
              recomClassModels.putIfAbsent(
                  i, () => ClassModel.fromJson(received['data'][i]));
            }
          }
          if (!controller.isOpen) {
            controller.openView();
          }
          return true;
        }
      }
    }
    return false;
  }

  void pollVal(double val, int index) {
    stateNum[index] = val.toInt();
    print('============================');
    print("val: $val, index : $index");
    print('============================');
    setState(() {
      sum = 0;
      for (var element in stateNum) {
        sum += element;
      }
    });
  }

  @override
  void initState() {
    today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    for (int i = 0; i < label.length; i++) {
      polledValue.add(pollVal);
    }
    getBookInfo();
    super.initState();
  }

  void onChanged(DateTime val) {
    setState(() {
      bookPublishDate = '${val.year}-${val.month}';
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
              minimumYear: 1900,
              maximumYear: DateTime.now().year,
              initialDateTime: DateTime.now(),
              mode: CupertinoDatePickerMode.monthYear,
              onDateTimeChanged: (DateTime date) => onChanged(date),
            ),
          ),
        );
      },
    );
  }

  Future<List<RegisterdBook>?> getBookInfo() async {
    print('hihihhihihi');
    ApiService registeredBook = ApiService();
    sessionID = await storage.read(key: sessionIDLS);
    if (sessionID != null) {
      final response =
          await registeredBook.getRequest(sessionID!, regidBooksURL);
      if ('success' == await registeredBook.reponseMessageCheck(response)) {
        List books = jsonDecode(response!.data)['data'];
        print(books);
        registeredBooks = books.map((e) => BookModel.fromJson((e))).toList();
        print(registeredBooks);
        return registeredBooks
            .map(
              (e) => RegisterdBook(
                name: e.bookName,
                uploadTime: e.uploadTime!,
                onTap: () => onBookTap,
                price: e.bookPrice,
              ),
            )
            .toList();
      }
    }
    return null;
  }

  void _onDismissed(DismissDirection direction, int index) {}
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
              authorController: bookAuthorCTR,
              polledValue: polledValue,
              onTap: onSearchRecomTap,
              recomClassModels: recomClassModels,
              onChanged: onSearchChanged,
              sum: sum,
              label: label,
              bookState: stateNum,
              className: className,
              comController: bookPublisherCTR,
              nameController: bookNameCTR,
              priceController: bookPriceCTR,
              publishedDate: bookPublishDate,
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
              print(snapshot.connectionState);
              if (!snapshot.hasData) {
                return const BottomCircleProgressBar();
              }

              if (snapshot.data!.isEmpty) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width * 1 / 10,
                  child: Image.asset(
                    'asset/img/writing.png',
                    fit: BoxFit.contain,
                  ),
                );
              }

              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) => Dismissible(
                  key: Key(snapshot.data![index].name),
                  onDismissed: (direction) => _onDismissed(direction, index),
                  confirmDismiss: (direction) {
                    if (direction == DismissDirection.endToStart) {
                      return showDialog(
                          context: context,
                          builder: (ctx) {
                            return AlertDialog(
                              title: const Text('책 삭제'),
                              content: Text(
                                  '${snapshot.data![index].name}책을 삭제하시겠습니까?'),
                              actions: <Widget>[
                                ElevatedButton(
                                  onPressed: () {
                                    return Navigator.of(context).pop(false);
                                  },
                                  child: const Text('CANCEL'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    return Navigator.of(context).pop(true);
                                  },
                                  child: const Text('DELETE'),
                                ),
                              ],
                            );
                          });
                    } else if (direction == DismissDirection.startToEnd) {
                      return showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('책 수정'),
                              content: const Text('책을 수정하시겠습니까?'),
                              actions: <Widget>[
                                ElevatedButton(
                                  onPressed: () {
                                    return Navigator.of(context).pop(false);
                                  },
                                  child: const Text('CANCEL'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    return Navigator.of(context).pop(true);
                                  },
                                  child: const Text('EDIT'),
                                ),
                              ],
                            );
                          });
                    }
                    return Future.value(false);
                  },
                  child: snapshot.data![index],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}


      // physics: const NeverScrollableScrollPhysics(),
      //           shrinkWrap: true,
      //           itemCount: snapshot.data!.length,
      //           itemBuilder: (BuildContext context, int index) {
      //             return snapshot.data![index];
      //           },