import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:resize/resize.dart';

import '../../multi_language/language_constants.dart';
import '../api_services/get_service.dart';
import '../api_services/post_service.dart';
import '../api_services/urls.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import '../controllers/edit_profile_controller.dart';
import '../controllers/general_controller.dart';

import '../repositories/delete_account_repo.dart';
import '../repositories/edit_user_profile_repo.dart';
import '../widgets/appbar_widget.dart';
import '../widgets/button_widget.dart';
import '../widgets/custom_dialog.dart';
import '../widgets/text_form_field_widget.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => UserProfileScreenState();
}

class UserProfileScreenState extends State<UserProfileScreen> {
  final GlobalKey<FormState> _userProfileUpdateFormKey = GlobalKey();
  final editUserProfileLogic = Get.put(EditUserProfileController());
  final generalLogic = Get.put(GeneralController());

  @override
  void initState() {
    super.initState();
    // getMethod(context, getLoggedInUserUrl, null, true, loggedInUserRepo);
    editUserProfileLogic.userProfileFirstNameController.text =
        generalLogic.currentUserModel!.loginInfo!.firstName ?? '';

    editUserProfileLogic.userProfileLastNameController.text =
        generalLogic.currentUserModel!.loginInfo!.lastName ?? '';

    editUserProfileLogic.userProfileUserNameController.text =
        generalLogic.currentUserModel!.loginInfo!.userName ?? '';

    editUserProfileLogic.userProfileDescriptionController.text =
        generalLogic.currentUserModel!.loginInfo!.description ?? '';

    editUserProfileLogic.userProfileAddressLine1Controller.text =
        generalLogic.currentUserModel!.loginInfo!.addressLine1 ?? '';

    editUserProfileLogic.userProfileZipCodeController.text =
        generalLogic.currentUserModel!.loginInfo!.zipCode ?? '';

    // editUserProfileLogic.uploadedProfileImage =
    //     generalLogic.currentUserModel!.loginInfo!.image;

    log("${generalLogic.currentUserModel!.loginInfo!.image} Log Image");
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GeneralController>(builder: (generalController) {
      return GetBuilder<EditUserProfileController>(
          builder: (editUserProfileController) {
        return ModalProgressHUD(
            progressIndicator: const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
            ),
            inAsyncCall: generalController.formLoaderController,
            child: GestureDetector(
              onTap: () {
                final FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              },
              child: Scaffold(
                backgroundColor: AppColors.white,
                appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(56),
                  child: AppBarWidget(
                    titleText: LanguageConstant.profile.tr,
                    leadingIcon: "assets/icons/Expand_left.png",
                    leadingOnTap: () {
                      Get.back();
                    },
                  ),
                ),
                body: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                    child: Form(
                      key: _userProfileUpdateFormKey,
                      child: Column(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding:
                                  EdgeInsets.fromLTRB(15.w, 15.h, 15.w, 15.h),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: AppColors.gradientOne,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      imagePickerDialog(context);
                                    },
                                    child: editUserProfileLogic.profileImage ==
                                            null
                                        ? generalLogic.currentUserModel == null
                                            ? Container(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        20, 20, 20, 20),
                                                decoration: BoxDecoration(
                                                    color: AppColors.offWhite,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    border: Border.all(
                                                        color: AppColors
                                                            .primaryColor)),
                                                child: Column(
                                                  children: [
                                                    Image.asset(
                                                        "assets/icons/Upload_duotone_line.png"),
                                                    SizedBox(height: 4.h),
                                                    Text(
                                                      LanguageConstant
                                                          .uploadImage.tr,
                                                      style: AppTextStyles
                                                          .bodyTextStyle1,
                                                    )
                                                  ],
                                                ),
                                              )
                                            : generalLogic.currentUserModel!
                                                        .loginInfo!.image ==
                                                    null
                                                ? Container(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(
                                                        20, 20, 20, 20),
                                                    decoration: BoxDecoration(
                                                        color:
                                                            AppColors.offWhite,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        border: Border.all(
                                                            color: AppColors
                                                                .primaryColor)),
                                                    child: Column(
                                                      children: [
                                                        Image.asset(
                                                            "assets/icons/Upload_duotone_line.png"),
                                                        SizedBox(height: 4.h),
                                                        Text(
                                                          LanguageConstant
                                                              .uploadImage.tr,
                                                          style: AppTextStyles
                                                              .bodyTextStyle1,
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                : ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.r),
                                                    child: Image.network(
                                                      scale: 4.h,
                                                      '$mediaUrl${generalLogic.currentUserModel!.loginInfo!.image}',
                                                      fit: BoxFit.cover,
                                                      height: 110.h,
                                                      width: 120.w,
                                                    ))
                                        : ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.r),
                                            child: Image.file(
                                              scale: 3.h,
                                              // '$mediaUrl${generalLogic.currentUserModel!.loginInfo!.image}',
                                              editUserProfileLogic
                                                  .profileImage!,
                                              height: 110.h,
                                              width: 120.w,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                  ),
                                  SizedBox(height: 12.h),
                                  Text(
                                    generalController.storageBox
                                                .read('authToken') !=
                                            null
                                        ? "${generalController.currentUserModel!.loginInfo!.firstName} ${generalController.currentUserModel!.loginInfo!.lastName}"
                                        : "",
                                    style: AppTextStyles.bodyTextStyle16,
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    generalController.storageBox
                                                .read('authToken') !=
                                            null
                                        ? "${generalController.currentUserModel!.email}"
                                        : "",
                                    style: AppTextStyles.bodyTextStyle16,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 18.h),
                          TextFormFieldWidget(
                            hintText: '* ${LanguageConstant.firstName.tr}',
                            controller: editUserProfileController
                                .userProfileFirstNameController,
                            // initialText: editUserProfileLogic
                            //     .userProfileFirstNameController.text,
                            onChanged: (String? value) {
                              editUserProfileController
                                      .userProfileFirstNameController.text ==
                                  value;
                              editUserProfileController.update();
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return LanguageConstant
                                    .firstNameFieldRequired.tr;
                              } else {
                                return null;
                              }
                            },
                          ),
                          SizedBox(height: 14.h),
                          TextFormFieldWidget(
                            hintText: '* ${LanguageConstant.lastName.tr}',
                            controller: editUserProfileController
                                .userProfileLastNameController,
                            onChanged: (String? value) {
                              editUserProfileController
                                      .userProfileLastNameController.text ==
                                  value;
                              editUserProfileController.update();
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return LanguageConstant
                                    .lastNameFieldRequired.tr;
                              } else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(height: 14),
                          TextFormFieldWidget(
                            hintText: '* ${LanguageConstant.username.tr}',
                            controller: editUserProfileController
                                .userProfileUserNameController,
                            onChanged: (String? value) {
                              editUserProfileController
                                      .userProfileUserNameController.text ==
                                  value;
                              editUserProfileController.update();
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return LanguageConstant
                                    .userNameFieldRequired.tr;
                              } else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(height: 14),
                          TextFormFieldWidget(
                            hintText: '* ${LanguageConstant.description.tr}',
                            controller: editUserProfileController
                                .userProfileDescriptionController,
                            // initialText: editUserProfileController
                            //         .userProfileDescriptionController
                            //         .text
                            //         .isEmpty
                            //     ? ''
                            //     : editUserProfileController
                            //         .userProfileDescriptionController.text,
                            onChanged: (String? value) {
                              editUserProfileController
                                      .userProfileDescriptionController.text ==
                                  value;
                              editUserProfileController.update();
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return LanguageConstant
                                    .descriptionFieldRequired.tr;
                              } else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(height: 14),
                          TextFormFieldWidget(
                            hintText: '* ${LanguageConstant.addressLine1.tr}',
                            controller: editUserProfileController
                                .userProfileAddressLine1Controller,
                            onChanged: (String? value) {
                              editUserProfileController
                                      .userProfileAddressLine1Controller.text ==
                                  value;
                              editUserProfileController.update();
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return LanguageConstant
                                    .addressLine1FieldRequired.tr;
                              } else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(height: 14),
                          TextFormFieldWidget(
                            hintText: '* ${LanguageConstant.zipCode.tr}',
                            controller: editUserProfileController
                                .userProfileZipCodeController,
                            onChanged: (String? value) {
                              editUserProfileController
                                      .userProfileZipCodeController.text ==
                                  value;
                              editUserProfileController.update();
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return LanguageConstant.zipCodeFieldRequired.tr;
                              } else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(height: 24),
                          ButtonWidgetOne(
                              onTap: () async {
                                ///---keyboard-close
                                FocusScopeNode currentFocus =
                                    FocusScope.of(context);
                                if (!currentFocus.hasPrimaryFocus) {
                                  currentFocus.unfocus();
                                }
                                if (_userProfileUpdateFormKey.currentState!
                                    .validate()) {
                                  if (editUserProfileController.profileImage !=
                                      null) {
                                    log("${editUserProfileController.profileImage!.path} Inside If");
                                    Get.find<GeneralController>()
                                        .updateFormLoaderController(true);
                                    // postMethod(
                                    //     context,
                                    //     editUserProfileURL,
                                    //     {
                                    //       "logged_in_as": "student",
                                    //       "first_name": editUserProfileController
                                    //           .userProfileFirstNameController
                                    //           .text,
                                    //       "last_name": editUserProfileController
                                    //           .userProfileLastNameController
                                    //           .text,
                                    //       "user_name": editUserProfileController
                                    //           .userProfileUserNameController
                                    //           .text,
                                    //       "description": editUserProfileController
                                    //           .userProfileDescriptionController
                                    //           .text,
                                    //       "address_line_1":
                                    //           editUserProfileController
                                    //               .userProfileAddressLine1Controller
                                    //               .text,
                                    //       "zip_code": editUserProfileController
                                    //           .userProfileZipCodeController
                                    //           .text,
                                    //       "image": editUserProfileController
                                    //           .profileImage!.path,
                                    //       "teacher_categories": "1",
                                    //     },
                                    //     true,
                                    //     editUserProfileDataRepo);
                                    editUserProfileImageRepo(
                                      editUserProfileController
                                          .userProfileFirstNameController.text,
                                      editUserProfileController
                                          .userProfileLastNameController.text,
                                      editUserProfileController
                                          .userProfileUserNameController.text,
                                      editUserProfileController
                                          .userProfileDescriptionController
                                          .text,
                                      editUserProfileController
                                          .userProfileZipCodeController.text,
                                      editUserProfileController
                                          .userProfileAddressLine1Controller
                                          .text,
                                      editUserProfileController.profileImage,
                                    );
                                  } else if (generalLogic.currentUserModel!
                                              .loginInfo!.image !=
                                          null &&
                                      editUserProfileController.profileImage ==
                                          null) {
                                    log(editUserProfileController
                                        .userProfileFirstNameController.text);
                                    log(editUserProfileController
                                        .userProfileLastNameController.text);
                                    log(editUserProfileController
                                        .userProfileUserNameController.text);
                                    log(editUserProfileController
                                        .userProfileDescriptionController.text);
                                    log(editUserProfileController
                                        .userProfileZipCodeController.text);
                                    log(editUserProfileController
                                        .userProfileAddressLine1Controller
                                        .text);
                                    // log(editUserProfileController
                                    //     .profileImage!.path);
                                    Get.find<GeneralController>()
                                        .updateFormLoaderController(true);
                                    postMethod(
                                        context,
                                        editUserProfileURL,
                                        {
                                          "logged_in_as": "student",
                                          "first_name": editUserProfileController
                                              .userProfileFirstNameController
                                              .text,
                                          "last_name": editUserProfileController
                                              .userProfileLastNameController
                                              .text,
                                          "user_name": editUserProfileController
                                              .userProfileUserNameController
                                              .text,
                                          "description": editUserProfileController
                                              .userProfileDescriptionController
                                              .text,
                                          "address_line_1":
                                              editUserProfileController
                                                  .userProfileAddressLine1Controller
                                                  .text,
                                          "zip_code": editUserProfileController
                                              .userProfileZipCodeController
                                              .text,
                                          // "image": generalLogic
                                          //     .currentUserModel!
                                          //     .loginInfo!
                                          //     .image,
                                          "teacher_categories": "1",
                                        },
                                        true,
                                        editUserProfileDataRepo);
                                  } else {
                                    showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          return CustomDialogBox(
                                            title: LanguageConstant.sorry.tr,
                                            titleColor: AppColors
                                                .customDialogErrorColor,
                                            descriptions: LanguageConstant
                                                .pleaseTryAgain.tr,
                                            text: LanguageConstant.ok.tr,
                                            functionCall: () {
                                              Navigator.pop(context);
                                            },
                                            img:
                                                'assets/icons/dialog_error.png',
                                          );
                                        });
                                  }
                                }

                                // if (_userProfileUpdateFormKey.currentState!
                                //     .validate()) {
                                //   log(editUserProfileController
                                //       .userProfileFirstNameController.text);
                                //   log(editUserProfileController
                                //       .userProfileLastNameController.text);
                                //   log(editUserProfileController
                                //       .userProfileUserNameController.text);
                                //   log(editUserProfileController
                                //       .userProfileDescriptionController.text);
                                //   log(editUserProfileController
                                //       .userProfileZipCodeController.text);
                                //   log(editUserProfileController
                                //       .userProfileAddressLine1Controller.text);

                                //   ///loader
                                //   Get.find<GeneralController>()
                                //       .updateFormLoaderController(true);

                                //   ///post-method
                                //   postMethod(
                                //       context,
                                //       editUserProfileURL,
                                //       {
                                //         // "logged_in_as": "student",
                                //         "first_name": editUserProfileController
                                //             .userProfileFirstNameController
                                //             .text,
                                //         "last_name": editUserProfileController
                                //             .userProfileLastNameController.text,
                                //         "user_name": editUserProfileController
                                //             .userProfileUserNameController.text,
                                //         "description": editUserProfileController
                                //             .userProfileDescriptionController
                                //             .text,
                                //         "address_line_1":
                                //             editUserProfileController
                                //                 .userProfileAddressLine1Controller
                                //                 .text,
                                //         "zip_code": editUserProfileController
                                //             .userProfileZipCodeController.text,
                                //         "teacher_categories": "1",
                                //       },
                                //       true,
                                //       editUserProfileDataRepo);
                                // }
                              },
                              buttonText: LanguageConstant.saveProfile.tr,
                              buttonTextStyle: AppTextStyles.buttonTextStyle1,
                              borderRadius: 40,
                              buttonColor: AppColors.gradientOne),
                          Center(
                            child: SizedBox(
                              width: 140.w,
                              child: ButtonWidgetOne(
                                  onTap: () {
                                    getMethod(context, deleteAccountURL, null,
                                        true, deleteAccountRepo);
                                  },
                                  buttonText: LanguageConstant.deleteAccount.tr,
                                  buttonTextStyle: AppTextStyles.bodyTextStyle8,
                                  borderRadius: 40,
                                  buttonColor: AppColors.gradientOne),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ));
      });
    });
  }

  void imagePickerDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            actions: <Widget>[
              CupertinoDialogAction(
                  isDefaultAction: true,
                  onPressed: () async {
                    // Navigator.pop(context);
                    // setState(() {
                    //   Get.find<EditUserProfileController>().profileImagesList =
                    //       [];
                    // });
                    // Get.find<EditUserProfileController>().profileImagesList.add(
                    //     await ImagePickerGC.pickImage(
                    //         enableCloseButton: true,
                    //         context: context,
                    //         source: ImgSource.Camera,
                    //         barrierDismissible: true,
                    //         imageQuality: 10,
                    //         maxWidth: 400,
                    //         maxHeight: 600));
                    // setState(() {
                    //   Get.find<EditUserProfileController>().profileImage = File(
                    //       Get.find<EditUserProfileController>()
                    //           .profileImagesList[0]
                    //           .path);
                    // });
                    Navigator.pop(context);
                    await pickImage(context, ImageSource.camera);
                  },
                  child: Text(
                    LanguageConstant.camera.tr,
                    style: AppTextStyles.buttonTextStyle8,
                  )),
              CupertinoDialogAction(
                  isDefaultAction: true,
                  onPressed: () async {
                    // Navigator.pop(context);
                    // setState(() {
                    //   Get.find<EditUserProfileController>().profileImagesList =
                    //       [];
                    // });
                    // Get.find<EditUserProfileController>().profileImagesList.add(
                    //     await ImagePickerGC.pickImage(
                    //         enableCloseButton: true,
                    //         context: context,
                    //         source: ImgSource.Gallery,
                    //         barrierDismissible: true,
                    //         imageQuality: 10,
                    //         maxWidth: 400,
                    //         maxHeight: 600));
                    // setState(() {
                    //   Get.find<EditUserProfileController>().profileImage = File(
                    //       Get.find<EditUserProfileController>()
                    //           .profileImagesList[0]
                    //           .path);
                    // });
                    Navigator.pop(context);
                    await pickImage(context, ImageSource.gallery);
                  },
                  child: Text(
                    LanguageConstant.gallery.tr,
                    style: AppTextStyles.buttonTextStyle8,
                  )),
            ],
          );
        });
  }

  Future<void> pickImage(BuildContext context, ImageSource source) async {
    final EditUserProfileController controller =
        Get.find<EditUserProfileController>();

    // Request permission before accessing the camera/gallery
    bool hasPermission = await requestPermission(source);
    if (!hasPermission) return;

    final ImagePicker _picker = ImagePicker();
    XFile? pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 10,
      maxWidth: 400,
      maxHeight: 600,
    );
    setState(() {});
    if (pickedFile != null) {
      controller.profileImagesList = [File(pickedFile.path)];
      controller.profileImage = File(pickedFile.path);

      print(pickedFile.path);
      print(controller.profileImage);
    }
  }

  Future<bool> requestPermission(ImageSource source) async {
    PermissionStatus status;

    if (source == ImageSource.camera) {
      status = await Permission.camera.request();
    } else {
      status = await Permission.photos
          .request(); // Android 13+ requires READ_MEDIA_IMAGES
    }

    if (status.isGranted) {
      return true;
    } else if (status.isPermanentlyDenied) {
      return false;
    }
    return false;
  }
}
