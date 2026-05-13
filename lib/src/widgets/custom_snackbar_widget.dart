import 'package:flutter/material.dart';
import 'package:get/get.dart';

showSnackBar(String title, String subTitle, {Color? color}) {
  Get.snackbar(title, subTitle,
      colorText: Colors.white,
      backgroundColor: color ?? Colors.black);
}
