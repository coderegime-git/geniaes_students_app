import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resize/resize.dart';
import '../api_services/post_service.dart';
import '../models/student_booked_services_model.dart';
import '../repositories/all_teachers_repo.dart';
import 'general_controller.dart';

class StudentBookedServicesController extends GetxController {
  GetStudentBookedServicesModel getStudentBookedServicesModel =
      GetStudentBookedServicesModel();

  bool allStudentBookedServicesLoader = false;
  updateStudentBookedServicesLoader(bool newValue) {
    allStudentBookedServicesLoader = newValue;
    update();
  }

  GetStudentBookedServicesDataModel getStudentBookedServicesDataModel =
      GetStudentBookedServicesDataModel();

  List<StudentBookedServiceModel> studentAllBookedServicesListForPagination =
      [];

  ///------------------------------- Lawyers-data-check
  bool getStudentBookedServiceDataCheck = false;
  getStudentBookedServicesDataCheck(bool value) {
    getStudentBookedServiceDataCheck = value;
    update();
  }

  int? selectedLawyerCategoryIndex = 0;
  updateSelectedLawyerCategoryIndex(int? newValue) {
    selectedLawyerCategoryIndex = newValue;
    update();
  }

  /// paginated-data-fetch
  Future paginationDataLoad(BuildContext context) async {
    // perform fetching data delay
    // await new Future.delayed(new Duration(seconds: 2));

    log("load more");
    // update data and loading status
    if (getStudentBookedServicesModel.data!.meta!.lastPage! >
        getStudentBookedServicesModel.data!.meta!.currentPage!) {
      Get.find<GeneralController>().changeGetPaginationProgressCheck(true);

      postMethod(
          context,
          '${getStudentBookedServicesModel.data!.meta!.path}',
          {
            'page':
                (getStudentBookedServicesModel.data!.meta!.currentPage! + 1),
            'perPage': getStudentBookedServicesModel.data!.meta!.perPage
          },
          false,
          getAllTeachersRepo);
      update();
    }
  }

  updateLawyerListForPagination(
      StudentBookedServiceModel studentBookedServiceModel) {
    studentAllBookedServicesListForPagination.add(studentBookedServiceModel);
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
