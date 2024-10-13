import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show kIsWeb;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// This is generated based on the Firebase project configuration.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      // Web configuration
      return web;
    }
    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
   apiKey: "AIzaSyCz-Z7d7fo1V6MqAgC_J8VlO_98cZGXPPg", // Your Firebase API key
    authDomain: "rental-8d6bc.firebaseapp.com", // Your project auth domain
    projectId: "rental-8d6bc", // Your Firebase project ID
    storageBucket: "rental-8d6bc.appspot.com", // Your storage bucket
      messagingSenderId: "528680030710", // Your messaging sender ID
      appId: "1:528680030710:web:ffa5db6c4757ebdf77b7d7", // Your Firebase app ID
    measurementId: 'G-V86PJ4HJFZ',
  );
}
