import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/student_appointment_history_controller.dart';
import '../controllers/general_controller.dart';
import '../models/student_appointment_history_model.dart';

getAllStudentAppointmentHistoryRepo(
    BuildContext context, bool responseCheck, Map<String, dynamic> response) {
  if (responseCheck) {
    Get.find<StudentAppointmentHistoryController>()
            .getStudentAppointmentHistoryModel =
        GetStudentAppointmentHistoryModel.fromJson(response);

    Get.find<StudentAppointmentHistoryController>()
        .updateStudentAppointmentHistoryLoader(true);
        
    if (Get.find<StudentAppointmentHistoryController>().getStudentAppointmentHistoryModel.data?.meta?.currentPage == 1) {
      Get.find<StudentAppointmentHistoryController>().emptyStudentAppointmentHistoryList();
    }

    log("${Get.find<StudentAppointmentHistoryController>().getStudentAppointmentHistoryModel.data!.data!.length.toString()} Total Student Appoinment History Length");
    log("${Get.find<StudentAppointmentHistoryController>().getStudentAppointmentHistoryModel.data!.data!.where((i) => i.appointmentStatusName == "Completed").toList().length.toString()} Total Completed Student Appoinment History Length");

    for (var element in Get.find<StudentAppointmentHistoryController>()
        .getStudentAppointmentHistoryModel
        .data!
        .data!) {
      Get.find<StudentAppointmentHistoryController>()
          .updateTeacherListForPagination(element);
    }

    Get.find<GeneralController>().changeGetPaginationProgressCheck(false);

    // if (Get.find<AllTeachersCategoriesController>().getAllTeacherCategoriesDataModel.status == true) {
    // } else {}
  } else if (!responseCheck) {
    Get.find<StudentAppointmentHistoryController>()
        .updateStudentAppointmentHistoryLoader(true);
  }
}
