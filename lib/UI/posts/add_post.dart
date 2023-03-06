import 'package:app_part/utils/utils.dart';
import 'package:app_part/widgets/round_button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  bool loading = false;
  final postController = TextEditingController();
  // this has created a firebase database instance and usig that instance, it has created a node(called as table in SQL lang) and termed that
  //node as Post.
  final databaseRef = FirebaseDatabase.instance.ref('Post');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Post'),
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

                  String id = DateTime.now().microsecondsSinceEpoch.toString();

                  databaseRef.child(id).set({
                    'roll-num': id,
                    'title': postController.text.toString()
                  }).then((value) {
                    setState(() {
                      loading = false;
                    });
                    Utils().registerMessage('Message inserted');
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
