import 'package:antrigo/pages/login_pages.dart';
import 'package:antrigo/pages/pasien/antrian.dart';
import 'package:antrigo/pages/pasien/daftar_antrian.dart';
import 'package:antrigo/pages/pasien/jadwal_pemeriksaan.dart';
import 'package:antrigo/pages/pasien/profile_pages.dart';
import 'package:antrigo/pages/pasien/riwayat_pemeriksaan.dart';
import 'package:antrigo/themes/custom_colors.dart';
import 'package:antrigo/themes/material_colors.dart';
import 'package:antrigo/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePages extends StatefulWidget {
  const HomePages({super.key});

  @override
  State<HomePages> createState() => _HomePagesState();
}

class _HomePagesState extends State<HomePages> {
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

  @override
  void initState() {
    super.initState();
    getUser();
  }

  showDialogExitToApp() {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text(titleLogout),
            content: Text(contentLogout),
            actions: [
              TextButton(onPressed: signOut, child: Text(textYa.toUpperCase())),
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(textTidak.toUpperCase()))
            ],
          );
        });
  }

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

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPages()),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(titleHome),
        actions: [
          IconButton(
              onPressed: showDialogExitToApp,
              icon: Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ))
        ],
      ),
      drawer: homeDrawer(),
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Stack(
          children: [
            buildBackground(size),
            buildHeader(size),
            buildTitleHeader(),
            buildIconHome(),
            _noAntrian == 0
                ? buildButtonAmbilNoAntrian()
                : buildButtonLihatAntrian(size)
          ],
        ),
      ),
    );
  }

  Widget homeDrawer() {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
              decoration: BoxDecoration(color: colorPrimary),
              child: Container(
                child: Center(
                  child: ListTile(
                    leading: Image.asset("assets/image/profil.png"),
                    title: Text(
                      "$_nama",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "No. Akun : ${_uid?.substring(20, 27)}",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              )),
          ListTile(
            onTap: () => Navigator.pushNamed(context, '/homePages'),
            leading: Image.asset(
              "assets/icon/icon_home.png",
              width: 24,
            ),
            title: Text(
              titleHome,
            ),
          ),
          ListTile(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ProfilePages(
                        uid: _uid.toString(),
                        nama: _nama.toString(),
                        email: _email.toString(),
                        role: _role.toString(),
                        nomorHp: _nomorHp.toString(),
                        jekel: _jekel.toString(),
                        tglLahir: _tglLahir.toString(),
                        alamat: _alamat.toString(),
                        isEdit: true))),
            leading: Image.asset(
              "assets/icon/icon_profile.png",
              width: 24,
            ),
            title: Text(
              titleProfile,
            ),
          ),
          ListTile(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => DaftarAntrianPages(
                          uid: _uid.toString(),
                          nama: _nama.toString(),
                        ))),
            leading: Image.asset(
              "assets/icon/icon_daftar_antrian.png",
              width: 24,
            ),
            title: Text(
              titleDaftarAntrian,
            ),
          ),
          ListTile(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) =>
                        JadwalPemeriksaanPages(uid: _uid.toString()))),
            leading: Image.asset(
              "assets/icon/icon_jadwal_periksa.png",
              width: 24,
            ),
            title: Text(
              titleJadwalPemeriksaan,
            ),
          ),
          ListTile(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RiwayatPemeriksaanPages(
              uid: _uid.toString()
            ))),
            leading: Image.asset(
              "assets/icon/icon_history.png",
              width: 24,
            ),
            title: Text(
              titleRiwayatPemeriksaan,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBackground(Size size) {
    return Container(
      width: size.width,
      height: size.height / 3.78,
      color: colorHome,
    );
  }

  Widget buildTitleHeader() {
    return Positioned.fill(
        top: 40,
        left: 40,
        right: 0,
        bottom: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Text(
                textWelcome,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24),
              ),
            ),
            Text(
              "Semoga Lekas Sembuh\n$_nama",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24),
            )
          ],
        ));
  }

  Widget buildHeader(Size size) {
    return Image.asset(
      "assets/image/vector.png",
      width: size.width,
      height: size.height / 3,
    );
  }

  Widget buildIconHome() {
    return Positioned.fill(
        child: Align(
            alignment: Alignment.center,
            child: Container(
                margin: const EdgeInsets.only(bottom: 90),
                child: Image.asset("assets/image/home_doctor.png"))));
  }

  Widget buildButtonAmbilNoAntrian() {
    return Positioned(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          margin: const EdgeInsets.only(bottom: 90),
          child: ElevatedButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => DaftarAntrianPages(
                            uid: _uid.toString(),
                            nama: _nama.toString(),
                          ))),
              style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(colorButtonHome),
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)))),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 40),
                child: Text(
                  textButtonAntrian,
                  style: TextStyle(
                    color: colorPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )),
        ),
      ),
    );
  }

  Widget buildButtonLihatAntrian(Size size) {
    return Positioned(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
                margin: const EdgeInsets.only(bottom: 120),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Image.asset("assets/ellipse/ellipse8.png"),
                    Image.asset("assets/image/suster.png"),
                  ],
                )),
            Container(
                width: size.width / 1.4,
                margin: const EdgeInsets.only(bottom: 160),
                child: Row(
                  children: [
                    Text(
                      titleNoAntrian,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                )),
            Container(
                width: size.width / 2.5,
                margin: const EdgeInsets.only(bottom: 80),
                child: Row(
                  children: [
                    Text(
                      _noAntrian == null ? "" : "$_noAntrian",
                      style:
                          TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                    ),
                  ],
                )),
            Container(
              margin: const EdgeInsets.only(top: 120),
              child: ElevatedButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => AntrianPages(
                              noAntrian: _noAntrian, poli: _poli))),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(colorButtonHome),
                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24)))),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 40),
                    child: Text(
                      textButtonLihatAntrian,
                      style: TextStyle(
                        color: colorPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
