import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resize/resize.dart';
import '../models/teacher_main_categories_model.dart';

class TeacherMainCategoriesController extends GetxController {
  GetTeacherMainCategoriesModel getTeacherMainCategoriesModel =
      GetTeacherMainCategoriesModel();
  Categories categoriesModel = Categories();
  // GetAllTeacherCategoriesDataModel getAllTeacherCategoriesDataModel =
  //     GetAllTeacherCategoriesDataModel();

  bool teacherMainCategoriesLoader = false;
  updateteacherMainCategoriesLoader(bool newValue) {
    teacherMainCategoriesLoader = newValue;
    update();
  }

  // String? selectedBlogCategory;
  // BlogModel selectedBlogForView = BlogModel();
  // updateSelectedBlogForView(BlogModel newValue, String? newSelectedBlogCategory) {
  //   selectedBlogForView = newValue;
  //   selectedBlogCategory = newSelectedBlogCategory;
  //   update();
  // }

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
