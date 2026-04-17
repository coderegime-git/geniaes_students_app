import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resize/resize.dart';
import '../../multi_language/language_constants.dart';
import '../api_services/post_service.dart';
import '../api_services/urls.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import '../controllers/general_controller.dart';
import '../controllers/teachers_by_category_controller.dart';
import '../controllers/search_controller.dart';
import '../repositories/teachers_by_category_repo.dart';
import '../routes.dart';
import '../widgets/appbar_widget.dart';
import '../widgets/button_widget.dart';
import '../widgets/custom_skeleton_loader.dart';
import '../widgets/search_filter_widget.dart';
import '../widgets/teacher_card_widget.dart';

class TeachersByCategoryScreen extends StatefulWidget {
  const TeachersByCategoryScreen({
    super.key,
  });

  @override
  State<TeachersByCategoryScreen> createState() =>
      _TeachersByCategoryScreenState();
}

class _TeachersByCategoryScreenState extends State<TeachersByCategoryScreen> {
  final logic = Get.put(TeachersByCategoryController());
  String? subCategorySlug = Get.parameters["subCategorySlug"];
  String? subCategoryName = Get.parameters["subCategoryName"];
  @override
  void initState() {
    super.initState();
    postMethod(context, '$getTeachersByCategory$subCategorySlug', null, false,
        getTeachersByCategoryRepo);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GeneralController>(builder: (generalController) {
      return GetBuilder<TeachersByCategoryController>(
          builder: (teacherByCategoryController) {
        return Scaffold(
          backgroundColor: AppColors.bgColorTwo,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(56),
            child: AppBarWidget(
              titleText: subCategoryName!,
              leadingIcon: "assets/icons/Expand_left.png",
              leadingOnTap: () {
                Get.back();
              },
            ),
          ),
          body: SingleChildScrollView(
            child: !teacherByCategoryController.teacherByCategoryLoader
                ? CustomVerticalSkeletonLoader(
                    height: 200.h,
                    highlightColor: AppColors.grey,
                    seconds: 2,
                    totalCount: 5,
                    width: 140.w,
                  )
                : Column(
                    children: [
                      SizedBox(height: 18.h),
                      SearchFilterWidget(
                        onSearchTap: () {},
                        controller: Get.find<SearchBarController>()
                            .searchTextController,
                        hintText: LanguageConstant.searchYourTutor.tr,
                      ),
                      SizedBox(height: 18.h),
                      ...List.generate(
                          teacherByCategoryController
                              .getAllTeachersModel.data!.data!.length, (index) {
                        return TeacherCardWidget(
                          teacherImage: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: teacherByCategoryController
                                        .teacherListForPagination[index]
                                        .image
                                        ?.length !=
                                    null
                                ? Image(
                                    image: NetworkImage(
                                        "$mediaUrl${teacherByCategoryController.teacherListForPagination[index].image}"),
                                    height: 110.h,
                                  )
                                : Image(
                                    image: const AssetImage(
                                        'assets/images/teacher-image.png'),
                                    height: 110.h,
                                  ),
                          ),
                          teacherName:
                              "${teacherByCategoryController.teacherListForPagination[index].name}",
                          categories: SizedBox(
                            height: 16.h,
                            child: ListView(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              physics: const NeverScrollableScrollPhysics(),
                              children: List.generate(
                                teacherByCategoryController
                                    .teacherListForPagination[index]
                                    .teacherCategories!
                                    .length,
                                (index1) {
                                  return Text(
                                    "${teacherByCategoryController.teacherListForPagination[index].teacherCategories![index1].name} | ",
                                    textAlign: TextAlign.start,
                                    style: AppTextStyles.bodyTextStyle3,
                                  );
                                },
                              ),
                            ),
                          ),
                          teacherRating:
                              "(${teacherByCategoryController.teacherListForPagination[index].rating})",
                          initRating: teacherByCategoryController
                              .teacherListForPagination[index].rating!
                              .toDouble(),
                          onTap: () {
                            generalController.updateSelectedTeacherForView(
                                teacherByCategoryController
                                    .teacherListForPagination[index]);

                            Get.toNamed(PageRoutes.teacherProfileScreen);
                          },
                        );
                      }),

                      // teacherByCategoryController
                      //         .teacherListForPagination.isNotEmpty
                      teacherByCategoryController
                                  .teacherListForPagination.length ==
                              teacherByCategoryController
                                  .getAllTeachersModel.data!.data!.length
                          ? Container(
                              margin: const EdgeInsets.fromLTRB(0, 0, 0, 18),
                              width: MediaQuery.of(context).size.width * .35,
                              child: generalController
                                      .getPaginationProgressCheck
                                  ? Container(
                                      height: generalController
                                              .getPaginationProgressCheck
                                          ? 50.0
                                          : 0,
                                      color: AppColors.transparent,
                                      child: const Center(
                                        child: CircularProgressIndicator(
                                          color: AppColors.primaryColor,
                                        ),
                                      ),
                                    )
                                  : ButtonWidgetOne(
                                      buttonText: LanguageConstant.loadMore.tr,
                                      onTap: () {
                                        teacherByCategoryController
                                            .paginationDataLoad(context);
                                      },
                                      buttonTextStyle:
                                          AppTextStyles.buttonTextStyle1,
                                      borderRadius: 40,
                                      buttonColor: AppColors.gradientOne,
                                    ))
                          : const SizedBox(),
                    ],
                  ),
          ),
        );
      });
    });
  }
}
