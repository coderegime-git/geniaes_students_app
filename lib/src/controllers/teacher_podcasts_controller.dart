import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resize/resize.dart';
import '../api_services/post_service.dart';
import '../models/teacher_podcasts_model.dart';
import '../repositories/teacher_podcasts_repo.dart';
import 'general_controller.dart';

class TeacherPodcastsController extends GetxController {
  GetTeacherPodcastsModel getTeacherPodcastsModel = GetTeacherPodcastsModel();

  bool allTeacherPodcastsLoader = false;
  updateTeacherPodcastsLoader(bool newValue) {
    allTeacherPodcastsLoader = newValue;
    update();
  }

  GetTeacherPodcastsDataModel getTeacherPodcastsDataModel =
      GetTeacherPodcastsDataModel();

  List<PodcastModel> teacherPodcastsListForPagination = [];

  // updateSelectedTeacherForView(
  //   TeacherModel newValue,
  // ) {
  //   selectedTeacherForView = newValue;

  //   update();
  // }

  ///------------------------------- Teachers-data-check
  bool getTeacherPodcastsDataCheck = false;
  getTeacherPodcastsDataCheckCheck(bool value) {
    getTeacherPodcastsDataCheck = value;
    update();
  }

  int? selectedTeacherPodcastsCategoryIndex = 0;
  updateSelectedTeacherPodcastsCategoryIndex(int? newValue) {
    selectedTeacherPodcastsCategoryIndex = newValue;
    update();
  }

  /// paginated-data-fetch
  Future paginationDataLoad(BuildContext context) async {
    // perform fetching data delay
    // await new Future.delayed(new Duration(seconds: 2));

    log("load more");
    // update data and loading status
    if (getTeacherPodcastsModel.data!.meta!.lastPage! >
        getTeacherPodcastsModel.data!.meta!.currentPage!) {
      Get.find<GeneralController>().changeGetPaginationProgressCheck(true);

      postMethod(
          context,
          '${getTeacherPodcastsModel.data!.meta!.path}',
          {
            'page': (getTeacherPodcastsModel.data!.meta!.currentPage! + 1),
            'perPage': getTeacherPodcastsModel.data!.meta!.perPage
          },
          false,
          getTeacherPodcastsRepo);
      update();
    }
  }

  updateTeacherPodcastsListForPagination(PodcastModel teacherPodcastsModel) {
    teacherPodcastsListForPagination.add(teacherPodcastsModel);
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
