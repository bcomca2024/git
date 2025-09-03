import 'package:firebase_core/firebase_core.dart';

class FirebaseConfig {
  static const FirebaseOptions firebaseOptions = FirebaseOptions(
    apiKey: "AIzaSyAzHE8XZMGfjW7-Tjx0w8suA59J4CRFoYU",
    authDomain: "bcomcaapp.firebaseapp.com",
    projectId: "bcomcaapp",
    storageBucket: "bcomcaapp.firebasestorage.app",
    messagingSenderId: "300829255056",
    appId: "1:300829255056:web:89424b27ec94a2678e3f15"
  );

  static Future<void> initializeFirebase() async {
    await Firebase.initializeApp(options: firebaseOptions);
  }
}
