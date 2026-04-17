import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resize/resize.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

import '../../multi_language/language_constants.dart';
import '../api_services/urls.dart';
import '../config/app_colors.dart';
import '../controllers/general_controller.dart';
import '../controllers/teacher_main_categories_controller.dart';
import '../controllers/search_controller.dart';
import '../routes.dart';
import '../widgets/appbar_widget.dart';
import '../widgets/category_card_widget.dart';
import '../widgets/search_filter_widget.dart';

class CategoryScreen extends StatefulWidget {
  final VoidCallback searchOnTap;
  CategoryScreen({super.key, required this.searchOnTap});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final logic = Get.put(TeacherMainCategoriesController());

  @override
  void initState() {
    super.initState();
    // Get.find<SearchBarController>().searchTextController.clear();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double gridRatio = screenWidth > 600 ? 1.8 / 1.5 : 1.36 / 1.5;
    return GetBuilder<GeneralController>(
      builder: (generalController) {
        return GetBuilder<TeacherMainCategoriesController>(
          builder: (teacherMainCategoriesController) {
            return Scaffold(
              backgroundColor: AppColors.bgColorTwo,
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(56.h),
                child: AppBarWidget(
                  titleText: LanguageConstant.categories.tr,
                  leadingIcon: "assets/icons/Sort.png",
                  leadingOnTap: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Column(
                  children: [
                    SearchFilterWidget(
                      onSearchTap: widget.searchOnTap,
                      controller:
                          Get.find<SearchBarController>().searchTextController,
                      hintText: LanguageConstant.searchYourTutor.tr,
                    ),
                    SizedBox(height: 10.h),
                    !teacherMainCategoriesController.teacherMainCategoriesLoader
                        ? SkeletonLoader(
                            period: const Duration(seconds: 2),
                            highlightColor: Colors.grey,
                            direction: SkeletonDirection.ltr,
                            builder: SizedBox(
                              height: 207.h,
                              width: MediaQuery.of(context).size.width,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: List.generate(3, (index) {
                                  return Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 15, 0),
                                    child: Container(
                                      width: 183.w,
                                      height: 207.h,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(14),
                                        color: Colors.grey,
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ))
                        : Expanded(
                            child: GridView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: teacherMainCategoriesController
                                  .getTeacherMainCategoriesModel.data!.length,
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding:
                                  EdgeInsets.fromLTRB(16.w, 0.h, 16.w, 0.h),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      childAspectRatio: gridRatio,
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 2),
                              itemBuilder: (context, index) {
                                return CategoryCardWidget(
                                  categoryName: teacherMainCategoriesController
                                      .getTeacherMainCategoriesModel
                                      .data![index]
                                      .name
                                      .toString(),
                                  categoryImage: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: teacherMainCategoriesController
                                                .getTeacherMainCategoriesModel
                                                .data![index]
                                                .image !=
                                            null
                                        ? Image(
                                            image: NetworkImage(
                                                "$mediaUrl${teacherMainCategoriesController.getTeacherMainCategoriesModel.data![index].image}"),
                                            height: 115.h,
                                            width: 170.w,
                                            fit: BoxFit.fitWidth,
                                          )
                                        : Image(
                                            image: const AssetImage(
                                                'assets/images/teacher-image.png'),
                                            height: 120.h,
                                            width: 170.w,
                                            fit: BoxFit.fitWidth,
                                          ),
                                  ),
                                  onTap: () {
                                    Get.toNamed(PageRoutes.subCategoriesScreen,
                                        arguments: {
                                          "categoryData":
                                              teacherMainCategoriesController
                                                  .getTeacherMainCategoriesModel
                                                  .data![index]
                                                  .categories,
                                        },
                                        parameters: {
                                          "categoryName":
                                              "${teacherMainCategoriesController.getTeacherMainCategoriesModel.data![index].name}",
                                          "categoryImage":
                                              "${teacherMainCategoriesController.getTeacherMainCategoriesModel.data![index].image}"
                                        });
                                  },
                                );
                              },
                            ),
                          ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
