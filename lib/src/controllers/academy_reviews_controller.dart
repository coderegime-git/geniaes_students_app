import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resize/resize.dart';
import '../api_services/post_service.dart';
import '../models/academy_reviews_model.dart';
import '../models/teacher_reviews_model.dart';
import '../repositories/academy_reviews_repo.dart';
import 'general_controller.dart';

class AcademyReviewsController extends GetxController {
  GetAcademyReviewsModel getAcademyReviewsModel = GetAcademyReviewsModel();

  bool allAcademyReviewsLoader = false;
  updateAcademyReviewsLoader(bool newValue) {
    allAcademyReviewsLoader = newValue;
    update();
  }

  GetAcademyReviewsDataModel getAcademyReviewsDataModel =
      GetAcademyReviewsDataModel();

  List<ReviewModel> teacherReviewsListForPagination = [];

  // updateSelectedAcademyForView(
  //   AcademyModel newValue,
  // ) {
  //   selectedAcademyForView = newValue;

  //   update();
  // }

  ///------------------------------- Academies-data-check
  bool getAcademyReviewsDataCheck = false;
  getAcademyReviewsDataCheckCheck(bool value) {
    getAcademyReviewsDataCheck = value;
    update();
  }

  int? selectedAcademyReviewsCategoryIndex = 0;
  updateSelectedAcademyReviewsCategoryIndex(int? newValue) {
    selectedAcademyReviewsCategoryIndex = newValue;
    update();
  }

  /// paginated-data-fetch
  Future paginationDataLoad(BuildContext context) async {
    // perform fetching data delay
    // await new Future.delayed(new Duration(seconds: 2));

    log("load more");
    // update data and loading status
    if (getAcademyReviewsModel.data!.meta!.lastPage! >
        getAcademyReviewsModel.data!.meta!.currentPage!) {
      Get.find<GeneralController>().changeGetPaginationProgressCheck(true);

      postMethod(
          context,
          '${getAcademyReviewsModel.data!.meta!.path}',
          {
            'page': (getAcademyReviewsModel.data!.meta!.currentPage! + 1),
            'perPage': getAcademyReviewsModel.data!.meta!.perPage
          },
          false,
          getAcademyReviewsRepo);
      update();
    }
  }

  updateAcademyReviewsListForPagination(ReviewModel teacherReviewsModel) {
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
