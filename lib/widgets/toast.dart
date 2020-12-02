import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_manager/styles/colors.dart';

Future<bool> showToastFunction(String message) {
  return Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
    timeInSecForIosWeb: 2,
    backgroundColor: AppColors.lightblue,
    textColor: Colors.white,
    fontSize: 16.0
  );
}