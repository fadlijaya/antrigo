import 'package:antrigo/pages/dokter/home_pages_d.dart';
import 'package:antrigo/pages/dokter/riwayat_pasien_masuk.dart';
import 'package:antrigo/pages/pasien/antrian.dart';
import 'package:antrigo/pages/pasien/daftar_antrian.dart';
import 'package:antrigo/pages/pasien/home_pages.dart';
import 'package:antrigo/pages/pasien/jadwal_pemeriksaan.dart';
import 'package:antrigo/pages/login_pages.dart';
import 'package:antrigo/pages/pasien/profile_pages.dart';
import 'package:antrigo/pages/pasien/riwayat_pemeriksaan.dart';
import 'package:antrigo/themes/material_colors.dart';
import 'package:antrigo/utils/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'pages/dokter/daftar_antrian_d.dart';
import 'pages/dokter/profile_pages_d.dart';
import 'pages/pasien/next_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: titleApp,
      theme: ThemeData(
        primarySwatch: colorPrimary,
      ),
      routes: {
        '/loginPages': (_) => LoginPages(),
        '/homePages': (_) => HomePages(),
        '/jadwalPemeriksaanPages': (_) => JadwalPemeriksaanPages(),
        '/homePagesDokter': (_) => HomePagesDokter(),
        '/daftarAntrianPagesDokter': (_) => DaftarAntrianPagesDokter(),
        '/riwayatPasienMasuk': (_) => RiwayatPasienMasuk()
      },
      home: const NextPages() 
    );
  }
}