import 'dart:convert';

import 'package:db/activity/common/notification.dart';
import 'package:db/common/api/address.dart';
import 'package:db/common/api/request.dart';
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
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      children: [
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

              return ListView.builder(
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
