import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/general_controller.dart';
import '../controllers/teacher_reviews_controller.dart';
import '../models/teacher_reviews_model.dart';

getTeacherReviewsRepo(
    BuildContext context, bool responseCheck, Map<String, dynamic> response) {
  if (responseCheck) {
    Get.find<TeacherReviewsController>().getTeacherReviewsModel =
        GetTeacherReviewsModel.fromJson(response);

    Get.find<TeacherReviewsController>().updateTeacherReviewsLoader(true);
    log("${Get.find<TeacherReviewsController>().getTeacherReviewsModel.data!.data!.length.toString()} Total Teachers Length");

    for (var element in Get.find<TeacherReviewsController>()
        .getTeacherReviewsModel
        .data!
        .data!) {
      Get.find<TeacherReviewsController>()
          .updateTeacherReviewsListForPagination(element);
    }

    Get.find<GeneralController>().changeGetPaginationProgressCheck(false);
  } else if (!responseCheck) {
    Get.find<TeacherReviewsController>().updateTeacherReviewsLoader(true);
  }
}
