import 'dart:io';
import 'dart:convert';

void main() {
  final env = Platform.environment;

  final firebaseJson = {
    "flutter": {
      "platforms": {
        "android": {
          "default": {
            "projectId": env['FIREBASE_PROJECT_ID'],
            "appId": env['FIREBASE_APP_ID_ANDROID'],
            "fileOutput": "android/app/google-services.json",
          },
        },
        "dart": {
          "lib/firebase_options.dart": {
            "projectId": env['FIREBASE_PROJECT_ID'],
            "configurations": {
              "android": env['FIREBASE_APP_ID_ANDROID'],
              "ios": env['FIREBASE_APP_ID_IOS'],
            },
          },
        },
      },
    },
  };

  final file = File('firebase.json');
  file.writeAsStringSync(JsonEncoder.withIndent('  ').convert(firebaseJson));
  print('-> firebase.json created');
}
