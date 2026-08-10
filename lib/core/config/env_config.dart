import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static String get firebaseApiKeyAndroid =>
      dotenv.env['FIREBASE_API_KEY_ANDROID'] ?? '';
  static String get firebaseApiKeyIOS =>
      dotenv.env['FIREBASE_API_KEY_IOS'] ?? '';
  static String get firebaseAppIdAndroid =>
      dotenv.env['FIREBASE_APP_ID_ANDROID'] ?? '';
  static String get firebaseAppIdIOS => dotenv.env['FIREBASE_APP_ID_IOS'] ?? '';

  static String get firebaseProjectId =>
      dotenv.env['FIREBASE_PROJECT_ID'] ?? '';
  static String get firebaseMessagingSenderId =>
      dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ?? '';
  static String get firebaseStorageBucket =>
      dotenv.env['FIREBASE_STORAGE_BUCKET'] ?? '';

  static String get googleMapsApiKey =>
      dotenv.env['GOOGLE_MAPS_API_KEY_ANDROID'] ?? '';

  static String get apiBaseUrl => dotenv.env['API_BASE_URL'] ?? '';

  static String get localService => dotenv.env['LOCAL_SERVICE'] ?? 'API';

  static Future<void> load() async {
    await dotenv.load(fileName: ".env");
    _validate();
  }

  static void _validate() {
    assert(
      firebaseApiKeyAndroid.isNotEmpty,
      'FIREBASE_API_KEY_ANDROID is not set in .env',
    );
    assert(
      firebaseApiKeyIOS.isNotEmpty,
      'FIREBASE_API_KEY_IOS is not set in .env',
    );
    assert(
      firebaseAppIdAndroid.isNotEmpty,
      'FIREBASE_APP_ID_ANDROID is not set in .env',
    );
    assert(
      firebaseAppIdIOS.isNotEmpty,
      'FIREBASE_APP_ID_IOS is not set in .env',
    );
    assert(
      firebaseProjectId.isNotEmpty,
      'FIREBASE_PROJECT_ID is not set in .env',
    );
    assert(
      firebaseMessagingSenderId.isNotEmpty,
      'FIREBASE_MESSAGING_SENDER_ID is not set in .env',
    );
    assert(
      firebaseStorageBucket.isNotEmpty,
      'FIREBASE_STORAGE_BUCKET is not set in .env',
    );
    assert(
      googleMapsApiKey.isNotEmpty,
      'GOOGLE_MAPS_API_KEY is not set in .env',
    );
    assert(apiBaseUrl.isNotEmpty, 'API_BASE_URL is not set in .env');
  }
}
