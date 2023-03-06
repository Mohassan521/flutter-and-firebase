import 'dart:html';

import 'package:app_part/UI/auth/login_screen.dart';
import 'package:app_part/UI/posts/add_post.dart';
import 'package:app_part/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final auth = FirebaseAuth.instance;
  // here we are passing ref of our node of which we have to fetch data from
  final ref = FirebaseDatabase.instance.ref('Post');
  final searchFilter = TextEditingController();
  final editController = TextEditingController();

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
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: TextFormField(
              controller: searchFilter,
              decoration: InputDecoration(
                hintText: 'Search by title',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              ),
              onChanged: (String value) {
                setState(() {});
              },
            )),
        Expanded(
            child: FirebaseAnimatedList(
                query: ref,
                defaultChild: Text('Loading'),
                // itembuilder needs 4 parameters, one is buildContext, second is datasnapshot, third one is animatio, and last one is index
                itemBuilder: (context, snapshot, animation, index) {
                  final title = snapshot.child('title').value.toString();

                  if (searchFilter.text.isEmpty) {
                    return ListTile(
                      title: Text(snapshot.child('title').value.toString()),
                      subtitle:
                          Text(snapshot.child('roll-num').value.toString()),
                      trailing: PopupMenuButton(
                          icon: Icon(Icons.more_vert),
                          itemBuilder: (context) => [
                                PopupMenuItem(
                                    value: 1,
                                    child: ListTile(
                                      onTap: () {
                                        Navigator.pop(context);
                                        showMyDialog(title,snapshot.child('roll-num').value.toString());
                                      },
                                      leading: Icon(Icons.edit),
                                      title: Text('Edit'),
                                    )),
                                PopupMenuItem(
                                    value: 2,
                                    child: ListTile(
                                      onTap: () {
                                        Navigator.pop(context);
                                        ref.child(snapshot.child('roll-num').value.toString()).remove();
                                      },
                                      leading: Icon(Icons.delete),
                                      title: Text('Delete'),
                                    )),
                              ]),
                    );
                  } else if (title
                      .toLowerCase()
                      .contains(searchFilter.text.toLowerCase().toString())) {
                    return ListTile(
                      title: Text(snapshot.child('title').value.toString()),
                      subtitle:
                          Text(snapshot.child('roll-num').value.toString()),
                    );
                  } else {
                    return Container();
                  }
                })),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddPost()));
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
                    ref.child(id).update({
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

// Expanded(
//           child: StreamBuilder(
//           stream: ref.onValue,
//           builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
//             if (!snapshot.hasData) {
//               return CircularProgressIndicator();
//             } else {
//               Map<dynamic, dynamic> map = snapshot.data!.snapshot.value as dynamic;
//               List<dynamic> list = [];
//               list.clear();
//               list = map.values.toList();

//               return ListView.builder(
//                   itemCount: snapshot.data!.snapshot.children.length,
//                   itemBuilder: (context, index) {
//                     return ListTile(
//                       title: Text(list[index]['title']),
//                       subtitle: Text(list[index]['roll-num']),
//                     );
//                   });
//             }
//           },
//         )
//         )