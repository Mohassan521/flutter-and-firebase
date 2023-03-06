import 'package:flutter/material.dart';

class VerifyPhoneCode extends StatefulWidget {
  final String VerificationId;
  const VerifyPhoneCode({super.key, required this.VerificationId});

  @override
  State<VerifyPhoneCode> createState() => _VerifyPhoneCodeState();
}

class _VerifyPhoneCodeState extends State<VerifyPhoneCode> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verification of Phone Number'),
      ),
      body: Column(children: []),
    );
  }
}
