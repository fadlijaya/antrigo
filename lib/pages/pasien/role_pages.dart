import 'package:antrigo/pages/dokter/home_pages_d.dart';
import 'package:antrigo/pages/pasien/home_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RolePages extends StatefulWidget {
  const RolePages({super.key});

  @override
  State<RolePages> createState() => _RolePagesState();
}

class _RolePagesState extends State<RolePages> {

  String? _uid;
  String? _nama;
  String? _email;
  String? _role;
  String? _nomorHp;
  String? _jekel;
  String? _tglLahir;
  String? _alamat;
  int? _noAntrian;
  String? _poli;

  Future<dynamic> getUser() async {
    await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((result) {
      if (result.docs.isNotEmpty) {
        setState(() {
          _uid = result.docs[0].data()['uid'];
          _nama = result.docs[0].data()['nama'];
          _email = result.docs[0].data()['email'];
          _role = result.docs[0].data()['role'];
          _nomorHp = result.docs[0].data()['nomor hp'];
          _tglLahir = result.docs[0].data()['tanggal lahir'];
          _alamat = result.docs[0].data()['alamat'];
          _noAntrian = result.docs[0].data()['no antrian'];
          _poli = result.docs[0].data()['poli'];
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    if (_role.toString() == "pasien") {
      return HomePages();
    } else if (_role.toString() == "dokter") {
      return HomePagesDokter();
    }

    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}