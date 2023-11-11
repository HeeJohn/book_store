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

  final String className = '항공우주학개론';
  late final String professor = '백효영';
  late final String classTime = '화 5-6';
  late final String classLoc = '이학관 203호';

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  Future<bool> getUserInfo() async {
    name = await storage.read(key: nameLS);
    id = await storage.read(key: studentIDLS);
    if (name != null && id != null) return true;

    return false;
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
                    elevation: MaterialStateProperty.all<double>(
                        0.0), // Set elevation to 0 for no elevation
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
        body: FutureBuilder<bool>(
            future: getUserInfo(),
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
                        classLoc: classLoc,
                        className: className,
                        professor: professor,
                        classTime: classTime,
                        sizeOfTuple: sizeOfTuple,
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}

class ScheduleTable extends StatelessWidget {
  final String className;
  final String professor;
  final String classTime;
  final String classLoc;
  final int sizeOfTuple;
  final Icon search = const Icon(
    Icons.image_search_rounded,
  );

  const ScheduleTable({
    super.key,
    required this.sizeOfTuple,
    required this.classLoc,
    required this.className,
    required this.professor,
    required this.classTime,
  });

  @override
  Widget build(BuildContext context) {
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
        sizeOfTuple,
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
                  className,
                ),
              ),
              Container(
                width: 100,
                height: 70,
                color: Colors.white,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(8),
                child: Text(
                  professor,
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
                  classTime,
                ),
              ),
              Container(
                width: 100,
                height: 70,
                color: Colors.white,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(8),
                child: Text(
                  classLoc,
                ),
              ),
              Container(
                width: 100,
                height: 70,
                color: Colors.white,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(8),
                child: search,
              ),
            ],
          );
        },
      ),
    );
  }
}
