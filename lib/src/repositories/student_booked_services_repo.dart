import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/student_booked_services_controller.dart';
import '../controllers/general_controller.dart';
import '../models/student_booked_services_model.dart';

getAllStudentBookedServicesRepo(
    BuildContext context, bool responseCheck, Map<String, dynamic> response) {
  if (responseCheck) {
    Get.find<StudentBookedServicesController>().getStudentBookedServicesModel =
        GetStudentBookedServicesModel.fromJson(response);

    Get.find<StudentBookedServicesController>()
        .updateStudentBookedServicesLoader(true);
    log("${Get.find<StudentBookedServicesController>().getStudentBookedServicesModel.data!.data!.length.toString()} Total Student Booked Services Length");
    log("${Get.find<StudentBookedServicesController>().getStudentBookedServicesModel.data!.data!.where((i) => i.serviceStatusName == "Completed").toList().length.toString()} Total Completed Student Booked Services Length");

    for (var element in Get.find<StudentBookedServicesController>()
        .getStudentBookedServicesModel
        .data!
        .data!) {
      Get.find<StudentBookedServicesController>()
          .updateLawyerListForPagination(element);
    }

    Get.find<GeneralController>().changeGetPaginationProgressCheck(false);

    // if (Get.find<AllLawyersCategoriesController>().getAllLawyerCategoriesDataModel.status == true) {
    // } else {}
  } else if (!responseCheck) {
    Get.find<StudentBookedServicesController>()
        .updateStudentBookedServicesLoader(true);
  }
}
