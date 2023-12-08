import 'package:db/activity/common/round_small_btn.dart';
import 'package:db/activity/search_screen.dart';
import 'package:db/common/api/models/class_model.dart';
import 'package:db/common/const/color.dart';
import 'package:flutter/material.dart';

class FloatingSheetWithSearchBar extends StatefulWidget {
  final String title;
  final VoidCallback onDonePressed;
  final Future<bool> Function(String?, SearchController) onChanged;
  final void Function(String, ClassModel) onSelected;
  final List<ClassModel> classModels;
  final Map<int, ClassModel> recomClassModels;
  final SearchController mainController;
  final ValueChanged<int> onCancelPressed;

  const FloatingSheetWithSearchBar({
    super.key,
    required this.title,
    required this.onDonePressed,
    required this.onChanged,
    required this.onSelected,
    required this.classModels,
    required this.recomClassModels,
    required this.mainController,
    required this.onCancelPressed,
  });

  @override
  State<FloatingSheetWithSearchBar> createState() =>
      _FloatingSheetWithSearchBarState();
}

class _FloatingSheetWithSearchBarState
    extends State<FloatingSheetWithSearchBar> {
  final FocusNode focusNode = FocusNode();

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
                    widget.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  RoundedSmallBtn(
                    title: "Done",
                    onPressed: widget.onDonePressed,
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
                      searchController: widget.mainController,
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
                            widget.onChanged(val, controller);
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
                        if (await widget.onChanged(
                            controller.value.text, controller)) {
                          return List<ListTile>.generate(
                            widget.recomClassModels.length,
                            (int index) {
                              return ListTile(
                                title: Text(
                                    widget.recomClassModels[index]!.className),
                                onTap: () {
                                  controller.closeView(widget
                                      .recomClassModels[index]!.classID
                                      .toString());
                                  widget.onSelected(
                                      controller.value.text,
                                      widget.recomClassModels.values
                                          .elementAt(index));
                                  controller.clear();
                                  setState(() {});
                                },
                              );
                            },
                          );
                        }
                        return List<Widget>.generate(
                          1,
                          (int index) {
                            return const LinearProgressIndicator(
                              color: grey,
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ScheduleTable(
                      onCancelButtonPressed: () => setState(() {}),
                      onCancelPressed: widget.onCancelPressed,
                      isForTableSearch: true,
                      sizeOfTuple: widget.classModels.length,
                      classTable: widget.classModels,
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
