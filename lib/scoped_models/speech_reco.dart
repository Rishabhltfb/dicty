import 'package:permission_handler/permission_handler.dart';

import './connected_scoped_model.dart';

class SpeechRecognitionService extends ConnectedModel {
  void requestPermission() async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.microphone);

    if (permission != PermissionStatus.granted) {
      await PermissionHandler()
          .requestPermissions([PermissionGroup.microphone]);
    }
  }
}
