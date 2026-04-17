import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resize/resize.dart';
import '../api_services/urls.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import '../controllers/all_teachers_controller.dart';
import '../controllers/general_controller.dart';
import '../routes.dart';
import 'custom_skeleton_loader.dart';
import 'home_teacher_card_widget.dart';

class HomeAllTeachersListWidget extends StatefulWidget {
  const HomeAllTeachersListWidget({
    Key? key,
  }) : super(key: key);

  @override
  _HomeAllTeachersListWidgetState createState() =>
      _HomeAllTeachersListWidgetState();
}

class _HomeAllTeachersListWidgetState extends State<HomeAllTeachersListWidget> {
  final logic = Get.put(AllTeachersController());

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
      return GetBuilder<AllTeachersController>(
          builder: (allTeachersController) {
        return !allTeachersController.allTeachersLoader
            ? CustomHorizontalSkeletonLoader(
                containerHeight: 140.h,
                listHeight: 140.h,
                highlightColor: AppColors.grey,
                seconds: 2,
                totalCount: 5,
                containerWidth: 200.w,
              )
            : allTeachersController.getAllTeachersModel.data!.data!.isNotEmpty
                ? AspectRatio(
                    aspectRatio: 3 / 1.92,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: allTeachersController
                          .getAllTeachersModel.data!.data!.length,
                      padding: EdgeInsets.fromLTRB(18.w, 0, 18.w, 0),
                      itemBuilder: (context, index) {
                        return HomeTeacherCardWidget(
                          image: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            // ignore: unrelated_type_equality_checks
                            child: allTeachersController.getAllTeachersModel
                                        .data!.data![index].image?.length !=
                                    null
                                ? Image(
                                    image: NetworkImage(
                                        "$mediaUrl${allTeachersController.getAllTeachersModel.data!.data![index].image}"),
                                    height: 150.h,
                                  )
                                : Image(
                                    image: const AssetImage(
                                        'assets/images/teacher-image.png'),
                                    height: 150.h,
                                  ),
                          ),
                          name: allTeachersController
                              .getAllTeachersModel.data!.data![index].name
                              .toString(),
                          categoryName: 'Math',
                          premiumImage: Image.asset(
                            "assets/icons/premium_star.png",
                          ),
                          onSearchTap: () {
                            generalController.updateSelectedTeacherForView(
                                allTeachersController
                                    .getAllTeachersModel.data!.data![index]);
                            Get.toNamed(PageRoutes.teacherProfileScreen);
                          },
                        );
                      },
                      separatorBuilder: (context, position) {
                        return SizedBox(width: 18.w);
                      },
                    ),
                  )
                : const SizedBox(
                    child: Center(
                      child: Text(
                        "No Data Found",
                        style: AppTextStyles.bodyTextStyle13,
                      ),
                    ),
                  );
      });
    });
  }
}
