import 'package:db/activity/common/map_screen.dart';
import 'package:db/common/api/models/meeting_model.dart';
import 'package:db/common/const/color.dart';
import 'package:db/home/common/layout.dart';
import 'package:flutter/material.dart';

class MeetUpScreen extends StatefulWidget {
  const MeetUpScreen({super.key});

  @override
  State<MeetUpScreen> createState() => _MeetUpScreenState();
}

class _MeetUpScreenState extends State<MeetUpScreen> {
  late MeetingModel appointMent;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    appointMent = ModalRoute.of(context)!.settings.arguments as MeetingModel;
    return MainLayout(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: Image.asset(
                'asset/img/map.gif',
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(
              width: 100,
            ),
            SizedBox(
              width: 100,
              height: 100,
              child: Image.asset(
                'asset/img/shake.gif',
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                const Text(
                  '구매자',
                  style: TextStyle(
                    color: Colors.black,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600,
                    fontSize: 50,
                  ),
                ),
                const SizedBox(
                  width: 100,
                  height: 100,
                  child: Icon(
                    Icons.person_2_outlined,
                    size: 100,
                  ),
                ),
                Text(
                  appointMent.buyer,
                  style: const TextStyle(
                    color: Colors.black,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600,
                    fontSize: 30,
                  ),
                ),
                Text(
                  appointMent.buyerPhone,
                  style: const TextStyle(
                    color: Colors.black,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            Container(
              width: 5,
              height: 150,
              color: Colors.black,
            ),
            Column(
              children: [
                const Text(
                  '판매자',
                  style: TextStyle(
                    color: Colors.black,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600,
                    fontSize: 50,
                  ),
                ),
                const SizedBox(
                  width: 100,
                  height: 100,
                  child: Icon(
                    Icons.person_2,
                    size: 100,
                  ),
                ),
                Text(
                  appointMent.seller,
                  style: const TextStyle(
                    color: Colors.black,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600,
                    fontSize: 30,
                  ),
                ),
                Text(
                  appointMent.sellerPhone,
                  style: const TextStyle(
                    color: Colors.black,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
              ],
            )
          ],
        ),
        SizedBox(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 1 / 4,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                    border: Border.all(
                      color: Colors.black, // 테두리 색상을 검은색으로 변경
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        '책이름 :  ${appointMent.bookName}',
                        style: const TextStyle(
                            fontSize: 20, fontStyle: FontStyle.italic),
                      ),
                      Text(
                        '저자 : ${appointMent.author}',
                        style: const TextStyle(
                            fontSize: 20, fontStyle: FontStyle.italic),
                      ),
                      Text(
                        '출판연도 :  ${appointMent.publishedYear}',
                        style: const TextStyle(
                            fontSize: 20, fontStyle: FontStyle.italic),
                      ),
                      Text(
                        '수업 :  ${appointMent.className} ',
                        style: const TextStyle(
                            fontSize: 20, fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: grey,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 1 / 3,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                            border: Border.all(
                              color: Colors.black, // 테두리 색상을 검은색으로 변경
                            ),
                          ),
                          child: MapScreen(
                            appointment: appointMent,
                          ),
                        );
                      },
                    );
                  },
                  child: const Text(
                    '약속장소 및 시간 선택',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
