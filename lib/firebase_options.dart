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
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyC_egT98hSgfwREfb1EIJ1hwxmWMP6qqoo',
    appId: '1:1030550448299:web:ac734af499b7ed75646fee',
    messagingSenderId: '1030550448299',
    projectId: 'cake123-6f168',
    authDomain: 'cake123-6f168.firebaseapp.com',
    storageBucket: 'cake123-6f168.appspot.com',

  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDWQXVKTnhh0KbViVgcg0swq_3Jz7xOwpg',
    appId: '1:1030550448299:android:0f94cd2f14a208cf646fee',
    messagingSenderId: '1030550448299',
    projectId: 'cake123-6f168',
    storageBucket: 'cake123-6f168.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBUWqGsccjUpjxUkoKFowhJ0fz8UaM4S-c',
    appId: '1:1030550448299:ios:4183b82abf15eed5646fee',
    messagingSenderId: '1030550448299',
    projectId: 'cake123-6f168',
    storageBucket: 'cake123-6f168.appspot.com',
    iosBundleId: 'com.example.cakeAppNew',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBUWqGsccjUpjxUkoKFowhJ0fz8UaM4S-c',
    appId: '1:1030550448299:ios:4183b82abf15eed5646fee',
    messagingSenderId: '1030550448299',
    projectId: 'cake123-6f168',
    storageBucket: 'cake123-6f168.appspot.com',
    iosBundleId: 'com.example.cakeAppNew',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyC_egT98hSgfwREfb1EIJ1hwxmWMP6qqoo',
    appId: '1:1030550448299:web:7b5f98ddc9644937646fee',
    messagingSenderId: '1030550448299',
    projectId: 'cake123-6f168',
    authDomain: 'cake123-6f168.firebaseapp.com',
    storageBucket: 'cake123-6f168.appspot.com',
  );
}
