import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resize/resize.dart';

import '../../multi_language/language_constants.dart';
import '../api_services/urls.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import '../controllers/general_controller.dart';
import '../controllers/teacher_main_categories_controller.dart';
import '../controllers/teachers_by_category_controller.dart';
import '../controllers/search_controller.dart';

import '../routes.dart';
import '../widgets/appbar_widget.dart';
import '../widgets/button_widget.dart';
import '../widgets/search_filter_widget.dart';

class SubCategoriesScreen extends StatefulWidget {
  const SubCategoriesScreen({
    super.key,
  });

  @override
  State<SubCategoriesScreen> createState() => _SubCategoriesScreenState();
}

class _SubCategoriesScreenState extends State<SubCategoriesScreen> {
  final logic = Get.put(TeachersByCategoryController());
  String? categoryImage = Get.parameters["categoryImage"];
  String? categoryName = Get.parameters["categoryName"];
  List categoryData = Get.arguments["categoryData"];

  @override
  void initState() {
    super.initState();
    print("${categoryData.length} CATEGORYDATA");
    print("${categoryName} CATEGORYNAME");
    // postMethod(context, '$getTeachersByCategory + $categorySlug', null, false,
    //     getTeachersByCategoryRepo);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GeneralController>(builder: (generalController) {
      return GetBuilder<TeacherMainCategoriesController>(
          builder: (teacherByCategoryController) {
        return Scaffold(
          backgroundColor: AppColors.bgColorTwo,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(56),
            child: AppBarWidget(
              titleText: categoryName!,
              leadingIcon: "assets/icons/Expand_left.png",
              leadingOnTap: () {
                Get.back();
              },
            ),
          ),
          body: SingleChildScrollView(
            child:
                // !teacherByCategoryController.teacherByCategoryLoader
                //     ? CustomVerticalSkeletonLoader(
                //         height: 200.h,
                //         highlightColor: AppColors.grey,
                //         seconds: 2,
                //         totalCount: 5,
                //         width: 140.w,
                //       )
                //     :
                Column(
              children: [
                SearchFilterWidget(
                  onSearchTap: () {},
                  controller:
                      Get.find<SearchBarController>().searchTextController,
                  hintText: LanguageConstant.searchYourTutor.tr,
                ),
                SizedBox(height: 18.h),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 10.h),
                  margin: EdgeInsets.fromLTRB(18.w, 0, 18.w, 0.h),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 4,
                        blurRadius: 15,
                        offset:
                            const Offset(0, 0), // changes position of shadow
                      ),
                    ],
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    // mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: categoryImage != null &&
                                categoryImage!.isNotEmpty &&
                                categoryImage.toString() != 'null'
                            ? Image(
                                image: NetworkImage("$mediaUrl$categoryImage"),
                                height: 120.h,
                                width: MediaQuery.of(context).size.width,
                                fit: BoxFit.cover,
                              )
                            : Image(
                                image: const AssetImage(
                                    'assets/images/teacher-image.png'),
                                height: 120.h,
                                width: MediaQuery.of(context).size.width,
                                fit: BoxFit.cover,
                              ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        "$categoryName",
                        textAlign: TextAlign.start,
                        style: AppTextStyles.bodyTextStyle13,
                      ),
                    ],
                  ),
                ),
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: 1,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.only(top: 18.h),
                    itemBuilder: (context, index) {
                      return ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: List.generate(
                          categoryData.length,
                          (index) {
                            return Container(
                              padding:
                                  EdgeInsets.fromLTRB(12.w, 4.h, 12.w, 4.h),
                              margin: EdgeInsets.fromLTRB(18.w, 0, 18.w, 18.h),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 4,
                                    blurRadius: 15,
                                    offset: const Offset(
                                        0, 0), // changes position of shadow
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${categoryData[index].name}",
                                    textAlign: TextAlign.start,
                                    style: AppTextStyles.bodyTextStyle12,
                                  ),
                                  ButtonWidgetFour(
                                    onTap: () {
                                      Get.toNamed(
                                          PageRoutes.teachersByCategoryScreen,
                                          parameters: {
                                            "subCategorySlug":
                                                "${categoryData[index].slug}",
                                            "subCategoryName":
                                                "${categoryData[index].name}"
                                          });
                                    },
                                    innerBorderColor: AppColors.white,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    }),
              ],
            ),
          ),
        );
      });
    });
  }
}
