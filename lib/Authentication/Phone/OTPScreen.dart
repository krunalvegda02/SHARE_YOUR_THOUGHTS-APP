// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names, sort_child_properties_last

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login1/Authentication/Phone/phoneNoS.dart';
import 'package:login1/Utils/utilities.dart';
import 'package:login1/screens/postScreen.dart';
import 'package:pinput/pinput.dart';

class OTPScreen extends StatefulWidget {
  final String verificationID;
  const OTPScreen({super.key, required this.verificationID});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

bool loading = false;
final FirebaseAuth _auth = FirebaseAuth.instance;
TextEditingController phoneController = TextEditingController();

class _OTPScreenState extends State<OTPScreen> {
  @override
  Widget build(BuildContext context) {
    var code = '';

    //PINPUT FUNCTION
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );
    defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );
    defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: const Color.fromRGBO(234, 239, 243, 1),
      ),
    );
    //PINPUT FUNCTION CLOSE

    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 114, 188, 248),
          title: const Text("Phone Verification"),
        ),
        body: Center(
          child: Center(
            child: Container(
              margin: const EdgeInsets.only(left: 25, right: 25),
              child: Column(
                children: [
                  Image.asset(
                    "assets/images/phone.png",
                    height: 230,
                    width: 230,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text("OTP Verification",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                  ),
                  const SizedBox(
                    height: 45,
                  ),

                  //PINPUT...............
                  Pinput(
                    length: 6,
                    showCursor: true,
                    onChanged: (value) {
                      code = value;
                    },
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  SizedBox(
                    height: 47,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          loading = true;
                        });

                        setState(() async {
                          final CREDENTIAL = PhoneAuthProvider.credential(
                              verificationId: widget.verificationID,
                              smsCode: code);
                          try {
                            setState(() {
                              loading = true;
                            });
                            await _auth.signInWithCredential(CREDENTIAL);

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Postscreen()));
                          } catch (e) {
                            setState(() {
                              loading = false;
                            });
                            Utilities.toastmessage(e.toString());
                          }
                        });
                      },
                      child: loading
                          ? const CircularProgressIndicator()
                          : const Text("Verify OTP"),
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 255, 234, 159),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const phoneNoScreen()));
                      },
                      child: const Text("Edit Phone Number ?"))
                ],
              ),
            ),
          ),
        ),
        resizeToAvoidBottomInset: false);
  }
}
