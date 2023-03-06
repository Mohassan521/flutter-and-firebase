import 'dart:io';

import 'package:app_part/utils/utils.dart';
import 'package:app_part/widgets/round_button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({super.key});

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  bool loading = false;
  File? _file;
  final picker = ImagePicker();

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  DatabaseReference databaseref = FirebaseDatabase.instance.ref('Post');

  Future getGalleryImage() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);

    setState(() {
      if (pickedFile != null) {
        _file = File(pickedFile.path);
      } else {
        print('No image found');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Images'),
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 150),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                    child: InkWell(
                        onTap: () {
                          getGalleryImage();
                        },
                        child: Container(
                          height: 200,
                          width: 200,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black)),
                          child: _file != null
                              ? Image.file(_file!.absolute)
                              : Center(
                                  child: Icon(Icons.image),
                                ),
                        ))),
                SizedBox(
                  height: 30,
                ),
                RoundButton(
                    loading: loading,
                    title: 'Upload',
                    onTap: () async {
                      setState(() {
                        loading = true;
                      });

                      firebase_storage.Reference ref = firebase_storage
                          .FirebaseStorage.instance
                          .ref('/images/' + DateTime.now().millisecondsSinceEpoch.toString());
                      firebase_storage.UploadTask uploadTask =
                          ref.putFile(_file!.absolute);

                      Future.value(uploadTask).then((value) async {
                        var newUrl = await ref.getDownloadURL();

                        databaseref
                            .child('1')
                            .set({'id': 1212, 'title': newUrl}).then((value) {
                          Utils().toastMessage('Uploaded');
                        }).onError((error, stackTrace) {
                          setState(() {
                            loading = false;
                            
                          });
                          Utils().toastMessage(error.toString());
                        });
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
