import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:flutter_dotenv/flutter_dotenv.dart'; 
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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static FirebaseOptions web = FirebaseOptions(
    apiKey: dotenv.get('FIREBASE_WEB_API_KEY'),
    appId: dotenv.get('FIREBASE_WEB_APP_ID'),
    messagingSenderId: '370947315001',
    projectId: 'my-routina-app',
    authDomain: 'my-routina-app.firebaseapp.com',
    storageBucket: 'my-routina-app.firebasestorage.app',
  );

  static FirebaseOptions android = FirebaseOptions(
    apiKey: dotenv.get('FIREBASE_ANDROID_API_KEY'),
    appId: dotenv.get('FIREBASE_ANDROID_APP_ID'),
    messagingSenderId: '370947315001',
    projectId: 'my-routina-app',
    storageBucket: 'my-routina-app.firebasestorage.app',
  );

  static FirebaseOptions ios = FirebaseOptions(
    apiKey: dotenv.get('FIREBASE_IOS_API_KEY'),
    appId: dotenv.get('FIREBASE_IOS_APP_ID'),
    messagingSenderId: '370947315001',
    projectId: 'my-routina-app',
    storageBucket: 'my-routina-app.firebasestorage.app',
    iosBundleId: 'com.example.routina',
  );

  static FirebaseOptions macos = ios; 

  static FirebaseOptions windows = web;
}