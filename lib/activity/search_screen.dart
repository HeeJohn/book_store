import 'dart:convert';

import 'package:db/activity/common/bottom_sheet_with_search.dart';
import 'package:db/common/api/address.dart';
import 'package:db/common/api/models/class_model.dart';
import 'package:db/common/api/request.dart';
import 'package:db/common/const/color.dart';
import 'package:db/common/hive/boxes.dart';
import 'package:db/common/hive/user.dart';
import 'package:db/common/local_storage/const.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String? name;
  int? id;
  final int sizeOfTuple = 5; // temp

  String? sessionID;
  List<int> tableInfo = [];
  Map<int, ClassModel> selectClassModels = {};
  Map<int, ClassModel> recomClassModels = {};
  List<ClassModel> classTable = [];
  @override
  void initState() {
    getStudentInfo();
    super.initState();
  }

  Future<List<ClassModel>?> getTableInfo() async {
    ApiService classInfo = ApiService();
    if (sessionID == 0) {
      final response = await classInfo.getRequest(sessionID!, tableURL, null);
      if ('success' == await classInfo.reponseMessageCheck(response)) {
        return jsonDecode(response!.data['data']);
      }
    }

    return null;
  }

  void getStudentInfo() async {
    name = '백효영';
    id = 201901366;
    sessionID = await storage.read(key: sessionIDLS);
    if (sessionID != null) {
      final box = Boxes.getUserData();
      UserData? student = box.get(sessionID);
      if (student != null) {
        name = student.studentName;
        id = student.studentID;
      }
    }
  }

  void onDonePressed() async {
    ApiService addTable = ApiService();
    if (sessionID != null) {
      final response =
          await addTable.postRequest(sessionID!, addTableURL, tableInfo);
      if ('success ' == await addTable.reponseMessageCheck(response)) {
        for (var element in selectClassModels.values) {
          classTable.add(element);
        }
      }
      setState(() {});
    }
  }

  void onSearchChanged(String val) async {
    print(val);
    print("======================================================");
    recomClassModels.clear();
    ApiService classInfo = ApiService();
    if (sessionID != null) {
      dynamic response =
          await classInfo.getRequest(sessionID!, tableSearchURL, {'text': val});
      if ('success' == await classInfo.reponseMessageCheck(response)) {
        dynamic received = await jsonDecode(response!.data);
        if (await received['data'] != null) {
          int size = await received['data'].length;
          print(size);
          if (size != 0) {
            print(received['data'][0]);
          }
          for (int i = 0; i < size; i++) {
            recomClassModels.putIfAbsent(
                i, () => ClassModel.fromJson(received['data'][i]));
          }
        }
      }
    }
  }

  void onSearchSelected(val) {
    if (val != null) {
      setState(() {
        tableInfo.add(val as int);
        classTable.add(recomClassModels.values.elementAt(val.toInt()));
      });
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
                    Container(
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
                    // if (!snapshot.hasData) {
                    //   return const Center(
                    //     child: SizedBox(
                    //       width: 200,
                    //       height: 200,
                    //       child: BottomCircleProgressBar(),
                    //     ),
                    //   );
                    // }
                    if (!snapshot.hasData) {
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
                    return ScheduleTable(
                      classTable: snapshot.data!,
                      sizeOfTuple: sizeOfTuple,
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

  const ScheduleTable({
    super.key,
    required this.sizeOfTuple,
    required this.classTable,
  });

  @override
  Widget build(BuildContext context) {
    void showBook(bookCode) {
      Navigator.of(context).pushNamed(bookScreen);
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
                width: 100,
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
                child: IconButton(
                  onPressed: () => showBook(
                    classTable[index].classCode,
                  ),
                  icon: const Icon(
                    Icons.image_search_rounded,
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
