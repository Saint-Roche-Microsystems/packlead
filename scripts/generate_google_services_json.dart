import 'dart:io';
import 'dart:convert';

void main() {
  final env = Platform.environment;

  final googleServices = {
    "project_info": {
      "project_number": env['FIREBASE_MESSAGING_SENDER_ID'],
      "project_id": env['FIREBASE_PROJECT_ID'],
      "storage_bucket": env['FIREBASE_STORAGE_BUCKET'],
    },
    "client": [
      {
        "client_info": {
          "mobilesdk_app_id": env['FIREBASE_APP_ID_ANDROID'],
          "android_client_info": {"package_name": "com.srmc.packlead"},
        },
        "oauth_client": [],
        "api_key": [
          {"current_key": env['FIREBASE_API_KEY_ANDROID']},
        ],
        "services": {
          "appinvite_service": {"other_platform_oauth_client": []},
        },
      },
    ],
    "configuration_version": "1",
  };

  final file = File('android/app/google-services.json');
  file.writeAsStringSync(JsonEncoder.withIndent('  ').convert(googleServices));
  print('-> google-services.json created');
}
