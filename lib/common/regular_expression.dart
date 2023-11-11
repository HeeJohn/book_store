import 'package:flutter/material.dart';

class RectularExp {
  /* ---------------------- validation for email  ----------------------*/
  static String? validateEmail(FocusNode focusNode, String value) {
    if (value.isEmpty) {
      focusNode.requestFocus();
      return 'Put your Email.';
    } else {
      String pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regExp = RegExp(pattern);

      if (!regExp.hasMatch(value)) {
        focusNode.requestFocus(); // focusing on this.textformfield

        if (value.contains(' ')) {
          return 'Email should not contain spaces';
        } else if (!value.contains('@')) {
          return 'Email should contain @ symbol';
        } else if (value.startsWith('@') || value.endsWith('@')) {
          return 'Invalid position of @ symbol';
        } else if (value.split('@')[1].contains('.') == false) {
          return 'Email should contain at least one dot after @';
        } else {
          return 'Invalid Email format';
        }
      } else {
        return null;
      }
    }
  }

  static String? validateStudentID(FocusNode focusNode, String? value) {
    if (value != null) {
      if (value.isEmpty) {
        focusNode.requestFocus();
        return '학번을 입력하세요';
      } else {
        String patternID = r'^([0-9]{9})$';

        RegExp regExpID = RegExp(patternID);

        if (!regExpID.hasMatch(value)) {
          focusNode.requestFocus();
          return '9자리의 학번을 입력하세요';
        }
      }
    }
    return null;
  }

/* ---------------------- validation for phone Number ---------------------- */
  static String? validatePhoneNumber(FocusNode focusNode, String? value) {
    if (value != null) {
      if (value.isEmpty) {
        focusNode.requestFocus();
        return '전화번호를 입력하세요';
      } else {
        String patternKR = r'^010-?([0-9]{4})-?([0-9]{4})$';

        RegExp regExpKR = RegExp(patternKR);

        if (!regExpKR.hasMatch(value)) {
          focusNode.requestFocus(); // focusing on this textformfield
          return '잘못된 형식의 전화번호';
        }

        if (regExpKR.hasMatch(value)) {
          return validatePhoneNumberKR(value);
        }
      }
    }
    return null;
  }

  static String? validatePhoneNumberKR(String value) {
    String patternKR = r'^010-?([0-9]{4})-?([0-9]{4})$';
    RegExp regExpKR = RegExp(patternKR);

    if (!regExpKR.hasMatch(value)) {
      return '010으로 시작하는 8자리 번호를 입력하세요.';
    }
    return null;
  }

/* ---------------------- validation for password ---------------------- */
  static String? validatePassword(FocusNode focusNode, String? value) {
    if (value != null) {
      if (value.isEmpty) {
        focusNode.requestFocus();
        return '비밀번호를 입력하세요.';
      } else {
        // Check length
        if (value.length < 8 || value.length > 15) {
          focusNode.requestFocus();
          return '8-15자리의 비밀번호를 생성하세요.';
        }

        // Check for special characters
        if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(value)) {
          focusNode.requestFocus();
          return '특수문자 하나 이상이 필요합니다.';
        }

        // Check for lowercase letters
        if (!RegExp(r'[a-z]').hasMatch(value)) {
          focusNode.requestFocus();
          return '소문자 하나 이상이 필요합니다.';
        }

        // Check for numbers
        if (!RegExp(r'[0-9]').hasMatch(value)) {
          focusNode.requestFocus();
          return '숫자 하나 이상이 필요합니다.';
        }
      }
    }
    return null;
  }

/* ---------------------- validation for name or username ----------------------*/
  static String? validateName(FocusNode focusNode, String value) {
    if (value.isEmpty) {
      focusNode.requestFocus();
      return 'Put your name';
    }

    // Check length
    if (value.length < 4 || value.length > 20) {
      focusNode.requestFocus();
      return 'must be between 4 and 20 characters';
    }

    // Check first letter
    if (!RegExp(r'[A-Za-z]').hasMatch(value[0])) {
      focusNode.requestFocus();
      return 'Name must start with a letter';
    }

    // Check for allowed characters (letters and digits)
    if (!RegExp(r'^[A-Za-z\d]+$').hasMatch(value)) {
      focusNode.requestFocus();
      return 'Name can only contain letters and digits';
    }

    return null; // Name is valid
  }

/* ---------------------- validation for age ---------------------- */
  static String? validateAge(FocusNode focusNode, String value) {
    if (value.isEmpty) {
      focusNode.requestFocus();
      return 'Put your age';
    } else {
      String pattern = r'^[0-9]{1,3}$';
      RegExp regExp = RegExp(pattern);

      if (!regExp.hasMatch(value)) {
        focusNode.requestFocus();
        return 'Age must be between 1 and 3 digits';
      }

      int? age = int.tryParse(value);

      if (age == null || age < 16 || age > 100) {
        focusNode.requestFocus();
        return 'Age must be between 16 and 100';
      }

      return null;
    }
  }
}
