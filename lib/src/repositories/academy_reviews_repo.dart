import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/general_controller.dart';
import '../controllers/academy_reviews_controller.dart';
import '../models/academy_reviews_model.dart';

getAcademyReviewsRepo(
    BuildContext context, bool responseCheck, Map<String, dynamic> response) {
  if (responseCheck) {
    Get.find<AcademyReviewsController>().getAcademyReviewsModel =
        GetAcademyReviewsModel.fromJson(response);

    Get.find<AcademyReviewsController>().updateAcademyReviewsLoader(true);
    log("${Get.find<AcademyReviewsController>().getAcademyReviewsModel.data!.data!.length.toString()} Total Academies Length");

    for (var element in Get.find<AcademyReviewsController>()
        .getAcademyReviewsModel
        .data!
        .data!) {
      Get.find<AcademyReviewsController>()
          .updateAcademyReviewsListForPagination(element);
    }

    Get.find<GeneralController>().changeGetPaginationProgressCheck(false);

    // if (Get.find<AllTeachersCategoriesController>().getAllTeacherCategoriesDataModel.status == true) {
    // } else {}
  } else if (!responseCheck) {
    Get.find<AcademyReviewsController>().updateAcademyReviewsLoader(true);
  }
}
