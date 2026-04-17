import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resize/resize.dart';
import 'package:tutorhub_for_students/multi_language/language_constants.dart';

import '../api_services/urls.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import '../controllers/general_controller.dart';

import '../routes.dart';

class AppBarWidget extends StatelessWidget {
  final String titleText;
  final String leadingIcon;
  final Color? appBarColor, leadingIconColor;
  final Widget? profileImage;
  final TextStyle? appBarTextStyle;
  // final Widget? actionsIconWidget;

  final VoidCallback leadingOnTap;
  const AppBarWidget({
    super.key,
    required this.leadingIcon,
    this.profileImage,
    required this.leadingOnTap,
    required this.titleText,
    this.appBarColor,
    this.appBarTextStyle,
    this.leadingIconColor,

    // this.actionsIconWidget,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      leading: InkWell(
        onTap: leadingOnTap,
        child: Image.asset(
          leadingIcon,
          scale: 1.7.h,
          color: leadingIconColor ?? AppColors.primaryColor,
        ),
      ),
      actions: <Widget>[
        Row(
          children: [
            InkWell(
              onTap:
                  Get.find<GeneralController>().storageBox.read('authToken') !=
                          null
                      ? () {
                          Get.toNamed(PageRoutes.userProfileScreen);
                        }
                      : () {
                          Get.toNamed(PageRoutes.signinScreen);
                        },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 16, 0),
                child: Get.find<GeneralController>()
                            .storageBox
                            .read('authToken') !=
                        null
                    ? Get.find<GeneralController>()
                                .currentUserModel!
                                .loginInfo!
                                .image !=
                            null
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(
                                '$mediaUrl${Get.find<GeneralController>().currentUserModel!.loginInfo!.image}'),
                            radius: 18.h,
                          )
                        : Image.asset(
                            "assets/icons/user-avatar.png",
                            height: 32.h,
                          )
                    : Image.asset(
                        "assets/icons/user-avatar.png",
                        height: 32.h,
                      ),
              ),
            ),
          ],
        )
      ],
      title: Text(
        titleText,
        style: appBarTextStyle ?? AppTextStyles.appbarTextStyle1,
      ),
      backgroundColor: appBarColor ?? AppColors.bgColorTwo,
      elevation: 0,
    );
  }
}

class AppBarWidgetTwo extends StatelessWidget {
  final String leadingIcon;
  final Widget? profileImage;
  // final Widget? actionsIconWidget;

  final VoidCallback leadingOnTap;
  const AppBarWidgetTwo({
    super.key,
    required this.leadingIcon,
    this.profileImage,
    required this.leadingOnTap,

    // this.actionsIconWidget,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: InkWell(
        onTap: leadingOnTap,
        child: Image.asset(
          leadingIcon,
          scale: 1.7.h,
        ),
      ),
      actions: <Widget>[
        Row(
          children: [
            InkWell(
              onTap:
                  Get.find<GeneralController>().storageBox.read('authToken') !=
                          null
                      ? () {
                          Get.toNamed(PageRoutes.userProfileScreen);
                        }
                      : () {
                          Get.toNamed(PageRoutes.signinScreen);
                        },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 16, 0),
                child: Get.find<GeneralController>()
                            .storageBox
                            .read('authToken') !=
                        null
                    ? Get.find<GeneralController>()
                                .currentUserModel!
                                .loginInfo!
                                .image !=
                            null
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(
                                '$mediaUrl${Get.find<GeneralController>().currentUserModel!.loginInfo!.image}'),
                            radius: 18.h,
                          )
                        : Image.asset(
                            "assets/icons/user-avatar.png",
                            height: 32.h,
                          )
                    : Image.asset(
                        "assets/icons/user-avatar.png",
                        height: 32.h,
                      ),
              ),
            ),
          ],
        )
      ],
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.gradientTwo,
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8.h),
          Text(
            LanguageConstant.welcomHome.tr,
            style: AppTextStyles.appbarTextStyle3,
          ),
          SizedBox(height: 6.h),
          Get.find<GeneralController>().storageBox.read('authToken') != null
              ? Text(
                  Get.find<GeneralController>()
                      .currentUserModel!
                      .loginInfo!
                      .name!,
                  style: AppTextStyles.appbarTextStyle2,
                )
              : Text(
                  LanguageConstant.signIn.tr,
                  style: AppTextStyles.appbarTextStyle2,
                )
        ],
      ),
      elevation: 0,
    );
  }
}
