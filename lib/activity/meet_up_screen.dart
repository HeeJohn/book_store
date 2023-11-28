import 'package:db/activity/common/map_screen.dart';
import 'package:db/common/const/color.dart';
import 'package:db/home/common/layout.dart';
import 'package:flutter/material.dart';

class MeetUpScreen extends StatelessWidget {
  const MeetUpScreen({super.key});
  final String? seller = '서희준';
  final String? buyer = '백효영';
  final String? buyerPhone = '010-1234-5678';
  final String? sellerPhone = '010-0987-6543';
  final String book =
      'https://www.google.com/url?sa=i&url=https%3A%2F%2Fykbook.com%2Fshop%2Fitem.php%3Fit_id%3D9999040951&psig=AOvVaw3h1Auu7obdg0FFmh0itXsU&ust=1700409333991000&source=images&cd=vfe&opi=89978449&ved=0CBEQjRxqFwoTCOCp28T0zYIDFQAAAAAdAAAAABAE';
  @override
  Widget build(BuildContext context) {
    return MainLayout(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: SizedBox(
                width: 100,
                height: 100,
                child: Image.asset(
                  'asset/img/map.gif',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(
              width: 100,
            ),
            Expanded(
              child: SizedBox(
                width: 100,
                height: 100,
                child: Image.asset(
                  'asset/img/shake.gif',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: Row(
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
                    buyer!,
                    style: const TextStyle(
                      color: Colors.black,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w600,
                      fontSize: 30,
                    ),
                  ),
                  Text(
                    buyerPhone!,
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
                    seller!,
                    style: const TextStyle(
                      color: Colors.black,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w600,
                      fontSize: 30,
                    ),
                  ),
                  Text(
                    sellerPhone!,
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
        ),
        Expanded(
          child: SizedBox(
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
                      child: const Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text('책이름 : 항공우주학개론'),
                                Text('저자 :홍길동'),
                                Text('출판연도 : 2008'),
                                Text('수업 : 항공우주학개론1 '),
                              ],
                            ),
                          )
                        ],
                      )),
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
                            child: const MapScreen(),
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
        ),
      ],
    );
  }
}
