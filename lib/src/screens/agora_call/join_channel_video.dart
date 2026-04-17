// ignore_for_file: library_prefixes

import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../config/app_colors.dart';
import '../../controllers/general_controller.dart';
import 'agora.config.dart' as config;

/// MultiChannel Example
class JoinChannelVideo extends StatefulWidget {
  const JoinChannelVideo({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<JoinChannelVideo> {
  late final RtcEngine _engine;

  bool isJoined = false, switchCamera = true, switchRender = true;
  // List<int> remoteUid = [];
  int? remoteUid;
  bool localUserJoined = false;
  _callEndCheckMethod() {
    if (callEnd == 2) {
      _leaveChannel();
      Get.back();
    }
  }

  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _callEndCheckMethod();
    });
    // if (Get.find<GeneralController>().callerType == 1) {
    Future.delayed(
      const Duration(seconds: 2),
    ).whenComplete(() => _joinChannel());
    // }

    _initEngine();
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
    _engine.release();
  }

  int? callEnd = 0;

  _initEngine() async {
    // _engine =
    //     await RtcEngine.createWithContext(RtcEngineContext(config.agoraAppId));
    // _addListeners();
    // await _engine.enableVideo();
    // await _engine.startPreview();
    // await _engine.enableLocalVideo(true);
    // VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
    // await _engine.setVideoEncoderConfiguration(configuration);
    _engine = createAgoraRtcEngineEx();
    await _engine.initialize(RtcEngineContext(
      appId: config.agoraAppId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));

    _addListeners();

    await _engine.enableVideo();
    await _engine.startPreview();
    await _engine.enableLocalVideo(true);

    await _engine.setVideoEncoderConfiguration(
      const VideoEncoderConfiguration(),
    );
  }

  _addListeners() {
    // _engine.setEventHandler(RtcEngineEventHandler(
    //   joinChannelSuccess: (channel, uid, elapsed) {
    //     setState(() {
    //       isJoined = true;
    //     });
    //   },
    //   userJoined: (uid, elapsed) {
    //     setState(() {
    //       remoteUid = uid;
    //       callEnd = 1;
    //     });
    //   },
    //   userOffline: (uid, reason) {
    //     setState(() {
    //       remoteUid = uid;
    //       if (callEnd == 1) {
    //         callEnd = 2;
    //       }
    //     });
    //     // if (remoteUid.isEmpty) {}
    //   },
    //   leaveChannel: (stats) {
    //     _leaveChannel();
    //     setState(() {
    //       isJoined = false;
    //       remoteUid = null;
    //       // remoteUid.clear();
    //     });
    //   },
    // ));
    _engine.registerEventHandler(RtcEngineEventHandler(
      onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
        isJoined = true;
      },
      onUserJoined: (RtcConnection connection, int uid, int elapsed) {
        remoteUid = uid;
        callEnd = 1;
      },
      onUserOffline:
          (RtcConnection connection, int uid, UserOfflineReasonType reason) {
        remoteUid = uid;
        if (callEnd == 1) {
          callEnd = 2;
        }
      },
      onLeaveChannel: (RtcConnection connection, RtcStats stats) {
        _leaveChannel();
        isJoined = false;
        remoteUid = null;
      },
    ));
  }

  Future<dynamic> _joinChannel() async {
    // if (defaultTargetPlatform == TargetPlatform.android) {
    //   await [Permission.microphone, Permission.camera].request();
    // }
    // await _engine.joinChannel(
    //     Get.find<GeneralController>().tokenForCall,
    //     Get.find<GeneralController>().channelForCall!,
    //     null,
    //     Get.find<GeneralController>().callerType);
    // _addListeners();
    if (defaultTargetPlatform == TargetPlatform.android) {
      await [Permission.microphone, Permission.camera].request();
    }

    await _engine.joinChannel(
      token: Get.find<GeneralController>().tokenForCall!,
      channelId: Get.find<GeneralController>().channelForCall!,
      uid: Get.find<GeneralController>().callerType,
      options: const ChannelMediaOptions(),
    );

    _addListeners();
  }

  _leaveChannel() async {
    await _engine.leaveChannel();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
        child: remoteVideo(),
        onWillPop: () async {
          return false;
        });
  }

  void onCallEnd(BuildContext context) {
    // Navigator.pop(context);
    Get.back();
  }

  bool muted = false;

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    _engine.muteLocalAudioStream(muted);
  }

  void _onSwitchCamera() {
    _engine.switchCamera();
  }

  Widget _toolbar() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
            onPressed: _onToggleMute,
            shape: const CircleBorder(),
            elevation: 2.0,
            fillColor: muted ? AppColors.primaryColor : Colors.white,
            padding: const EdgeInsets.all(12.0),
            child: Icon(
              muted ? Icons.mic_off : Icons.mic,
              color: muted ? Colors.white : AppColors.primaryColor,
              size: 20.0,
            ),
          ),
          RawMaterialButton(
            onPressed: () {
              _leaveChannel();
              Get.back();
              // _onCallEnd(context);
            },
            shape: const CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
            child: const Icon(
              Icons.clear,
              color: Colors.white,
              size: 35.0,
            ),
          ),
          RawMaterialButton(
            onPressed: _onSwitchCamera,
            shape: const CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(12.0),
            child: Icon(
              Icons.switch_camera,
              color: AppColors.primaryColor,
              size: 20.0,
            ),
          )
        ],
      ),
    );
  }

  Widget remoteVideo() {
    if (remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine,
          canvas: VideoCanvas(uid: remoteUid),
          connection: RtcConnection(
              channelId: Get.find<GeneralController>().channelForCall),
        ),
      );
    } else {
      return const Text(
        'Please wait for remote user to join',
        textAlign: TextAlign.center,
      );
    }
  }

  // _renderVideo() {
  //   return SafeArea(
  //     child: Stack(
  //       children: [
  //         remoteUid == 0
  //             ? const SizedBox()
  //             : remoteUid == null
  //                 ? const CircularProgressIndicator()
  //                 : RtcRemoteView.SurfaceView(
  //                     channelId: Get.find<GeneralController>().channelForCall!,
  //                     uid: remoteUid!,
  //                   ),
  //         const SizedBox(
  //           width: 120,
  //           height: 120,
  //           child: RtcLocalView.SurfaceView(),
  //         ),
  //         _toolbar(),
  //         _toolbar()
  //       ],
  //     ),
  //   );
  // }
}