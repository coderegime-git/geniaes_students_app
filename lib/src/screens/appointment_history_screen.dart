import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resize/resize.dart';

import '../../multi_language/language_constants.dart';
import '../api_services/get_service.dart';
import '../api_services/urls.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import '../controllers/student_appointment_history_controller.dart';
import '../controllers/general_controller.dart';
import '../models/student_appointment_history_model.dart';
import '../repositories/student_appointment_history_repo.dart';
import '../routes.dart';
import '../widgets/appbar_widget.dart';
import '../widgets/appointment_card_widget.dart';
import '../widgets/custom_skeleton_loader.dart';

class AppointmentHistoryScreen extends StatefulWidget {
  const AppointmentHistoryScreen({super.key});

  @override
  State<AppointmentHistoryScreen> createState() =>
      _AppointmentHistoryScreenState();
}

class _AppointmentHistoryScreenState extends State<AppointmentHistoryScreen> {
  final logic = Get.put(StudentAppointmentHistoryController());

  List<StudentAppointmentHistoryModel>? pendingList = [];
  String? fromBookAppointment = Get.parameters["fromBookAppointment"];

  @override
  void initState() {
    super.initState();
    getMethod(context, "$getStudentAppointmentHistory?page=1", null, true,
        getAllStudentAppointmentHistoryRepo);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StudentAppointmentHistoryController>(
        builder: (studentAppointmentHistoryController) {
      return GetBuilder<GeneralController>(builder: (generalController) {
        return DefaultTabController(
          length: 5, // length of tabs
          initialIndex: int.parse(Get.arguments?["initialIndex"]?.toString() ?? "0"),
          child: Scaffold(
            backgroundColor: AppColors.white,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(56),
              child: AppBarWidget(
                titleText: LanguageConstant.appointmentHistory.tr,
                leadingIcon: "assets/icons/Expand_left.png",
                leadingOnTap: () {
                  fromBookAppointment == "Yes"
                      ? Get.toNamed(PageRoutes.homeScreen)
                      : Get.back();
                },
              ),
            ),
            body: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TabBar(
                    labelColor: AppColors.white,
                    unselectedLabelColor: AppColors.black,
                    dividerColor: AppColors.transparent,
                    padding: EdgeInsets.fromLTRB(8.w, 6.h, 8.w, 6.h),
                    indicatorPadding: EdgeInsets.fromLTRB(0.w, 4.h, 0.w, 4.h),
                    labelPadding: EdgeInsets.zero,
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelStyle: AppTextStyles.buttonTextStyle2,
                    unselectedLabelStyle: AppTextStyles.buttonTextStyle7,
                    indicator: BoxDecoration(
                        gradient: AppColors.gradientOne,
                        borderRadius: BorderRadius.circular(20)),
                    tabs: [
                      Tab(
                        text: LanguageConstant.all.tr,
                      ),
                      Tab(
                        text: LanguageConstant.pending.tr,
                      ),
                      Tab(
                        text: LanguageConstant.accepted.tr,
                      ),
                      Tab(
                        text: LanguageConstant.rejected.tr,
                      ),
                      Tab(
                        text: LanguageConstant.completed.tr,
                      ),
                    ],
                  ),
                  !studentAppointmentHistoryController
                          .allStudentAppointmentHistoryLoader
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
                          child: TabBarView(children: <Widget>[
                            // All Appointment History
                            studentAppointmentHistoryController
                                    .studentAllAppointmentHistoryListForPagination
                                    .isNotEmpty
                                ? RefreshIndicator(
                                    color: AppColors.primaryColor,
                                    onRefresh: () async {
                                      getMethod(context, "$getStudentAppointmentHistory?page=1", null, true, getAllStudentAppointmentHistoryRepo);
                                    },
                                    child: ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount: studentAppointmentHistoryController
                                        .studentAllAppointmentHistoryListForPagination
                                        .length,
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    padding: const EdgeInsets.only(top: 18),
                                    itemBuilder: (context, index) {
                                      return AppointmentCardWidget(
                                        teacherName:
                                            studentAppointmentHistoryController
                                                .studentAllAppointmentHistoryListForPagination[
                                                    index]
                                                .teacherName
                                                .toString(),
                                        teacherImage:
                                            studentAppointmentHistoryController
                                                        .studentAllAppointmentHistoryListForPagination[
                                                            index]
                                                        .teacherImage ==
                                                    null
                                                ? ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.r),
                                                    child: Image.asset(
                                                      scale: 4.h,
                                                      'assets/images/teacher-image.png',
                                                      fit: BoxFit.cover,
                                                      height: 110.h,
                                                      width: 120.w,
                                                    ))
                                                : ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.r),
                                                    child: Image.network(
                                                      scale: 4.h,
                                                      '$mediaUrl${studentAppointmentHistoryController.studentAllAppointmentHistoryListForPagination[index].teacherImage!}',
                                                      fit: BoxFit.cover,
                                                      height: 110.h,
                                                      width: 120.w,
                                                    ),
                                                  ),
                                        onTap: () {
                                          generalController
                                              .updateSelectedAppointmentHistoryForView(
                                                  studentAppointmentHistoryController
                                                          .studentAllAppointmentHistoryListForPagination[
                                                      index]);
                                          Get.toNamed(PageRoutes
                                              .appointmentHistoryDetailScreen)?.then((value) {
                                            getMethod(context, "$getStudentAppointmentHistory?page=1", null, true, getAllStudentAppointmentHistoryRepo);
                                          });
                                        },
                                        appointmentStatus: Container(
                                          padding: const EdgeInsets.fromLTRB(
                                              5, 2, 5, 2),
                                          decoration: BoxDecoration(
                                              color: studentAppointmentHistoryController
                                                          .studentAllAppointmentHistoryListForPagination[
                                                              index]
                                                          .appointmentStatusCode! ==
                                                      1
                                                  ? AppColors.beigeColor
                                                  : studentAppointmentHistoryController
                                                              .studentAllAppointmentHistoryListForPagination[
                                                                  index]
                                                              .appointmentStatusCode! ==
                                                          5
                                                      ? AppColors.green
                                                          .withOpacity(0.5)
                                                      : studentAppointmentHistoryController
                                                                  .studentAllAppointmentHistoryListForPagination[
                                                                      index]
                                                                  .appointmentStatusCode! ==
                                                              2
                                                          ? AppColors.orange
                                                              .withOpacity(0.7)
                                                          : AppColors
                                                              .primaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Text(
                                            // "Pending",
                                            studentAppointmentHistoryController
                                                .studentAllAppointmentHistoryListForPagination[
                                                    index]
                                                .appointmentStatusName!,
                                            style: AppTextStyles.bodyTextStyle4,
                                          ),
                                        ),
                                        appointmentTypeName:
                                            studentAppointmentHistoryController
                                                .studentAllAppointmentHistoryListForPagination[
                                                    index]
                                                .appointmentTypeName!,
                                        dateAndTime:
                                            '${studentAppointmentHistoryController.studentAllAppointmentHistoryListForPagination[index].date!} \n${studentAppointmentHistoryController.studentAllAppointmentHistoryListForPagination[index].startTime ?? ""} - ${studentAppointmentHistoryController.studentAllAppointmentHistoryListForPagination[index].endTime ?? ""}',
                                      );
                                    },
                                  ),
                                )
                                : RefreshIndicator(
                                    color: AppColors.primaryColor,
                                    onRefresh: () async {
                                      getMethod(context, "$getStudentAppointmentHistory?page=1", null, true, getAllStudentAppointmentHistoryRepo);
                                    },
                                    child: ListView(
                                      physics: const AlwaysScrollableScrollPhysics(),
                                      children: [
                                        SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                                        Center(
                                          child: Text(
                                            LanguageConstant.noDataFound.tr,
                                            style: AppTextStyles.bodyTextStyle13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                            // Pending Appointment History
                            appointmentHistoryWidget(
                                1,
                                studentAppointmentHistoryController,
                                generalController),
                            // Accepted Appointment History
                            appointmentHistoryWidget(
                                2,
                                studentAppointmentHistoryController,
                                generalController),
                            // Rejected Appointment History
                            appointmentHistoryWidget(
                                3,
                                studentAppointmentHistoryController,
                                generalController),
                            // Completed Appointment History
                            appointmentHistoryWidget(
                                5,
                                studentAppointmentHistoryController,
                                generalController),
                          ]),
                        )
                ]),
          ),
        );
      });
    });
  }

  // Appointment History
  Widget appointmentHistoryWidget(
      int statusCode,
      StudentAppointmentHistoryController studentAppointmentHistoryController,
      GeneralController generalController) {
    return studentAppointmentHistoryController
            .studentAllAppointmentHistoryListForPagination
            .where((i) => i.appointmentStatusCode == statusCode)
            .toList()
            .isNotEmpty
        ? RefreshIndicator(
            color: AppColors.primaryColor,
            onRefresh: () async {
              getMethod(context, "$getStudentAppointmentHistory?page=1", null, true, getAllStudentAppointmentHistoryRepo);
            },
            child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            // ignore: iterable_contains_unrelated_type
            itemCount: studentAppointmentHistoryController
                .studentAllAppointmentHistoryListForPagination
                .where((i) => i.appointmentStatusCode == statusCode)
                .toList()
                .length,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.only(top: 18.h),
            itemBuilder: (context, index) {
              return AppointmentCardWidget(
                teacherName: studentAppointmentHistoryController
                        .studentAllAppointmentHistoryListForPagination
                        .where((i) => i.appointmentStatusCode == statusCode)
                        .toList()[index]
                        .teacherName ??
                    "",
                teacherImage: studentAppointmentHistoryController
                            .studentAllAppointmentHistoryListForPagination
                            .where((i) => i.appointmentStatusCode == statusCode)
                            .toList()[index]
                            .teacherImage ==
                        null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: Image.asset(
                          scale: 4.h,
                          'assets/images/teacher-image.png',
                          fit: BoxFit.cover,
                          height: 110.h,
                          width: 120.w,
                        ))
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: Image.network(
                          scale: 4.h,
                          '$mediaUrl${studentAppointmentHistoryController.studentAllAppointmentHistoryListForPagination.where((i) => i.appointmentStatusCode == statusCode).toList()[index].teacherImage!}',
                          fit: BoxFit.cover,
                          height: 110.h,
                          width: 120.w,
                        ),
                      ),
                appointmentTypeName: studentAppointmentHistoryController
                    .studentAllAppointmentHistoryListForPagination
                    .where((i) => i.appointmentStatusCode == statusCode)
                    .toList()[index]
                    .appointmentTypeName!,
                appointmentStatus: Container(
                  padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                  decoration: BoxDecoration(
                      color: studentAppointmentHistoryController
                                  .studentAllAppointmentHistoryListForPagination
                                  .where((i) =>
                                      i.appointmentStatusCode == statusCode)
                                  .toList()[index]
                                  .appointmentStatusCode! ==
                              1
                          ? AppColors.beigeColor
                          : studentAppointmentHistoryController
                                      .studentAllAppointmentHistoryListForPagination
                                      .where((i) =>
                                          i.appointmentStatusCode == statusCode)
                                      .toList()[index]
                                      .appointmentStatusCode! ==
                                  5
                              ? AppColors.green.withOpacity(0.5)
                              : studentAppointmentHistoryController
                                          .studentAllAppointmentHistoryListForPagination
                                          .where((i) =>
                                              i.appointmentStatusCode ==
                                              statusCode)
                                          .toList()[index]
                                          .appointmentStatusCode! ==
                                      2
                                  ? AppColors.orange.withOpacity(0.5)
                                  : AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(5)),
                  child: Text(
                    // statusCode,
                    studentAppointmentHistoryController
                        .studentAllAppointmentHistoryListForPagination
                        .where((i) => i.appointmentStatusCode == statusCode)
                        .toList()[index]
                        .appointmentStatusName!,
                    style: AppTextStyles.bodyTextStyle4,
                  ),
                ),
                dateAndTime:
                    '${studentAppointmentHistoryController.studentAllAppointmentHistoryListForPagination.where((i) => i.appointmentStatusCode == statusCode).toList()[index].date!}\n${studentAppointmentHistoryController.studentAllAppointmentHistoryListForPagination.where((i) => i.appointmentStatusCode == statusCode).toList()[index].startTime ?? ""} - ${studentAppointmentHistoryController.studentAllAppointmentHistoryListForPagination.where((i) => i.appointmentStatusCode == statusCode).toList()[index].endTime ?? ""}',
                onTap: () {
                  generalController.updateSelectedAppointmentHistoryForView(
                      studentAppointmentHistoryController
                          .studentAllAppointmentHistoryListForPagination
                          .where((i) => i.appointmentStatusCode == statusCode)
                          .toList()[index]);
                  Get.toNamed(PageRoutes.appointmentHistoryDetailScreen)?.then((value) {
                    getMethod(context, "$getStudentAppointmentHistory?page=1", null, true, getAllStudentAppointmentHistoryRepo);
                  });
                },
              );
            },
          ),
        )
        : RefreshIndicator(
            color: AppColors.primaryColor,
            onRefresh: () async {
              getMethod(context, "$getStudentAppointmentHistory?page=1", null, true, getAllStudentAppointmentHistoryRepo);
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                Center(
                  child: Text(
                    LanguageConstant.noDataFound.tr,
                    style: AppTextStyles.bodyTextStyle13,
                  ),
                ),
              ],
            ),
          );
  }
}
