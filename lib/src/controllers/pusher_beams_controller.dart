import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';

import 'package:get/get.dart';
import 'package:pusher_beams/pusher_beams.dart';
import '../api_services/urls.dart';
import '../config/app_configs.dart';
import '../models/pusher_payload_model.dart';
import '../routes.dart';

import '../screens/agora_call/agora_logic.dart';
import '../screens/incoming_call_screen.dart';
import '../models/student_appointment_history_model.dart';
import 'general_controller.dart';

class PusherBeamsController extends GetxController {
  GetPusherBeamsPayloadModel getPusherBeamsPayloadModel =
      GetPusherBeamsPayloadModel();
  bool _isPusherInitialized = false;
  String? _currentPusherUserId;

  @override
  void onInit() {
    super.onInit();
  }

  getSecure() async {
    final userId =
        Get.find<GeneralController>().storageBox.read('userID').toString();
    print("PUSHER USER ID: $userId");
    log("PUSHER USER ID: $userId");
    log("PUSHER AUTH URL: ${apiBaseUrl}pusher/beams-auth");
    final BeamsAuthProvider provider = BeamsAuthProvider()
      ..authUrl = '${apiBaseUrl}pusher/beams-auth'
      ..headers = {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer ${Get.find<GeneralController>().storageBox.read('authToken')}'
      }
      ..queryParams = {
        'user_id':
            Get.find<GeneralController>().storageBox.read('userID').toString()
      }
      ..credentials = 'include';

    try {
      final storageUserId = Get.find<GeneralController>().storageBox.read('userID').toString();
      
      if (storageUserId == "null" || storageUserId.isEmpty) {
        log("PusherBeams getSecure: No user ID in storage");
        return;
      }

      if (_currentPusherUserId == storageUserId) {
        log("PusherBeams user ID already set: $storageUserId");
        return;
      }

      await PusherBeams.instance.setDeviceInterests([
        storageUserId,
      ]);

      if (Get.find<GeneralController>().storageBox.hasData('userID')) {
        await PusherBeams.instance.setUserId(
          storageUserId,
          provider,
          (error) => {
            if (error != null)
              {
                print("$error ERROR PUSHER"),
              }
            else
              {
                print("PUSHER USER ID SET SUCCESS"),
                _currentPusherUserId = storageUserId,
              },

            // Success! Do something...
          },
        );
      }
    } catch (e) {
      log("PusherBeams getSecure error: $e");
    }
  }

  initPusherBeams() async {
    if (kIsWeb || (!Platform.isAndroid && !Platform.isIOS)) return;
    if (_isPusherInitialized) {
      log("PUSHER ALREADY INITIALIZED");
      await getSecure(); // Still try to getSecure in case user just logged in
      return;
    }
    log("INITIALIZE PUSHER");
    log("${Get.find<GeneralController>().storageBox.hasData('userID')} USERIDTRUE");
    log("${Get.find<GeneralController>().storageBox.read('userID')} USERIDREAD");

    try {
      await PusherBeams.instance.start(AppConfigs.pusherBeamsInstanceId.toString());
      await PusherBeams.instance.addDeviceInterest("hello");
      _isPusherInitialized = true;
    } catch (e) {
      log("PusherBeams start error: $e");
    }

    try {
      await getSecure();
      // Let's see our current interests
      if (Get.find<GeneralController>()
          .storageBox
          .read('userID')
          .toString()
          .isNotEmpty) {
        final interests = await PusherBeams.instance.getDeviceInterests();
        log("$interests DEVICEINTEREST");
      }

      // This is not intented to use in web
      if (!kIsWeb) {
        await PusherBeams.instance
            .onInterestChanges((interests) => {print('Interests: $interests')});

        await PusherBeams.instance.onMessageReceivedInTheForeground(
            _onMessageReceivedInTheForeground);
      }

      await _checkForInitialMessage();
    } catch (e) {
      log("PusherBeams init error during post-start: $e");
    }
    log("INITIALIZE PUSHER END");
  }

  Future<void> _checkForInitialMessage() async {
    final initialMessage = await PusherBeams.instance.getInitialMessage();
    if (initialMessage != null) {
      log("${initialMessage.toString()} INITIALMSG");
      // _showAlert(
      //   'Initial Message Is:',
      //   initialMessage.toString(),
      // );
    }
  }

  void _onMessageReceivedInTheForeground(Map<Object?, Object?> data) {
    log("PUSHER MESSAGE RECEIVED: $data");
    dynamic allData = data["data"];
    if (allData == null || allData["payload"] == null) {
      log("Pusher Beams Payload is null");
      return;
    }
    Map<String, dynamic> payload = jsonDecode(allData["payload"]);
    dynamic appointmentData = payload["appointment"];
    if (appointmentData == null) {
      log("Pusher Beams Appointment Data is null");
      return;
    }

    log("${jsonDecode(allData["payload"])} PAYLOAD");
    log("${appointmentData} APPOINTMENT");

    Get.find<GeneralController>().updateChannelForCall(payload["channel_name"]);
    Get.find<GeneralController>()
        .updateTokenForCall(payload["token"].toString());

    log("CHANNEL NAME: ${payload["channel_name"]}");

    if (Get.find<GeneralController>().storageBox.hasData('userData') &&
        Get.find<GeneralController>().storageBox.hasData('authToken')) {
      // Update GeneralController with appointment data so call screens can use it
      final tempAppt = StudentAppointmentHistoryModel(
        id: appointmentData["id"],
        studentId: appointmentData["student_id"],
        teacherName: appointmentData["teacher_name"]?.toString() ?? "Teacher",
        teacherImage: appointmentData["teacher_image"]?.toString() ?? "",
        appointmentTypeName: appointmentData["appointment_type_name"],
        appointmentTypeId: appointmentData["appointment_type_id"],
      );
      Get.find<GeneralController>()
          .updateSelectedAppointmentHistoryForView(tempAppt);

      Get.to(
          IncomingCallScreen(
            callAcceptOnTap:
                appointmentData["appointment_type_id"].toString() == "1"
                    ? () {
                        Get.back();
                        Get.toNamed(PageRoutes.videoCallScreen);
                      }
                    : appointmentData["appointment_type_id"].toString() == "2"
                        ? () {
                            Get.back();
                            Get.toNamed(PageRoutes.audioCallScreen);
                          }
                        : () {
                            Get.back();
                            Get.toNamed(PageRoutes.liveChatScreen);
                          },
            callRejectOnTap: () {
              Get.find<AgoraLogic>().leaveChannel();
              Get.back();
            },
            callingUserName:
                appointmentData["teacher_name"]?.toString() ?? "Teacher",
            image: appointmentData["teacher_image"]?.toString() ?? '',
            incomingCallType: appointmentData["appointment_type_id"]
                        .toString() ==
                    "3"
                ? "Incoming Live Chat"
                : "Incoming ${appointmentData["appointment_type_name"] ?? 'Call'}",
          ),
          fullscreenDialog: true,
          transition: Transition.downToUp,
          duration: const Duration(milliseconds: 600));
      log("Pusher Beams Call Notification is Initialized");
    } else {
      log("Pusher Beams Call Notification is not Initialized");
    }
  }

  clearAllStatePusherBeams() async {
    await PusherBeams.instance.clearAllState();
    _isPusherInitialized = false;
    _currentPusherUserId = null;
    log("Pusher Beams States are cleared");
  }

  clearDeviceInterests() async {
    await PusherBeams.instance.clearDeviceInterests();
    _isPusherInitialized = false;
    _currentPusherUserId = null;
    log("Pusher Beams Device Interests are cleared");
  }
}
