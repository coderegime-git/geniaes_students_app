import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resize/resize.dart';
import '../models/all_featured_teachers_model.dart';

class AllFeaturedTeachersController extends GetxController {
  GetAllFeaturedTeachersModel getAllFeaturedTeachersModel =
      GetAllFeaturedTeachersModel();

  bool featuredTeachersLoader = false;
  updatefeaturedTeachersLoader(bool newValue) {
    featuredTeachersLoader = newValue;
    update();
  }

  // TeacherModel selectedTeacherForView = TeacherModel();
  // updateSelectedTeacherForView(
  //   TeacherModel newValue,
  // ) {
  //   selectedTeacherForView = newValue;
  //   update();
  // }

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
