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
        return macos;
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
    apiKey: 'AIzaSyCNxKlCFIpHmyyyCfb7FWorhMaxwXvVs30',
    appId: '1:246221281013:web:1f95f814e454bdb1d317bc',
    messagingSenderId: '246221281013',
    projectId: 'soundest-95e52',
    authDomain: 'soundest-95e52.firebaseapp.com',
    databaseURL: 'https://soundest-95e52-default-rtdb.firebaseio.com',
    storageBucket: 'soundest-95e52.appspot.com',
    measurementId: 'G-488SFBQ21Q',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBppL15tAO1h0OqbwN9QgqKDm94QrBaftQ',
    appId: '1:246221281013:android:8fa36968778cc62ad317bc',
    messagingSenderId: '246221281013',
    projectId: 'soundest-95e52',
    databaseURL: 'https://soundest-95e52-default-rtdb.firebaseio.com',
    storageBucket: 'soundest-95e52.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDld4yaoTuWZ6I0Js84UE2d8ibeJxNcZ9s',
    appId: '1:246221281013:ios:8f6f18ef91d33728d317bc',
    messagingSenderId: '246221281013',
    projectId: 'soundest-95e52',
    databaseURL: 'https://soundest-95e52-default-rtdb.firebaseio.com',
    storageBucket: 'soundest-95e52.appspot.com',
    iosClientId: '246221281013-rq375121pmccsh6t5ekr4n9o64ajlo70.apps.googleusercontent.com',
    iosBundleId: 'com.example.soundest',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDld4yaoTuWZ6I0Js84UE2d8ibeJxNcZ9s',
    appId: '1:246221281013:ios:42a126627674871ed317bc',
    messagingSenderId: '246221281013',
    projectId: 'soundest-95e52',
    databaseURL: 'https://soundest-95e52-default-rtdb.firebaseio.com',
    storageBucket: 'soundest-95e52.appspot.com',
    iosClientId: '246221281013-d0tq474iual4pmkho0mb5754rpod5lf8.apps.googleusercontent.com',
    iosBundleId: 'com.example.soundest.RunnerTests',
  );
}
