// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
      return web;
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDf4U0NvIrwZiZVkaWgI6FUTGGJPxDlGOs',
    appId: '1:467190161889:web:1349e5f0b98a20aa18b2a0',
    messagingSenderId: '467190161889',
    projectId: 'the-wall-social-app',
    authDomain: 'the-wall-social-app.firebaseapp.com',
    storageBucket: 'the-wall-social-app.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBtqyRDyivshtl4fEIelCsswaBbHwEcIzc',
    appId: '1:467190161889:android:8b53a4916ff888b718b2a0',
    messagingSenderId: '467190161889',
    projectId: 'the-wall-social-app',
    storageBucket: 'the-wall-social-app.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDbsl1kiTG0CgizlrXkGASVvqmfLKHmZpI',
    appId: '1:467190161889:ios:232f99750024a25218b2a0',
    messagingSenderId: '467190161889',
    projectId: 'the-wall-social-app',
    storageBucket: 'the-wall-social-app.appspot.com',
    iosClientId:
        '467190161889-8nltuboecdf6gme78kaepq4pgqos22ul.apps.googleusercontent.com',
    iosBundleId: 'com.example.theWallSociaApp',
  );
}