import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tutorhub_for_students/src/screens/search_screen.dart';
import '../controllers/all_teachers_controller.dart';
import '../controllers/general_controller.dart';
import '../models/all_teachers_model.dart';

getAllTeachersRepo(
    BuildContext context, bool responseCheck, Map<String, dynamic> response) {
  if (responseCheck) {
    log("${(response["data"]["data"] as List).length} All Teachers Length");

    Get.find<AllTeachersController>().getAllTeachersModel =
        GetAllTeachersModel.fromJson(response);

    log("${Get.find<AllTeachersController>().getAllTeachersModel.data!.data!.length.toString()} Total Teachers Length");
    Get.find<AllTeachersController>().updateTeachersLoader(true);

    for (var element
        in Get.find<AllTeachersController>().getAllTeachersModel.data!.data!) {
      Get.find<AllTeachersController>().updateTeacherListForPagination(element);
    }

    Get.find<GeneralController>().changeGetPaginationProgressCheck(false);

    // if (Get.find<AllTeachersCategoriesController>().getAllTeacherCategoriesDataModel.status == true) {
    // } else {}
  } else if (!responseCheck) {
    Get.find<AllTeachersController>().updateTeachersLoader(true);
  }
}

getAllSearchedTeachersRepo(
    BuildContext context, bool responseCheck, Map<String, dynamic> response) {
  if (responseCheck) {
    if (Get.find<AllTeachersController>().teacherListForPagination.isNotEmpty) {
      Get.find<AllTeachersController>().teacherListForPagination = [];
    }
    if (Get.find<GeneralController>().isSearchOn == true) {
      Get.to(() => SearchScreen());
    }

    Get.find<AllTeachersController>().getAllTeachersModel =
        GetAllTeachersModel.fromJson(response);

    Get.find<AllTeachersController>().updateTeachersLoader(true);
    log("${Get.find<AllTeachersController>().getAllTeachersModel.data!.data!.length.toString()} Total Teachers Length");

    for (var element
        in Get.find<AllTeachersController>().getAllTeachersModel.data!.data!) {
      Get.find<AllTeachersController>().updateTeacherListForPagination(element);
    }

    Get.find<GeneralController>().changeGetPaginationProgressCheck(false);

    // if (Get.find<AllTeachersCategoriesController>().getAllTeacherCategoriesDataModel.status == true) {
    // } else {}
  } else if (!responseCheck) {
    Get.find<AllTeachersController>().updateTeachersLoader(true);
  }
}
