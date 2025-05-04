// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAftNT9uZcMQVfzKfBG48tkMixI3_HywP8',
    appId: '1:469678331494:android:fc43854448b1f14eadbfa7',
    messagingSenderId: '469678331494',
    projectId: 'breakly-a5b05',
    storageBucket: 'breakly-a5b05.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB6rFvOXrAhF9sGuT1itqqxUmlMOG_CPvE',
    appId: '1:469678331494:android:fc43854448b1f14eadbfa7',
    messagingSenderId: '469678331494',
    projectId: 'breakly-a5b05',
    storageBucket: 'breakly-a5b05.firebasestorage.app',
  );
}