import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resize/resize.dart';
import '../models/all_top_rated_teachers_model.dart';

class AllTopRatedTeachersController extends GetxController {
  GetAllTopRatedTeachersModel getAllTopRatedTeachersModel =
      GetAllTopRatedTeachersModel();

  bool topRatedTeachersLoader = false;
  updateTopRatedTeachersLoader(bool newValue) {
    topRatedTeachersLoader = newValue;
    update();
  }

  int? selectedTeacherCategoryIndex = 0;
  updateSelectedTeacherCategoryIndex(int? newValue) {
    selectedTeacherCategoryIndex = newValue;
    update();
  }

  ///----app-bar-settings-----start
  ScrollController? scrollController;
  bool lastStatus = true;
  double height = 100.h;

  bool get isShrink {
    return scrollController!.hasClients &&
        scrollController!.offset > (height - kToolbarHeight);
  }

  void scrollListener() {
    if (isShrink != lastStatus) {
      lastStatus = isShrink;
      update();
    }
  }
}
