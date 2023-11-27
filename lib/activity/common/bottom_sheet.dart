import 'dart:io';

import 'package:db/activity/common/custom_text.dart';
import 'package:db/activity/common/round_small_btn.dart';
import 'package:db/activity/common/state_slider.dart';
import 'package:db/common/api/models/class_model.dart';
import 'package:db/common/const/color.dart';
import 'package:db/home/splash.dart';
import 'package:flutter/material.dart';

class FloatingSheet extends StatelessWidget {
  final String title;
  final String? className;
  final Future<bool> Function(String?, SearchController) onChanged;
  final Map<int, ClassModel> recomClassModels;
  final VoidCallback onDonePressed;
  final VoidCallback onDatePressed;
  final TextEditingController comController, nameController, priceController;
  final String? publishedDate;
  final List<int> bookState;
  final List<ValueChanged?> onSliderChanged;
  final List<String> label;
  final ValueChanged<String> onTap;
  final int sum;
  final Future<void> Function() tapOnBookPhoto;
  final File? bookImage;

  const FloatingSheet({
    super.key,
    required this.onTap,
    required this.onChanged,
    required this.bookState,
    required this.onSliderChanged,
    required this.onDatePressed,
    required this.className,
    required this.title,
    required this.onDonePressed,
    required this.comController,
    required this.nameController,
    required this.priceController,
    required this.label,
    required this.sum,
    required this.bookImage,
    required this.tapOnBookPhoto,
    required this.recomClassModels,
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
        height: MediaQuery.of(context).size.height * 4 / 5,
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
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => tapOnBookPhoto,
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2,
                        height: MediaQuery.of(context).size.height / 3,
                        alignment: Alignment.bottomCenter,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(
                            color: grey,
                            width: 2,
                          ),
                          image: bookImage == null
                              ? null
                              : DecorationImage(
                                  image: FileImage(bookImage!),
                                  fit: BoxFit.cover,
                                ),
                        ),
                        //Adds black gradient from bottom to top to image
                        child: Container(
                          width: double.infinity,
                          alignment: Alignment.bottomCenter,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.0),
                                Colors.black.withOpacity(0.1),
                                Colors.black.withOpacity(0.2),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
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
                          onTap: () {},
                          onChanged: (value) {
                            onChanged(value, controller);
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
                                      .className
                                      .toString());
                                  onTap(controller.value.text);
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
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      height: 100,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: label.length,
                        itemBuilder: (context, index) {
                          return StateSlider(
                            value: bookState[index].toDouble(),
                            onSliderChanged: onSliderChanged[index],
                            label: label[index],
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      '책상태 평균점수: $sum',
                      style: const TextStyle(
                        color: grey,
                        fontWeight: FontWeight.w500,
                        fontSize: 30,
                        fontStyle: FontStyle.italic,
                      ),
                    )
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
