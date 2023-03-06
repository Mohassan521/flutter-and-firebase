import 'dart:html';

import 'package:app_part/UI/auth/login_screen.dart';
import 'package:app_part/UI/firestore/add_firestore_data.dart';
import 'package:app_part/UI/posts/add_post.dart';
import 'package:app_part/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class FirestoreList extends StatefulWidget {
  const FirestoreList({super.key});

  @override
  State<FirestoreList> createState() => _FirestoreListState();
}

class _FirestoreListState extends State<FirestoreList> {
  final auth = FirebaseAuth.instance;
  final editController = TextEditingController();
  final firestore = FirebaseFirestore.instance.collection('users').snapshots();

  CollectionReference ref = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Post Screen'),
        actions: [
          IconButton(
            onPressed: () {
              auth.signOut().then((value) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              }).onError((error, stackTrace) {
                Utils().toastMessage(error.toString());
              });
            },
            icon: Icon(Icons.logout_outlined),
          ),
          SizedBox(
            width: 30,
          )
        ],
      ),
      body: Column(children: [
        // firebaseanimatedlist handles all the animations and other things automatically, u just pass it a reference and it returns all the
        // list items. whereas the advantage of stream builder is that firebase database returns some events that are itself streams so
        // u can get those streams.
        SizedBox(
          height: 10,
        ),

        StreamBuilder<QuerySnapshot>(
            stream: firestore,
            // because return type of snapshot is required in the form of streams/queries
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return CircularProgressIndicator();

              if (snapshot.hasError) return Text('Something went wrong');

              return Expanded(
                  child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            showMyDialog(
                                snapshot.data!.docs[index]['title'].toString(),
                                snapshot.data!.docs[index]['id'].toString());
                          },
                          title: Text(snapshot.data!.docs[index]['title'].toString()),
                          subtitle: Text(snapshot.data!.docs[index]['id'].toString()),
                          trailing: PopupMenuButton(
                            icon: Icon(Icons.more_vert),
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 1,
                                child: ListTile(
                                   onTap: () {
                                        Navigator.pop(context);
                                        showMyDialog(snapshot.data!.docs[index]['title'].toString(),snapshot.data!.docs[index]['id'].toString());
                                      },
                                      leading: Icon(Icons.edit),
                                      title: Text('Edit'),
                                )
                              ),
                             PopupMenuItem(
                                value: 2,
                                child: ListTile(
                                   onTap: () {
                                        Navigator.pop(context);
                                        ref.doc(snapshot.data!.docs[index]['id'].toString()).delete();
                                      },
                                      leading: Icon(Icons.edit),
                                      title: Text('Delete'),
                                )
                              )
                            ]
                            
                          ),
                        );
                      }));
            }),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddFirestoreDataScreen()));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> showMyDialog(String title, String id) async {
    editController.text = title;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Update'),
            content: Container(
              child: TextField(
                controller: editController,
                decoration: InputDecoration(),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel')),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ref.doc(id).update({
                      'title': editController.text.toLowerCase()
                    }).then((value) {
                      Utils().toastMessage('Record updated');
                    }).onError((error, stackTrace) {
                      Utils().toastMessage(error.toString());
                    });
                  },
                  child: Text('Update')),
            ],
          );
        });
  }
}
