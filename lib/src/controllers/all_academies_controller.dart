import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resize/resize.dart';
import '../api_services/post_service.dart';
import '../models/all_events_model.dart';
import '../models/all_academies_model.dart';
import '../repositories/all_events_repo.dart';
import 'general_controller.dart';

class AllAcademiesController extends GetxController {
  GetAllAcademiesModel getAllAcademiesModel = GetAllAcademiesModel();

  bool allAcademiesLoader = false;
  updateAcademiesLoader(bool newValue) {
    allAcademiesLoader = newValue;
    update();
  }

  EventModel selectedEventForView = EventModel();
  GetAllEventsDataModel getAllEventsDataModel = GetAllEventsDataModel();

  List<AcademyModel> academiesListForPagination = [];

  ///------------------------------- Academies-data-check
  bool getAcademiesDataCheck = false;
  getAcademiesDataCheckCheck(bool value) {
    getAcademiesDataCheck = value;
    update();
  }

  int? selectedAcademiesCategoryIndex = 0;
  updateSelectedEventsCategoryIndex(int? newValue) {
    selectedAcademiesCategoryIndex = newValue;
    update();
  }

  /// paginated-data-fetch
  Future paginationDataLoad(BuildContext context) async {
    // perform fetching data delay
    // await new Future.delayed(new Duration(seconds: 2));

    log("load more");
    // update data and loading status
    if (getAllAcademiesModel.data!.meta!.lastPage! >
        getAllAcademiesModel.data!.meta!.currentPage!) {
      Get.find<GeneralController>().changeGetPaginationProgressCheck(true);

      postMethod(
          context,
          '${getAllAcademiesModel.data!.meta!.path}',
          {
            'page': (getAllAcademiesModel.data!.meta!.currentPage! + 1),
            'perPage': getAllAcademiesModel.data!.meta!.perPage
          },
          false,
          getAllEventsRepo);
      update();
    }
  }

  updateAcademiesListForPagination(AcademyModel academyModel) {
    academiesListForPagination.add(academyModel);
    update();
  }

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
