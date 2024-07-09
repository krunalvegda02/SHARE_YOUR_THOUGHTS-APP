import 'dart:ui';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login1/Authentication/Email/login_screen.dart';
import 'package:login1/screens/add_post.dart';
import 'package:login1/Utils/utilities.dart';

class Postscreen extends StatefulWidget {
  const Postscreen({super.key});

  @override
  State<Postscreen> createState() => _PostscreenState();
}

final _auth = FirebaseAuth.instance;
final ref = FirebaseDatabase.instance.ref("add");

final SearchController = TextEditingController();
final editcontroller = TextEditingController();

class _PostscreenState extends State<Postscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 114, 188, 248),
        title: const Text("Your Thoughts..."),
        actions: [
          IconButton(
              onPressed: () {
                _auth.signOut().toString();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
              },
              icon: const Icon(Icons.logout_outlined))
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const add_post()));
        },
        child: const Icon(Icons.add),
      ),

//BODY
      body: Column(
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SizedBox(
              height: 48,
              child:
//SEARCH BAR
                  TextFormField(
                controller: SearchController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(23))),
                    hintText: "Search",
                    hintStyle: TextStyle(fontSize: 19),
                    prefixIcon: Icon(Icons.search)),
                onChanged: (String value) {
                  setState(() {});
                },
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child:

//SHOW DATA ON SCREEN -- ANIMATEDLIST IS A SPECIAL PROPERTY TO FETCH DATA FROM FIREBASE SERVER
                FirebaseAnimatedList(
                    query: ref,
                    itemBuilder: (context, snapshot, animation, index) {
                      final subject =
                          snapshot.child("subject").value.toString();
                      final thought =
                          snapshot.child("thought").value.toString();
                      final id = snapshot.child("add").value.toString();

//NORMAL DATA WIHTOUT SEARCH FILTER
                      if (SearchController.text.isEmpty) {
                        return Card(
                          child: ListTile(
                            title: Text(snapshot
                                .child(
                                  "subject",
                                )
                                .value
                                .toString()),
                            subtitle: Text(thought),
                            trailing: PopupMenuButton(
                                itemBuilder: (context) => [
                                      PopupMenuItem(
                                          value: 1,
                                          child: ListTile(
                                            onTap: () {
                                              Navigator.pop(context);
                                              showMyDialog(thought, id);
                                            },
                                            leading: const Icon(Icons.edit),
                                            title: const Text("Edit Thought"),
                                          )),
                                      PopupMenuItem(
                                          value: 1,
                                          child: ListTile(
                                            onTap: () {
                                              ref
                                                  .child(snapshot
                                                      .child("id")
                                                      .value
                                                      .toString())
                                                  .remove();
                                            },
                                            leading: const Icon(Icons.delete),
                                            title: const Text("Delete Thought"),
                                          ))
                                    ],
                                child: const Icon(Icons.more_vert)),
                          ),
                        );
                      }

//SEARCH FILTER DATA
                      else if (subject.toLowerCase().contains(
                          SearchController.text.toLowerCase().toString())) {
                        return ListTile(
                          title:
                              Text(snapshot.child("subject").value.toString()),
                          subtitle:
                              Text(snapshot.child("thought").value.toString()),
                          trailing: PopupMenuButton(
                              itemBuilder: (context) => [
                                    PopupMenuItem(
                                        value: 1,
                                        child: ListTile(
                                          onTap: () {
                                            Navigator.pop(context);
                                            showMyDialog(thought, id);
                                          },
                                          trailing: const Icon(Icons.edit),
                                          title: const Text("Edit Thought"),
                                        )),
                                    PopupMenuItem(
                                        value: 1,
                                        child: ListTile(
                                          onTap: () {
                                            ref
                                                .child(snapshot
                                                    .child("id")
                                                    .value
                                                    .toString())
                                                .remove();
                                          },
                                          trailing: const Icon(Icons.delete),
                                          title: const Text("Delete Thought"),
                                        ))
                                  ],
                              child: const Icon(Icons.more_vert)),
                        );
                      }
//OTHER CONDITION
// 1> IF THERE IS NO DATA IN FIREBASE
// 2> IF OUT SEARCH FILTER DATA IS NOT AVAILABLE

                      else {
                        return Container();
                      }
                    }),

//ANIMATEDLIST COMPLETE
          )
        ],
      ),
    );
  }

//POPUP MENU FOR UPDATE

  Future<void> showMyDialog(String thought, String id) async {
    editcontroller.text = thought;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text("update"),
              content: Container(
                  child: TextFormField(
                controller: editcontroller,
                decoration: InputDecoration(
                    hintText: "Edit",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              )),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ref.child("id").update({
                        'thought': editcontroller.text.toLowerCase()
                      }).then((value) {
                        Utilities.toastmessage("Post Updated");
                      }).onError((error, StackTrace) {
                        Utilities.toastmessage(error.toString());
                      });
                    },
                    child: const Text("Update")),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel"))
              ]);
        });
  }
}
