import 'dart:convert';
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
  int? classID;
  String? bookPrice, bookRGDate, className;
  List<int> stateNum = List<int>.filled(label.length, 0);
  Map<int, ClassModel> recomClassModels = {};
  List<void Function(double, int)> polledValue = [];
  int sum = 0;
  static const List<String> label = ['찢김', '하이라이트', '연필자국', '펜자국', '바램', '더러움'];
  late DateTime today;
  late String? sessionID;
  List<BookModel> registeredBooks = [];
  void onBookTap(BookModel e) {}

  void onDonePressed() async {
    if (bookPublishDate != null && classID != null) {
      Map<String, dynamic> bookData = {
        'publisher': bookPublisherCTR.text,
        'name': bookNameCTR.text,
        'price': bookPriceCTR.text,
        'bookPublishedDate': bookPublishDate,
        'author': bookAuthorCTR.text,
        'classID': classID!,
        'bookStateList': stateNum,
        'upload_time':
            "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}-${DateTime.now().hour}-${DateTime.now().minute}",
      };
      print(bookData);
      final bookSend = ApiService();
      final sessionID = await storage.read(key: sessionIDLS);

      if (sessionID != null) {
        final response =
            await bookSend.postRequest(sessionID, addBookURL, bookData);
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
      classID = classCode;
      print(className);
      print(classID);
    });
  }

  void onSortPressed(String how) async {
    switch (how) {
      case 'price':
        how = 'price';
        break;
      case 'status':
        how = 'book_id';
        break;
      case 'latest':
        how = 'upload_time';
        break;
      default:
        how = '';
    }
    getBookInfo(how);
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

  Future<List<RegisterdBook>?> getBookInfo(String how) async {
    ApiService regidBook = ApiService();
    sessionID = await storage.read(key: sessionIDLS);
    if (sessionID != null) {
      final response =
          await regidBook.getRequest(sessionID!, regidBooksURL, {'how': how});
      if ('success' == await regidBook.reponseMessageCheck(response)) {
        final books = await jsonDecode(response!.data)['data'];
        print(books);
        print(books.length);
        registeredBooks.clear();
        print('before');
        for (int i = 0; i < books.length; i++) {
          print(books[i]);
          registeredBooks[i] = BookModel.fromJson(books[i]);
        }
        print('after');
        print(registeredBooks.length);
        return registeredBooks
            .map((e) => RegisterdBook(
                  name: e.bookName,
                  uploadTime: e.uploadTime!,
                  onTap: () => onBookTap(e),
                  price: e.bookPrice,
                ))
            .toList();
      }
    }
    return null;
  }

  void _onDismissed(int bookID) async {
    ApiService removeBook = ApiService();
    sessionID = await storage.read(key: sessionIDLS);
    if (sessionID != null) {
      print(bookID);
      final response = await removeBook.postRequest(
        sessionID!,
        removeBookURL,
        {'bookID': bookID},
      );

      if ('success' == await removeBook.reponseMessageCheck(response)) {
        setState(() {});
      }
    }
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
        const SizedBox(
          height: 20,
        ),
        const Text(
          "등록된 책 리스트",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () => onSortPressed('latest'),
              child: const Text('최신순'),
            ),
            ElevatedButton(
              onPressed: () => onSortPressed('price'),
              child: const Text('가격순'),
            ),
            ElevatedButton(
              onPressed: () => onSortPressed('status'),
              child: const Text('상태순'),
            ),
          ],
        ),
        Expanded(
          child: FutureBuilder<List<RegisterdBook>?>(
            future: getBookInfo(''),
            builder: (context, snapshot) {
              print(snapshot.data);
              if (!snapshot.hasData) {
                return const BottomCircleProgressBar();
              }
              if (snapshot.data!.isEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '등록된 책이 없습니다.',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Image.asset(
                        'asset/img/writing.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                );
              }

              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) => Dismissible(
                  key: Key(snapshot.data![index].name),
                  confirmDismiss: (direction) {
                    return showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('책 삭제'),
                            content: Text(
                                '"${snapshot.data![index].name}" 책을 삭제하시겠습니까?'),
                            actions: <Widget>[
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('CANCEL'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  _onDismissed(registeredBooks[index].bookId!);
                                  Navigator.of(context).pop();
                                },
                                child: const Text('DELETE'),
                              ),
                            ],
                          );
                        });
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