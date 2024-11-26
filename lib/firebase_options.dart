// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDYY7wHcNgauAJJG4BW-FoeTFv9oi2CsoA',
    appId: '1:389412089387:android:dbcd3d87949fcdb8ba846e',
    messagingSenderId: '389412089387',
    projectId: 'task-manager-2fb12',
    storageBucket: 'task-manager-2fb12.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDNhioXXIpS71X-zAtyMzKJGzF7J5zKOH8',
    appId: '1:389412089387:ios:148d9e22ea4e4f2fba846e',
    messagingSenderId: '389412089387',
    projectId: 'task-manager-2fb12',
    storageBucket: 'task-manager-2fb12.firebasestorage.app',
    iosBundleId: 'com.example.taskManager',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAe-AX7gThpr5z265CVebT_Mu4tl0vUt5w',
    appId: '1:389412089387:web:24ab6f231338ee2cba846e',
    messagingSenderId: '389412089387',
    projectId: 'task-manager-2fb12',
    authDomain: 'task-manager-2fb12.firebaseapp.com',
    storageBucket: 'task-manager-2fb12.firebasestorage.app',
  );
}