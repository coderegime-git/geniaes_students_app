import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resize/resize.dart';
import '../../multi_language/language_constants.dart';
import '../api_services/post_service.dart';
import '../api_services/urls.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import '../controllers/all_academies_controller.dart';
import '../controllers/general_controller.dart';
import '../controllers/search_controller.dart';
import '../repositories/all_academies_repo.dart';
import '../routes.dart';
import '../widgets/academy_card_widget.dart';
import '../widgets/appbar_widget.dart';
import '../widgets/button_widget.dart';
import '../widgets/custom_skeleton_loader.dart';
import '../widgets/search_filter_widget.dart';

class AcademiesScreen extends StatefulWidget {
  const AcademiesScreen({super.key});

  @override
  State<AcademiesScreen> createState() => _AcademiesScreenState();
}

class _AcademiesScreenState extends State<AcademiesScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GeneralController>(builder: (generalController) {
      return GetBuilder<AllAcademiesController>(
          builder: (allAcademiesController) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
            backgroundColor: AppColors.bgColorTwo,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(56),
              child: AppBarWidget(
                titleText: LanguageConstant.academies.tr,
                leadingIcon: "assets/icons/Expand_left.png",
                leadingOnTap: () {
                  Get.back();
                },
              ),
            ),
            body: !allAcademiesController.allAcademiesLoader
                ? CustomVerticalSkeletonLoader(
                    height: 200.h,
                    highlightColor: AppColors.grey,
                    seconds: 2,
                    totalCount: 5,
                    width: 140.w,
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        SearchFilterWidget(
                          onSearchTap: () {
                            postMethod(
                                context,
                                getAllAcademies,
                                {
                                  'search': Get.find<SearchBarController>()
                                      .searchTextController
                                      .text
                                },
                                false,
                                getAllSearchedAcademiesRepo);
                          },
                          controller: Get.find<SearchBarController>()
                              .searchTextController,
                          hintText: LanguageConstant.searchYourAcademy.tr,
                        ),
                        SizedBox(height: 18.h),
                        allAcademiesController
                                .academiesListForPagination.isNotEmpty
                            ? ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: allAcademiesController
                                    .academiesListForPagination.length,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return AcademyCardWidget(
                                    academyName:
                                        "${allAcademiesController.academiesListForPagination[index].name}",
                                    academyImage: ClipRRect(
                                      borderRadius: BorderRadius.circular(18),
                                      child: allAcademiesController
                                                  .academiesListForPagination[
                                                      index]
                                                  .image
                                                  ?.length !=
                                              null
                                          ? Image(
                                              image: NetworkImage(
                                                  "$mediaUrl${allAcademiesController.academiesListForPagination[index].image}"),
                                              height: 110.h,
                                              width: 110.w,
                                              fit: BoxFit.cover,
                                            )
                                          : Image(
                                              image: const AssetImage(
                                                  'assets/images/teacher-image.png'),
                                              height: 110.h,
                                              width: 110.w,
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                    categories: SizedBox(
                                      height: 14.h,
                                      child: ListView(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        children: List.generate(
                                          allAcademiesController
                                              .academiesListForPagination[index]
                                              .academyCategories!
                                              .length,
                                          (index1) {
                                            return Text(
                                              "${allAcademiesController.academiesListForPagination[index].academyCategories![index1].name} | ",
                                              textAlign: TextAlign.start,
                                              style:
                                                  AppTextStyles.bodyTextStyle3,
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    academyRating:
                                        "(${allAcademiesController.academiesListForPagination[index].rating})",
                                    initRating: allAcademiesController
                                        .academiesListForPagination[index]
                                        .rating!
                                        .toDouble(),
                                    onTap: () {
                                      generalController
                                          .updateSelectedAcademyForView(
                                              allAcademiesController
                                                      .academiesListForPagination[
                                                  index]);

                                      Get.toNamed(
                                        PageRoutes.academyProfileScreen,
                                      );
                                    },
                                  );
                                })
                            : SizedBox(
                                height: 120.h,
                                child: Center(
                                  child: Text(
                                    LanguageConstant.noDataFound.tr,
                                    style: AppTextStyles.bodyTextStyle13,
                                  ),
                                ),
                              ),

                        // allAcademiesController
                        //         .academiesListForPagination.isNotEmpty
                        allAcademiesController
                                    .academiesListForPagination.length >=
                                allAcademiesController
                                    .getAllAcademiesModel.data!.meta!.perPage!
                            ? allAcademiesController
                                        .academiesListForPagination.length ==
                                    allAcademiesController
                                        .getAllAcademiesModel.data!.data!.length
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
                                              allAcademiesController
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
