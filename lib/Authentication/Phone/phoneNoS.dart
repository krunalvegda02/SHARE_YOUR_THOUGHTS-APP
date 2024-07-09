// ignore_for_file: camel_case_types, file_names, deprecated_member_use, sort_child_properties_last

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:login1/Authentication/Phone/OTPScreen.dart';
import 'package:login1/Utils/utilities.dart';

class phoneNoScreen extends StatefulWidget {
  const phoneNoScreen({super.key});

  static String verify = '';
  @override
  State<phoneNoScreen> createState() => _phoneNoScreenState();
}

bool loading = false;
FirebaseAuth _auth = FirebaseAuth.instance;

TextEditingController phoneController = TextEditingController();
TextEditingController countrycode = TextEditingController();

class _phoneNoScreenState extends State<phoneNoScreen> {
  @override
  @override
  void initState() {
    super.initState();
    countrycode.text = "+91 ";
  }

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: const Color.fromARGB(255, 114, 188, 248),
            title: const Text("Phone Verification"),
          ),
          body: Center(
            child: Container(
              margin: const EdgeInsets.only(left: 25, right: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    "assets/images/phone.png",
                    height: 220,
                    width: 220,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    "Phone verification",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                      "We need to Register your phone before getting started!",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20)),
                  const SizedBox(
                    height: 25,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey),
                        // color: Colors.black,
                        borderRadius: BorderRadius.circular(10)),
                    height: 55,
                    width: double.infinity,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 40,
                          child: TextFormField(
                            //ignorePointers: true,
                            keyboardType: TextInputType.phone,
                            controller: countrycode,
                            decoration: const InputDecoration(
                              hintText: "+91",
                              contentPadding: EdgeInsets.all(5),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        //
                        const VerticalDivider(
                          thickness: 2,
                          color: Colors.grey,
                        ),
                        Expanded(
                          child: TextFormField(
                            /// ignorePointers: true,
                            keyboardType: TextInputType.phone,
                            controller: phoneController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Enter Phone Number",
                              hintStyle: TextStyle(fontSize: Checkbox.width),
                              contentPadding: EdgeInsets.all(10),
                              suffixIcon: Icon(Icons.call),
                              enabledBorder: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  SizedBox(
                    height: 45,
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            loading = true;
                          });
                          _auth.verifyPhoneNumber(
                              verificationCompleted: (_) {
                                setState(() {
                                  loading = true;
                                });
                              },
                              verificationFailed: (e) {
                                Utilities.toastmessage(e.toString());
                                setState(() {
                                  loading = false;
                                });
                              },
                              codeSent: (String verificationID, int? token) {
                                setState(() {
                                  loading = false;
                                });
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => OTPScreen(
                                            verificationID: verificationID)));
                              },
                              codeAutoRetrievalTimeout: (e) {
                                Utilities.toastmessage(e.toString());
                                setState(() {
                                  loading = false;
                                });
                              },
                              phoneNumber:
                                  '${countrycode.text + phoneController.text}');
                        },
                        child: loading
                            ? const CircularProgressIndicator(
                                color: Colors.black,
                              )
                            : const Text("Verify Phone Number "),
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 255, 234, 159),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)))),
                  ),
                ],
              ),
            ),
          ),
          resizeToAvoidBottomInset: false),
    );
  }
}
