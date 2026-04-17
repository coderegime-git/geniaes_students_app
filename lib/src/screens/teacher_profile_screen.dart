import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:resize/resize.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../multi_language/language_constants.dart';
import '../api_services/get_service.dart';
import '../api_services/urls.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import '../controllers/general_controller.dart';
import '../controllers/teacher_appointment_types_controller.dart';
import '../controllers/teacher_book_appointment_controller.dart';
import '../repositories/teacher_appointment_types_repo.dart';
import '../routes.dart';
import '../widgets/appbar_widget.dart';
import '../widgets/button_widget.dart';
import '../widgets/teacher_broadcasts_list_widget.dart';
import '../widgets/teacher_podcasts_list_widget.dart';
import '../widgets/teacher_reviews_list_widget.dart';

class TeacherProfileScreen extends StatefulWidget {
  TeacherProfileScreen();

  @override
  State<TeacherProfileScreen> createState() => _TeacherProfileScreenState();
}

class _TeacherProfileScreenState extends State<TeacherProfileScreen> {
  final teacherBookAppointmentlogic =
      Get.put(TeacherAppointmentScheduleController());
  final teacherAppointmentTypeslogic =
      Get.put(TeacherAppointmentTypesController());
  @override
  void initState() {
    super.initState();
    // /isabellacarrington/appointment_types
    // Get Teacher Appointment Types API Call
    print(
        "${Get.find<GeneralController>().selectedTeacherForView.userName} TeacherUsername");
    getMethod(
        context,
        '$getTeacherAppointmentTypes${Get.find<GeneralController>().selectedTeacherForView.userName}/appointment_types',
        null,
        false,
        getTeacherAppointmentTypesRepo);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GeneralController>(builder: (generalController) {
      return GetBuilder<TeacherAppointmentTypesController>(
          builder: (teacherAppointmentTypesController) {
        return Scaffold(
          backgroundColor: AppColors.bgColorTwo,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(56),
            child: AppBarWidget(
              titleText: LanguageConstant.tutorProfile.tr,
              leadingIcon: "assets/icons/Expand_left.png",
              leadingOnTap: () {
                Get.back();
              },
            ),
          ),
          body: !teacherAppointmentTypesController.teacherAppointmentTypesLoader
              ? const Center(
                  child: CircularProgressIndicator(
                    backgroundColor: AppColors.transparent,
                    color: AppColors.primaryColor,
                  ),
                )
              : SingleChildScrollView(
                  child: Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(0.w, 0.h, 0.w, 0.h),
                        child: ClipRRect(
                          child:
                              generalController.selectedTeacherForView.image !=
                                      null
                                  ? Image(
                                      image: NetworkImage(
                                        "$mediaUrl${generalController.selectedTeacherForView.image}",
                                      ),
                                      height: 350.h,
                                      width: MediaQuery.of(context).size.width,
                                      fit: BoxFit.cover,
                                    )
                                  : Image(
                                      image: const AssetImage(
                                          'assets/images/teacher-image.png'),
                                      height: 350.h,
                                      width: MediaQuery.of(context).size.width,
                                      fit: BoxFit.cover,
                                    ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 240.h, 0, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 12.h, 0, 0),
                              decoration: BoxDecoration(
                                color: AppColors.bgColorTwo,
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(40),
                                  topLeft: Radius.circular(40),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.4),
                                    spreadRadius: 0.5,
                                    blurRadius: 8,
                                    offset: Offset(
                                        5, 0), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 40.h,
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount:
                                            teacherAppointmentTypesController
                                                .getTeacherAppointmentTypesModel
                                                .data!
                                                .length,
                                        scrollDirection: Axis.horizontal,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              ButtonWidgetOne(
                                                borderRadius: 40,
                                                buttonColor:
                                                    AppColors.gradientOne,
                                                buttonText:
                                                    teacherAppointmentTypesController
                                                        .getTeacherAppointmentTypesModel
                                                        .data![index]
                                                        .displayName
                                                        .toString(),
                                                buttonTextStyle: AppTextStyles
                                                    .buttonTextStyle5,
                                                onTap:
                                                    Get.find<GeneralController>()
                                                                .storageBox
                                                                .read(
                                                                    'authToken') !=
                                                            null
                                                        ? () {
                                                            // Get.toNamed(PageRoutes
                                                            //     .videoCallAppointmentScreen);
                                                            teacherAppointmentTypesController
                                                                        .getTeacherAppointmentTypesModel
                                                                        .data![
                                                                            index]
                                                                        .id ==
                                                                    1
                                                                ? Get.toNamed(
                                                                    PageRoutes
                                                                        .callAppointmentScreen,
                                                                    parameters: {
                                                                        "appointmentTypeId": teacherAppointmentTypesController
                                                                            .getTeacherAppointmentTypesModel
                                                                            .data![index]
                                                                            .id!
                                                                            .toString(),
                                                                        "screenTitle": LanguageConstant
                                                                            .videoCallAppointmet
                                                                            .tr,
                                                                      })
                                                                : teacherAppointmentTypesController
                                                                            .getTeacherAppointmentTypesModel
                                                                            .data![
                                                                                index]
                                                                            .id ==
                                                                        2
                                                                    ? Get.toNamed(
                                                                        PageRoutes
                                                                            .callAppointmentScreen,
                                                                        parameters: {
                                                                            "appointmentTypeId":
                                                                                teacherAppointmentTypesController.getTeacherAppointmentTypesModel.data![index].id!.toString(),
                                                                            "screenTitle":
                                                                                LanguageConstant.audioCallAppointmet.tr,
                                                                          })
                                                                    : teacherAppointmentTypesController.getTeacherAppointmentTypesModel.data![index].id ==
                                                                            3
                                                                        ? Get.toNamed(
                                                                            PageRoutes.chatAppointmentScreen,
                                                                            parameters: {
                                                                                "appointmentTypeId": teacherAppointmentTypesController.getTeacherAppointmentTypesModel.data![index].id!.toString(),
                                                                                "screenTitle": LanguageConstant.chatAppointmet.tr,
                                                                              })
                                                                        : '';
                                                          }
                                                        : () {
                                                            generalController
                                                                .showMessageDialog(
                                                                    context);
                                                          },
                                              ),
                                              SizedBox(
                                                width: 14.w,
                                              )
                                            ],
                                          );
                                        }),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        16.w, 16.h, 16.w, 8.h),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                // "Jhon Doe",
                                                generalController
                                                    .selectedTeacherForView.name
                                                    .toString(),
                                                textAlign: TextAlign.start,
                                                style: AppTextStyles
                                                    .bodyTextStyle13,
                                              ),
                                              SizedBox(
                                                height: 5.h,
                                              ),
                                              Text(
                                                // 'jhondoe@gmail.com',
                                                "${generalController.selectedTeacherForView.userName}",
                                                textAlign: TextAlign.start,
                                                style: AppTextStyles
                                                    .bodyTextStyle9,
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () async {
                                                  await launchUrl(Uri.parse(
                                                      "${generalController.selectedTeacherForView.teacherSettings!.facebookUrl}"));
                                                },
                                                child: Image.asset(
                                                  "assets/icons/icon_Facebook_F_.png",
                                                  color: AppColors.primaryColor,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10.w,
                                              ),
                                              GestureDetector(
                                                onTap: () async {
                                                  await launchUrl(Uri.parse(
                                                      "${generalController.selectedTeacherForView.teacherSettings!.instagramUrl}"));
                                                },
                                                child: Image.asset(
                                                  "assets/icons/icon_Instagram_.png",
                                                  color: AppColors.primaryColor,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10.w,
                                              ),
                                              GestureDetector(
                                                onTap: () async {
                                                  await launchUrl(Uri.parse(
                                                      "${generalController.selectedTeacherForView.teacherSettings!.twitterUrl}"));
                                                },
                                                child: Image.asset(
                                                  "assets/icons/icon_Twitter_.png",
                                                  color: AppColors.primaryColor,
                                                ),
                                              ),
                                            ],
                                          )
                                        ]),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        16.w, 8.h, 16.w, 8.h),
                                    child: Divider(
                                      height: 1.5.h,
                                      color: AppColors.lightGrey,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        16.w, 0.h, 16.w, 8.h),
                                    height: 26.h,
                                    child: ListView(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                      children: List.generate(
                                          generalController
                                              .selectedTeacherForView
                                              .teacherCategories!
                                              .length, (index1) {
                                        return Row(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  12.w, 4.h, 12.w, 4.h),
                                              decoration: BoxDecoration(
                                                  color: AppColors.primaryColor
                                                      .withOpacity(0.2),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          40)),
                                              child: Text(
                                                "${generalController.selectedTeacherForView.teacherCategories![index1].name}",
                                                textAlign: TextAlign.start,
                                                style: AppTextStyles
                                                    .bodyTextStyle2,
                                              ),
                                            ),
                                            SizedBox(width: 8.w),
                                          ],
                                        );
                                      }),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.fromLTRB(
                                        18, 12, 18, 18),
                                    child: generalController
                                                .selectedTeacherForView
                                                .description !=
                                            null
                                        ? Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(LanguageConstant.about.tr,
                                                  style: AppTextStyles
                                                      .bodyTextStyle13),
                                              SizedBox(height: 12.h),
                                              Text(
                                                  '${generalController.selectedTeacherForView.description}',
                                                  style: AppTextStyles
                                                      .bodyTextStyle7),
                                            ],
                                          )
                                        : Center(
                                            child: Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  0, 50.h, 0, 0),
                                              child: Text(
                                                LanguageConstant.noDataFound.tr,
                                                style: AppTextStyles
                                                    .bodyTextStyle13,
                                              ),
                                            ),
                                          ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(
                                        12.w, 12.h, 12.w, 12.h),
                                    decoration: BoxDecoration(
                                      color: AppColors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.25),
                                          spreadRadius: 2,
                                          blurRadius: 10,
                                          offset: Offset(0,
                                              0), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        RatingBar.builder(
                                          initialRating: generalController
                                              .selectedTeacherForView.rating!
                                              .toDouble(),
                                          minRating: 1,
                                          itemSize: 15.h,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          ignoreGestures: true,
                                          itemPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 0.0),
                                          itemBuilder: (context, _) =>
                                              const Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          onRatingUpdate: (double value) {},
                                        ),
                                        SizedBox(height: 10.h),
                                        Text(
                                          // '4.5',
                                          "${LanguageConstant.rating.tr} (${generalController.selectedTeacherForView.rating!})",
                                          textAlign: TextAlign.start,
                                          style: AppTextStyles.bodyTextStyle6,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10.h),
                                  DefaultTabController(
                                    length: 3, // length of tabs
                                    initialIndex: 0,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: <Widget>[
                                        TabBar(
                                          labelColor: AppColors.white,
                                          unselectedLabelColor:
                                              AppColors.secondaryColor,
                                          dividerColor: AppColors.transparent,
                                          padding: EdgeInsets.fromLTRB(
                                              8.w, 6.h, 8.w, 6.h),
                                          labelPadding: EdgeInsets.zero,
                                          indicatorPadding: EdgeInsets.fromLTRB(
                                              2.w, 8.h, 2.w, 8.h),
                                          indicatorSize:
                                              TabBarIndicatorSize.tab,
                                          labelStyle:
                                              AppTextStyles.buttonTextStyle2,
                                          unselectedLabelStyle:
                                              AppTextStyles.buttonTextStyle7,
                                          indicator: BoxDecoration(
                                              gradient: AppColors.gradientOne,
                                              borderRadius:
                                                  BorderRadius.circular(40)),
                                          tabs: [
                                            Tab(
                                                text: LanguageConstant
                                                    .reviews.tr),
                                            Tab(
                                                text: LanguageConstant
                                                    .podcast.tr),
                                            Tab(
                                                text: LanguageConstant
                                                    .broadcast.tr),
                                          ],
                                        ),
                                        Container(
                                            height: 400,
                                            decoration: const BoxDecoration(
                                              border: Border(
                                                top: BorderSide(
                                                    color:
                                                        AppColors.primaryColor,
                                                    width: 1),
                                              ),
                                            ),
                                            child:
                                                TabBarView(children: <Widget>[
                                              // Reviews
                                              TeacherReviewsListWidget(
                                                teacherReviewsSlug:
                                                    '${generalController.selectedTeacherForView.userName}',
                                              ),
                                              // Podcasts
                                              TeacherPodcastsListWidget(
                                                teacherPodcastsSlug:
                                                    '${generalController.selectedTeacherForView.userName}',
                                              ),
                                              // Broadcasts
                                              TeacherBroadcastsListWidget(
                                                teacherBroadcastsSlug:
                                                    '${generalController.selectedTeacherForView.userName}',
                                              ),
                                            ]))
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        );
      });
    });
  }
}
