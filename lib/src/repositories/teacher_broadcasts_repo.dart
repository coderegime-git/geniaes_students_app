import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/general_controller.dart';
import '../controllers/teacher_broadcasts_controller.dart';
import '../models/teacher_broadcasts_model.dart';

getTeacherBroadcastsRepo(
    BuildContext context, bool responseCheck, Map<String, dynamic> response) {
  if (responseCheck) {
    Get.find<TeacherBroadcastsController>().getTeacherBroadcastsModel =
        GetTeacherBroadcastsModel.fromJson(response);

    Get.find<TeacherBroadcastsController>().updateTeacherBroadcastsLoader(true);
    log("${Get.find<TeacherBroadcastsController>().getTeacherBroadcastsModel.data!.data!.length.toString()} Total Teachers Broadcasts Length");

    for (var element in Get.find<TeacherBroadcastsController>()
        .getTeacherBroadcastsModel
        .data!
        .data!) {
      Get.find<TeacherBroadcastsController>()
          .updateTeacherBroadcastsListForPagination(element);
    }

    Get.find<GeneralController>().changeGetPaginationProgressCheck(false);

    // if (Get.find<AllTeachersCategoriesController>().getAllTeacherCategoriesDataModel.status == true) {
    // } else {}
  } else if (!responseCheck) {
    Get.find<TeacherBroadcastsController>().updateTeacherBroadcastsLoader(true);
  }
}
