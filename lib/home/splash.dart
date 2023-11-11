import 'dart:async';
import 'package:db/activity/bottom_bar.dart';
import 'package:db/common/api/address.dart';
import 'package:db/common/api/token_request.dart';
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
  void initState() {
    super.initState();
    getToken();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
        future: getToken(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              throw Exception("Error, Splash Screen : no data received ");
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

  /*========================== method ==========================*/
  Future<String?> getToken() async {
    final accessToken = await storage.read(key: accessTokenKeyLS);
    if (accessToken != null) {
      //  return login(accessToken);
    } else {
      //   nextPage(homeScreen);
    }
    scheduleTimeout(5 * 1000); // 5 seconds.
    return null;
  }

  // Go to the next page
  void nextPage(String page) {
    Navigator.pushNamed(context, page);
  }

  Timer scheduleTimeout([int milliseconds = 10000]) =>
      Timer(Duration(milliseconds: milliseconds), handleTimeout);

  void handleTimeout() {
    nextPage(loginScreen);
  }

  Future<String?> login(String accessToken) async {
    final login = ApiService();

    final response = await login.splahsWithToken(
      accessToken,
      splashURL,
    );
    final message = await login.tokenReponseCheck(response);
    return message;
  }
}

class BottomCircleProgressBar extends StatelessWidget {
  const BottomCircleProgressBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
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
