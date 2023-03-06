import 'package:app_part/UI/auth/verify_code.dart';
import 'package:app_part/utils/utils.dart';
import 'package:app_part/widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginWithPhoneNumber extends StatefulWidget {
  const LoginWithPhoneNumber({super.key});

  @override
  State<LoginWithPhoneNumber> createState() => _LoginWithPhoneNumberState();
}

class _LoginWithPhoneNumberState extends State<LoginWithPhoneNumber> {
  bool loading = false;
  final phoneNumberController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login with Phone Number'),
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(children: [
            SizedBox(
              height: 30,
            ),
            TextFormField(
              controller: phoneNumberController,
              decoration: InputDecoration(hintText: '+1 234 5678 9012'),
            ),
            SizedBox(
              height: 20,
            ),
            RoundButton(
              title: 'Login',
              onTap: () {
                _auth.verifyPhoneNumber(
                    phoneNumber: phoneNumberController.toString(),
                    verificationCompleted: (context) {},
                    verificationFailed: (e) {
                      Utils().toastMessage(e.toString());
                    },
                    codeSent: (String verificationId, int? token) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => VerifyPhoneCode(VerificationId: verificationId,)));
                    },
                    codeAutoRetrievalTimeout: (e) {
                      Utils().toastMessage(e.toString());
                    });
              },
            )
          ])),
    );
  }
}
