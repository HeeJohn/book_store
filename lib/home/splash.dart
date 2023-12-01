import 'dart:async';
import 'dart:convert';
import 'package:db/activity/common/bottom_bar.dart';
import 'package:db/common/api/address.dart';
import 'package:db/common/api/models/user_model.dart';
import 'package:db/common/api/request.dart';
import 'package:db/common/hive/boxes.dart';
import 'package:db/common/hive/user.dart';
import 'package:db/common/local_storage/const.dart';
import 'package:db/home/common/layout.dart';
import 'package:db/home/common/top_image.dart';
import 'package:db/home/login.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: checkLoginInfo(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data == null) {
              throw Exception(snapshot.data);
            } else if (snapshot.data == "success") {
              return const BottomBar();
            } else {
              return const LogInScreen();
            }
          }

          return const MainLayout(
            children: [
              Expanded(child: TopImage()),
              Expanded(child: SingleChildScrollView(child: _MiddleText())),
              Expanded(child: BottomCircleProgressBar()),
            ],
          );
        });
  }

  void nextPage(String page) {
    Navigator.pushNamed(context, page);
  }

  Future<String> checkLoginInfo() async {
    final phoneNum = await storage.read(key: phoneNumberLS);
    final password = await storage.read(key: passwordLS);

    // if (phoneNum != null && password != null) {
    //   return await login('$phoneNum:$password');
    // }

    return 'false';
  }

  Future<String> login(String authInfo) async {
    final login = ApiService();

    final response = await login.getRequest(authInfo, splashURL, null);
    if (response != null) {
      saveUserInfo(jsonDecode(response.data)['loggedUser']);
    }
    return await login.reponseMessageCheck(response);
  }
}

void saveUserInfo(dynamic data) async {
  print(data);
  StudentModel student = StudentModel.fromJson(data);
  UserData loggedUser = UserData(
    studentID: student.studentID,
    studentName: student.studentName,
    studentPhoneNum: student.studentPhoneNum,
  );

  final box1 = Boxes.getUserData();
  final isUserPreviouslyCached = box1.get(student.sessionID);
  isUserPreviouslyCached ?? box1.put(student.sessionID, loggedUser);
}

class BottomCircleProgressBar extends StatelessWidget {
  const BottomCircleProgressBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 1 / 3,
          child: Image.asset(
            'asset/img/progress.gif',
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }
}

class _MiddleText extends StatelessWidget {
  const _MiddleText();

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Welcome to',
          style: TextStyle(color: Colors.black, fontSize: 50),
        ),
        Text(
          'Hanseo =)',
          style: TextStyle(color: Colors.black, fontSize: 50),
        ),
        Text(
          'Book Store',
          style: TextStyle(color: Colors.black, fontSize: 50),
        ),
      ],
    );
  }
}
