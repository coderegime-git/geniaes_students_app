import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resize/resize.dart';
import '../../multi_language/language_constants.dart';
import '../api_services/post_service.dart';
import '../api_services/urls.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import '../controllers/all_teachers_controller.dart';
import '../controllers/general_controller.dart';
import '../controllers/search_controller.dart';
import '../repositories/all_teachers_repo.dart';
import '../routes.dart';
import '../widgets/appbar_widget.dart';
import '../widgets/button_widget.dart';
import '../widgets/custom_skeleton_loader.dart';
import '../widgets/search_filter_widget.dart';
import '../widgets/teacher_card_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final logic = Get.put(AllTeachersController());

  @override
  void initState() {
    super.initState();
    if (Get.find<AllTeachersController>().teacherListForPagination.isEmpty) {
      Get.find<AllTeachersController>().updateTeachersLoader(false);
      postMethod(
          context, '$getAllTeachers?page=1', null, false, getAllTeachersRepo);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GeneralController>(builder: (generalController) {
      return GetBuilder<AllTeachersController>(
          builder: (allTeachersController) {
        return WillPopScope(
          onWillPop: () async => false,
          child: !allTeachersController.allTeachersLoader
              ? CustomVerticalSkeletonLoader(
                  height: 200.h,
                  highlightColor: AppColors.grey,
                  seconds: 2,
                  totalCount: 5,
                  width: 140.w,
                )
              : Scaffold(
                  backgroundColor: AppColors.bgColorTwo,
                  appBar: PreferredSize(
                    preferredSize: Size.fromHeight(56.h),
                    child: AppBarWidget(
                      titleText: "Tutors",
                      leadingIcon: "assets/icons/Expand_left.png",
                      leadingOnTap: () {
                        setState(() {
                          generalController.isSearchOn = false;
                        });
                        Get.find<SearchBarController>()
                            .searchTextController
                            .clear();
                        postMethod(
                            context,
                            getAllTeachers,
                            {
                              'search': Get.find<SearchBarController>()
                                  .searchTextController
                                  .text
                            },
                            false,
                            getAllSearchedTeachersRepo);

                        Get.back();
                      },
                    ),
                  ),
                  body: SingleChildScrollView(
                    child: Column(
                      children: [
                        SearchFilterWidget(
                          onSearchTap: () {
                            postMethod(
                                context,
                                getAllTeachers,
                                {
                                  'search': Get.find<SearchBarController>()
                                      .searchTextController
                                      .text
                                },
                                false,
                                getAllSearchedTeachersRepo);
                          },
                          controller: Get.find<SearchBarController>()
                              .searchTextController,
                          hintText: LanguageConstant.searchYourTutor.tr,
                        ),
                        SizedBox(height: 18.h),
                        allTeachersController
                                .teacherListForPagination.isNotEmpty
                            ? ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: allTeachersController
                                    .teacherListForPagination.length,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return TeacherCardWidget(
                                    teacherImage: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: allTeachersController
                                                  .teacherListForPagination[
                                                      index]
                                                  .image
                                                  ?.length !=
                                              null
                                          ? Image(
                                              image: NetworkImage(
                                                  "$mediaUrl${allTeachersController.teacherListForPagination[index].image}"),
                                              height: 110.h,
                                            )
                                          : Image(
                                              image: const AssetImage(
                                                  'assets/images/teacher-image.png'),
                                              height: 110.h,
                                            ),
                                    ),
                                    teacherName:
                                        "${allTeachersController.teacherListForPagination[index].name}",
                                    categories: SizedBox(
                                      height: 16.h,
                                      child: ListView(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        children: List.generate(
                                          allTeachersController
                                              .teacherListForPagination[index]
                                              .teacherCategories!
                                              .length,
                                          (index1) {
                                            return Text(
                                              "${allTeachersController.teacherListForPagination[index].teacherCategories![index1].name} | ",
                                              textAlign: TextAlign.start,
                                              style:
                                                  AppTextStyles.bodyTextStyle3,
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    teacherRating:
                                        "(${allTeachersController.teacherListForPagination[index].rating})",
                                    initRating: allTeachersController
                                        .teacherListForPagination[index].rating!
                                        .toDouble(),
                                    onTap: () {
                                      generalController
                                          .updateSelectedTeacherForView(
                                              allTeachersController
                                                      .teacherListForPagination[
                                                  index]);

                                      Get.toNamed(
                                          PageRoutes.teacherProfileScreen);
                                    },
                                  );
                                })
                            : SizedBox(
                                height: 120.h,
                                child: const Center(
                                  child: Text(
                                    "No Data Found",
                                    style: AppTextStyles.bodyTextStyle13,
                                  ),
                                ),
                              ),

                        // allTeachersController
                        //         .teacherListForPagination.isNotEmpty
                        allTeachersController.teacherListForPagination.length >=
                                allTeachersController
                                    .getAllTeachersModel.data!.meta!.perPage!
                            ? allTeachersController
                                        .teacherListForPagination.length ==
                                    allTeachersController
                                        .getAllTeachersModel.data!.data!.length
                                ? Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 18),
                                    width:
                                        MediaQuery.of(context).size.width * .35,
                                    child: generalController
                                            .getPaginationProgressCheck
                                        ? Container(
                                            height: generalController
                                                    .getPaginationProgressCheck
                                                ? 50.0
                                                : 0,
                                            color: Colors.transparent,
                                            child: const Center(
                                              child: CircularProgressIndicator(
                                                color: AppColors.primaryColor,
                                              ),
                                            ),
                                          )
                                        : ButtonWidgetOne(
                                            buttonText:
                                                LanguageConstant.loadMore.tr,
                                            onTap: () {
                                              allTeachersController
                                                  .paginationDataLoad(context);
                                            },
                                            buttonTextStyle:
                                                AppTextStyles.buttonTextStyle1,
                                            borderRadius: 40,
                                            buttonColor: AppColors.gradientOne,
                                          ))
                                : const SizedBox()
                            : const SizedBox(),
                      ],
                    ),
                  ),
                ),
        );
      });
    });
  }
}
