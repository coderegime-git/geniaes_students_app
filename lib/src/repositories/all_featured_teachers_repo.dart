import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/all_featured_teachers_controller.dart';
import '../models/all_featured_teachers_model.dart';

getAllFeaturedTeachersRepo(
    BuildContext context, bool responseCheck, Map<String, dynamic> response) {
  if (responseCheck) {
    Get.find<AllFeaturedTeachersController>().getAllFeaturedTeachersModel =
        GetAllFeaturedTeachersModel.fromJson(response);

    Get.find<AllFeaturedTeachersController>()
        .updatefeaturedTeachersLoader(true);

    // if (Get.find<AllTeachersCategoriesController>().getAllTeacherCategoriesDataModel.status == true) {
    // } else {}
  } else if (!responseCheck) {
    Get.find<AllFeaturedTeachersController>()
        .updatefeaturedTeachersLoader(true);
  }
}
