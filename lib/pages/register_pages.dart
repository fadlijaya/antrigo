import 'package:antrigo/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../themes/custom_colors.dart';
import '../themes/material_colors.dart';
import 'pasien/home_pages.dart';

class RegisterPages extends StatefulWidget {
  const RegisterPages({super.key});

  @override
  State<RegisterPages> createState() => _RegisterPagesState();
}

class _RegisterPagesState extends State<RegisterPages> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nama = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  late bool _showPassword = true;
  String? role;

  void togglePasswordVisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  Future<dynamic> signUp() async {
    if (_formKey.currentState!.validate()) {
      showAlertDialogLoading(context);
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _email.text, password: _password.text);

        User? users = FirebaseAuth.instance.currentUser;

        await FirebaseFirestore.instance
            .collection('users')
            .doc(users?.uid)
            .set({
          'uid': users?.uid,
          'role': role.toString(),
          'nama': _nama.text,
          'email': _email.text,
          'nomor hp': '',
          'jenis kelamin': '',
          'tanggal lahir': '',
          'alamat': '',
          'no antrian': 0,
          'poli': ''
        });

        Navigator.pop(context);
        signUpDialog();
      } catch (e) {
        return e.toString();
      }
    }
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

  signUpDialog() {
    return showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.check_circle,
                  color: colorPinkText,
                  size: 72,
                ),
                SizedBox(
                  height: 16,
                ),
                Center(child: Text('Register Berhasil')),
              ],
            ),
            actions: [
              Center(
                  child: TextButton(
                      onPressed: () =>
                          Navigator.popAndPushNamed(context, '/loginPages'),
                      child: const Text(
                        'OK',
                        style: TextStyle(color: colorPinkText),
                      )))
            ],
          );
        });
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
                buildButtonLogin()
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
            children: const [
              Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: Text(
                  titleRegister,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Image.asset("assets/image/line.png",),
            ],
          )
        ],
      ),
    );
  }

  Widget buildIcon() {
    return Container(
        margin: const EdgeInsets.only(bottom: 24),
        child: Image.asset("assets/image/double_doctor.png",));
  }

  Widget buildFormLogin() {
    return Form(
        key: _formKey,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            children: [
              RadioListTile(
                title: Text("Saya Pasien", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                value: "pasien",
                groupValue: role,
                onChanged: (value) {
                  setState(() {
                    role = value.toString();
                  });
                },
                activeColor: Colors.white,
              ),
              RadioListTile(
                title: Text("Saya Dokter", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                value: "dokter",
                groupValue: role,
                onChanged: (value) {
                  setState(() {
                    role = value.toString();
                  });
                },
                activeColor: Colors.white,
              ),
              Container(
                margin: const EdgeInsets.only(top: 8, bottom: 16),
                padding: const EdgeInsets.only(left: 4, bottom: 4),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white),
                child: TextFormField(
                  controller: _nama,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(top: 16),
                    prefixIcon: Icon(
                      Icons.account_circle_rounded,
                    ),
                    border: InputBorder.none,
                    hintText: 'Nama',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Masukkan Nama!';
                    }

                    return null;
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 16),
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
                    hintText: 'Email',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Masukkan Email!';
                    }

                    return null;
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 16),
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
              Container(
                margin: const EdgeInsets.only(bottom: 24),
                padding: const EdgeInsets.only(left: 4, bottom: 4),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white),
                child: TextFormField(
                  controller: _confirmPassword,
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
                    hintText: 'Konfirmasi Password',
                  ),
                  validator: (value) {
                    if (value!.isEmpty || value != _password.text) {
                      return 'Password Salah!';
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
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: ElevatedButton(
          onPressed: signUp,
          style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(colorButton),
              shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24)))),
          child: Container(
              width: 120,
              height: 40,
              child: Center(
                  child: Text(
                titleSignUp,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              )))),
    );
  }
}
