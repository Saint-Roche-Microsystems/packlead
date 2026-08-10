import 'dart:io';

Future<void> main() async {
  if (!File('.env').existsSync()) {
    print('Error: .env file not found');
    exit(1);
  }

  final envContent = await File('.env').readAsString();
  final envVars = <String, String>{};

  for (final line in envContent.split('\n')) {
    final trimmed = line.trim();
    if (trimmed.isEmpty || trimmed.startsWith('#')) continue;

    final parts = trimmed.split('=');
    if (parts.length >= 2) {
      final key = parts[0].trim();
      final value = parts.sublist(1).join('=').trim();
      envVars[key] = value;
    }
  }

  print(' Generating configuration files...\n');

  final googleServicesResult = await Process.run(
    'dart',
    ['scripts/generate_google_services_json.dart'],
    environment: {...Platform.environment, ...envVars},
  );

  if (googleServicesResult.exitCode != 0) {
    print(' Failed to generate google-services.json');
    print(googleServicesResult.stderr);
    exit(1);
  }
  print(googleServicesResult.stdout);

  final firebaseJsonResult = await Process.run(
    'dart',
    ['scripts/generate_firebase_json.dart'],
    environment: {...Platform.environment, ...envVars},
  );

  if (firebaseJsonResult.exitCode != 0) {
    print(' Failed to generate firebase.json');
    print(firebaseJsonResult.stderr);
    exit(1);
  }
  print(firebaseJsonResult.stdout);

  print('\nSetup complete! You can now run the App');
}
