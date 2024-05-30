import 'package:flutter/material.dart';
import 'package:kajak/presentation/auth/login.dart';
import 'package:kajak/presentation/halaman_home_screen/halaman_home_screen.dart';
import 'package:kajak/presentation/halaman_terjemahan_screen/halaman_terjemahan_screen.dart';
import 'package:kajak/presentation/halaman_kawruh_basa_screen/halaman_kawruh_basa_screen.dart';
import 'package:kajak/presentation/halaman_kawruh_basa_sub_menu/halaman_kawruh_basa_sub_menu.dart';
import 'package:kajak/presentation/halaman_paramasastra_screen/halaman_paramasastra_screen.dart';
import 'package:kajak/presentation/halaman_paramasastra_sub_menu/halaman_paramasastra_sub_menu.dart';
import 'package:kajak/presentation/halaman_kasusastraan_screen/halaman_kasusastraan_screen.dart';
import 'package:kajak/presentation/halaman_kasusastraan_sub_menu/halaman_kasusastraan_sub_menu.dart';
import 'package:kajak/presentation/halaman_kasusastraan_sub_menu_paribasan_screen/halaman_kasusastraan_sub_menu_paribasan_screen.dart';
import 'package:kajak/presentation/halaman_aksara_jawa_screen/halaman_aksara_jawa_screen.dart';
import 'package:kajak/presentation/halaman_aksara_jawa_sub_menu/halaman_aksara_jawa_sub_menu.dart';
import 'package:kajak/presentation/kuis_screen/kuis_screen.dart';
import 'package:kajak/presentation/kuis_two_screen/kuis_two_screen.dart';
import 'package:kajak/presentation/soal_kuis_screen/soal_kuis_screen.dart';
import 'package:kajak/presentation/soal_kuis_hasil_dan_pembahasan_screen/soal_kuis_hasil_dan_pembahasan_screen.dart';
import 'package:kajak/presentation/app_navigation_screen/app_navigation_screen.dart';

class AppRoutes {
  int id = 0;
  var obj = {};

  AppRoutes({
    required this.id,
    required this.obj
  });

  static const String loginScreen = '/login';

  static const String halamanHomeScreen = '/halaman_home_screen';

  static const String halamanTerjemahanScreen = '/halaman_terjemahan_screen';

  static const String halamanKawruhBasaScreen = '/halaman_kawruh_basa_screen';

  static const String halamankasustraanBasaScreen = '/halaman_kasustraan_basa_screen';

  static const String halamanKawruhBasaSubMenu =
      '/halaman_kawruh_basa_sub_menu';

  static const String halamanParamasastraScreen =
      '/halaman_paramasastra_screen';

  static const String halamanParamasastraSubMenu =
      '/halaman_paramasastra_sub_menu';

  static const String halamanKasusastraanScreen =
      '/halaman_kasusastraan_screen';

  static const String halamanKasusastraanSubMenu =
      '/halaman_kasusastraan_sub_menu';

  static const String halamanKasusastraanSubMenuParibasanScreen =
      '/halaman_kasusastraan_sub_menu_paribasan_screen';

  static const String halamanAksaraJawaScreen = '/halaman_aksara_jawa_screen';

  static const String halamanAksaraJawaSubMenu =
      '/halaman_aksara_jawa_sub_menu';

  static const String kuisScreen = '/kuis_screen';

  static const String kuisTwoScreen = '/kuis_two_screen';

  static const String soalKuisScreen = '/soal_kuis_screen';

  static const String soalKuisHasilDanPembahasanScreen =
      '/soal_kuis_hasil_dan_pembahasan_screen';

  static const String appNavigationScreen = '/app_navigation_screen';

  static Map<String, WidgetBuilder> routes = {
    loginScreen: (context) => LoginActivity(),
    halamanHomeScreen: (context) => HalamanHomeScreen(),
    halamanTerjemahanScreen: (context) => HalamanTerjemahanScreen(),
    halamanKawruhBasaScreen: (context) => HalamanKawruhBasaScreen(),
    halamanKawruhBasaSubMenu: (context) =>
        HalamanKawruhBasaSubMenu(int.parse((ModalRoute.of(context)?.settings.arguments as AppRoutes).id.toString())),
    halamanParamasastraScreen: (context) => HalamanParamasastraScreen(),
    halamanParamasastraSubMenu: (context) =>
        HalamanParamasastraSubMenu((ModalRoute.of(context)?.settings.arguments as AppRoutes).obj),
    halamanKasusastraanScreen: (context) => HalamanKasusastraanScreen(),
    halamanKasusastraanSubMenu: (context) =>
        HalamanKasusastraanSubMenu(int.parse((ModalRoute.of(context)?.settings.arguments as AppRoutes).id.toString())),
    halamanKasusastraanSubMenuParibasanScreen: (context) =>
        HalamanKasusastraanSubMenuParibasanScreen(int.parse((ModalRoute.of(context)?.settings.arguments as AppRoutes).id.toString()), (ModalRoute.of(context)?.settings.arguments as AppRoutes).obj),
    halamanAksaraJawaScreen: (context) => HalamanAksaraJawaScreen(),
    halamanAksaraJawaSubMenu: (context) =>
        HalamanAksaraJawaSubMenu(int.parse((ModalRoute.of(context)?.settings.arguments as AppRoutes).id.toString())),
    kuisScreen: (context) => KuisScreen(),
    kuisTwoScreen: (context) => KuisTwoScreen(),
    soalKuisScreen: (context) => SoalKuisScreen(),
    soalKuisHasilDanPembahasanScreen: (context) =>
        SoalKuisHasilDanPembahasanScreen(),
    // appNavigationScreen: (context) => AppNavigationScreen()
  };
}
