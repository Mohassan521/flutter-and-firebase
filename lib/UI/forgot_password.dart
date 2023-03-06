import 'package:app_part/utils/utils.dart';
import 'package:app_part/widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final emailController = TextEditingController();
  final auth = FirebaseAuth.instance;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Forgot Password!!'), actions: []),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30)),
                    hintText: 'Enter your registered email',
                  ),
                ),
                SizedBox(
                  height: 35,
                ),
                RoundButton(
                  loading: loading,
                    title: 'Verify Email',
                    onTap: () {
                      setState(() {
                        loading = true;
                      });
                      auth
                          .sendPasswordResetEmail(
                              email: emailController.text.toString())
                          .then((value) {
                        setState(() {
                          loading = false;
                        });
                        Utils().toastMessage('Password reset email sent');
                      }).onError((error, stackTrace) {
                        setState(() {
                          loading = false;
                        });
                        Utils().toastMessage(error.toString());
                      });
                    })
              ])),
    );
  }
}
