import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resize/resize.dart';
import 'package:tutorhub_for_students/multi_language/language_constants.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import '../controllers/general_controller.dart';
import '../controllers/teacher_appointment_types_controller.dart';
import '../controllers/search_controller.dart';
import '../routes.dart';
import '../widgets/appbar_widget.dart';
import '../widgets/home_all_teachers_list_widget.dart';
import '../widgets/home_banner_slider_widget.dart';
import '../widgets/home_buy_services_list_widget.dart';
import '../widgets/home_categories_list_widget.dart';
import '../widgets/home_academies_list_widget.dart';
import '../widgets/home_featured_teachers_list_widget.dart';
import '../widgets/home_top_rated_teachers_list_widget.dart';
import '../widgets/home_upcoming_events_list_widget.dart';
import '../widgets/search_filter_widget.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback allCategoryOnTap, allTutorsOnTap, searchOnTap;
  const HomeScreen(
      {super.key,
      required this.allCategoryOnTap,
      required this.searchOnTap,
      required this.allTutorsOnTap});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int isTeacherListSelected = 0;

  final teacherAppointmentTypeslogic =
      Get.put(TeacherAppointmentTypesController());

  @override
  void initState() {
    // Get.find<SearchBarController>().searchTextController.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GeneralController>(builder: (generalController) {
      return Scaffold(
        backgroundColor: AppColors.bgColorTwo,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(150.h),
          child: Stack(
            children: [
              AppBarWidgetTwo(
                leadingIcon: "assets/icons/Sort.png",
                leadingOnTap: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
              Padding(
                padding: EdgeInsets.only(top: 155.h),
                child: Container(
                  height: 40.h,
                  decoration: const BoxDecoration(color: AppColors.bgColorTwo),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 120.h),
                child: SearchFilterWidget(
                  onSearchTap: widget.searchOnTap,
                  controller:
                      Get.find<SearchBarController>().searchTextController,
                  hintText: LanguageConstant.searchYourTutor.tr,
                ),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      LanguageConstant.categories.tr,
                      style: AppTextStyles.headingTextStyle1,
                    ),
                    GestureDetector(
                      onTap: widget.allCategoryOnTap,
                      child: Text(
                        LanguageConstant.seeAll.tr,
                        style: AppTextStyles.headingTextStyle2,
                      ),
                    ),
                  ],
                ),
              ),
              HomeCategoriesListWidget(),
              Padding(
                padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      LanguageConstant.premierTutors.tr,
                      style: AppTextStyles.headingTextStyle1,
                    ),
                    GestureDetector(
                      onTap: widget.allTutorsOnTap,
                      child: Text(
                        LanguageConstant.seeAll.tr,
                        style: AppTextStyles.headingTextStyle2,
                      ),
                    ),
                  ],
                ),
              ),
              HomePremierTeacherSliderWidget(),
              Padding(
                padding: EdgeInsets.fromLTRB(18.w, 0, 18.w, 14.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LanguageConstant.findYourTutor.tr,
                      style: AppTextStyles.headingTextStyle1,
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        isTeacherListSelected == 0
                            ? Container(
                                padding:
                                    EdgeInsets.fromLTRB(18.w, 8.h, 18.w, 8.h),
                                decoration: BoxDecoration(
                                    color: AppColors.primaryColor,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Text(
                                  LanguageConstant.all.tr,
                                  style: AppTextStyles.buttonTextStyle2,
                                ),
                              )
                            : GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isTeacherListSelected = 0;
                                  });
                                },
                                child: Container(
                                  padding:
                                      EdgeInsets.fromLTRB(18.w, 8.h, 18.w, 8.h),
                                  decoration: BoxDecoration(
                                      color: AppColors.primaryColor
                                          .withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Text(
                                    LanguageConstant.all.tr,
                                    style: AppTextStyles.buttonTextStyle3,
                                  ),
                                ),
                              ),
                        SizedBox(width: 10.w),
                        isTeacherListSelected == 1
                            ? Container(
                                padding:
                                    EdgeInsets.fromLTRB(18.w, 8.h, 18.w, 8.h),
                                decoration: BoxDecoration(
                                    color: AppColors.primaryColor,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Text(
                                  LanguageConstant.topRated.tr,
                                  style: AppTextStyles.buttonTextStyle2,
                                ),
                              )
                            : GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isTeacherListSelected = 1;
                                  });
                                },
                                child: Container(
                                  padding:
                                      EdgeInsets.fromLTRB(18.w, 8.h, 18.w, 8.h),
                                  decoration: BoxDecoration(
                                      color: AppColors.primaryColor
                                          .withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Text(
                                    LanguageConstant.topRated.tr,
                                    style: AppTextStyles.buttonTextStyle3,
                                  ),
                                ),
                              ),
                        SizedBox(width: 10.w),
                        isTeacherListSelected == 2
                            ? Container(
                                padding:
                                    EdgeInsets.fromLTRB(18.w, 8.h, 18.w, 8.h),
                                decoration: BoxDecoration(
                                    color: AppColors.primaryColor,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Text(
                                  LanguageConstant.featured.tr,
                                  style: AppTextStyles.buttonTextStyle2,
                                ),
                              )
                            : GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isTeacherListSelected = 2;
                                  });
                                },
                                child: Container(
                                  padding:
                                      EdgeInsets.fromLTRB(18.w, 8.h, 18.w, 8.h),
                                  decoration: BoxDecoration(
                                      color: AppColors.primaryColor
                                          .withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Text(
                                    LanguageConstant.featured.tr,
                                    style: AppTextStyles.buttonTextStyle3,
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ],
                ),
              ),
              isTeacherListSelected == 0
                  ? const HomeAllTeachersListWidget()
                  : isTeacherListSelected == 1
                      ? const HomeTopRatedTeachersListWidget()
                      : isTeacherListSelected == 2
                          ? const HomeFeaturedTeachersListWidget()
                          : SizedBox(
                              child: Center(
                                child: Text(
                                  LanguageConstant.noDataFound.tr,
                                  style: AppTextStyles.bodyTextStyle13,
                                ),
                              ),
                            ),
              Padding(
                padding: EdgeInsets.fromLTRB(18.w, 10.h, 18.w, 14.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      LanguageConstant.findAcademies.tr,
                      style: AppTextStyles.headingTextStyle1,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(PageRoutes.academiesScreen);
                      },
                      child: Text(
                        LanguageConstant.seeAll.tr,
                        style: AppTextStyles.headingTextStyle2,
                      ),
                    ),
                  ],
                ),
              ),
              const HomeAcademiesListWidget(),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 20, 18, 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      LanguageConstant.quickBuyServices.tr,
                      style: AppTextStyles.headingTextStyle1,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(PageRoutes.servicesScreen);
                      },
                      child: Text(
                        LanguageConstant.seeAll.tr,
                        style: AppTextStyles.headingTextStyle2,
                      ),
                    ),
                  ],
                ),
              ),
              const HomeBuyServicesListWidget(),
              Padding(
                padding: EdgeInsets.fromLTRB(18.w, 10.h, 18.w, 14.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      LanguageConstant.upcomingEvents.tr,
                      style: AppTextStyles.headingTextStyle1,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(PageRoutes.eventsScreen);
                      },
                      child: Text(
                        LanguageConstant.seeAll.tr,
                        style: AppTextStyles.headingTextStyle2,
                      ),
                    ),
                  ],
                ),
              ),
              const HomeUpcomingEventsListWidget(),
              SizedBox(height: 10.h)
            ],
          ),
        ),
      );
    });
  }
}
