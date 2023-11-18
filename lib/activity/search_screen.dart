import 'package:db/activity/common/bottm_sheet.dart';
import 'package:db/activity/common/round_small_btn.dart';
import 'package:db/common/api/address.dart';
import 'package:db/common/api/models/class_model.dart';
import 'package:db/common/api/request.dart';
import 'package:db/common/const/color.dart';
import 'package:db/common/local_storage/const.dart';
import 'package:db/home/splash.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late String? name;
  late String? id;
  final int sizeOfTuple = 5; // temp
  late final int userMode;
  late final String? sessionID;
  late final List<int>? tableInfo;

  final String className = '항공우주학개론';
  late final String professor = '백효영';
  late final String classTime = '화 5-6';
  late final String classLoc = '이학관 203호';

  @override
  void initState() {
    getInfo();
    super.initState();
  }

  Future<List<ClassModel>?> getInfo() async {
    sessionID = await storage.read(key: sessionIDLS);
    ApiService classInfo = ApiService();
    if (sessionID != null) {
      final response = await classInfo.getRequest(sessionID!, tableURL);
      if ('success' == await classInfo.reponseMessageCheck(response)) {
        return response!.data['data'];
      }
    }

    return null;
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
              child: SearchAnchor(
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
                    onTap: () {
                      controller.openView();
                    },
                    onChanged: (_) {
                      controller.openView();
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
                          setState(() {
                            controller.closeView(item);
                          });
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
        body: FutureBuilder<List<ClassModel>?>(
          future: getInfo(),
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
            if (snapshot.data == null) {
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
                          title: "시간표를 등록하세요",
                          onDonePressed: () {},
                        );
                      },
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(30),
                        ),
                      ),
                    ),
                    icon: const Icon(
                      Icons.add,
                    ),
                  ),
                ),
              );
            }

            return SingleChildScrollView(
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
                          name = '백효영',
                          style: const TextStyle(
                            color: Colors.black,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w400,
                            fontSize: 50,
                          ),
                        )
                      ],
                    ),
                    ScheduleTable(
                      classTable: snapshot.data!,
                      sizeOfTuple: sizeOfTuple,
                    ),
                  ],
                ),
              ),
            );
          },
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
