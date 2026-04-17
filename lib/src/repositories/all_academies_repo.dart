import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/all_academies_controller.dart';
import '../controllers/general_controller.dart';
import '../models/all_academies_model.dart';

getAllAcademiesRepo(
    BuildContext context, bool responseCheck, Map<String, dynamic> response) {
  if (responseCheck) {
    Get.find<AllAcademiesController>().getAllAcademiesModel =
        GetAllAcademiesModel.fromJson(response);

    Get.find<AllAcademiesController>().updateAcademiesLoader(true);
    log("${Get.find<AllAcademiesController>().getAllAcademiesModel.data!.data!.length.toString()} Total Academies Length");

    for (var element in Get.find<AllAcademiesController>()
        .getAllAcademiesModel
        .data!
        .data!) {
      Get.find<AllAcademiesController>()
          .updateAcademiesListForPagination(element);
    }

    Get.find<GeneralController>().changeGetPaginationProgressCheck(false);

    // if (Get.find<AllTeachersCategoriesController>().getAllTeacherCategoriesDataModel.status == true) {
    // } else {}
  } else if (!responseCheck) {
    Get.find<AllAcademiesController>().updateAcademiesLoader(true);
  }
}

getAllSearchedAcademiesRepo(
    BuildContext context, bool responseCheck, Map<String, dynamic> response) {
  if (responseCheck) {
    if (Get.find<AllAcademiesController>()
        .academiesListForPagination
        .isNotEmpty) {
      Get.find<AllAcademiesController>().academiesListForPagination = [];
    }
    Get.find<AllAcademiesController>().getAllAcademiesModel =
        GetAllAcademiesModel.fromJson(response);

    Get.find<AllAcademiesController>().updateAcademiesLoader(true);
    log("${Get.find<AllAcademiesController>().getAllAcademiesModel.data!.data!.length.toString()} Total Academies Length");

    for (var element in Get.find<AllAcademiesController>()
        .getAllAcademiesModel
        .data!
        .data!) {
      Get.find<AllAcademiesController>()
          .updateAcademiesListForPagination(element);
    }

    Get.find<GeneralController>().changeGetPaginationProgressCheck(false);

    // if (Get.find<AllTeachersCategoriesController>().getAllTeacherCategoriesDataModel.status == true) {
    // } else {}
  } else if (!responseCheck) {
    Get.find<AllAcademiesController>().updateAcademiesLoader(true);
  }
}
