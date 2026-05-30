import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:resize/resize.dart';
import 'firebase_options.dart';
import 'multi_language/languages.dart';
import 'src/api_services/get_service.dart';
import 'src/api_services/logic.dart';
import 'src/api_services/urls.dart';
import 'src/controllers/all_academies_controller.dart';
import 'src/controllers/all_events_controller.dart';
import 'src/controllers/all_featured_teachers_controller.dart';
import 'src/controllers/all_languages_controller.dart';
import 'src/controllers/all_services_controller.dart';
import 'src/controllers/all_settings_controller.dart';
import 'src/controllers/all_teachers_controller.dart';
import 'src/controllers/all_top_rated_teachers_controller.dart';
import 'src/controllers/general_controller.dart';
import 'src/controllers/logged_in_user_controller.dart';
import 'src/controllers/pusher_beams_controller.dart';
import 'src/controllers/search_controller.dart';
import 'src/repositories/all_languages_repo.dart';
import 'src/repositories/all_settings_repo.dart';
import 'src/repositories/main_repo/main_logic.dart';
import 'src/routes.dart';
import 'src/screens/agora_call/agora_logic.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'private-make-agora-call', // id
    'High Importance Notifications', // title
    // 'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  // ALL GOOD
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  Get.put(ApiController());
  Get.put(GetAllSettingsController());
  Get.put(GetAllLanguagesController());
  Get.put(GeneralController());
  Get.put(LoggedInUserController());

  Get.put(SearchBarController());
  Get.put(MainLogic());
  Get.put(AgoraLogic());
  Get.put(PusherBeamsController());

  Get.put(AllTeachersController());
  Get.put(AllFeaturedTeachersController());
  Get.put(AllTopRatedTeachersController());
  Get.put(AllEventsController());
  Get.put(AllServicesController());
  Get.put(AllAcademiesController());

  //-----load-configurations-from-local-json
  try {
    await GlobalConfiguration().loadFromUrl(getAllSettingUrl);
    log("Working");
  } catch (e) {
    log("Error");
    // something went wrong while fetching the config from the url ... do something
  }

  runApp(
    const MyApp(),
  );

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(channel.id, channel.name,
              // channel.description,
              importance: Importance.high,
              priority: Priority.high,
              // color: Colors.blue,
              playSound: true,
              icon: '@mipmap/ic_launcher'),
        ),
      );
    }
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Get All Settings
    getMethod(context, getAllSettingUrl, null, true, getAllSettingsRepo);
    // Get All Languages
    getMethod(context, getAllLanguagesUrl, null, true, getAllLanguagesRepo);
    
    // Delay requesting notification permission to ensure the Native Activity has fully resumed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      requestNotificationPermission();
    });
  }

  Future<void> requestNotificationPermission() async {
    // 1. Request via permission_handler (especially for Android 13+)
    try {
      PermissionStatus status = await Permission.notification.status;
      if (status.isDenied) {
        status = await Permission.notification.request();
        log('permission_handler notification request status: $status');
      }
    } catch (e) {
      log('permission_handler notification request error: $e');
    }

    // 2. Request via FirebaseMessaging
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      log('User granted provisional permission');
    } else {
      log('User declined or has not accepted permission');
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Resize(
      allowtextScaling: true,
      size: const Size(375, 812),
      builder: () {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          translations: LanguagesChang(),
          title: 'Geniaes - Students',
          initialBinding: BindingsBuilder(() {}),
          locale: Locale(
              '${Get.find<GeneralController>().storageBox.read('languageCode')}',
              '${Get.find<GeneralController>().storageBox.read('countryCode')}'),
          fallbackLocale: Locale(
              '${Get.find<GeneralController>().storageBox.read('languageCode')}',
              '${Get.find<GeneralController>().storageBox.read('countryCode')}'),
          // fallbackLocale: const Locale('en', 'US'),
          theme: ThemeData(),
          initialRoute: PageRoutes.splashScreen,
          getPages: appRoutes(),
        );
      },
    );
  }
}
