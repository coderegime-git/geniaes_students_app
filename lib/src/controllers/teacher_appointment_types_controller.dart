import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resize/resize.dart';

import '../models/teacher_appointment_types_model.dart';

class TeacherAppointmentTypesController extends GetxController {
  GetTeacherAppointmentTypesModel getTeacherAppointmentTypesModel =
      GetTeacherAppointmentTypesModel();

  bool teacherAppointmentTypesLoader = false;
  updateTeacherAppointmentTypesLoader(bool newValue) {
    teacherAppointmentTypesLoader = newValue;
    update();
  }

  String? selectedTeacherCategory;
  // TeacherModel selectedTeacherForView = TeacherModel();
  GetTeacherAppointmentTypesDataModel getTeacherAppointmentTypesData =
      GetTeacherAppointmentTypesDataModel();

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
