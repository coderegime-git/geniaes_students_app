import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:resize/resize.dart';
import 'package:tutorhub_for_students/src/controllers/all_languages_controller.dart';

import 'firebase_options.dart';
import 'multi_language/languages.dart';
import 'src/api_services/get_service.dart';
import 'src/api_services/logic.dart';
import 'src/api_services/urls.dart';
import 'src/controllers/all_settings_controller.dart';
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

@pragma('vm:entry-point')
Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("BG message: ${message.notification?.title}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 1. Background handler - FIRST
  FirebaseMessaging.onBackgroundMessage(firebaseBackgroundHandler);

  // 2. Initialize local notifications
  const AndroidInitializationSettings androidSettings =
  AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initSettings =
  InitializationSettings(android: androidSettings);
  await flutterLocalNotificationsPlugin.initialize(initSettings);

  // 3. Create notification channel
  await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);

  // 4. Foreground options
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  // 5. Get & print token
  String? t = await FirebaseMessaging.instance.getToken();
  print("FCM TOKEN ---- $t"); // ← Check this in terminal!

  // 6. Foreground message listener
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            importance: Importance.high,
            priority: Priority.high,
            playSound: true,
            icon: '@mipmap/ic_launcher',
          ),
        ),
      );
    }
  });

  // 7. GetX controllers
  Get.put(ApiController());
  Get.put(GetAllSettingsController());
  Get.put(GetAllLanguagesController());
  Get.put(GeneralController());
  Get.put(LoggedInUserController());
  Get.put(SearchBarController());
  Get.put(MainLogic());
  Get.put(AgoraLogic());
  Get.put(PusherBeamsController());

  try {
    await GlobalConfiguration().loadFromUrl(getAllSettingUrl);
  } catch (e) {
    log("Config Error: $e");
  }

  runApp(const MyApp()); // ← Always last
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
