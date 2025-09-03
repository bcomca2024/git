import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAzHE8XZMGfjW7-Tjx0w8suA59J4CRFoYU',
    appId: '1:300829255056:web:89424b27ec94a2678e3f15',
    messagingSenderId: '300829255056',
    projectId: 'bcomcaapp',
    authDomain: 'bcomcaapp.firebaseapp.com',
    storageBucket: 'bcomcaapp.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'your-android-api-key',
    appId: 'your-android-app-id',
    messagingSenderId: '300829255056',
    projectId: 'bcomcaapp',
    storageBucket: 'bcomcaapp.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'your-ios-api-key',
    appId: 'your-ios-app-id',
    messagingSenderId: '300829255056',
    projectId: 'bcomcaapp',
    storageBucket: 'bcomcaapp.firebasestorage.app',
  );
}
