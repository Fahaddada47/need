import 'package:flutter/material.dart';

class NavigationService {
  static void push(BuildContext context, {required Widget page, Route<dynamic>? route}) {
    Navigator.of(context).push(route ?? MaterialPageRoute(builder: (context) => page));
  }

  static void pushReplacement(BuildContext context, {required Widget page, Route<dynamic>? route}) {
    Navigator.of(context).pushReplacement(route ?? MaterialPageRoute(builder: (context) => page));
  }

  static void pushAndRemoveUntil(BuildContext context, {required Widget page, Route<dynamic>? route}) {
    Navigator.of(context).pushAndRemoveUntil(route ?? MaterialPageRoute(builder: (context) => page), (route) => false);
  }

  static void pop(BuildContext context) {
    Navigator.of(context).pop();
  }

  static void popUntil(BuildContext context) {
    Navigator.of(context).popUntil((route) => false);
  }
}
