import 'dart:convert';
import 'package:db/activity/common/bottom_sheet_with_search.dart';
import 'package:db/activity/common/registered_book.dart';
import 'package:db/common/api/address.dart';
import 'package:db/common/api/models/book_model.dart';
import 'package:db/common/api/models/class_model.dart';
import 'package:db/common/api/request.dart';
import 'package:db/common/const/color.dart';
import 'package:db/common/local_storage/const.dart';
import 'package:db/home/common/layout.dart';
import 'package:db/home/splash.dart';

import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String? name;
  int? id = 0;
  final int sizeOfTuple = 5; // temp

  String? sessionID;
  List<int> tableInfo = [];
  Map<int, ClassModel> recomClassModels = {};
  Map<int, BookModel> recomBookModels = {};
  Map<int, BookState> recomBookStatusModels = {};
  List<ClassModel> classTable = [];

  SearchController searchController = SearchController();

  Future<List<ClassModel>?> getTableInfo() async {
    ApiService classInfo = ApiService();
    sessionID = await storage.read(key: sessionIDLS);
    if (sessionID != null) {
      final response = await classInfo.getRequest(sessionID!, myTableURL, {});
      if ('success' == await classInfo.reponseMessageCheck(response)) {
        final data = jsonDecode(response!.data)['data'];
        classTable.clear();
        for (int i = 0; i < data.length; i++) {
          classTable.add(ClassModel.fromJson(data[i]));
        }
        return classTable;
      }
    }
    return [];
  }

  void getStudentInfo() async {
    final personInfo = ApiService();
    name = '';
    sessionID = await storage.read(key: sessionIDLS);
    if (sessionID != null) {
      final response =
          await personInfo.getRequest(sessionID!, personInfoURL, {});
      if ('success' == await personInfo.reponseMessageCheck(response)) {
        final data = jsonDecode(response!.data)['data'];
        setState(() {
          name = data['name'];
          id = data['student_id'];
        });
      }
    }
  }

  @override
  void initState() {
    getStudentInfo();
    super.initState();
  }

  void onCancelPressed(int classID) async {
    print('--------------');
    print(classID);
    ApiService classInfo = ApiService();
    sessionID = await storage.read(key: sessionIDLS);
    if (sessionID != null) {
      final response = await classInfo.postRequest(
        sessionID!,
        delMyTableURL,
        {'classID': classID},
      );
      if ('success' == await classInfo.reponseMessageCheck(response)) {
        setState(() {
          classTable.removeWhere((element) => element.classID == classID);
          tableInfo.removeWhere((element) => element == classID);
        });
      }
    }
    setState(() {});
  }

  Future<bool> onSearchBookChanged(
      String? val, SearchController controller) async {
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

  void onDonePressed() async {
    ApiService addTable = ApiService();
    for (int i = 0; i < tableInfo.length; i++) {
      print('table info------------> $i');
    }
    if (sessionID != null) {
      final response = await addTable
          .postRequest(sessionID!, tableAddURL, {'class_id': tableInfo});
      if ('success' == await addTable.reponseMessageCheck(response)) {
        setState(() {
          classTable.clear();
          tableInfo.clear();
          Navigator.of(context).pop();
        });
      }
    }
  }

  Future<bool> onSearchChanged(String? val, SearchController controller) async {
    print(val);
    print("======================================================");

    ApiService classInfo = ApiService();
    if (sessionID != null) {
      dynamic response = await classInfo
          .postRequest(sessionID!, tableSearchURL, {'text': val});
      if ('success' == await classInfo.reponseMessageCheck(response)) {
        dynamic received = await jsonDecode(response!.data);
        if (await received['data'] != null) {
          int size = await received['data'].length;
          print(size);
          if (size != 0) {
            print(received['data'][0]);
          }
          recomClassModels.clear();
          for (int i = 0; i < size; i++) {
            recomClassModels.putIfAbsent(
                i, () => ClassModel.fromJson(received['data'][i]));
          }
          if (!controller.isOpen) controller.openView();
          return true;
        }
      }
    }
    return false;
  }

  void onSearchSelected(String val, ClassModel classModel) {
    print(val);
    setState(() {
      if (!tableInfo.contains(int.parse(val))) {
        print('=============================== in');
        tableInfo.add(int.parse(val));
        classTable.add(classModel);
      }
      print('=============================== out');
    });
  }

  void onLogOutPressed() async {
    if (sessionID != null) {
      final logOut = ApiService();
      final response = await logOut.getRequest(sessionID!, logOutURL, {});
      if ('success' == await logOut.reponseMessageCheck(response)) {
        await storage.deleteAll();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            Expanded(
              child: SearchAnchor(
                isFullScreen: false,
                builder: (BuildContext context, SearchController controller) {
                  return SearchBar(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: const BorderSide(
                          color: Colors.grey,
                          width: 1,
                        ),
                      ),
                    ),
                    elevation: MaterialStateProperty.all<double>(0.0),
                    backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromARGB(255, 255, 255, 255),
                    ),
                    controller: controller,
                    padding: const MaterialStatePropertyAll<EdgeInsets>(
                      EdgeInsets.only(right: 16),
                    ),
                    onTap: () {},
                    onChanged: (val) {
                      print("============================");
                      print(val);
                    },
                    leading: Container(
                      color: const Color.fromARGB(255, 223, 223, 223),
                      width: 60,
                      height: 60,
                      child: const Icon(
                        Icons.search,
                        color: grey,
                      ),
                    ),
                  );
                },
                suggestionsBuilder:
                    (BuildContext context, SearchController controller) {
                  return List<ListTile>.generate(
                    5,
                    (int index) {
                      final String item = 'item $index';
                      return ListTile(
                        title: Text(item),
                        onTap: () {
                          controller.closeView(item);
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('로그아웃'),
                                content: const Text('로그아웃을 하시겠습니까?'),
                                actions: <Widget>[
                                  ElevatedButton(
                                    onPressed: () {
                                      onLogOutPressed();
                                      Navigator.of(context)
                                          .popUntil((route) => false);
                                    },
                                    child: const Text('예'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(false);
                                    },
                                    child: const Text('아니오'),
                                  ),
                                ],
                              );
                            });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: grey,
                          borderRadius: BorderRadius.circular(1000),
                        ),
                        width: 150,
                        height: 150,
                        child: const Icon(
                          Icons.person_4,
                          color: grey,
                          size: 150,
                          shadows: [
                            Shadow(
                              color: Colors.white,
                              offset: Offset.zero,
                              blurRadius: 20,
                            )
                          ],
                        ),
                      ),
                    ),
                    Text(
                      name!,
                      style: const TextStyle(
                        color: Colors.black,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w400,
                        fontSize: 50,
                      ),
                    ),
                    Text(
                      id.toString(),
                      style: const TextStyle(
                        color: Colors.black,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w300,
                        fontSize: 25,
                      ),
                    )
                  ],
                ),
                FutureBuilder<List<ClassModel>?>(
                  future: getTableInfo(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: SizedBox(
                          width: 200,
                          height: 200,
                          child: BottomCircleProgressBar(),
                        ),
                      );
                    }
                    if (snapshot.data!.isEmpty) {
                      return Center(
                        child: SizedBox(
                          width: 200,
                          height: 200,
                          child: IconButton(
                            onPressed: () => showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              builder: (BuildContext context) {
                                return FloatingSheetWithSearchBar(
                                  onCancelPressed: onCancelPressed,
                                  mainController: searchController,
                                  classModels: classTable,
                                  recomClassModels: recomClassModels,
                                  title: "시간표를 등록하세요",
                                  onDonePressed: onDonePressed,
                                  onChanged: onSearchChanged,
                                  onSelected: onSearchSelected,
                                );
                              },
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(30),
                                ),
                              ),
                            ),
                            icon: Icon(
                              Icons.add,
                              size: MediaQuery.of(context).size.width * 1 / 3,
                            ),
                          ),
                        ),
                      );
                    }
                    return GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (BuildContext context) {
                            return FloatingSheetWithSearchBar(
                              onCancelPressed: onCancelPressed,
                              mainController: searchController,
                              classModels: classTable,
                              recomClassModels: recomClassModels,
                              title: "시간표를 등록하세요",
                              onDonePressed: onDonePressed,
                              onChanged: onSearchChanged,
                              onSelected: onSearchSelected,
                            );
                          },
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(30),
                            ),
                          ),
                        );
                      },
                      child: ScheduleTable(
                        onCancelButtonPressed: () => setState(() {}),
                        onCancelPressed: onCancelPressed,
                        isForTableSearch: false,
                        classTable: snapshot.data!,
                        sizeOfTuple: sizeOfTuple,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ScheduleTable extends StatelessWidget {
  final List<ClassModel> classTable;
  final int sizeOfTuple;
  final bool isForTableSearch;
  final ValueChanged<int> onCancelPressed;
  final VoidCallback onCancelButtonPressed;
  const ScheduleTable({
    super.key,
    required this.onCancelButtonPressed,
    required this.sizeOfTuple,
    required this.classTable,
    required this.isForTableSearch,
    required this.onCancelPressed,
  });

  @override
  Widget build(BuildContext context) {
    void showBook(int classID) {
      print(classID);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => Book(
            classID: classID,
          ),
        ),
      );
    }

    return Table(
      border: TableBorder.symmetric(
        outside: BorderSide.none,
        inside: const BorderSide(
          color: grey,
          width: 2.0,
          style: BorderStyle.solid,
        ),
      ),
      columnWidths: const <int, TableColumnWidth>{
        0: IntrinsicColumnWidth(),
        1: FlexColumnWidth(),
        2: FixedColumnWidth(64),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: List.generate(
        classTable.length,
        (index) {
          return TableRow(
            children: [
              Container(
                width: 150,
                height: 70,
                color: Colors.grey,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(8),
                child: Text(
                  classTable[index].className,
                ),
              ),
              Container(
                width: 100,
                height: 70,
                color: Colors.white,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(8),
                child: Text(
                  classTable[index].classProf,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                width: 100,
                height: 70,
                color: Colors.white,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(8),
                child: Text(
                  classTable[index].classCredit.toString(),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (!isForTableSearch)
                Container(
                  width: 100,
                  height: 70,
                  color: Colors.white,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(8),
                  child: IconButton(
                    onPressed: () => showBook(classTable[index].classID),
                    icon: const Icon(
                      Icons.image_search_rounded,
                    ),
                  ),
                ),
              if (isForTableSearch)
                Container(
                  width: 100,
                  height: 70,
                  color: Colors.white,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(8),
                  child: IconButton(
                    onPressed: () {
                      onCancelButtonPressed();
                      onCancelPressed(classTable[index].classID);
                    },
                    icon: const Icon(
                      Icons.cancel_presentation_outlined,
                      color: Colors.red,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class Book extends StatefulWidget {
  final int classID;
  const Book({
    required this.classID,
    super.key,
  });

  @override
  State<Book> createState() => _BookState();
}

class _BookState extends State<Book> {
  List<BookModel> registeredBooks = [];
  List<BookState> registeredBooksState = [];
  bool latestButton = false;
  bool stateButton = false;
  bool priceButton = false;
  String how = 'price', order = 'ASC';

  void onSortPressed(String how, bool order) async {
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
        how = 'price';
    }
    this.how = how;
    this.order = order ? 'ASC' : 'DESC';
    getBookInfo(this.how, this.order);
  }

  Future<List<RegisterdBook>?> getBookInfo(String how, String order) async {
    ApiService searchBook = ApiService();
    var sessionID = await storage.read(key: sessionIDLS);
    if (sessionID != null) {
      final response = await searchBook.getRequest(sessionID, searchBooksURL, {
        'how': how,
        'order': order,
        'classID': widget.classID,
      });
      if ('success' == await searchBook.reponseMessageCheck(response)) {
        final books = jsonDecode(response!.data)['data'];
        registeredBooks.clear();
        try {
          for (int i = 0; i < books.length; i++) {
            registeredBooks.add(BookModel.fromJson(books[i]));
            registeredBooksState.add(BookState.fromJson(books[i]));
          }
        } catch (e) {
          print(e);
        }

        return registeredBooks
            .map((e) => RegisterdBook(
                  name: e.bookName,
                  uploadTime: e.uploadTime!,
                  onTap: () {},
                  price: e.bookPrice,
                ))
            .toList();
      }
    }
    return null;
  }

  void notify(int sellerID, int bookID) async {
    print('===========');
    print(sellerID);
    print(bookID);
    print('===========');
    ApiService notify = ApiService();
    var sessionID = await storage.read(key: sessionIDLS);
    if (sessionID != null) {
      final response = await notify.postRequest(
        sessionID,
        notifyURL,
        {'sellerID': sellerID, 'bookID': bookID},
      );
      if ('success' == await notify.reponseMessageCheck(response)) {
        pop();
      }
    }
  }

  void pop() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      children: [
        const SizedBox(
          height: 20,
        ),
        const Text(
          "검색된 책",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                latestButton ? (Colors.grey) : Colors.purple[100],
              )),
              onPressed: () => {
                onSortPressed('latest', latestButton),
                latestButton = !latestButton,
                setState(() {}),
              },
              child: const Text('최신순'),
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                priceButton ? (Colors.grey) : Colors.purple[100],
              )),
              onPressed: () => {
                onSortPressed('price', priceButton),
                priceButton = !priceButton,
                setState(() {}),
              },
              child: const Text('가격순'),
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                stateButton ? (Colors.grey) : Colors.purple[100],
              )),
              onPressed: () => {
                onSortPressed('status', stateButton),
                stateButton = !stateButton,
                setState(() {}),
              },
              child: const Text('상태순'),
            ),
          ],
        ),
        Expanded(
          child: FutureBuilder<List<RegisterdBook>?>(
            future: getBookInfo(how, order),
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
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      snapshot.data![index],
                      IconButton(
                        iconSize: MediaQuery.of(context).size.width / 7,
                        onPressed: () => showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('구매 요청'),
                                content: Text(
                                    '"${snapshot.data![index].name}" 책구매를 요청하시겠습니까?'),
                                actions: <Widget>[
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('NO'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      notify(registeredBooks[index].studentID!,
                                          registeredBooks[index].bookId!);
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('YES'),
                                  ),
                                ],
                              );
                            }),
                        icon: const Icon(
                          Icons.request_quote,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
