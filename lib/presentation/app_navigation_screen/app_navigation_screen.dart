import 'package:kajak/core/app_export.dart';
import 'package:flutter/material.dart';

class AppNavigationScreen extends StatelessWidget {
  const AppNavigationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return SafeArea(
        child: Scaffold(
            body: SizedBox(
                width: 375.h)));
  }

  /// Navigates to the halamanHomeScreen when the action is triggered.
  ///
  /// The [BuildContext] parameter is used to build the navigation stack.
  /// When the action is triggered, this function uses the [Navigator] widget
  /// to push the named route for the halamanHomeScreen.
  onTapHalamanHome(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.halamanHomeScreen);
  }

  /// Navigates to the halamanTerjemahanScreen when the action is triggered.
  ///
  /// The [BuildContext] parameter is used to build the navigation stack.
  /// When the action is triggered, this function uses the [Navigator] widget
  /// to push the named route for the halamanTerjemahanScreen.
  onTapHalamanterjemahan(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.halamanTerjemahanScreen);
  }

  /// Navigates to the halamanKawruhBasaScreen when the action is triggered.
  ///
  /// The [BuildContext] parameter is used to build the navigation stack.
  /// When the action is triggered, this function uses the [Navigator] widget
  /// to push the named route for the halamanKawruhBasaScreen.
  onTapHalamanKawruhBasa(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.halamanKawruhBasaScreen);
  }

  /// Navigates to the halamanKawruhBasaSubMenu when the action is triggered.
  ///
  /// The [BuildContext] parameter is used to build the navigation stack.
  /// When the action is triggered, this function uses the [Navigator] widget
  /// to push the named route for the halamanKawruhBasaSubMenu.
  onTapHalamanKawruhBasaSubMenu(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.halamanKawruhBasaSubMenu);
  }

  /// Navigates to the halamanParamasastraScreen when the action is triggered.
  ///
  /// The [BuildContext] parameter is used to build the navigation stack.
  /// When the action is triggered, this function uses the [Navigator] widget
  /// to push the named route for the halamanParamasastraScreen.
  onTapHalamanParamasastra(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.halamanParamasastraScreen);
  }

  /// Navigates to the halamanParamasastraSubMenu when the action is triggered.
  ///
  /// The [BuildContext] parameter is used to build the navigation stack.
  /// When the action is triggered, this function uses the [Navigator] widget
  /// to push the named route for the halamanParamasastraSubMenu.
  onTapHalamanParamasastraSubMenu(BuildContext context) {
    Navigator.pushNamed(
        context, AppRoutes.halamanParamasastraSubMenu);
  }

  /// Navigates to the halamanKasusastraanScreen when the action is triggered.
  ///
  /// The [BuildContext] parameter is used to build the navigation stack.
  /// When the action is triggered, this function uses the [Navigator] widget
  /// to push the named route for the halamanKasusastraanScreen.
  onTapHalamanKasusastraan(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.halamanKasusastraanScreen);
  }

  /// Navigates to the halamanKasusastraanSubMenu when the action is triggered.
  ///
  /// The [BuildContext] parameter is used to build the navigation stack.
  /// When the action is triggered, this function uses the [Navigator] widget
  /// to push the named route for the halamanKasusastraanSubMenu.
  onTapHalamanKasusastraanSubMenuSix(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.halamanKasusastraanSubMenu);
  }

  /// Navigates to the halamanAksaraJawaScreen when the action is triggered.
  ///
  /// The [BuildContext] parameter is used to build the navigation stack.
  /// When the action is triggered, this function uses the [Navigator] widget
  /// to push the named route for the halamanAksaraJawaScreen.
  onTapHalamanAksaraJawa(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.halamanAksaraJawaScreen);
  }

  /// Navigates to the halamanAksaraJawaSubMenu when the action is triggered.
  ///
  /// The [BuildContext] parameter is used to build the navigation stack.
  /// When the action is triggered, this function uses the [Navigator] widget
  /// to push the named route for the halamanAksaraJawaSubMenu.
  onTapHalamanAksaraJawaSubmenuTwo(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.halamanAksaraJawaSubMenu);
  }

  /// Navigates to the kuisScreen when the action is triggered.
  ///
  /// The [BuildContext] parameter is used to build the navigation stack.
  /// When the action is triggered, this function uses the [Navigator] widget
  /// to push the named route for the kuisScreen.
  onTapKuis(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.kuisScreen);
  }

  /// Navigates to the kuisTwoScreen when the action is triggered.
  ///
  /// The [BuildContext] parameter is used to build the navigation stack.
  /// When the action is triggered, this function uses the [Navigator] widget
  /// to push the named route for the kuisTwoScreen.
  onTapKuisTwo(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.kuisTwoScreen);
  }

  /// Navigates to the soalKuisScreen when the action is triggered.
  ///
  /// The [BuildContext] parameter is used to build the navigation stack.
  /// When the action is triggered, this function uses the [Navigator] widget
  /// to push the named route for the soalKuisScreen.
  onTapSoalKuis(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.soalKuisScreen);
  }

  /// Navigates to the soalKuisHasilDanPembahasanScreen when the action is triggered.
  ///
  /// The [BuildContext] parameter is used to build the navigation stack.
  /// When the action is triggered, this function uses the [Navigator] widget
  /// to push the named route for the soalKuisHasilDanPembahasanScreen.
  onTapSoalKuisHasildanpembahasan(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.soalKuisHasilDanPembahasanScreen);
  }
}
