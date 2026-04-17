import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/general_controller.dart';
import '../controllers/teacher_podcasts_controller.dart';
import '../models/teacher_podcasts_model.dart';

getTeacherPodcastsRepo(
    BuildContext context, bool responseCheck, Map<String, dynamic> response) {
  if (responseCheck) {
    Get.find<TeacherPodcastsController>().getTeacherPodcastsModel =
        GetTeacherPodcastsModel.fromJson(response);

    Get.find<TeacherPodcastsController>().updateTeacherPodcastsLoader(true);
    log("${Get.find<TeacherPodcastsController>().getTeacherPodcastsModel.data!.data!.length.toString()} Total Teachers Podcasts Length");

    for (var element in Get.find<TeacherPodcastsController>()
        .getTeacherPodcastsModel
        .data!
        .data!) {
      Get.find<TeacherPodcastsController>()
          .updateTeacherPodcastsListForPagination(element);
    }

    Get.find<GeneralController>().changeGetPaginationProgressCheck(false);

    // if (Get.find<AllTeachersCategoriesController>().getAllTeacherCategoriesDataModel.status == true) {
    // } else {}
  } else if (!responseCheck) {
    Get.find<TeacherPodcastsController>().updateTeacherPodcastsLoader(true);
  }
}
