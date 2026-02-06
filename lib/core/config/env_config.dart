import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static String get firebaseApiKeyAndroid => dotenv.env['FIREBASE_API_KEY_ANDROID'] ?? '';
  static String get firebaseApiKeyIOS => dotenv.env['FIREBASE_API_KEY_IOS'] ?? '';
  static String get firebaseAppIdAndroid => dotenv.env['FIREBASE_APP_ID_ANDROID'] ?? '';
  static String get firebaseAppIdIOS => dotenv.env['FIREBASE_APP_ID_IOS'] ?? '';

  static String get firebaseProjectId => dotenv.env['FIREBASE_PROJECT_ID'] ?? '';
  static String get firebaseMessagingSenderId => dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ?? '';
  static String get firebaseStorageBucket => dotenv.env['FIREBASE_STORAGE_BUCKET'] ?? '';

  static String get ordersApiBaseUrl => dotenv.env['ORDERS_API_BASE_URL'] ?? '';

  static Future<void> load() async {
    await dotenv.load(fileName: ".env");
    _validate();
  }

  static void _validate() {
    assert(firebaseApiKeyAndroid.isNotEmpty, 'FIREBASE_API_KEY_ANDROID is not set in .env');
    assert(firebaseApiKeyIOS.isNotEmpty, 'FIREBASE_API_KEY_IOS is not set in .env');
    assert(firebaseAppIdAndroid.isNotEmpty, 'FIREBASE_APP_ID_ANDROID is not set in .env');
    assert(firebaseAppIdIOS.isNotEmpty, 'FIREBASE_APP_ID_IOS is not set in .env');
    assert(firebaseProjectId.isNotEmpty, 'FIREBASE_PROJECT_ID is not set in .env');
    assert(firebaseMessagingSenderId.isNotEmpty, 'FIREBASE_MESSAGING_SENDER_ID is not set in .env');
    assert(firebaseStorageBucket.isNotEmpty, 'FIREBASE_STORAGE_BUCKET is not set in .env');
    assert(ordersApiBaseUrl.isNotEmpty, 'ORDERS_API_BASE_URL is not set in .env');
  }
}