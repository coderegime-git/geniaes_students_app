import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/general_controller.dart';
import '../controllers/teacher_appointment_types_controller.dart';
import '../models/teacher_appointment_types_model.dart';
import '../models/all_teachers_model.dart';

getTeacherAppointmentTypesRepo(
    BuildContext context, bool responseCheck, Map<String, dynamic> response) {
  if (responseCheck) {
    Get.find<TeacherAppointmentTypesController>()
            .getTeacherAppointmentTypesModel =
        GetTeacherAppointmentTypesModel.fromJson(response);

    Get.find<TeacherAppointmentTypesController>()
        .updateTeacherAppointmentTypesLoader(true);
    if (Get.find<TeacherAppointmentTypesController>().getTeacherAppointmentTypesModel.data != null) {
      log("${Get.find<TeacherAppointmentTypesController>().getTeacherAppointmentTypesModel.data!.length.toString()} Total Teacher Appointment Types Length");
    }

    Get.find<GeneralController>().changeGetPaginationProgressCheck(false);
  } else {
    Get.find<TeacherAppointmentTypesController>()
        .updateTeacherAppointmentTypesLoader(true);
  }
}

getTeacherProfileRepo(
    BuildContext context, bool responseCheck, Map<String, dynamic> response) {
  if (responseCheck) {
    if (response['data'] != null) {
      Get.find<GeneralController>().updateSelectedTeacherForView(
          TeacherModel.fromJson(response['data']));
      log("Teacher Profile Updated for: ${Get.find<GeneralController>().selectedTeacherForView.name}");
    }
  }
}
