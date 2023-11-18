import 'package:db/activity/common/custom_text.dart';
import 'package:db/activity/common/round_small_btn.dart';
import 'package:db/activity/common/state_slider.dart';
import 'package:db/common/const/color.dart';
import 'package:flutter/material.dart';

class FloatingSheet extends StatelessWidget {
  final String title;
  final String? className;
  final VoidCallback onDonePressed;
  final VoidCallback onDatePressed;
  final TextEditingController comController, nameController, priceController;
  final String? publishedDate;
  final ValueChanged refresh;
  final List<int>? bookState;
  final List<ValueChanged>? onSliderChanged;
  final List<String> label;

  const FloatingSheet({
    super.key,
    required this.bookState,
    required this.onSliderChanged,
    required this.onDatePressed,
    required this.className,
    required this.title,
    required this.onDonePressed,
    required this.comController,
    required this.nameController,
    required this.priceController,
    required this.refresh,
    required this.label,
    this.publishedDate,
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
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SearchAnchor(
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
                        onTap: () {
                          controller.openView();
                        },
                        onChanged: (value) {
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
                              controller.closeView(item);
                              refresh(controller.text);
                            },
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  CustomTextField(
                    enabled: false,
                    label: "수업이름",
                    hintText: className ?? '',
                    textinputType: TextInputType.none,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  CustomTextField(
                    label: "책이름",
                    hintText: "항공우주학개론",
                    controller: nameController,
                    textinputType: TextInputType.name,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  CustomTextField(
                    label: "가격",
                    hintText: "50000",
                    controller: priceController,
                    textinputType: TextInputType.number,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  CustomTextField(
                    label: "출판사",
                    hintText: "한서컴퍼니",
                    controller: comController,
                    textinputType: TextInputType.name,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  CustomTextField(
                    enabled: false,
                    label: "출판연도",
                    hintText: publishedDate ?? "",
                    textinputType: TextInputType.none,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                      border: Border.all(
                        color: grey,
                        width: 3,
                      ),
                    ),
                    width: MediaQuery.of(context).size.width,
                    child: IconButton(
                      icon: const Icon(
                        Icons.date_range,
                      ),
                      onPressed: onDatePressed,
                    ),
                  ),
                  ListView.builder(
                    itemCount: label.length,
                    itemBuilder: (context, index) {
                      return StateSlider(
                        value: bookState![index].toDouble(),
                        onSliderChanged: onSliderChanged![index],
                        label: label[index],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
