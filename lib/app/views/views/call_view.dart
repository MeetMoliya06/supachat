import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class CallView extends GetView {
  final String userID;
  final String callID;
  final bool isVideo;
  const CallView({super.key, required this.userID, required this.callID, required this.isVideo});
  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
      appID: 1455117441,
      appSign: "37b309858e442bec882e20194e4534840928e7bc4a318aeadfd03ac639808aae",
      userID: userID,
      userName: 'user_$userID',
      callID: callID,
      config: isVideo ? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall() : ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall(),
    );
  }
}
