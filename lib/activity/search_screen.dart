import 'package:db/activity/common/bottom_sheet.dart';
import 'package:db/activity/common/search_bar.dart';
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
  late final int userMode;
  String? sessionID;
  late final List<int>? tableInfo;
  final SearchController controller = SearchController();
  final SearchController tableController = SearchController();
  @override
  void initState() {
    getStudentInfo();
    super.initState();
  }

  void onBarTap() {
    setState(() {
      controller.openView();
    });
  }

  void onChanged(_) {
    setState(() {
      controller.openView();
    });
  }

  void onItemTap() {
    setState(() {
      controller.openView();
    });
  }

  void onTableItemTap() {
    setState(() {
      tableController.openView();
    });
  }

  void onTableBarTap() {
    setState(() {
      tableController.openView();
    });
  }

  void onTableChanged(_) {
    setState(() {
      tableController.openView();
    });
    return;
  }

  Future<List<ClassModel>?> getTableInfo() async {
    ApiService classInfo = ApiService();
    if (sessionID != null) {
      final response = await classInfo.getRequest(sessionID!, tableURL);
      if ('success' == await classInfo.reponseMessageCheck(response)) {
        return response!.data['data'];
      }
    }

    return null;
  }

  void getStudentInfo() async {
    name = '백효영';
    id = 201901366;
    sessionID = await storage.read(key: sessionIDLS);
    if (sessionID == null) {
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
      final response = await addTable.postRequest(
          sessionID!, addTableURL, tableInfo ??= null);
      if ('success ' == await addTable.reponseMessageCheck(response)) {
        print("sucessfully send");
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
              child: Search(
                controller: controller,
                onChanged: onChanged,
                onBarTap: onBarTap,
                onItemTap: onItemTap,
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
                                  return FloatingSheet(
                                    search: Search(
                                      controller: tableController,
                                      onItemTap: onTableItemTap,
                                      onBarTap: onTableBarTap,
                                      onChanged: onTableChanged,
                                    ),
                                    title: "시간표를 등록하세요",
                                    onDonePressed: onDonePressed,
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
                    }),
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
                child: Text(
                  '${classTable[index].classDay}\n${classTable[index].classTime}',
                ),
              ),
              Container(
                width: 100,
                height: 70,
                color: Colors.white,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(8),
                child: Text(
                  classTable[index].classLoc,
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
