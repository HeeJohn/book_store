import 'package:db/common/api/address.dart';
import 'package:db/common/custom_textform.dart';
import 'package:db/common/local_storage/const.dart';
import 'package:db/common/widget/next_button.dart';
import 'package:db/home/common/layout.dart';
import 'package:flutter/material.dart';
import 'package:db/common/regular_expression.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final focusNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool hasError = false;
  int index = 0;
  dynamic input;
  late final Map<String, List<dynamic>> signUpList;
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    /* 0: 전화번호, 1: 이름, 2: 학번, 3: 비밀번호 */
    signUpList = {
      'hintText': [
        '전화번호 ex) 010-xxxx-xxxx',
        '이름 ex) 서희준',
        '학번 ex) 201901366',
        '비밀번호 ex) qweasd123!',
      ],
      'errorText': [
        '잘못된 형식의 전화번호',
        '잘못된 이름',
        '잘못된 학번',
        '잘못된 비밀번호',
      ],
      'keyboardType': [
        TextInputType.phone,
        TextInputType.name,
        TextInputType.phone,
        TextInputType.emailAddress,
      ],
      'obscureText': [
        false,
        false,
        false,
        true,
      ],
      'prefixIcon': [
        const Icon(
          Icons.phone,
        ),
        const Icon(
          Icons.person_3,
        ),
        const Icon(
          Icons.numbers,
        ),
        const Icon(
          Icons.password,
        ),
      ],
      'validator': [
        validatorPhone,
        validatorName,
        validatorStudentID,
        validatorPW,
      ],
      'storage': [
        phoneNumberLS,
        nameLS,
        studentIDLS,
        passwordLS,
      ],
    };
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  String? validatorPhone(value) {
    return RectularExp.validatePhoneNumber(focusNode, value);
  }

  String? validatorName(value) {
    return RectularExp.validateName(focusNode, value);
  }

  String? validatorStudentID(value) {
    return RectularExp.validateStudentID(focusNode, value);
  }

  String? validatorPW(value) {
    return RectularExp.validatePassword(focusNode, value);
  }

  void onChanged(String? val) {
    if (_formKey.currentState!.validate()) {
      hasError = false;
    } else {
      hasError = true;
    }
  }

  // Check if the form input is valid and proceed accordingly.
  void validInputCheck() async {
    if (_formKey.currentState!.validate()) {
      await storage.write(
          key: signUpList['storage']![index],
          value: textController.value.text.toString());
      textController.clear();
      if (index == 3) {
        nextPage();
      }
      index = (index + 1) % 4;
    }
    setState(() {});
  }

  void nextPage() {
    Navigator.pushNamedAndRemoveUntil(context, loginScreen, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    bool isOnKeyBoard = MediaQuery.of(context).viewInsets.bottom != 0;
    return MainLayout(
      children: [
        const Text(
          'Sign Up',
          style: TextStyle(
            fontSize: 70,
            fontWeight: FontWeight.w600,
            fontStyle: FontStyle.italic,
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 180,
          child: BookAnimation(
            index: index,
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Form(
              key: _formKey,
              child: CustomTextFormField(
                textEditingController: textController,
                hasError: hasError,
                onChanged: onChanged,
                obscureText: signUpList['obscureText']![index],
                autofocus: true,
                hintText: signUpList['hintText']![index].toString(),
                errorText: hasError
                    ? signUpList['errorText']![index].toString()
                    : null,
                validator: signUpList['validator']![index],
                focusNode: focusNode,
                keyboardType:
                    signUpList['keyboardType']![index] as TextInputType,
                prefixIcon: signUpList['prefixIcon']![index] as Icon,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            NextButton(
              buttonText: 'NEXT',
              onPressed: validInputCheck,
            ),
            SizedBox(
              height: isOnKeyBoard ? 0 : 200,
            ),
          ],
        ),
      ],
    );
  }
}

class BookAnimation extends StatelessWidget {
  final int index;

  const BookAnimation({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: <Widget>[
        Book(
          stackCount: -1,
          selected: index,
          book: 'asset/img/book_1.png',
          width: 50,
          height: 150,
          loc: 10,
        ),
        Book(
          stackCount: 0,
          selected: index,
          book: 'asset/img/book_2.png',
          width: 50,
          height: 140,
          loc: 50,
        ),
        Book(
          stackCount: 1,
          selected: index,
          book: 'asset/img/book_3.png',
          width: 50,
          height: 115,
          loc: 88,
        ),
        Book(
          stackCount: 2,
          selected: index,
          book: 'asset/img/book_4.png',
          width: 65,
          height: 100,
          loc: 130,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Image.asset(
                      'asset/img/book_board.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SizedBox(
                child: Image.asset(
                  'asset/img/book_writing.gif',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class Book extends StatelessWidget {
  final String book;
  final double height;
  final double width;
  final int selected;
  final int stackCount;
  final double loc;
  const Book({
    super.key,
    required this.selected,
    required this.book,
    required this.height,
    required this.width,
    required this.stackCount,
    required this.loc,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      width: width,
      height: height,
      left: selected > stackCount
          ? loc
          : MediaQuery.of(context).size.width * 3 / 5,
      bottom: 20,
      duration: const Duration(seconds: 2),
      curve: Curves.fastOutSlowIn,
      child: SizedBox(
        child: Image.asset(
          book,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
