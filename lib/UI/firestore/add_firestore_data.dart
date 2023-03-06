import 'package:app_part/utils/utils.dart';
import 'package:app_part/widgets/round_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddFirestoreDataScreen extends StatefulWidget {
  const AddFirestoreDataScreen({super.key});

  @override
  State<AddFirestoreDataScreen> createState() => _AddFirestoreDataScreenState();
}

class _AddFirestoreDataScreenState extends State<AddFirestoreDataScreen> {
  bool loading = false;
  final postController = TextEditingController();
  final firestore = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Firestore Data from here!!'),
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(children: [
            SizedBox(
              height: 30,
            ),
            TextFormField(
              maxLines: 4,
              controller: postController,
              decoration: InputDecoration(
                  hintText: 'What is in your mind',
                  border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 30,
            ),
            RoundButton(
                title: 'Add',
                loading: loading,
                onTap: () {
                  setState(() {
                    loading = true;
                  });

                  String id = DateTime.now().millisecondsSinceEpoch.toString();

                  firestore.doc(id).set({
                    'title': postController.text.toString(),
                    'id': id
                  }).then((value) {
                    setState(() {
                      loading = false;
                    });
                    Utils().toastMessage('User created');
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
