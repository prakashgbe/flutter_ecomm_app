
import 'package:flutter/material.dart';

class OnboardModel {
  String img;
  String text;
  String desc;
  Color bg;
  Color button;

  OnboardModel({
    required this.img,
    required this.text,
    required this.desc,
    required this.bg,
    required this.button,
  });
}

List<OnboardModel> screens = <OnboardModel>[
    OnboardModel(
      img: 'assets/images/Wilsonart.png',
      text: "Belajar Dengan Metode Learning by Doing",
      desc:
          "Sebuah metode belajar yang terbuktiampuh dalam meningkatkan produktifitas belajar, Learning by Doing",
      bg: Colors.white,
      button: Color(0xFF4756DF),
    ),
    OnboardModel(
      img: 'assets/images/Wilsonart.png',
      text: "Dapatkan Kemudahan Akses Kapanpun dan Dimanapun",
      desc:
          "Tidak peduli dimanapun kamu, semua kursus yang telah kamu ikuti bias kamu akses sepenuhnya",
      bg: Color(0xFF4756DF),
      button: Colors.white,
    ),
    OnboardModel(
      img: 'assets/images/Wilsonart.png',
      text: "Gunakan Fitur Kolaborasi Untuk Pengalaman Lebih",
      desc:
          "Tersedia fitur Kolaborasi dengan tujuan untuk mengasah skill lebih dalam karena bias belajar bersama",
      bg: Colors.white,
      button: Color(0xFF4756DF),
    ),
  ];

