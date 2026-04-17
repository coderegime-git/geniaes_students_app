import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resize/resize.dart';
import '../api_services/post_service.dart';
import '../models/teacher_broadcasts_model.dart';
import '../repositories/teacher_broadcasts_repo.dart';
import 'general_controller.dart';

class TeacherBroadcastsController extends GetxController {
  GetTeacherBroadcastsModel getTeacherBroadcastsModel =
      GetTeacherBroadcastsModel();

  bool allTeacherBroadcastsLoader = false;
  updateTeacherBroadcastsLoader(bool newValue) {
    allTeacherBroadcastsLoader = newValue;
    update();
  }

  GetTeacherBroadcastsDataModel getTeacherBroadcastsDataModel =
      GetTeacherBroadcastsDataModel();

  List<BroadcastModel> teacherBroadcastsListForPagination = [];

  // updateSelectedTeacherForView(
  //   TeacherModel newValue,
  // ) {
  //   selectedTeacherForView = newValue;

  //   update();
  // }

  ///------------------------------- Teachers-data-check
  bool getTeacherBroadcastsDataCheck = false;
  getTeacherBroadcastsDataCheckCheck(bool value) {
    getTeacherBroadcastsDataCheck = value;
    update();
  }

  int? selectedTeacherBroadcastsCategoryIndex = 0;
  updateSelectedTeacherBroadcastsCategoryIndex(int? newValue) {
    selectedTeacherBroadcastsCategoryIndex = newValue;
    update();
  }

  /// paginated-data-fetch
  Future paginationDataLoad(BuildContext context) async {
    // perform fetching data delay
    // await new Future.delayed(new Duration(seconds: 2));

    log("load more");
    // update data and loading status
    if (getTeacherBroadcastsModel.data!.meta!.lastPage! >
        getTeacherBroadcastsModel.data!.meta!.currentPage!) {
      Get.find<GeneralController>().changeGetPaginationProgressCheck(true);

      postMethod(
          context,
          '${getTeacherBroadcastsModel.data!.meta!.path}',
          {
            'page': (getTeacherBroadcastsModel.data!.meta!.currentPage! + 1),
            'perPage': getTeacherBroadcastsModel.data!.meta!.perPage
          },
          false,
          getTeacherBroadcastsRepo);
      update();
    }
  }

  updateTeacherBroadcastsListForPagination(
      BroadcastModel teacherBroadcastsModel) {
    teacherBroadcastsListForPagination.add(teacherBroadcastsModel);
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
