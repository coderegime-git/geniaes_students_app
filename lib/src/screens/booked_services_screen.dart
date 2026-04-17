import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resize/resize.dart';

import '../../multi_language/language_constants.dart';
import '../api_services/get_service.dart';
import '../api_services/urls.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import '../controllers/student_booked_services_controller.dart';
import '../controllers/general_controller.dart';

import '../models/student_booked_services_model.dart';
import '../repositories/student_booked_services_repo.dart';
import '../routes.dart';
import '../widgets/appbar_widget.dart';

import '../widgets/custom_skeleton_loader.dart';
import '../widgets/service_card_widget.dart';

class BookedServicesScreen extends StatefulWidget {
  const BookedServicesScreen({super.key});

  @override
  State<BookedServicesScreen> createState() => _BookedServicesScreenState();
}

class _BookedServicesScreenState extends State<BookedServicesScreen> {
  final logic = Get.put(StudentBookedServicesController());

  List<GetStudentBookedServicesModel>? pendingList = [];
  String? fromBookService = Get.parameters["fromBookService"];

  @override
  void initState() {
    super.initState();
    getMethod(context, "$getStudentBookedServicesHistory?page=1", null, true,
        getAllStudentBookedServicesRepo);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StudentBookedServicesController>(
        builder: (studentBookedServicesController) {
      return GetBuilder<GeneralController>(builder: (generalController) {
        return DefaultTabController(
          length: 4, // length of tabs
          initialIndex: 0,
          child: Scaffold(
            backgroundColor: AppColors.white,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(56),
              child: AppBarWidget(
                leadingIcon: "assets/icons/Expand_left.png",
                leadingOnTap: () {
                  fromBookService == "Yes"
                      ? Get.toNamed(PageRoutes.homeScreen)
                      : Get.back();
                },
                titleText: LanguageConstant.bookedServices.tr,
              ),
            ),
            body: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Theme(
                    data: ThemeData()
                        .copyWith(dividerColor: AppColors.primaryColor),
                    child: TabBar(
                      labelColor: AppColors.white,
                      unselectedLabelColor: AppColors.secondaryColor,
                      dividerColor: AppColors.transparent,
                      padding: const EdgeInsets.fromLTRB(3, 6, 3, 6),
                      labelPadding: EdgeInsets.zero,
                      indicatorPadding: EdgeInsets.fromLTRB(2.w, 8.h, 2.w, 8.h),
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelStyle: AppTextStyles.buttonTextStyle2,
                      unselectedLabelStyle: AppTextStyles.buttonTextStyle7,
                      indicator: BoxDecoration(
                          gradient: AppColors.gradientOne,
                          borderRadius: BorderRadius.circular(10)),
                      tabs: [
                        Tab(text: LanguageConstant.all.tr),
                        Tab(text: LanguageConstant.pending.tr),
                        Tab(text: LanguageConstant.accepted.tr),
                        Tab(text: LanguageConstant.completed.tr),
                      ],
                    ),
                  ),
                  !studentBookedServicesController
                          .allStudentBookedServicesLoader
                      ? Expanded(
                          child: CustomVerticalSkeletonLoader(
                            height: 200.h,
                            highlightColor: AppColors.grey,
                            seconds: 2,
                            totalCount: 5,
                            width: 140.w,
                          ),
                        )
                      : Expanded(
                          child: Container(
                            decoration: const BoxDecoration(
                                border: Border(
                                    top: BorderSide(
                                        color: AppColors.primaryColor,
                                        width: 1))),
                            child: TabBarView(children: <Widget>[
                              // All Appointment History
                              ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: studentBookedServicesController
                                    .studentAllBookedServicesListForPagination
                                    .length,
                                physics: const AlwaysScrollableScrollPhysics(),
                                padding: const EdgeInsets.only(top: 18),
                                itemBuilder: (context, index) {
                                  return ServiceCardWidget(
                                    serviceName: studentBookedServicesController
                                            .studentAllBookedServicesListForPagination[
                                                index]
                                            .serviceName ??
                                        "",
                                    serviceImage: studentBookedServicesController
                                                .studentAllBookedServicesListForPagination[
                                                    index]
                                                .serviceImage ==
                                            null
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.r),
                                            child: Image.asset(
                                              scale: 4.h,
                                              'assets/images/teacher-image.png',
                                              fit: BoxFit.cover,
                                              height: 110.h,
                                              width: 120.w,
                                            ))
                                        : ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.r),
                                            child: Image.network(
                                              scale: 4.h,
                                              '$mediaUrl${studentBookedServicesController.studentAllBookedServicesListForPagination[index].serviceImage!}',
                                              fit: BoxFit.cover,
                                              height: 110.h,
                                              width: 120.w,
                                            )),
                                    serviceStatus: Container(
                                      padding:
                                          const EdgeInsets.fromLTRB(5, 2, 5, 2),
                                      decoration: BoxDecoration(
                                          color: studentBookedServicesController
                                                      .studentAllBookedServicesListForPagination[
                                                          index]
                                                      .serviceStatusCode! ==
                                                  1
                                              ? AppColors.primaryColor
                                              : studentBookedServicesController
                                                          .studentAllBookedServicesListForPagination[
                                                              index]
                                                          .serviceStatusCode! ==
                                                      5
                                                  ? AppColors.green
                                                      .withOpacity(0.5)
                                                  : studentBookedServicesController
                                                              .studentAllBookedServicesListForPagination[
                                                                  index]
                                                              .serviceStatusCode! ==
                                                          2
                                                      ? AppColors.orange
                                                          .withOpacity(0.5)
                                                      : AppColors.primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Text(
                                        // "Pending",
                                        studentBookedServicesController
                                            .studentAllBookedServicesListForPagination[
                                                index]
                                            .serviceStatusName!,
                                        style: AppTextStyles.bodyTextStyle4,
                                      ),
                                    ),
                                    serviceTypeName:
                                        LanguageConstant.service.tr,
                                    dateAndTime: studentBookedServicesController
                                        .studentAllBookedServicesListForPagination[
                                            index]
                                        .date!,
                                    onTap: () {
                                      generalController
                                          .updateSelectedBookedServicesForView(
                                              studentBookedServicesController
                                                      .studentAllBookedServicesListForPagination[
                                                  index]);
                                      Get.toNamed(
                                          PageRoutes.bookedServiceDetailScreen);
                                    },
                                  );
                                },
                              ),
                              // Pending Appointment History
                              bookedServicesWidget(
                                  1,
                                  studentBookedServicesController,
                                  generalController),
                              // Accepted Appointment History
                              bookedServicesWidget(
                                  2,
                                  studentBookedServicesController,
                                  generalController),
                              // Completed Appointment History
                              bookedServicesWidget(
                                  5,
                                  studentBookedServicesController,
                                  generalController),
                            ]),
                          ),
                        )
                ]),
          ),
        );
      });
    });
  }

  // Booked Services
  Widget bookedServicesWidget(
      int statusCode,
      StudentBookedServicesController studentBookedServicesController,
      GeneralController generalController) {
    return studentBookedServicesController
            .studentAllBookedServicesListForPagination
            .where((i) => i.serviceStatusCode == statusCode)
            .toList()
            .isNotEmpty
        ? ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            // ignore: iterable_contains_unrelated_type
            itemCount: studentBookedServicesController
                .studentAllBookedServicesListForPagination
                .where((i) => i.serviceStatusCode == statusCode)
                .toList()
                .length,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(top: 18),
            itemBuilder: (context, index) {
              return ServiceCardWidget(
                serviceImage: studentBookedServicesController
                            .studentAllBookedServicesListForPagination
                            .where((i) => i.serviceStatusCode == statusCode)
                            .toList()[index]
                            .serviceImage ==
                        null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: Image.asset(
                          scale: 4.h,
                          'assets/images/teacher-image.png',
                          fit: BoxFit.cover,
                          height: 110.h,
                          width: 120.w,
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: Image.network(
                          scale: 4.h,
                          '$mediaUrl${studentBookedServicesController.studentAllBookedServicesListForPagination.where((i) => i.serviceStatusCode == statusCode).toList()[index].serviceImage!}',
                          fit: BoxFit.cover,
                          height: 110.h,
                          width: 120.w,
                        )),
                serviceName: studentBookedServicesController
                        .studentAllBookedServicesListForPagination
                        .where((i) => i.serviceStatusCode == statusCode)
                        .toList()[index]
                        .serviceName ??
                    "",
                serviceStatus: Container(
                  padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                  decoration: BoxDecoration(
                      color: studentBookedServicesController
                                  .studentAllBookedServicesListForPagination
                                  .where(
                                      (i) => i.serviceStatusCode == statusCode)
                                  .toList()[index]
                                  .serviceStatusCode! ==
                              1
                          ? AppColors.primaryColor
                          : studentBookedServicesController
                                      .studentAllBookedServicesListForPagination
                                      .where((i) =>
                                          i.serviceStatusCode == statusCode)
                                      .toList()[index]
                                      .serviceStatusCode! ==
                                  5
                              ? AppColors.green.withOpacity(0.5)
                              : studentBookedServicesController
                                          .studentAllBookedServicesListForPagination
                                          .where((i) =>
                                              i.serviceStatusCode == statusCode)
                                          .toList()[index]
                                          .serviceStatusCode! ==
                                      2
                                  ? AppColors.orange.withOpacity(0.5)
                                  : AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(5)),
                  child: Text(
                    // statusCode,
                    studentBookedServicesController
                        .studentAllBookedServicesListForPagination
                        .where((i) => i.serviceStatusCode == statusCode)
                        .toList()[index]
                        .serviceStatusName!,
                    style: AppTextStyles.bodyTextStyle4,
                  ),
                ),
                serviceTypeName: LanguageConstant.service.tr,
                dateAndTime: studentBookedServicesController
                    .studentAllBookedServicesListForPagination
                    .where((i) => i.serviceStatusCode == statusCode)
                    .toList()[index]
                    .date!,
                onTap: () {
                  generalController.updateSelectedBookedServicesForView(
                      studentBookedServicesController
                          .studentAllBookedServicesListForPagination
                          .where((i) => i.serviceStatusCode == statusCode)
                          .toList()[index]);
                  Get.toNamed(PageRoutes.bookedServiceDetailScreen);
                },
              );
            },
          )
        : Center(
            child: Text(
              LanguageConstant.noDataFound.tr,
              style: AppTextStyles.bodyTextStyle13,
            ),
          );
  }
}
