import 'package:db/activity/common/map_screen.dart';
import 'package:db/home/common/layout.dart';
import 'package:flutter/material.dart';

class MeetUpScreen extends StatelessWidget {
  const MeetUpScreen({super.key});
  final String? seller = '서희준';
  final String? buyer = '백효영';
  final String? buyerPhone = '010-1234-5678';
  final String? sellerPhone = '010-0987-6543';
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
                    height: MediaQuery.of(context).size.height * 1 / 5,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                      border: Border.all(
                        color: Colors.black, // 테두리 색상을 검은색으로 변경
                      ),
                    ),
                    child: const Text('hi'),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 1 / 2,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                      border: Border.all(
                        color: Colors.black, // 테두리 색상을 검은색으로 변경
                      ),
                    ),
                    child: const MapScreen(),
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
