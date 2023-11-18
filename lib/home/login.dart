import 'dart:convert';
import 'package:db/common/api/address.dart';
import 'package:db/common/api/request.dart';
import 'package:db/common/custom_textform.dart';
import 'package:db/home/common/layout.dart';
import 'package:db/home/splash.dart';
import 'package:flutter/material.dart';
import 'package:db/common/regular_expression.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final _phoneNumFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final GlobalKey<FormState> _formKeyPassword = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyId = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();

  String? errorText;
  String id = '';
  String password = '';
  bool hasError = false;

  @override
  void dispose() {
    _scrollController.dispose();
    _phoneNumFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    bool isOnKeyBoard = MediaQuery.of(context).viewInsets.bottom != 0;
    return MainLayout(
      children: [
        const SizedBox(
          height: 50,
        ),
        const Text(
          'Login',
          style: TextStyle(
            fontSize: 70,
            fontWeight: FontWeight.w600,
            fontStyle: FontStyle.italic,
          ),
        ),
        Expanded(
          child: Image.asset(
            'asset/img/eye_book.gif',
            fit: BoxFit.contain,
            width: MediaQuery.of(context).size.width * 1 / 2,
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            child: _MiddleTextField(
              phoneNumberFocus: _phoneNumFocusNode,
              passwordFocus: _passwordFocusNode,
              phoneNumberValidator: (value) =>
                  RectularExp.validatePhoneNumber(_phoneNumFocusNode, value),
              passwordValidator: (value) =>
                  RectularExp.validatePassword(_passwordFocusNode, value),
              idKey: _formKeyId,
              passwordKey: _formKeyPassword,
              hasError: hasError,
              onIdChanged: onIdChanged,
              errorText: errorText,
              onPasswordChanged: onPasswordChanged,
            ),
          ),
        ),
        SizedBox(
          height: isOnKeyBoard ? 0.0 : 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _BottomSignUp(onSignUpPressed: () => nextPage(signUpScreen)),
            _BottomLogin(
              onLoginPressed: validInputCheck,
            ),
          ],
        ),
        SizedBox(
          height: isOnKeyBoard ? 10.0 : 50,
        ),
      ],
    );
  }

  Future<String?> login(String authInfo) async {
    final login = ApiService();
    nextPage(bottomBar);
    return null;
    final response = await login.getRequest(
      authInfo,
      splashURL,
    );
    final message = await login.reponseMessageCheck(response);
    if ('success' == message) {
      saveUserInfo(jsonDecode(response!.data)['loggedUser']);
      nextPage(searchScreen);
      return null;
    } else {
      return message;
    }
  }

  void nextPage(String page) {
    Navigator.pushNamed(
      context,
      page,
    );
  }

  // Validate input and proceed with login.
  void validInputCheck() {
    if (_formKeyId.currentState!.validate() &&
        _formKeyPassword.currentState!.validate()) {
      login('$id:$password');
    } else {
      setState(() {});
    }
  }

  void onIdChanged(String value) {
    setState(() {
      if (_formKeyId.currentState!.validate()) {
        hasError = false;
        errorText = null;
      } else {
        hasError = true;
      }

      id = value;
    });
  }

  void onPasswordChanged(String value) {
    setState(() {
      if (_formKeyPassword.currentState!.validate()) {
        hasError = false;
        errorText = null;
      } else {
        hasError = true;
      }

      password = value;
    });
  }

  void scrollToTop() {
    _scrollController.animateTo(0.0,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  void scrollToBottom() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }
}

class _MiddleTextField extends StatelessWidget {
  final ValueChanged<String> onIdChanged;
  final String? errorText;
  final ValueChanged<String> onPasswordChanged;
  final FocusNode phoneNumberFocus;
  final FocusNode passwordFocus;
  final bool hasError;
  final GlobalKey idKey;
  final GlobalKey passwordKey;
  final String? Function(String?)? passwordValidator;
  final String? Function(String?)? phoneNumberValidator;
  const _MiddleTextField({
    required this.phoneNumberValidator,
    required this.passwordValidator,
    required this.idKey,
    required this.phoneNumberFocus,
    required this.passwordFocus,
    required this.passwordKey,
    required this.hasError,
    required this.errorText,
    required this.onPasswordChanged,
    required this.onIdChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Form(
          key: idKey,
          child: CustomTextFormField(
            hasError: hasError,
            errorText: errorText,
            keyboardType: TextInputType.number,
            onChanged: onIdChanged,
            hintText: 'ex) 010xxxxxxxx',
            autofocus: true,
            focusNode: phoneNumberFocus,
            validator: phoneNumberValidator,
            prefixIcon: Icon(
              hasError ? Icons.person_2_outlined : Icons.person_2,
            ),
          ),
        ),
        SizedBox(
          height: hasError ? 0 : 30.0,
        ),
        Form(
          key: passwordKey,
          child: CustomTextFormField(
            hasError: hasError,
            errorText: errorText,
            onChanged: onPasswordChanged,
            hintText: 'Password', // Placeholder text for password input.
            obscureText: true,
            focusNode: passwordFocus,
            validator: passwordValidator,
            prefixIcon: Icon(
              hasError ? Icons.lock : Icons.key,
            ),
          ),
        )
      ],
    );
  }
}

class _BottomSignUp extends StatelessWidget {
  final VoidCallback onSignUpPressed;
  const _BottomSignUp({required this.onSignUpPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        minimumSize: Size(
          MediaQuery.of(context).size.width * 1 / 4,
          MediaQuery.of(context).size.height * 1 / 15,
        ),
        backgroundColor: const Color.fromARGB(255, 176, 176, 176),
        foregroundColor: Colors.black,
        textStyle: const TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 20,
        ),
      ),
      onPressed: onSignUpPressed,
      child: const Text('Sign Up'),
    );
  }
}

class _BottomLogin extends StatelessWidget {
  final VoidCallback onLoginPressed;

  const _BottomLogin({required this.onLoginPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        minimumSize: Size(
          MediaQuery.of(context).size.width * 1 / 4,
          MediaQuery.of(context).size.height * 1 / 15,
        ),
        backgroundColor: const Color.fromARGB(255, 176, 176, 176),
        foregroundColor: Colors.black,
        textStyle: const TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 20,
        ),
      ),
      onPressed: onLoginPressed,
      child: const Text('Log In'),
    );
  }
}
