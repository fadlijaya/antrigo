import 'package:antrigo/themes/material_colors.dart';
import 'package:antrigo/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../themes/custom_colors.dart';

class ProfilePagesDokter extends StatefulWidget {
  String? uid;
  String? nama;
  String? email;
  String? role;
  String? nomorHp;
  String? jekel;
  String? tglLahir;
  String? alamat; 
  final bool isEdit;
  ProfilePagesDokter(
      {Key? key,
      this.uid,
      this.nama,
      this.email,
      this.role,
      this.nomorHp,
      this.jekel,
      this.tglLahir,
      this.alamat,
      required this.isEdit})
      : super(key: key);

  @override
  State<ProfilePagesDokter> createState() => _ProfilePagesDokterState();
}

class _ProfilePagesDokterState extends State<ProfilePagesDokter> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nama = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _nomorHp = TextEditingController();
  final TextEditingController _tglLahir = TextEditingController();
  final TextEditingController _alamat = TextEditingController();

  String _jekel = "";
  DateTime selectedDate = DateTime.now();
  String? setDate, setTime;

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(1900),
        lastDate: DateTime.now());
    if (picked != null)
      setState(() {
        selectedDate = picked;
        _tglLahir.text = DateFormat.yMd().format(selectedDate);
      });
  }

  @override
  void initState() {
    super.initState();
    if (widget.isEdit) {
      setState(() {
        _nama.text = widget.nama!;
        _email.text = widget.email!;
        _nomorHp.text = widget.nomorHp!;
        _jekel = widget.jekel!;
        _tglLahir.text = widget.tglLahir!;
        _alamat.text = widget.alamat!;
      });
    }
  }

  Future<dynamic> updateData() async {
    if (widget.isEdit) {
      DocumentReference documentReference =
          FirebaseFirestore.instance.collection('users').doc(widget.uid);

      FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot documentSnapshot =
            await transaction.get(documentReference);

        if (documentSnapshot.exists) {
          transaction.update(documentReference, <String, dynamic>{
            'nama': _nama.text,
            'email': _email.text,
            'nomor hp': _nomorHp.text,
            'jenis kelamin': _jekel,
            'tanggal lahir': _tglLahir.text,
            'alamat': _alamat.text
          });
        }
      });

      infoUpdate();
    }
  }

  infoUpdate() {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text(titleSuccess),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  "Data Pribadi Anda Berhasil di Perbarui",
                ),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/homePagesDokter'),
                  child: Text("OK", style: TextStyle(color: colorPinkText),))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(titleProfile),
      ),
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [buildHeader(size), buildFormProfile(size), buildButtonSave()],
          ),
        ),
      ),
    );
  }

  Widget buildHeader(Size size) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 0, 40),
      child: Row(
        children: [
          Container(
              child: Stack(
            children: [
              Image.asset("assets/ellipse/ellipse1.png", width: size.width/1.8,),
              Positioned.fill(
                  left: 0,
                  top: 36,
                  right: 0,
                  bottom: 0,
                  child: Text(
                    textDeskripsiProfile,
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ))
            ],
          )),
          Image.asset("assets/image/suster.png")
        ],
      ),
    );
  }

   Widget buildFormProfile(Size size) {
    return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              padding: const EdgeInsets.only(left: 4, bottom: 4),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12), color: Colors.white),
              child: TextFormField(
                controller: _nama,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                decoration: const InputDecoration(
                  labelText: textNama),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Masukkan $textNama';
                  } else {
                    return '$textNama Salah!';
                  }
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              padding: const EdgeInsets.only(left: 4, bottom: 4),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12), color: Colors.white),
              child: TextFormField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                decoration: const InputDecoration(
                  labelText: textEmail,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Masukkan $textEmail';
                  } else {
                    return '$textEmail Salah!';
                  }
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              padding: const EdgeInsets.only(left: 4, bottom: 4),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12), color: Colors.white),
              child: TextFormField(
                controller: _nomorHp,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                decoration: const InputDecoration(
                  labelText: textNomorHP,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Masukkan $textNomorHP';
                  } else {
                    return '$textNomorHP Salah!';
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 4, bottom: 4),
              child: const Text(
                "Jenis Kelamin",
                style: TextStyle(),
              ),
            ),
            Row(
              children: [
                Radio(
                    activeColor: colorPinkText,
                    value: "Pria",
                    groupValue: _jekel,
                    onChanged: (value) {
                      setState(() {
                        _jekel = value!;
                      });
                    }),
                const Text(
                  "Pria",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  width: 24,
                ),
                Radio(
                    activeColor: colorPinkText,
                    value: "Wanita",
                    groupValue: _jekel,
                    onChanged: (value) {
                      setState(() {
                        _jekel = value!;
                      });
                    }),
                const Text(
                  "Wanita",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            InkWell(
              onTap: () {
                _selectDate(context);
              },
              child: Container(
                width: size.width,
                margin: EdgeInsets.only(top: 8, left: 16, right: 16),
                alignment: Alignment.center,
                decoration: BoxDecoration(color: colorButtonHome),
                child: TextFormField(
                  style: TextStyle(fontSize: 18),
                  enabled: false,
                  keyboardType: TextInputType.text,
                  controller: _tglLahir,
                  onSaved: (String? val) {
                    setDate = val!;
                  },
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.calendar_month,
                        color: colorPrimary,
                      ),
                      disabledBorder:
                          UnderlineInputBorder(borderSide: BorderSide.none),
                      contentPadding: EdgeInsets.only(top: 12)),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              padding: const EdgeInsets.only(left: 4, bottom: 4),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12), color: Colors.white),
              child: TextFormField(
                controller: _alamat,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                decoration: const InputDecoration(
                  labelText: textAlamat,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Masukkan $textAlamat';
                  } else {
                    return '$textAlamat Salah!';
                  }
                },
              ),
            )
          ],
        ));
  }

  Widget buildButtonSave() {
    return ElevatedButton(
        onPressed: updateData,
        style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(colorButton),
            shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24)))),
        child: Container(
            width: 120,
            height: 40,
            child: Center(
                child: Text(
              textButtonSave,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ))));
  }
}
