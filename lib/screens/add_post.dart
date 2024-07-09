// ignore_for_file: camel_case_types

import 'dart:core';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:login1/Utils/utilities.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class add_post extends StatefulWidget {
  const add_post({super.key});

  @override
  State<add_post> createState() => _add_postState();
}

class _add_postState extends State<add_post> {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  final _auth = FirebaseAuth.instance;

  final databaseRef = FirebaseDatabase.instance.ref("add");

  File? _image;
  File? _camera;
  final picker = ImagePicker();

  Future getImage() async {
    final PickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (PickedFile != null) {
        _image = File(PickedFile.path);
      } else {
        print("No image Picked");
      }
    });
  }

  Future takeImage() async {
    final PickedFile = await picker.pickImage(source: ImageSource.camera);
    if (PickedFile != null) {
      _camera = File(PickedFile.path);
    } else {
      print("Please take an image");
    }
  }

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final postkey = GlobalKey<FormState>();

    TextEditingController subcontroller = TextEditingController();
    TextEditingController postcontroller = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        //automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 114, 188, 248),
        title: const Text("Add Post"),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 25, right: 25),
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Stack(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Form(
                  key: postkey,
                  child: Column(
                    children: [
                      TextFormField(
                        maxLines: 2,
                        controller: subcontroller,
                        keyboardType: TextInputType.multiline,
                        decoration: const InputDecoration(
                            hintText: "Subject:",
                            hintStyle: TextStyle(fontSize: 18),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 2.0,
                                ))),
                        onChanged: (String value) {},
                        validator: (value) {
                          DecorationPosition;
                          return value!.isEmpty
                              ? 'Subject Field Cant Be Null*'
                              : null;
                        },
                      ),
                      const SizedBox(
                        height: 1,
                      ),
                      TextFormField(
                        maxLines: 6,
                        controller: postcontroller,
                        keyboardType: TextInputType.multiline,
                        decoration: const InputDecoration(
                            hintText: "Share Your Thoughts Here...",
                            hintStyle: TextStyle(fontSize: 18),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 2.0,
                                ))),
                        onChanged: (String value) {},
                        validator: (value) {
                          DecorationPosition;
                          return value!.isEmpty
                              ? 'Please Enter Your Thought*'
                              : null;
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 217),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                          onPressed: () {
                            getImage();
                          },
                          icon: const Icon(Icons.image)),
                      IconButton(
                          onPressed: () {
                            takeImage();
                          },
                          icon: const Icon(Icons.camera_alt)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 249, 227, 128),
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                child: TextButton(
                    onPressed: () {
                      if (postkey.currentState!.validate()) {
                        setState(() {
                          loading = true;
                        });

                        String id =
                            DateTime.now().millisecondsSinceEpoch.toString();
                        databaseRef.child(id).set({
                          "id": id,
                          "subject": subcontroller.text.toString(),
                          "thought": postcontroller.text.toString(),
                        }).then((value) {
                          setState(() {
                            loading = false;
                          });
                          Utilities.toastmessage('Thought is Posted');
                        }).onError((error, StackTrace) {
                          setState(() {
                            loading = false;
                          });
                          Utilities.toastmessage(error.toString());
                        });
                      }
                    },
                    child: loading
                        ? const CircularProgressIndicator()
                        : const Text("Share")))
          ],
        ),
      ),
    );
  }
}
