import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';

import 'package:get/get.dart';
import 'package:pusher_beams/pusher_beams.dart';
import '../api_services/urls.dart';
import '../models/pusher_payload_model.dart';
import '../routes.dart';

import '../screens/agora_call/agora_logic.dart';
import '../screens/incoming_call_screen.dart';
import '../models/student_appointment_history_model.dart';
import 'general_controller.dart';

class PusherBeamsController extends GetxController {
  GetPusherBeamsPayloadModel getPusherBeamsPayloadModel =
      GetPusherBeamsPayloadModel();

  @override
  void onInit() {
    super.onInit();
  }

  getSecure() async {
    final BeamsAuthProvider provider = BeamsAuthProvider()
      ..authUrl = '${apiBaseUrl}pusher/beams-auth'
      ..headers = {'Content-Type': 'application/json'}
      ..queryParams = {
        'user_id':
            Get.find<GeneralController>().storageBox.read('userID').toString()
      }
      ..credentials = 'omit';

    // if (Get.find<GeneralController>().storageBox.hasData('userID')) {
    await PusherBeams.instance.setDeviceInterests([
      Get.find<GeneralController>().storageBox.read('userID').toString(),
    ]);
    // }
    if (Get.find<GeneralController>().storageBox.hasData('userID')) {
      await PusherBeams.instance.setUserId(
        Get.find<GeneralController>().storageBox.read('userID').toString(),
        provider,
        (error) => {
          if (error != null)
            {
              print("$error ERROR PUSHER"),
            }
          else
            {
              print("$error PUSHER2"),
            },

          // Success! Do something...
        },
      );
    }
  }

  initPusherBeams() async {
    log("INITIALIZE PUSHER");
    log("${Get.find<GeneralController>().storageBox.hasData('userID')} USERIDTRUE");
    log("${Get.find<GeneralController>().storageBox.read('userID')} USERIDREAD");

    await getSecure();
    // Let's see our current interests
    if (Get.find<GeneralController>()
        .storageBox
        .read('userID')
        .toString()
        .isNotEmpty) {
      log(await "${PusherBeams.instance.getDeviceInterests()} DEVICEINTEREST");
    }

    // This is not intented to use in web
    if (!kIsWeb) {
      await PusherBeams.instance
          .onInterestChanges((interests) => {print('Interests: $interests')});

      await PusherBeams.instance
          .onMessageReceivedInTheForeground(_onMessageReceivedInTheForeground);
    }

    await _checkForInitialMessage();
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
    dynamic allData = data["data"];
    Map<String, dynamic> payload = jsonDecode(allData["payload"]);
    dynamic appointmentData = payload["appointment"];

    log("${jsonDecode(allData["payload"])} PAYLOAD");
    log("${appointmentData} APPOINTMENT");

    Get.find<GeneralController>().updateChannelForCall(payload["channel_name"]);
    Get.find<GeneralController>().updateTokenForCall(payload["token"].toString());

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
    log("Pusher Beams States are cleared");
  }

  clearDeviceInterests() async {
    await PusherBeams.instance.clearDeviceInterests();
    log("Pusher Beams Device Interests are cleared");
  }
}
