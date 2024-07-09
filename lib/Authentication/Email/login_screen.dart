// ignore_for_file: deprecated_member_use

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:login1/Authentication/Email/forgot_pasword.dart';
import 'package:login1/Authentication/Email/sign_up.dart';
import 'package:login1/Authentication/Phone/phoneNoS.dart';
import 'package:login1/Utils/utilities.dart';
import 'package:login1/screens/postScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

bool loading = false;

class _LoginScreenState extends State<LoginScreen> {
  final _formkey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  void login() {
    _auth
        .signInWithEmailAndPassword(
            email: emailController.text,
            password: passController.text.toString())
        .then((value) {
      Utilities.toastmessage(value.user!.email.toString());
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Postscreen()));
      setState(() {
        loading = false;
      });
    }).onError((error, StackTrace) {
      debugPrint(error.toString());
      Utilities.toastmessage(error.toString());
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = View.of(context).physicalSize;

    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color.fromARGB(255, 114, 188, 248),
          title: const Text(
            "Login Screen",
          ),
        ),
        body:
            //  : Color.fromARGB(255, 146, 187, 220),
            Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
              Image.asset(
                "assets/images/login.png",
                height: 230,
                width: 230,
              ),
              const SizedBox(
                child: Text(
                  "LOGIN ",
                  style: TextStyle(fontSize: 35, color: Colors.black),
                ),
              ),
              Form(
                child: Column(
                  children: [
                    Form(
                        key: _formkey,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 20),
                              child: TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                controller: emailController,
                                decoration: const InputDecoration(
                                  labelText: "Email",
                                  // helperText: "enter email: e.g. xyz12@gmail.com",
                                  hintText: "enter your email",
                                  prefixIcon: Icon(Icons.email),
                                ),
                                onChanged: (String value) {},
                                validator: (value) {
                                  return value!.isEmpty
                                      ? 'please enter E-mail'
                                      : null;
                                },
                              ),
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 10),
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                controller: passController,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  labelText: "Password",
                                  hintText: "enter your password",
                                  prefixIcon: Icon(Icons.lock_open_rounded),
                                  suffixIcon:
                                      Icon(Icons.remove_red_eye_outlined),
                                ),
                                onChanged: (String value) {},
                                validator: (value) {
                                  return value!.isEmpty
                                      ? 'please enter password'
                                      : null;
                                },
                              ),
                            ),
                            const SizedBox(height: 30),
                          ],
                        )),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              if (_formkey.currentState!.validate()) {
                                login();
                                setState(() {
                                  loading = true;
                                });
                              }
                            },
                            child: Container(
                              height: 45,
                              width: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: const Color.fromARGB(255, 249, 227, 128),
                                border: Border.all(color: Colors.black),
                              ),
                              child: Center(
                                child: loading
                                    ? const CircularProgressIndicator()
                                    : const Text(
                                        "LOGIN",
                                        style: TextStyle(fontSize: 20),
                                        textAlign: TextAlign.center,
                                      ),
                              ),
                            ),
                          ),
                        ]),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // const SizedBox(
                        //   width: 90,
                        // ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ForgotPasword()));
                          },
                          child: const Text("Forgot Password?"),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const phoneNoScreen(),
                      ));
                },
                child: Container(
                  height: 50,
                  width: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: const Color.fromARGB(255, 249, 227, 128),
                    border: Border.all(color: Colors.black),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Login with Phone Number",
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't Have An Account?",
                      style: TextStyle(fontSize: 15)),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUp(),
                            ));
                      },
                      child: const Text(
                        "SignUp",
                        style: TextStyle(fontSize: 15),
                      ))
                ],
              ),
            ]),
        resizeToAvoidBottomInset: false,
      ),
    );
  }
}
