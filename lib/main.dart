import 'package:app_part/UI/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyBV-VzytcyhWbmYP4hfyItaId1FARs2_bA', 
      appId: 'com.example.app_part', 
      messagingSenderId: '', 
      projectId: 'fir-practice-1e503',
      databaseURL: 'https://fir-practice-1e503-default-rtdb.firebaseio.com/',
      storageBucket: 'fir-practice-1e503.appspot.com'
      )
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple
      ),
      home: SplashScreen()
    );
  }
}

