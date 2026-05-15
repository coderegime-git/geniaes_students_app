import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tutorhub_for_students/src/config/app_colors.dart';

import '../config/app_configs.dart';
import '../controllers/all_events_controller.dart';
import '../controllers/all_featured_teachers_controller.dart';
import '../controllers/all_academies_controller.dart';
import '../controllers/all_services_controller.dart';
import '../controllers/all_settings_controller.dart';
import '../controllers/all_teachers_controller.dart';
import '../controllers/all_top_rated_teachers_controller.dart';
import '../models/logged_in_user_model.dart';
import '../api_services/get_service.dart';
import '../api_services/post_service.dart';
import '../api_services/urls.dart';
import '../controllers/general_controller.dart';

import '../repositories/all_events_repo.dart';
import '../repositories/all_featured_teachers_repo.dart';
import '../repositories/all_academies_repo.dart';
import '../repositories/all_services_repo.dart';
import '../repositories/all_teachers_repo.dart';
import '../repositories/all_top_rated_teachers_repo.dart';
import '../routes.dart';
import '../widgets/background_widgets/splash_screen_background_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;
  late AnimationController _controller;

  startTime() async {
    final controller = Get.find<GetAllSettingsController>();
    final logo = controller.getAllSettingsModel.data?.logo;

    // If logo is null or empty, fallback to default delay
    if (logo == null || logo.isEmpty) {
      await Future.delayed(const Duration(seconds: 3));
      checkFirstSeenAndNavigate();
      return;
    }

    final image = NetworkImage("${AppConfigs.mediaUrl}$logo");

    final completer = Completer();

    image.resolve(const ImageConfiguration()).addListener(
          ImageStreamListener(
            (ImageInfo imageInfo, bool synchronousCall) {
              // Logo loaded successfully
              completer.complete();
            },
            onError: (dynamic exception, StackTrace? stackTrace) {
              // Logo failed to load; still navigate
              completer.complete();
            },
          ),
        );

    // Wait for logo load or timeout as fallback
    await Future.any([
      completer.future,
      Future.delayed(const Duration(seconds: 6)), // max wait
    ]);

    checkFirstSeenAndNavigate();
  }

  Future checkFirstSeenAndNavigate() async {
    bool seen =
        (Get.find<GeneralController>().storageBox.read('seen') ?? false);

    if (seen) {
      Get.toNamed(PageRoutes.homeScreen);
    } else {
      await Get.find<GeneralController>().storageBox.write('seen', true);
      Get.toNamed(PageRoutes.introScreen);
    }
  }

  @override
  void initState() {
    super.initState();

    if (Get.find<GeneralController>().storageBox.hasData('userData') &&
        Get.find<GeneralController>().storageBox.hasData('authToken')) {
      Get.find<GeneralController>().currentUserModel = User.fromJson(jsonDecode(
          Get.find<GeneralController>().storageBox.read('userData')));
    }
    log("${Get.find<GeneralController>().storageBox.read('userData')} Intro User Data");

    // Get All Teachers on Home Page
    postMethod(
        context, '$getAllTeachers?page=1', null, false, getAllTeachersRepo);
    // Get All Featured Teachers on Home Page
    getMethod(context, getFeaturedTeachers, {'limit': 10}, false,
        getAllFeaturedTeachersRepo);
    // Get All Top Rated Teachers on Home Page
    getMethod(context, getTopRatedTeachers, {'limit': 10}, false,
        getAllTopRatedTeachersRepo);
    // Get All Events on Home Page
    postMethod(context, '$getAllEvents?page=1', null, false, getAllEventsRepo);
    // Get All Services on Home Page
    postMethod(
        context, '$getAllServices?page=1', null, false, getAllServicesRepo);
    // Get All Academies on Home Page
    postMethod(
        context, '$getAllAcademies?page=1', null, false, getAllAcademiesRepo);

    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));
    animation =
        CurvedAnimation(parent: animationController, curve: Curves.easeInOut);

    animation.addListener(() => setState(() {}));
    animationController.forward();

    startTime();

    _controller = AnimationController(
        duration: const Duration(milliseconds: 10800),
        vsync: this,
        value: 0,
        lowerBound: 0,
        upperBound: 1);

    _controller.forward();
  }

  @override
  dispose() {
    _controller.dispose();
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GetAllSettingsController>(
        builder: (getAllSettingsController) {
      final logo = getAllSettingsController.getAllSettingsModel.data?.logo;
      return Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: Stack(
          children: <Widget>[
            Positioned(child: SplashBackgroundWidget()),
            Container(
              decoration: const BoxDecoration(color: AppColors.white),
              child: Center(
                child: AnimatedBuilder(
                  animation: animation,
                  builder: (context, child) {
                    return logo == null || logo.isEmpty
                        ? const CircularProgressIndicator(
                            color: AppColors.primaryColor,
                          )
                        : SizedBox(
                            width: animation.value * 350,
                            height: animation.value * 150,
                            child: Image.network(
                              "${AppConfigs.mediaUrl}$logo",
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  const CircularProgressIndicator(
                                color: AppColors.primaryColor,
                              ),
                            ),
                          );
                  },
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
