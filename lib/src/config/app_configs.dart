import 'package:get/get.dart';
import '../controllers/all_settings_controller.dart';

class AppConfigs {
  AppConfigs._();

  static String baseUrl = "https://www.geniaes.com/";
  static String apiBaseUrl = "https://www.geniaes.com/api/v1/";
  static String mediaUrl = "https://www.geniaes.com";

  static dynamic agoraAppId = Get.find<GetAllSettingsController>()
          .getAllSettingsModel
          .data!
          .agoraAppId ??
      "";
  static dynamic agoraAppCertificate = Get.find<GetAllSettingsController>()
          .getAllSettingsModel
          .data!
          .agoraAppCertificate ??
      "";
  static dynamic pusherBeamsInstanceId = "9466bd1b-2413-4135-badc-36ae30931bac";
  static dynamic pusherBeamsSecretKey = "7DDCB27292D90F8C5477BDC0B55CC575D7F4BDC34E6A1CE3ACA66B7AB5703FF2";
  static dynamic pusherAppId = "2147119";
  static dynamic pusherAppKey = "bb996c4ee562d236d648";
  static dynamic pusherAppSecret = "7b8eb3018fd3d46c7e3a";
  static dynamic pusherAppCluster = "ap2";
  static dynamic stripeKey = Get.find<GetAllSettingsController>()
          .getAllSettingsModel
          .data!
          .stripeKey ??
      "";
  static dynamic stripeSecret = Get.find<GetAllSettingsController>()
          .getAllSettingsModel
          .data!
          .stripeSecret ??
      "";
  static dynamic googleClientId = Get.find<GetAllSettingsController>()
          .getAllSettingsModel
          .data!
          .googleClientId ??
      "";
  static dynamic googleClientSecret = Get.find<GetAllSettingsController>()
          .getAllSettingsModel
          .data!
          .googleClientSecret ??
      "";
  static dynamic facebookClientId = Get.find<GetAllSettingsController>()
          .getAllSettingsModel
          .data!
          .facebookClientId ??
      "";
  static dynamic facebookClientSecret = Get.find<GetAllSettingsController>()
          .getAllSettingsModel
          .data!
          .facebookClientSecret ??
      "";
  static dynamic appLogo =
      Get.find<GetAllSettingsController>().getAllSettingsModel.data!.logo ?? "";
}
