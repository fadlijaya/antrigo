import 'dart:math';

import 'package:antrigo/themes/custom_colors.dart';
import 'package:antrigo/themes/material_colors.dart';
import 'package:antrigo/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DaftarAntrianPages extends StatefulWidget {
  String? uid;
  String? nama;
  DaftarAntrianPages({Key? key, this.uid, this.nama}) : super(key: key);

  @override
  State<DaftarAntrianPages> createState() => _DaftarAntrianPagesState();
}

class _DaftarAntrianPagesState extends State<DaftarAntrianPages> {
  final _formKey = GlobalKey<FormState>();
  String? selectedItemPoli;
  DateTime selectedDate = DateTime.now();
  String? setDate, setTime;
  String? hour, minute, time;
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  var itemPoli = [
    'Gigi',
    'Mata',
    'Umum',
    'THT',
    'Kandungan',
    'Anak',
    'Penyakit Dalam'
  ];

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat.yMd().format(selectedDate);
      });
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        hour = selectedTime.hour.toString();
        minute = selectedTime.minute.toString();
        time = hour! + ' : ' + minute!;
        _timeController.text = time!;
        _timeController.text = formatDate(
            DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]).toString();
      });
  }

  @override
  void initState() {
    _dateController.text = DateFormat.yMd().format(DateTime.now());

    _timeController.text = formatDate(
        DateTime(2019, 08, 1, DateTime.now().hour, DateTime.now().minute),
        [hh, ':', nn, " ", am]).toString();
    super.initState();
  }

  Future<dynamic> createAntrianPoli() async {
    if (_formKey.currentState!.validate()) {
      showAlertDialogLoading(context);
      try {
        User? users = FirebaseAuth.instance.currentUser;
        QuerySnapshot docUsersAntrian = await FirebaseFirestore.instance.collection('users').doc(users!.uid).collection('antrian').get();
        List<DocumentSnapshot> docUserAntrianCount = docUsersAntrian.docs;

        final docId = await FirebaseFirestore.instance
            .collection('users')
            .doc(users.uid)
            .collection('antrian')
            .add({
          'uid pasien': widget.uid.toString(),
          'nama pasien': widget.nama.toString(),
          'poli': selectedItemPoli.toString(),
          'tanggal antrian': _dateController.text,
          'waktu antrian': _timeController.text,
          'no antrian': docUserAntrianCount.length + 1
        });

        QuerySnapshot docAntrianPasien = await FirebaseFirestore.instance.collection('antrian pasien').get();
        List<DocumentSnapshot> docAntrianPasienCount = docAntrianPasien.docs;

        await FirebaseFirestore.instance
            .collection('antrian pasien')
            .doc(docId.id)
            .set({
          'uid pasien': widget.uid.toString(),
          'doc id': docId.id.toString(),
          'nama pasien': widget.nama.toString(),
          'poli': selectedItemPoli.toString(),
          'tanggal antrian': _dateController.text,
          'waktu antrian': _timeController.text,
          'no antrian': docAntrianPasienCount.length + 1,
          'status': 'Menunggu'
        });
        updateDataUsers();
        Navigator.pop(context);
        signUpDialog();
      } catch (e) {
        return e.toString();
      }
    }
  }

   Future<dynamic> updateDataUsers() async {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('users').doc(widget.uid);

    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot documentSnapshot =
          await transaction.get(documentReference);

      if (documentSnapshot.exists) {
        transaction.update(documentReference, <String, dynamic>{
          'no antrian': FieldValue.increment(1),
          'poli': selectedItemPoli.toString()
        });
      }
    });
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
            title: Text(titleSuccess),
            content: Text('Antrian Anda Telah Terdaftar!'),
            actions: [
              TextButton(
                  onPressed: () =>
                      Navigator.popAndPushNamed(context, '/homePages'),
                  child: const Text(
                    'OK',
                    style: TextStyle(color: colorPinkText),
                  ))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(titleDaftarAntrian),
      ),
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Column(
          children: [
            buildTextTitle(),
            buildFormAmbilAntrian(size),
            buildButtonDaftar(),
            buildFooter(size)
          ],
        ),
      ),
    );
  }

  Widget buildTextTitle() {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 40),
        child: Text(textAmbilAntrian,
            style: TextStyle(
                color: colorPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold)));
  }

  Widget buildFormAmbilAntrian(Size size) {
    final format = DateFormat('dd-MM-yyyy');
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        "Poli",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    DropdownButton(
                      items: itemPoli.map((String value) {
                        return DropdownMenuItem(
                            value: value, child: Text(value));
                      }).toList(),
                      onChanged: (selected) {
                        setState(() {
                          selectedItemPoli = selected as String;
                        });
                      },
                      value: selectedItemPoli,
                      isExpanded: true,
                      hint: const Text("Pilih Poli"),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        "Tanggal",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        _selectDate(context);
                      },
                      child: Container(
                        width: size.width,
                        margin: EdgeInsets.only(top: 16),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(color: colorButtonHome),
                        child: TextFormField(
                          style: TextStyle(fontSize: 18),
                          enabled: false,
                          keyboardType: TextInputType.text,
                          controller: _dateController,
                          onSaved: (String? val) {
                            setDate = val!;
                          },
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.calendar_month,
                                color: colorPrimary,
                              ),
                              disabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide.none),
                              contentPadding: EdgeInsets.only(top: 12)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        "Waktu",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        _selectTime(context);
                      },
                      child: Container(
                        width: size.width,
                        margin: EdgeInsets.only(top: 16),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(color: colorButtonHome),
                        child: TextFormField(
                          style: TextStyle(fontSize: 18),
                          enabled: false,
                          keyboardType: TextInputType.text,
                          controller: _timeController,
                          onSaved: (String? val) {
                            setDate = val!;
                          },
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.calendar_month,
                                color: colorPrimary,
                              ),
                              disabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide.none),
                              contentPadding: EdgeInsets.only(top: 12)),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }

  Widget buildButtonDaftar() {
    return ElevatedButton(
        onPressed: createAntrianPoli,
        style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(colorButton),
            shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24)))),
        child: Container(
            width: 120,
            height: 40,
            child: Center(
                child: Text(
              textButtonDaftar,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ))));
  }

  Widget buildFooter(Size size) {
    return Container(
      margin: const EdgeInsets.only(top: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: size.width / 2,
            child: Stack(
              children: [
                Image.asset("assets/ellipse/ellipse4.png"),
                Positioned.fill(
                    left: 0,
                    top: 32,
                    right: 0,
                    bottom: 0,
                    child: Text(
                      "Hy kak ${widget.nama},\n$textInformasiDaftarAntrian",
                      textAlign: TextAlign.center,
                    )),
              ],
            ),
          ),
          Image.asset("assets/image/suster.png")
        ],
      ),
    );
  }
}
