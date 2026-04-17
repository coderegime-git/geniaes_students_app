import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resize/resize.dart';
import '../models/teacher_appointment_schedule_model.dart';

class TeacherAppointmentScheduleController extends GetxController {
  GetTeacherAppointmentScheduleModel getTeacherAppointmentScheduleModel =
      GetTeacherAppointmentScheduleModel();

  TextEditingController videCallQuestionFieldController =
      TextEditingController();
  TextEditingController audioCallQuestionFieldController =
      TextEditingController();
  TextEditingController liveChatQuestionFieldController =
      TextEditingController();

  bool getTeacherBookAppointmentLoader = false;
  updateTeacherBookAppointmentLoader(bool newValue) {
    getTeacherBookAppointmentLoader = newValue;
    update();
  }

  String? selectedTeacherCategory;
  // TeacherModel selectedTeacherForView = TeacherModel();
  GetTeacherBookAppointmentDataModel getTeacherBookAppointmentDataModel =
      GetTeacherBookAppointmentDataModel();

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
