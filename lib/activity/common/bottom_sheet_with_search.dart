import 'package:db/activity/common/round_small_btn.dart';
import 'package:db/activity/search_screen.dart';
import 'package:db/common/api/models/class_model.dart';
import 'package:db/common/const/color.dart';
import 'package:db/home/splash.dart';
import 'package:flutter/material.dart';

class FloatingSheetWithSearchBar extends StatelessWidget {
  final String title;
  final VoidCallback onDonePressed;
  final Future<bool> Function(String?, SearchController) onChanged;
  final void Function(String, ClassModel) onSelected;
  final List<ClassModel> classModels;
  final Map<int, ClassModel> recomClassModels;
  final FocusNode focusNode = FocusNode();
  final SearchController mainController;
  final ValueChanged<int> onCalcelPressed;

  FloatingSheetWithSearchBar({
    super.key,
    required this.title,
    required this.onDonePressed,
    required this.onChanged,
    required this.onSelected,
    required this.classModels,
    required this.recomClassModels,
    required this.mainController,
    required this.onCalcelPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(60)),
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              height: 5,
              width: 50,
              margin: const EdgeInsets.symmetric(vertical: 15.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.black),
            ),
            Container(
              alignment: Alignment.centerRight,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  RoundedSmallBtn(
                    title: "Done",
                    onPressed: onDonePressed,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SearchAnchor(
                      searchController: mainController,
                      builder:
                          (BuildContext context, SearchController controller) {
                        return SearchBar(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
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
                          onChanged: (val) {
                            onChanged(val, controller);
                            // 예시: 입력 필드에 포커스를 설정
                          },
                          onTap: () {},
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
                      suggestionsBuilder: (context, controller) async {
                        if (await onChanged(
                            controller.value.text, controller)) {
                          return List<ListTile>.generate(
                            recomClassModels.length,
                            (int index) {
                              return ListTile(
                                title: Text(recomClassModels[index]!.className),
                                onTap: () {
                                  controller.closeView(recomClassModels[index]!
                                      .classCode
                                      .toString());

                                  onSelected(controller.value.text,
                                      recomClassModels.values.elementAt(index));
                                  controller.clear();
                                },
                              );
                            },
                          );
                        }
                        return List<Widget>.generate(
                          5,
                          (int index) {
                            return const BottomCircleProgressBar();
                          },
                        );
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ScheduleTable(
                      onCalcelPressed: onCalcelPressed,
                      isForTableSearch: true,
                      sizeOfTuple: classModels.length,
                      classTable: classModels,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
