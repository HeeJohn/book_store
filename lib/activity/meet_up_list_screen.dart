import 'dart:convert';

import 'package:db/common/api/address.dart';
import 'package:db/common/api/models/meeting_model.dart';
import 'package:db/common/api/request.dart';
import 'package:db/common/const/color.dart';
import 'package:db/common/local_storage/const.dart';
import 'package:db/home/splash.dart';
import 'package:flutter/material.dart';

class MeetUpList extends StatefulWidget {
  const MeetUpList({super.key});

  @override
  State<MeetUpList> createState() => _MeetUpListState();
}

class _MeetUpListState extends State<MeetUpList> {
  late final List<String> bbookName, bbookPrice, bbuyer, bseller;
  late final List<String> sbookName, sbookPrice, sbuyer, sseller;
  List<MeetingModel> buyList = [];
  List<MeetingModel> sellList = [];
  int myID = 0;

  Future<bool> getList() async {
    final meetingList = ApiService();
    final sessionID = await storage.read(key: sessionIDLS);
    if (sessionID != null) {
      final response =
          await meetingList.getRequest(sessionID, notBoxURL, {'flag': 1});
      if ('success' == await meetingList.reponseMessageCheck(response)) {
        try {
          myID = await jsonDecode(response!.data)['id'];
          final decodedData = await jsonDecode(response.data)['data'];
          buyList.clear();
          sellList.clear();

          for (int i = 0; i < decodedData.length; i++) {
            if (decodedData[i]['buyer_id'] == myID) {
              buyList.add(MeetingModel.fromJson(decodedData[i]));
            } else {
              sellList.add(MeetingModel.fromJson(decodedData[i]));
            }
          }
          print(buyList);
          print(sellList);
          return true;
        } catch (e) {
          print('Error while processing response data: $e');
        }
      }
    }
    return false;
  }

  void onSellTap(int index) {
    Navigator.of(context).pushNamed(meetUpScreen, arguments: sellList[index]);
  }

  void onBuyTap(int index) {
    Navigator.of(context).pushNamed(meetUpScreen, arguments: buyList[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 10,
          ),
          child: FutureBuilder<bool>(
            future: getList(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const BottomCircleProgressBar();
              }
              if (buyList.isEmpty && sellList.isEmpty) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        '등록된 약속이 없습니다.',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        child: Image.asset(
                          'asset/img/writing.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return Column(
                children: [
                  const Text(
                    '판매 약속 리스트',
                    style: TextStyle(
                      fontSize: 30,
                      fontStyle: FontStyle.italic,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height / 2,
                      child: ListView.separated(
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 10,
                        ),
                        itemCount: sellList.length,
                        itemBuilder: (context, index) {
                          return MeetUp(
                            onTap: () => onSellTap(index),
                            behave: '판매',
                            seller: sellList[index].seller,
                            bookName: sellList[index].bookName,
                            bookPrice: sellList[index].price.toString(),
                            buyer: sellList[index].buyer,
                          );
                        },
                      ),
                    ),
                  ),
                  const Text(
                    '구매 약속 리스트',
                    style: TextStyle(
                      fontSize: 30,
                      fontStyle: FontStyle.italic,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height / 2,
                      child: ListView.separated(
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 10,
                        ),
                        itemCount: buyList.length,
                        itemBuilder: (context, index) {
                          return MeetUp(
                            onTap: () => onBuyTap(index),
                            behave: '구매',
                            seller: buyList[index].seller,
                            bookName: buyList[index].bookName,
                            bookPrice: buyList[index].price.toString(),
                            buyer: buyList[index].buyer,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class MeetUp extends StatelessWidget {
  final String buyer, seller, bookName, bookPrice, behave;
  final VoidCallback onTap;
  const MeetUp({
    super.key,
    required this.bookName,
    required this.bookPrice,
    required this.buyer,
    required this.seller,
    required this.behave,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
          border: Border.all(
            color: grey,
            width: 3,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  const Icon(
                    Icons.person_2,
                  ),
                  Text(
                    seller,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  const Icon(
                    Icons.arrow_forward_sharp,
                  ),
                  Text(
                    behave,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  const Icon(
                    Icons.person_2_outlined,
                  ),
                  Text(
                    seller,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(bookName),
                  Text(bookPrice),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
