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
    apiKey: 'AIzaSyDENlLOEDk_aphqYYn1Nw9EKkxXZu9rOrA',
    appId: '1:209544392405:web:7da7cba450bed90fd9bc5c',
    messagingSenderId: '209544392405',
    projectId: 'smileapp-c6b27',
    authDomain: 'smileapp-c6b27.firebaseapp.com',
    storageBucket: 'smileapp-c6b27.firebasestorage.app',
    measurementId: 'G-V6T1YW19VS',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBywWsFQyc8fJmFJcDpYyKFO8ZqXe-NweE',
    appId: '1:209544392405:android:fcdddc3b4b0353d2d9bc5c',
    messagingSenderId: '209544392405',
    projectId: 'smileapp-c6b27',
    storageBucket: 'smileapp-c6b27.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCIguF_BhlFE5Habt9kGKxidpw8RwpwNKI',
    appId: '1:209544392405:ios:763e1d3cb18589d9d9bc5c',
    messagingSenderId: '209544392405',
    projectId: 'smileapp-c6b27',
    storageBucket: 'smileapp-c6b27.firebasestorage.app',
    iosBundleId: 'com.technocore.smileapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCIguF_BhlFE5Habt9kGKxidpw8RwpwNKI',
    appId: '1:209544392405:ios:f71a5c8b0d198ef4d9bc5c',
    messagingSenderId: '209544392405',
    projectId: 'smileapp-c6b27',
    storageBucket: 'smileapp-c6b27.firebasestorage.app',
    iosBundleId: 'com.example.smileapp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDENlLOEDk_aphqYYn1Nw9EKkxXZu9rOrA',
    appId: '1:209544392405:web:9feb4b3a1a1557d0d9bc5c',
    messagingSenderId: '209544392405',
    projectId: 'smileapp-c6b27',
    authDomain: 'smileapp-c6b27.firebaseapp.com',
    storageBucket: 'smileapp-c6b27.firebasestorage.app',
    measurementId: 'G-0Y9J1J0X8K',
  );

}