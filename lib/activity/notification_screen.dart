import 'dart:convert';
import 'package:db/common/api/address.dart';
import 'package:db/common/api/request.dart';
import 'package:db/common/const/color.dart';
import 'package:db/common/local_storage/const.dart';
import 'package:db/home/common/layout.dart';
import 'package:db/home/common/top_image.dart';
import 'package:db/home/splash.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  Future<List<Notify>?> getNotiList() async {
    ApiService notification = ApiService();
    final sessionID = await storage.read(key: sessionIDLS);
    if (sessionID != null) {
      final response = await notification.getRequest(sessionID, notifyURL);
      if ('success' == await notification.reponseMessageCheck(response)) {
        final List<Map<String, String>> data =
            jsonDecode(response!.data['data']);
        return null;
      }
    }
    return [
      Notify(
        buyer: "서희준",
        bookName: "항공우주학개론",
        onPressed: () {},
        bookPrice: "50000",
      ),
      Notify(
        buyer: "서희준",
        bookName: "항공우주학개론",
        onPressed: () {},
        bookPrice: "50000",
      ),
      Notify(
        buyer: "서희준",
        bookName: "항공우주학개론",
        onPressed: () {},
        bookPrice: "50000",
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      children: [
        const SizedBox(
          height: 20,
        ),
        const Text(
          '구매요청 리스트',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
        ),
        Expanded(
          child: FutureBuilder<List<Notify>?>(
            future: getNotiList(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Expanded(child: BottomCircleProgressBar());
              }

              if (snapshot.data == null) {
                return const Center(
                  child: TopImage(),
                );
              }

              return ListView.separated(
                separatorBuilder: (context, index) => const SizedBox(
                  height: 20,
                ),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  return snapshot.data![index];
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class Notify extends StatelessWidget {
  final String buyer;
  final String bookName;
  final String bookPrice;
  final VoidCallback onPressed;

  const Notify({
    super.key,
    required this.buyer,
    required this.bookName,
    required this.onPressed,
    required this.bookPrice,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
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
                  buyer,
                ),
              ],
            ),
          ),
          const Expanded(
            child: Column(
              children: [
                Icon(
                  Icons.attach_money,
                ),
                Text(
                  '구매요청',
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: onPressed,
                        icon: const Icon(
                          Icons.check_circle_outline,
                          color: Colors.blue,
                        ),
                      ),
                      const Text(
                        '수락',
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: onPressed,
                        icon: const Icon(
                          Icons.check_circle,
                          color: Colors.red,
                        ),
                      ),
                      const Text(
                        '거절',
                      ),
                    ],
                  ),
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
    );
  }
}
