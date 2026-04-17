import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/general_controller.dart';

import '../controllers/teacher_book_appointment_controller.dart';
import '../models/teacher_appointment_schedule_model.dart';

getTeacherBookAppointmentRepo(
    BuildContext context, bool responseCheck, Map<String, dynamic> response) {
  if (responseCheck) {
    Get.find<TeacherAppointmentScheduleController>()
            .getTeacherAppointmentScheduleModel =
        GetTeacherAppointmentScheduleModel.fromJson(response);
    Get.find<TeacherAppointmentScheduleController>()
        .updateTeacherBookAppointmentLoader(true);
    log("${Get.find<TeacherAppointmentScheduleController>().getTeacherAppointmentScheduleModel.data!} Total Teacher Book Appointment Length");

    Get.find<GeneralController>().changeGetPaginationProgressCheck(false);
  } else if (!responseCheck) {
    Get.find<TeacherAppointmentScheduleController>()
        .updateTeacherBookAppointmentLoader(true);
  }
}
