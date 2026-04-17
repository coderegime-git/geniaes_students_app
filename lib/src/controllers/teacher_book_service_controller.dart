import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TeacherBookServiceController extends GetxController {
  TextEditingController serviceQuestionFieldController =
      TextEditingController();

  bool getTeacherBookServiceLoader = false;
  updateTeacherBookServiceLoader(bool newValue) {
    getTeacherBookServiceLoader = newValue;
    update();
  }
}
