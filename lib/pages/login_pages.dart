import 'package:antrigo/pages/dokter/home_pages_d.dart';
import 'package:antrigo/pages/pasien/home_pages.dart';
import 'package:antrigo/pages/pasien/role_pages.dart';
import 'package:antrigo/themes/material_colors.dart';
import 'package:antrigo/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../themes/custom_colors.dart';
import 'register_pages.dart';

class LoginPages extends StatefulWidget {
  const LoginPages({super.key});

  @override
  State<LoginPages> createState() => _LoginPagesState();
}

class _LoginPagesState extends State<LoginPages> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  late bool _showPassword = true;

  void togglePasswordVisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  @override
  void initState() {
    if (FirebaseAuth.instance.currentUser != null) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const RolePages()),
            (route) => false);
      });
    }
    super.initState();
  }

  Future<dynamic> login() async {
    if (_formKey.currentState!.validate()) {
      showAlertDialogLoading(context);
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _email.text, password: _password.text);

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const RolePages()),
            (route) => false);
            
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          Navigator.pop(context);
          showAlertUserNotFound();
        } else if (e.code == 'wrong-password') {
          Navigator.pop(context);
          showAlertUserWrongPassword();
        }
      }
    }
  }

  showAlertUserNotFound() {
    AlertDialog alert = AlertDialog(
      title: Text(titleError),
      content: Text("Maaf, User Tidak Ditemukan!"),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "OK",
              style: TextStyle(color: colorPinkText),
            ))
      ],
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertUserWrongPassword() {
    AlertDialog alert = AlertDialog(
      title: Text(titleError),
      content: Text("Maaf, Password Salah!"),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "OK",
              style: TextStyle(color: colorPinkText),
            ))
      ],
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertDialogLoading(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          Container(
              margin: const EdgeInsets.only(left: 15),
              child: const Text(
                "Loading...",
                style: TextStyle(fontSize: 12),
              )),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  displaySnackBar(text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: colorPrimary,
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                buildHeader(),
                buildIcon(),
                buildFormLogin(),
                buildButtonLogin(),
                buildFooter()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  titleLogin,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Image.asset("assets/image/line.png"),
            ],
          )
        ],
      ),
    );
  }

  Widget buildIcon() {
    return Container(
        margin: const EdgeInsets.only(bottom: 24),
        child: Image.asset("assets/image/double_doctor.png"));
  }

  Widget buildFormLogin() {
    return Form(
        key: _formKey,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 24),
                padding: const EdgeInsets.only(left: 4, bottom: 4),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white),
                child: TextFormField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(top: 16),
                    prefixIcon: Icon(
                      Icons.email,
                    ),
                    border: InputBorder.none,
                    hintText: textEmail,
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Masukkan $textEmail!';
                    }

                    return null;
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 40),
                padding: const EdgeInsets.only(left: 4, bottom: 4),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white),
                child: TextFormField(
                  controller: _password,
                  obscureText: _showPassword,
                  textInputAction: TextInputAction.done,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(top: 16),
                    prefixIcon: const Icon(
                      Icons.lock,
                    ),
                    suffixIcon: GestureDetector(
                      onTap: togglePasswordVisibility,
                      child: _showPassword
                          ? Icon(
                              Icons.visibility_off,
                              color: colorPrimary,
                            )
                          : Icon(
                              Icons.visibility,
                              color: colorPrimary,
                            ),
                    ),
                    border: InputBorder.none,
                    hintText: 'Password',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Masukkan Password!';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ));
  }

  Widget buildButtonLogin() {
    return ElevatedButton(
        onPressed: login,
        style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(colorButton),
            shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24)))),
        child: Container(
            width: 120,
            height: 40,
            child: Center(
                child: Text(
              titleLogin,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ))));
  }

  Widget buildFooter() {
    return Container(
      margin: const EdgeInsets.only(top: 24),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Text(
              textDaftarRegister,
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => RegisterPages())),
              child: Text(
                titleRegister,
                style: TextStyle(color: colorButton),
              ))
        ],
      ),
    );
  }
}
