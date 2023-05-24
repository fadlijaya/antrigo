import 'package:antrigo/themes/custom_colors.dart';
import 'package:antrigo/themes/material_colors.dart';
import 'package:antrigo/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AntrianPages extends StatefulWidget {
  int? noAntrian;
  String? poli;
  AntrianPages({Key? key, this.noAntrian, this.poli}) : super(key: key);

  @override
  State<AntrianPages> createState() => _AntrianPagesState();
}

class _AntrianPagesState extends State<AntrianPages> {
  final Stream<QuerySnapshot> _streamAntrianPasien =
      FirebaseFirestore.instance.collection("antrian pasien").snapshots();
  
  int? noAntrianSedangDilayani;

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
    .collection('sedang dilayani')
    .get()
    .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
            noAntrianSedangDilayani = doc['no antrian'];
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: colorButtonHome,
      appBar: AppBar(
        title: Text(titleAntrian),
      ),
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Stack(
          children: [
            buildItemAntrian(size),
            buildEllipse(),
            buildTextInformasi(size),
            buildImage(),
            buildEllipseBottom1(),
            buildEllipseBottom2()
          ],
        ),
      ),
    );
  }

  Widget buildItemAntrian(Size size) {
    return Column(
      children: [
        /*Padding(
          padding: const EdgeInsets.only(top: 24),
          child: Text(
            "poli ${widget.poli}".toUpperCase(),
            style: TextStyle(
                color: colorPinkText,
                fontSize: 24,
                fontWeight: FontWeight.bold),
          ),
        ),*/
        FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('sedang dilayani')
              .doc("avpg6d1x7v6iAnmkVERw")
              .get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong");
            }

            if (snapshot.hasData && !snapshot.data!.exists) {
              return Text("Document does not exist");
            }

            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
              return Container(
                  margin: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                  width: size.width,
                  height: size.height / 5,
                  decoration: BoxDecoration(
                      color: colorPrimary,
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        textSedangDilayani,
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      Text(
                        "${data['no antrian']}",
                        style: TextStyle(
                            fontSize: 60,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      )
                    ],
                  ));
            }

            return CircularProgressIndicator();
          },
        ),
        Row(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(8, 0, 0, 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: colorButtonHome),
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    textNoAntrian,
                    style: TextStyle(color: colorPinkText, fontSize: 12),
                  ),
                  Text(
                    "${widget.noAntrian}",
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: colorPinkText),
                  )
                ],
              ),
            ),
            StreamBuilder<QuerySnapshot>(
                stream: _streamAntrianPasien,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text("Error!"),
                    );
                  } else {
                    int sisaAntrian = snapshot.data!.docs.length - int.parse("${noAntrianSedangDilayani}");
                    return Container(
                      margin: const EdgeInsets.fromLTRB(4, 0, 0, 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            textSisaAntrian,
                            style:
                                TextStyle(color: colorPinkText, fontSize: 12),
                          ),
                          Text(
                            "${int.parse(sisaAntrian.toString())}",
                            style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: colorPinkText),
                          )
                        ],
                      ),
                    );
                  }
                }),
            StreamBuilder<QuerySnapshot>(
                stream: _streamAntrianPasien,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text("Error!"),
                    );
                  } else {
                    int totalAntrianPasien = snapshot.data!.docs.length;
                    return Container(
                      margin: const EdgeInsets.fromLTRB(4, 0, 0, 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            textJumlahPendaftar,
                            style:
                                TextStyle(color: colorPinkText, fontSize: 12),
                          ),
                          Text(
                            "${int.parse(totalAntrianPasien.toString())}",
                            style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: colorPinkText),
                          )
                        ],
                      ),
                    );
                  }
                }),
          ],
        )
      ],
    );
  }

  Widget buildEllipse() {
    return Positioned(
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 140),
                child: Image.asset("assets/ellipse/ellipse5.png"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextInformasi(Size size) {
    return Positioned(
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          width: size.width / 2,
          padding: const EdgeInsets.all(16),
          child: Stack(
            children: [
              Padding(
                  padding: const EdgeInsets.only(top: 140),
                  child: Text(
                    textInformasiAntrian,
                    style: TextStyle(fontSize: 12),
                    textAlign: TextAlign.center,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildImage() {
    return Positioned(
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 240, left: 40),
                child: Image.asset("assets/image/suster3.png"),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildEllipseBottom1() {
    return Positioned(
      child: Align(
        alignment: Alignment.bottomRight,
        child: Container(
          child: Stack(
            children: [
              Image.asset("assets/ellipse/ellipse6.png"),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildEllipseBottom2() {
    return Positioned(
      child: Align(
        alignment: Alignment.bottomRight,
        child: Container(
          child: Stack(
            children: [
              Image.asset("assets/ellipse/ellipse7.png"),
            ],
          ),
        ),
      ),
    );
  }
}
