import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resize/resize.dart';
import '../api_services/post_service.dart';
import '../models/all_teachers_model.dart';
import '../repositories/teachers_by_category_repo.dart';
import 'general_controller.dart';

class TeachersByCategoryController extends GetxController {
  GetAllTeachersModel getAllTeachersModel = GetAllTeachersModel();

  bool teacherByCategoryLoader = false;
  updateTeachersByCategoryLoader(bool newValue) {
    teacherByCategoryLoader = newValue;
    update();
  }

  String? selectedTeacherCategory;
  // TeacherModel selectedTeacherForView = TeacherModel();
  GetAllTeachersDataModel getAllTeachersDataModel = GetAllTeachersDataModel();

  List<TeacherModel> teacherListForPagination = [];

  // updateSelectedTeacherForView(
  //   TeacherModel newValue,
  // ) {
  //   selectedTeacherForView = newValue;

  //   update();
  // }

  ///------------------------------- Teachers-data-check
  bool getTeachersDataCheck = false;
  getTeachersDataCheckCheck(bool value) {
    getTeachersDataCheck = value;
    update();
  }

  int? selectedTeacherCategoryIndex = 0;
  updateSelectedTeacherCategoryIndex(int? newValue) {
    selectedTeacherCategoryIndex = newValue;
    update();
  }

  /// paginated-data-fetch
  Future paginationDataLoad(BuildContext context) async {
    // perform fetching data delay
    // await new Future.delayed(new Duration(seconds: 2));

    log("load more");
    // update data and loading status
    if (getAllTeachersModel.data!.meta!.lastPage! >
        getAllTeachersModel.data!.meta!.currentPage!) {
      Get.find<GeneralController>().changeGetPaginationProgressCheck(true);

      postMethod(
          context,
          '${getAllTeachersModel.data!.meta!.path}',
          {
            'page': (getAllTeachersModel.data!.meta!.currentPage! + 1),
            'perPage': getAllTeachersModel.data!.meta!.perPage
          },
          false,
          getTeachersByCategoryRepo);
      update();
    }
  }

  updateTeacherListForPagination(TeacherModel teacherModel) {
    teacherListForPagination.add(teacherModel);
    update();
  }

  clearTeachersList() {
    teacherListForPagination = [];
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
