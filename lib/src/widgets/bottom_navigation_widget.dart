import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:resize/resize.dart';

import '../../multi_language/language_constants.dart';
import '../api_services/get_service.dart';
import '../api_services/post_service.dart';
import '../api_services/urls.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import '../controllers/all_settings_controller.dart';
import '../controllers/general_controller.dart';
import '../controllers/search_controller.dart';
import '../controllers/logged_in_user_controller.dart';
import '../controllers/sign_out_user_controller.dart';
import '../controllers/signin_controller.dart';
import '../models/logged_in_user_model.dart';

import '../repositories/all_teachers_repo.dart';
import '../repositories/sign_out_user_repo.dart';
import '../repositories/teacher_main_categories_repo.dart';
import '../routes.dart';
import '../screens/category_screen.dart';
import '../screens/home_screen.dart';

import '../screens/teachers_screen.dart';

class BottomNavigationWidget extends StatefulWidget {
  const BottomNavigationWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BottomNavigationWidgetState createState() => _BottomNavigationWidgetState();
}

class _BottomNavigationWidgetState extends State<BottomNavigationWidget> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final loggedInUserLogic = Get.put(LoggedInUserController());
  final signInLogic = Get.put(SigninController());
  final signOutUserLogic = Get.put(SignOutUserController());
  // int Get.find<GeneralController>().bottomNavIndex = 1;

  @override
  void initState() {
    if (Get.find<GeneralController>().storageBox.hasData('userData')) {
      Get.find<GeneralController>().currentUserModel = User.fromJson(jsonDecode(
          Get.find<GeneralController>().storageBox.read('userData')));
    }
    log("${Get.find<GeneralController>().storageBox.read('userData')} Bottom User Data");
    // Get All Main Categories
    getMethod(context, getTeacherMainCategoriesURL, null, false,
        getTeacherMainCategoriesRepo);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgetScreens = <Widget>[
      const TeachersScreen(),
      HomeScreen(
        allCategoryOnTap: () =>
            setState(() => Get.find<GeneralController>().bottomNavIndex = 2),
        allTutorsOnTap: () =>
            setState(() => Get.find<GeneralController>().bottomNavIndex = 0),
        searchOnTap: () {
          setState(() {
            Get.find<GeneralController>().isSearchOn = true;
          });
          postMethod(
              context,
              getAllTeachers,
              {
                'search':
                    Get.find<SearchBarController>().searchTextController.text
              },
              false,
              getAllSearchedTeachersRepo);
        },
      ),
      CategoryScreen(
        searchOnTap: () {
          setState(() {
            Get.find<GeneralController>().isSearchOn = true;
          });
          postMethod(
              context,
              getAllTeachers,
              {
                'search':
                    Get.find<SearchBarController>().searchTextController.text
              },
              false,
              getAllSearchedTeachersRepo);
        },
      ),
    ];
    return GetBuilder<LoggedInUserController>(builder: (loggedInUserLogic) {
      return WillPopScope(
        onWillPop: () async => false,
        child: ModalProgressHUD(
          progressIndicator: const CircularProgressIndicator(
            color: AppColors.primaryColor,
          ),
          inAsyncCall: Get.find<GeneralController>().formLoaderController,
          child: Scaffold(
            backgroundColor: AppColors.white,
            key: scaffoldKey,

            body: Center(
              child: widgetScreens
                  .elementAt(Get.find<GeneralController>().bottomNavIndex),
            ),
            drawer: Drawer(
              backgroundColor: AppColors.offWhite,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                ),
              ),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: AppColors.gradientOne,
                ),
                child: ListView(
                  children: [
                    DrawerHeader(
                      padding: EdgeInsets.fromLTRB(10.w, 0, 10.w, 0),
                      decoration: BoxDecoration(
                          border: Border(
                        bottom: Divider.createBorderSide(context,
                            color: AppColors.white, width: 0.0),
                      )),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Get.find<GeneralController>()
                                        .storageBox
                                        .read('authToken') !=
                                    null
                                ? Get.find<GeneralController>()
                                            .currentUserModel!
                                            .loginInfo!
                                            .image !=
                                        null
                                    ? Image(
                                        image: NetworkImage(
                                            '$mediaUrl${Get.find<GeneralController>().currentUserModel!.loginInfo!.image}'),
                                        height: 100.h,
                                      )
                                    : Image(
                                        image: const AssetImage(
                                            'assets/icons/user-avatar.png'),
                                        height: 100.h,
                                      )
                                : Image(
                                    image: const AssetImage(
                                        'assets/icons/user-avatar.png'),
                                    height: 100.h,
                                    fit: BoxFit.contain,
                                  ),
                          ),
                          SizedBox(
                            height: 3.h,
                          ),
                          Flexible(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Get.find<GeneralController>()
                                            .storageBox
                                            .read('authToken') !=
                                        null
                                    ? Text(
                                        "${Get.find<GeneralController>().currentUserModel!.loginInfo!.name} ",
                                        style: AppTextStyles.bodyTextStyle5,
                                      )
                                    : GestureDetector(
                                        onTap: () {
                                          Get.toNamed(PageRoutes.signinScreen);
                                        },
                                        child: Text(
                                          LanguageConstant.signIn.tr,
                                          style: AppTextStyles.bodyTextStyle4,
                                        ),
                                      ),
                                SizedBox(
                                  height: 2.h,
                                ),
                                Text(
                                  Get.find<GeneralController>()
                                              .storageBox
                                              .read('authToken') !=
                                          null
                                      // ? "${loggedInUserLogic.loggedInUserModel.data!.email}"
                                      ? "${Get.find<GeneralController>().currentUserModel!.email} "
                                      : "",
                                  style: AppTextStyles.subHeadingTextStyle3,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        children: [
                          Get.find<GeneralController>()
                                      .storageBox
                                      .read('authToken') !=
                                  null
                              ? ListTile(
                                  isThreeLine: false,
                                  dense: true,
                                  visualDensity: const VisualDensity(
                                      vertical: -1, horizontal: -3),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 0),
                                  leading: const ImageIcon(
                                    AssetImage("assets/icons/User.png"),
                                    color: AppColors.white,
                                  ),
                                  title: Text(
                                    LanguageConstant.profile.tr,
                                    style: AppTextStyles.subHeadingTextStyle2,
                                  ),
                                  onTap: () {
                                    Get.toNamed(PageRoutes.userProfileScreen);
                                  },
                                )
                              : const SizedBox(),
                          // ListTile(
                          //   isThreeLine: false,
                          //   dense: true,
                          //   visualDensity:
                          //       const VisualDensity(vertical: -1, horizontal: -3),
                          //   contentPadding: const EdgeInsets.symmetric(
                          //       horizontal: 12, vertical: 0),
                          //   leading: const ImageIcon(
                          //     AssetImage("assets/icons/Bell_pin.png"),
                          //     color: AppColors.secondaryColor,
                          //   ),
                          //   title: const Text(
                          //     'Notifications',
                          //     style: AppTextStyles.subHeadingTextStyle2,
                          //   ),
                          //   onTap: () {
                          //     Get.toNamed(PageRoutes.notificationsScreen);
                          //   },
                          // ),
                          Get.find<GeneralController>()
                                          .storageBox
                                          .read('authToken') !=
                                      null &&
                              (Get.find<GetAllSettingsController>()
                                  .getAllSettingsModel
                                  .data
                                  ?.enableWalletSystem ?? "0") == "1"
                              ? ListTile(
                                  isThreeLine: false,
                                  dense: true,
                                  visualDensity: const VisualDensity(
                                      vertical: -1, horizontal: -3),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 0),
                                  leading: const ImageIcon(
                                    AssetImage("assets/icons/Wallet_alt.png"),
                                    color: AppColors.white,
                                  ),
                                  title: Text(
                                    LanguageConstant.wallet.tr,
                                    style: AppTextStyles.subHeadingTextStyle2,
                                  ),
                                  onTap: () {
                                    Get.toNamed(PageRoutes.walletScreen);
                                  },
                                )
                              : const SizedBox(),
                          Get.find<GeneralController>()
                                      .storageBox
                                      .read('authToken') !=
                                  null
                              ? ListTile(
                                  isThreeLine: false,
                                  dense: true,
                                  visualDensity: const VisualDensity(
                                      vertical: -1, horizontal: -3),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 0),
                                  leading: const ImageIcon(
                                    AssetImage(
                                        "assets/icons/Folders_light.png"),
                                    color: AppColors.white,
                                  ),
                                  title: Text(
                                    LanguageConstant.appointmentHistory.tr,
                                    style: AppTextStyles.subHeadingTextStyle2,
                                  ),
                                  onTap: () {
                                    Get.toNamed(
                                        PageRoutes.appointmentHistoryScreen);
                                  },
                                )
                              : const SizedBox(),
                          ListTile(
                            isThreeLine: false,
                            dense: true,
                            visualDensity: const VisualDensity(
                                vertical: -1, horizontal: -3),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 0),
                            leading: const ImageIcon(
                              AssetImage("assets/icons/Folders_light.png"),
                              color: AppColors.white,
                            ),
                            title: Text(
                              LanguageConstant.bookedServices.tr,
                              style: AppTextStyles.subHeadingTextStyle2,
                            ),
                            onTap: Get.find<GeneralController>()
                                        .storageBox
                                        .read('authToken') !=
                                    null
                                ? () {
                                    Get.toNamed(
                                        PageRoutes.bookedServicesScreen);
                                  }
                                : () {},
                          ),
                          ListTile(
                            isThreeLine: false,
                            dense: true,
                            visualDensity: const VisualDensity(
                                vertical: -1, horizontal: -3),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 0),
                            leading: const ImageIcon(
                              AssetImage("assets/icons/academies-icon.png"),
                              color: AppColors.white,
                            ),
                            title: Text(
                              LanguageConstant.academies.tr,
                              style: AppTextStyles.subHeadingTextStyle2,
                            ),
                            onTap: () {
                              Get.toNamed(PageRoutes.academiesScreen);
                            },
                          ),
                          // ListTile(
                          //   isThreeLine: false,
                          //   dense: true,
                          //   visualDensity:
                          //       const VisualDensity(vertical: -1, horizontal: -3),
                          //   contentPadding: const EdgeInsets.symmetric(
                          //       horizontal: 24, vertical: 0),
                          //   leading: const ImageIcon(
                          //     AssetImage("assets/icons/services-icon.png"),
                          //     color: AppColors.secondaryColor,
                          //   ),
                          //   title: const Text(
                          //     'Quick Buy Services',
                          //     style: AppTextStyles.subHeadingTextStyle2,
                          //   ),
                          //   onTap: () {
                          //     Get.toNamed(PageRoutes.quickBuyServices);
                          //   },
                          // ),
                          ListTile(
                            isThreeLine: false,
                            dense: true,
                            visualDensity: const VisualDensity(
                                vertical: -1, horizontal: -3),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 0),
                            leading: const ImageIcon(
                              AssetImage("assets/icons/language-icon.png"),
                              color: AppColors.white,
                            ),
                            title: Text(
                              LanguageConstant.languages.tr,
                              style: AppTextStyles.subHeadingTextStyle2,
                            ),
                            onTap: () {
                              Get.toNamed(PageRoutes.languagesScreen);
                            },
                          ),
                          ListTile(
                            isThreeLine: false,
                            dense: true,
                            visualDensity: const VisualDensity(
                                vertical: -1, horizontal: -3),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 0),
                            leading: const ImageIcon(
                              AssetImage("assets/icons/blog-icon.png"),
                              color: AppColors.white,
                            ),
                            title: Text(
                              LanguageConstant.blogs.tr,
                              style: AppTextStyles.subHeadingTextStyle2,
                            ),
                            onTap: () {
                              Get.toNamed(PageRoutes.blogsScreen);
                            },
                          ),
                          ListTile(
                            isThreeLine: false,
                            dense: true,
                            visualDensity: const VisualDensity(
                                vertical: -1, horizontal: -3),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 0),
                            leading: const ImageIcon(
                              AssetImage("assets/icons/Group.png"),
                              color: AppColors.white,
                            ),
                            title: Text(
                              LanguageConstant.aboutUs.tr,
                              style: AppTextStyles.subHeadingTextStyle2,
                            ),
                            onTap: () {
                              Get.toNamed(PageRoutes.aboutusScreen);
                            },
                          ),
                          ListTile(
                            isThreeLine: false,
                            dense: true,
                            visualDensity: const VisualDensity(
                                vertical: -1, horizontal: -3),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 0),
                            leading: const ImageIcon(
                              AssetImage("assets/icons/Message.png"),
                              color: AppColors.white,
                            ),
                            title: Text(
                              LanguageConstant.contactUs.tr,
                              style: AppTextStyles.subHeadingTextStyle2,
                            ),
                            onTap: () {
                              Get.toNamed(PageRoutes.contactusScreen);
                            },
                          ),
                          ListTile(
                            isThreeLine: false,
                            dense: true,
                            visualDensity: const VisualDensity(
                                vertical: -1, horizontal: -3),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 0),
                            leading: const ImageIcon(
                              AssetImage("assets/icons/Chield_alt.png"),
                              color: AppColors.white,
                            ),
                            title: Text(
                              LanguageConstant.privacyPolicy.tr,
                              style: AppTextStyles.subHeadingTextStyle2,
                            ),
                            onTap: () {
                              Get.toNamed(PageRoutes.privacyPolicyScreen);
                            },
                          ),
                          // ListTile(
                          //   isThreeLine: false,
                          //   dense: true,
                          //   visualDensity:
                          //       const VisualDensity(vertical: -1, horizontal: -3),
                          //   contentPadding: const EdgeInsets.symmetric(
                          //       horizontal: 24, vertical: 0),
                          //   leading: const ImageIcon(
                          //     AssetImage("assets/icons/setting-icon.png"),
                          //     color: AppColors.white,
                          //   ),
                          //   title: const Text(
                          //     'Settings',
                          //     style: AppTextStyles.subHeadingTextStyle2,
                          //   ),
                          //   onTap: () {
                          //     Navigator.pop(context);
                          //   },
                          // ),

                          Get.find<GeneralController>()
                                      .storageBox
                                      .read('authToken') !=
                                  null
                              ? ListTile(
                                  isThreeLine: false,
                                  dense: true,
                                  visualDensity: const VisualDensity(
                                      vertical: -1, horizontal: -3),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 0),
                                  leading: const ImageIcon(
                                    AssetImage(
                                        "assets/icons/Sign_out_circle.png"),
                                    color: AppColors.white,
                                  ),
                                  title: Text(
                                    LanguageConstant.logOut.tr,
                                    style: AppTextStyles.subHeadingTextStyle2,
                                  ),
                                  onTap: () {
                                    Get.find<GeneralController>()
                                        .updateFormLoaderController(true);
                                    getMethod(context, signOutURL, null, true,
                                        signOutUserRepo);

                                    // Get.toNamed(PageRoutes.homeScreen);
                                  },
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: SnakeNavigationBar.gradient(
              backgroundGradient: AppColors.gradientOne,

              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: const ImageIcon(
                    AssetImage("assets/icons/Group.png"),
                    size: 22,
                    color: AppColors.white,
                  ),
                  label: LanguageConstant.tutors.tr,
                ),
                BottomNavigationBarItem(
                  icon: const ImageIcon(
                    AssetImage("assets/icons/Home.png"),
                    size: 22,
                    color: AppColors.white,
                  ),
                  label: LanguageConstant.home.tr,
                ),
                BottomNavigationBarItem(
                  icon: const ImageIcon(
                    AssetImage("assets/icons/File_dock.png"),
                    size: 22,
                    color: AppColors.white,
                  ),
                  label: LanguageConstant.categories.tr,
                ),
              ],
              selectedLabelStyle: AppTextStyles.bodyTextStyle4,

              unselectedLabelStyle: AppTextStyles.bodyTextStyle5,
              // currentIndex: _selectedIndex,
              // selectedItemColor: kMainWhite,
              // unselectedItemColor: Colors.white70,
              // onTap: _onItemTapped, onItemSelected: (int value) {  },
              behaviour: SnakeBarBehaviour.pinned,
              snakeShape: SnakeShape.indicator,
              // shape: RoundedRectangleBorder(
              //   borderRadius: BorderRadius.only(
              //       topLeft: Radius.circular(20),
              //       topRight: Radius.circular(20)),
              // ),
              padding: EdgeInsets.zero,

              ///configuration for SnakeNavigationBar.color
              snakeViewGradient: AppColors.gradientFour,
              selectedItemGradient: SnakeShape.rectangle == SnakeShape.indicator
                  ? AppColors.gradientOne
                  : null,
              unselectedItemGradient: AppColors.gradientFour,

              ///configuration for SnakeNavigationBar.gradient
              //snakeViewGradient: selectedGradient,
              //selectedItemGradient: snakeShape == SnakeShape.indicator ? selectedGradient : null,
              //unselectedItemGradient: unselectedGradient,

              showUnselectedLabels: true,
              showSelectedLabels: true,
              currentIndex: Get.find<GeneralController>().bottomNavIndex,
              // selectedIndex: _currentIndex,
              // showElevation: true,
              // itemCornerRadius: 24, curve: Curves.easeIn,
              // onItemSelected: (index) =>
              //     setState(() => _currentIndex = index),
              onTap: (index) => setState(
                  () => Get.find<GeneralController>().bottomNavIndex = index),
            ),
            // bottomNavigationBar: BottomNavyBar(
            //   selectedIndex: Get.find<GeneralController>().bottomNavIndex,
            //   backgroundColor: AppColors.offWhite,
            //   showElevation: true,
            //   itemCornerRadius: 24,
            //   curve: Curves.easeIn,
            //   onItemSelected: (index) => setState(
            //       () => Get.find<GeneralController>().bottomNavIndex = index),
            //   items: <BottomNavyBarItem>[
            //     BottomNavyBarItem(
            //       icon: const ImageIcon(
            //         AssetImage("assets/icons/Group.png"),
            //         size: 28,
            //         color: AppColors.secondaryColor,
            //       ),
            //       title: const Text(
            //         'Teachers',
            //         style: AppTextStyles.bodyTextStyle2,
            //       ),
            //       activeColor: AppColors.primaryColor,
            //       textAlign: TextAlign.center,
            //     ),
            //     BottomNavyBarItem(
            //       icon: const ImageIcon(
            //         AssetImage("assets/icons/Home.png"),
            //         size: 30,
            //         color: AppColors.secondaryColor,
            //       ),
            //       title: const Text(
            //         'Home',
            //         style: AppTextStyles.bodyTextStyle2,
            //       ),
            //       activeColor: AppColors.primaryColor,
            //       textAlign: TextAlign.center,
            //     ),
            //     BottomNavyBarItem(
            //       icon: const ImageIcon(
            //         AssetImage("assets/icons/File_dock.png"),
            //         color: AppColors.secondaryColor,
            //       ),
            //       title: const Text(
            //         'Category',
            //         style: AppTextStyles.bodyTextStyle2,
            //       ),
            //       activeColor: AppColors.primaryColor,
            //       textAlign: TextAlign.center,
            //     ),
            //   ],
            // ),
          ),
        ),
      );
    });
  }
}
