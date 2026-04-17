import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:resize/resize.dart';
import '../../multi_language/language_constants.dart';
import '../api_services/urls.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import '../controllers/general_controller.dart';
import '../controllers/academy_reviews_controller.dart';
import '../routes.dart';
import '../widgets/appbar_widget.dart';

import '../widgets/academy_reviews_list_widget.dart';

class AcademyProfileScreen extends StatefulWidget {
  AcademyProfileScreen();

  @override
  State<AcademyProfileScreen> createState() => _AcademyProfileScreenState();
}

class _AcademyProfileScreenState extends State<AcademyProfileScreen> {
  final logic = Get.put(AcademyReviewsController());
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GeneralController>(builder: (generalController) {
      return Scaffold(
        backgroundColor: AppColors.secondaryColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: AppBarWidget(
            titleText: LanguageConstant.academyProfile.tr,
            leadingIcon: "assets/icons/Expand_left.png",
            leadingOnTap: () {
              Get.back();
            },
            appBarColor: AppColors.secondaryColor,
            leadingIconColor: AppColors.white,
            appBarTextStyle: AppTextStyles.appbarTextStyle2,
          ),
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(0, 12.h, 0, 0),
                margin: EdgeInsets.fromLTRB(0, 60.h, 0, 0),
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
                      offset: const Offset(5, 0), // changes position of shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 60.h, 0, 0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        // "Jhon Doe",
                        generalController.selectedAcademyForView.name
                            .toString(),
                        textAlign: TextAlign.start,
                        style: AppTextStyles.bodyTextStyle13,
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Text(
                        // 'jhondoe@gmail.com',
                        "${generalController.selectedAcademyForView.userName}",
                        textAlign: TextAlign.start,
                        style: AppTextStyles.bodyTextStyle9,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                LanguageConstant.followUsOn.tr,
                                // generalController.selectedAcademyForView.name
                                //     .toString(),
                                textAlign: TextAlign.start,
                                style: AppTextStyles.bodyTextStyle13,
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      // await launchUrl(Uri.parse(
                                      //     "${generalController.selectedAcademyForView.academySettings .facebookUrl}"));
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
                                      // await launchUrl(Uri.parse(
                                      //     "${generalController.selectedAcademyForView.academySettings!.instagramUrl}"));
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
                                      // await launchUrl(Uri.parse(
                                      //     "${generalController.selectedAcademyForView.academySettings!.twitterUrl}"));
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
                        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 8.h),
                        child: Divider(
                          height: 1.5.h,
                          color: AppColors.lightGrey,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(16.w, 0.h, 16.w, 8.h),
                        height: 26.h,
                        child: ListView(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          physics: const NeverScrollableScrollPhysics(),
                          children: List.generate(
                              generalController.selectedAcademyForView
                                  .academyCategories!.length, (index1) {
                            return Row(
                              children: [
                                Container(
                                  padding:
                                      EdgeInsets.fromLTRB(12.w, 4.h, 12.w, 4.h),
                                  decoration: BoxDecoration(
                                      color: AppColors.primaryColor
                                          .withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(40)),
                                  child: Text(
                                    "${generalController.selectedAcademyForView.academyCategories![index1].name}",
                                    textAlign: TextAlign.start,
                                    style: AppTextStyles.bodyTextStyle2,
                                  ),
                                ),
                                SizedBox(width: 8.w),
                              ],
                            );
                          }),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
                        child: generalController
                                    .selectedAcademyForView.description !=
                                null
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(LanguageConstant.about.tr,
                                      style: AppTextStyles.bodyTextStyle13),
                                  SizedBox(height: 12.h),
                                  Text(
                                      '${generalController.selectedAcademyForView.description}',
                                      style: AppTextStyles.bodyTextStyle7),
                                ],
                              )
                            : Center(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 50, 0, 0),
                                  child: Text(
                                    LanguageConstant.noDataFound.tr,
                                    style: AppTextStyles.bodyTextStyle13,
                                  ),
                                ),
                              ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 12.h),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.25),
                              spreadRadius: 2,
                              blurRadius: 10,
                              offset:
                                  Offset(0, 0), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            RatingBar.builder(
                              initialRating: generalController
                                  .selectedAcademyForView.rating!
                                  .toDouble(),
                              minRating: 1,
                              itemSize: 15.h,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              ignoreGestures: true,
                              itemPadding:
                                  const EdgeInsets.symmetric(horizontal: 0.0),
                              itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (double value) {},
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              // '4.5',
                              "${LanguageConstant.rating.tr} (${generalController.selectedAcademyForView.rating!})",
                              textAlign: TextAlign.start,
                              style: AppTextStyles.bodyTextStyle6,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              LanguageConstant.associatedTutors.tr,
                              style: AppTextStyles.bodyTextStyle13,
                            ),
                          ],
                        ),
                      ),
                      generalController.selectedAcademyForView.academyTeachers!
                              .isNotEmpty
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AspectRatio(
                                  aspectRatio: 3 / 1.69,
                                  child: ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemCount: generalController
                                        .selectedAcademyForView
                                        .academyTeachers!
                                        .length,
                                    padding:
                                        const EdgeInsets.fromLTRB(18, 0, 18, 0),
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          generalController
                                              .updateSelectedTeacherForView(
                                                  generalController
                                                      .selectedAcademyForView
                                                      .academyTeachers![index]);
                                          Get.toNamed(
                                              PageRoutes.teacherProfileScreen);
                                        },
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                              child: generalController
                                                          .selectedAcademyForView
                                                          .academyTeachers![
                                                              index]
                                                          .image !=
                                                      null
                                                  ? Image(
                                                      image: NetworkImage(
                                                          "$mediaUrl${generalController.selectedAcademyForView.academyTeachers![index].image}"),
                                                      height: 150.h,
                                                    )
                                                  : Image(
                                                      image: const AssetImage(
                                                          'assets/images/events-image-2.png'),
                                                      height: 150.h,
                                                    ),
                                            ),
                                            const SizedBox(height: 12),
                                            Text(
                                              generalController
                                                  .selectedAcademyForView
                                                  .academyTeachers![index]
                                                  .name!,
                                              style:
                                                  AppTextStyles.bodyTextStyle2,
                                            ),
                                            const SizedBox(height: 6),
                                            SizedBox(
                                              height: 10.h,
                                              child: ListView(
                                                shrinkWrap: true,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                children: List.generate(
                                                    generalController
                                                        .selectedAcademyForView
                                                        .academyTeachers![index]
                                                        .teacherCategories!
                                                        .length, (index1) {
                                                  return Text(
                                                    generalController
                                                            .selectedAcademyForView
                                                            .academyTeachers![
                                                                index]
                                                            .teacherCategories!
                                                            .isNotEmpty
                                                        ? "${generalController.selectedAcademyForView.academyTeachers![index].teacherCategories![index1].name} | "
                                                        : "",
                                                    // "Category",
                                                    textAlign: TextAlign.start,
                                                    style: AppTextStyles
                                                        .bodyTextStyle3,
                                                  );
                                                }),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    separatorBuilder: (context, position) {
                                      return SizedBox(width: 18.w);
                                    },
                                  ),
                                ),
                              ],
                            )
                          : const Text(
                              "No Data Found",
                              style: AppTextStyles.bodyTextStyle13,
                            ),
                      DefaultTabController(
                          length: 2, // length of tabs
                          initialIndex: 0,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Theme(
                                  data: ThemeData().copyWith(
                                      dividerColor: AppColors.primaryColor),
                                  child: TabBar(
                                    labelColor: AppColors.white,
                                    unselectedLabelColor:
                                        AppColors.secondaryColor,
                                    dividerColor: AppColors.transparent,
                                    padding:
                                        EdgeInsets.fromLTRB(8.w, 6.h, 8.w, 6.h),
                                    labelPadding: EdgeInsets.zero,
                                    indicatorPadding:
                                        EdgeInsets.fromLTRB(2.w, 8.h, 2.w, 8.h),
                                    indicatorSize: TabBarIndicatorSize.tab,
                                    labelStyle: AppTextStyles.buttonTextStyle2,
                                    unselectedLabelStyle:
                                        AppTextStyles.buttonTextStyle7,
                                    indicator: BoxDecoration(
                                        gradient: AppColors.gradientOne,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    tabs: const [
                                      Tab(text: 'About'),
                                      Tab(text: 'Reviews'),
                                    ],
                                  ),
                                ),
                                Container(
                                    height: 400,
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        top: BorderSide(
                                            color: AppColors.primaryColor,
                                            width: 1),
                                      ),
                                    ),
                                    child: TabBarView(children: <Widget>[
                                      // About
                                      Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            18, 12, 18, 18),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                'About ${generalController.selectedAcademyForView.name}',
                                                style: AppTextStyles
                                                    .bodyTextStyle2),
                                            const SizedBox(height: 14),
                                            Text(
                                                '${generalController.selectedAcademyForView.description}',
                                                style: AppTextStyles
                                                    .bodyTextStyle7),
                                          ],
                                        ),
                                      ),
                                      // Reviews
                                      AcademyReviewsListWidget(
                                        academyReviewsSlug:
                                            '${generalController.selectedAcademyForView.userName}',
                                      ),
                                    ]))
                              ])),
                    ],
                  ),
                ),
              ),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: generalController.selectedAcademyForView.image != null
                      ? Image(
                          image: NetworkImage(
                            "$mediaUrl${generalController.selectedAcademyForView.image}",
                          ),
                          height: 120.h,
                        )
                      : Image(
                          image: const AssetImage(
                              'assets/images/teacher-image.png'),
                          height: 120.h,
                        ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
