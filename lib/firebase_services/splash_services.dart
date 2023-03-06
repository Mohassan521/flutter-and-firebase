import 'dart:async';
import 'package:app_part/UI/auth/login_screen.dart';
import 'package:app_part/UI/firestore/firestore_list_screen.dart';
import 'package:app_part/UI/posts/post_screen.dart';
import 'package:app_part/UI/posts/upload_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashServices {
  void isLogin(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;

    if(user != null){
        Timer(
        const Duration(seconds: 1),
        () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => PostScreen())));
    }
    else{
          Timer(
            const Duration(seconds: 3),
            () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => LoginScreen())));
    }


  }
}
