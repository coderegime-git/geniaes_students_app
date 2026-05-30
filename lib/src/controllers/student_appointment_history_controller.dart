import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resize/resize.dart';
import '../api_services/post_service.dart';
import '../models/student_appointment_history_model.dart';
import '../repositories/all_teachers_repo.dart';
import 'general_controller.dart';

class StudentAppointmentHistoryController extends GetxController {
  GetStudentAppointmentHistoryModel getStudentAppointmentHistoryModel =
      GetStudentAppointmentHistoryModel();

  bool allStudentAppointmentHistoryLoader = false;
  updateStudentAppointmentHistoryLoader(bool newValue) {
    allStudentAppointmentHistoryLoader = newValue;
    update();
  }

  String? selectedTeacherCategory;
  // TeacherModel selectedTeacherForView = TeacherModel();
  GetStudentAppointmentHistoryDataModel getStudentAppointmentHistoryDataModel =
      GetStudentAppointmentHistoryDataModel();

  List<StudentAppointmentHistoryModel>
      studentAllAppointmentHistoryListForPagination = [];

  // updateSelectedTeacherForView(
  //   TeacherModel newValue,
  // ) {
  //   selectedTeacherForView = newValue;

  //   update();
  // }

  ///------------------------------- Teachers-data-check
  bool getStudentAppointmentHistoryDataCheck = false;
  getStudentAppointmentHistorysDataCheck(bool value) {
    getStudentAppointmentHistoryDataCheck = value;
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
    if (getStudentAppointmentHistoryModel.data!.meta!.lastPage! >
        getStudentAppointmentHistoryModel.data!.meta!.currentPage!) {
      Get.find<GeneralController>().changeGetPaginationProgressCheck(true);

      postMethod(
          context,
          '${getStudentAppointmentHistoryModel.data!.meta!.path}',
          {
            'page':
                (getStudentAppointmentHistoryModel.data!.meta!.currentPage! +
                    1),
            'perPage': getStudentAppointmentHistoryModel.data!.meta!.perPage
          },
          false,
          getAllTeachersRepo);
      update();
    }
  }

  updateTeacherListForPagination(
      StudentAppointmentHistoryModel studentAppointmentHistoryModel) {
    studentAllAppointmentHistoryListForPagination
        .add(studentAppointmentHistoryModel);
    update();
  }

  emptyStudentAppointmentHistoryList() {
    studentAllAppointmentHistoryListForPagination.clear();
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
