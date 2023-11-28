import 'package:db/activity/common/bottom_bar.dart';
import 'package:db/activity/meet_up_list_screen.dart';
import 'package:db/activity/meet_up_screen.dart';
import 'package:db/activity/register_screen.dart';
import 'package:db/activity/search_screen.dart';
import 'package:db/common/api/address.dart';
import 'package:db/common/hive/user.dart';
import 'package:db/home/login.dart';
import 'package:db/home/sign.dart';
import 'package:db/home/splash.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(UserDataAdapter());
  await Hive.openBox<UserData>('loggedUser');

  runApp(const BookStore());
}

class BookStore extends StatelessWidget {
  const BookStore({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hanseo Book Store',
      debugShowCheckedModeBanner: false,
      initialRoute: splashScreen,
      routes: {
        splashScreen: (context) => const SplashScreen(),
        loginScreen: (context) => const LogInScreen(),
        signUpScreen: (context) => const SignUpScreen(),
        searchScreen: (context) => const SearchScreen(),
        bottomBar: (context) => const BottomBar(),
        registerScreen: (context) => const RegisterScreen(),
        meetUpScreen: (context) => const MeetUpScreen(),
        meetUpListScreen: (context) => const MeetUpList(),
      },
    );
  }
}
