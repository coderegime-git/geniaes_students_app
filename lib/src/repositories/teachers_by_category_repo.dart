import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/general_controller.dart';
import '../controllers/teachers_by_category_controller.dart';
import '../models/all_teachers_model.dart';

getTeachersByCategoryRepo(
    BuildContext context, bool responseCheck, Map<String, dynamic> response) {
  if (responseCheck) {
    Get.find<TeachersByCategoryController>().getAllTeachersModel =
        GetAllTeachersModel.fromJson(response);

    Get.find<TeachersByCategoryController>()
        .updateTeachersByCategoryLoader(true);
    log("${Get.find<TeachersByCategoryController>().getAllTeachersModel.data!.data!.length.toString()} Total Teachers From Category Length");

    Get.find<TeachersByCategoryController>().clearTeachersList();
    for (var element in Get.find<TeachersByCategoryController>()
        .getAllTeachersModel
        .data!
        .data!) {
      Get.find<TeachersByCategoryController>()
          .updateTeacherListForPagination(element);
    }

    Get.find<GeneralController>().changeGetPaginationProgressCheck(false);

    // if (Get.find<AllTeachersCategoriesController>().getAllTeacherCategoriesDataModel.status == true) {
    // } else {}
  } else if (!responseCheck) {
    Get.find<TeachersByCategoryController>()
        .updateTeachersByCategoryLoader(true);
  }
}
