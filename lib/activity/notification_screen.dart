import 'dart:convert';
import 'package:db/common/api/address.dart';
import 'package:db/common/api/models/meeting_model.dart';
import 'package:db/common/api/request.dart';
import 'package:db/common/const/color.dart';
import 'package:db/common/local_storage/const.dart';
import 'package:db/home/common/layout.dart';
import 'package:db/home/common/top_image.dart';
import 'package:db/home/splash.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<MeetingModel> meetingList = [];

  void onRejectPressed(MeetingModel meetingModel) async {
    ApiService toMeeUpList = ApiService();
    final sessionID = await storage.read(key: sessionIDLS);
    if (sessionID != null) {
      final response = await toMeeUpList.getRequest(sessionID, notBoxURL, {});
      if ('success' == await toMeeUpList.reponseMessageCheck(response)) {
        final data = jsonDecode(response!.data)['data'];
      }
    }
  }

  void onAcceptPressed(MeetingModel meetingModel) async {
    ApiService delNotBox = ApiService();
    final sessionID = await storage.read(key: sessionIDLS);
    if (sessionID != null) {
      final response = await delNotBox.postRequest(
        sessionID,
        notBoxURL,
        {'book_id': meetingModel.bookID},
      );
      if ('success' == await delNotBox.reponseMessageCheck(response)) {
        setState(() {});
      }
    }
  }

  Future<List<Notify>?> getNotiList() async {
    ApiService notification = ApiService();
    final sessionID = await storage.read(key: sessionIDLS);
    if (sessionID != null) {
      final response = await notification.getRequest(sessionID, notBoxURL, {});
      if ('success' == await notification.reponseMessageCheck(response)) {
        final data = jsonDecode(response!.data)['data'];
        print(data.length);
        meetingList.clear();
        for (int i = 0; i < data.length; i++) {
          print(data[i]);
          meetingList.add(MeetingModel.fromJson(data[i]));
        }
        print(meetingList.length);
        return meetingList
            .map((e) => Notify(
                  buyer: e.buyer,
                  bookName: e.bookName,
                  onAcceptPressed: () => onAcceptPressed(e),
                  onRejectPressed: () => onRejectPressed(e),
                  bookPrice: e.price.toString(),
                ))
            .toList();
      }
    }
    return null;
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

              if (snapshot.data!.isEmpty) {
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
  final VoidCallback onAcceptPressed;
  final VoidCallback onRejectPressed;

  const Notify({
    super.key,
    required this.buyer,
    required this.bookName,
    required this.onRejectPressed,
    required this.onAcceptPressed,
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
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            children: [
              const Icon(
                Icons.person_2,
              ),
              Text(
                buyer,
              ),
            ],
          ),
          const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.attach_money,
              ),
              Text(
                '구매요청',
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: onAcceptPressed,
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
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: onRejectPressed,
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
            ],
          ),
          Column(
            children: [
              Text(
                bookName,
              ),
              Text(bookPrice),
            ],
          ),
        ],
      ),
    );
  }
}
