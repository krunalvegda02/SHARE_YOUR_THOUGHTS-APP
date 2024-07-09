import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login1/Authentication/Email/login_screen.dart';
import 'package:login1/Utils/utilities.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool loading = false;
  final _formkey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void signUp() {
    _auth
        .createUserWithEmailAndPassword(
            email: emailController.text.toString(),
            password: passController.text.toString())
        .then((value) {
      setState(() {
        Utilities.toastmessage("sign up succesfully");
        loading = false;
      });
    }).onError((error, StackTrace) {
      Utilities.toastmessage(error.toString());
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 114, 188, 248),
          title: const Text(
            "SignUp screen",
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
              const Text(
                "SignUp",
                style: TextStyle(fontSize: 35, color: Colors.black),
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
                              suffixIcon: Icon(Icons.remove_red_eye_outlined),
                            ),
                            onChanged: (String value) {},
                            validator: (value) {
                              return value!.isEmpty
                                  ? 'please enter password'
                                  : null;
                            },
                          ),
                        ),
                        const SizedBox(height: 50),
                      ],
                    ),
                  ),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            if (_formkey.currentState!.validate()) {
                              signUp();
                              setState(() {
                                loading = true;
                              });
                            }
                          },
                          child: Container(
                            height: 50,
                            width: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: const Color.fromARGB(255, 249, 227, 128),
                              border: Border.all(color: Colors.black),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                loading
                                    ? const CircularProgressIndicator()
                                    : const Text(
                                        "Sign Up",
                                        style: TextStyle(fontSize: 20),
                                        textAlign: TextAlign.center,
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already Have An Account?",
                          style: TextStyle(fontSize: 15)),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ));
                          },
                          child: const Text(
                            "LOGIN",
                            style: TextStyle(fontSize: 15),
                          ))
                    ],
                  ),
                ],
              )),
            ]),
        resizeToAvoidBottomInset: false);
  }
}
