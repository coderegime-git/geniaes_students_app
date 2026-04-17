import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resize/resize.dart';
import '../api_services/post_service.dart';
import '../models/teacher_reviews_model.dart';
import '../repositories/teacher_reviews_repo.dart';
import 'general_controller.dart';

class TeacherReviewsController extends GetxController {
  GetTeacherReviewsModel getTeacherReviewsModel = GetTeacherReviewsModel();

  bool allTeacherReviewsLoader = false;
  updateTeacherReviewsLoader(bool newValue) {
    allTeacherReviewsLoader = newValue;
    update();
  }

  GetTeacherReviewsDataModel getTeacherReviewsDataModel =
      GetTeacherReviewsDataModel();

  List<ReviewModel> teacherReviewsListForPagination = [];

  // updateSelectedTeacherForView(
  //   TeacherModel newValue,
  // ) {
  //   selectedTeacherForView = newValue;

  //   update();
  // }

  ///------------------------------- Teachers-data-check
  bool getTeacherReviewsDataCheck = false;
  getTeacherReviewsDataCheckCheck(bool value) {
    getTeacherReviewsDataCheck = value;
    update();
  }

  int? selectedTeacherReviewsCategoryIndex = 0;
  updateSelectedTeacherReviewsCategoryIndex(int? newValue) {
    selectedTeacherReviewsCategoryIndex = newValue;
    update();
  }

  /// paginated-data-fetch
  Future paginationDataLoad(BuildContext context) async {
    // perform fetching data delay
    // await new Future.delayed(new Duration(seconds: 2));

    log("load more");
    // update data and loading status
    if (getTeacherReviewsModel.data!.meta!.lastPage! >
        getTeacherReviewsModel.data!.meta!.currentPage!) {
      Get.find<GeneralController>().changeGetPaginationProgressCheck(true);

      postMethod(
          context,
          '${getTeacherReviewsModel.data!.meta!.path}',
          {
            'page': (getTeacherReviewsModel.data!.meta!.currentPage! + 1),
            'perPage': getTeacherReviewsModel.data!.meta!.perPage
          },
          false,
          getTeacherReviewsRepo);
      update();
    }
  }

  updateTeacherReviewsListForPagination(ReviewModel teacherReviewsModel) {
    teacherReviewsListForPagination.add(teacherReviewsModel);
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
