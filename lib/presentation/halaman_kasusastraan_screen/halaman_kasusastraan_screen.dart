import 'dart:async';

import 'package:kajak/ConnectivityService.dart';
import 'package:kajak/core/app_export.dart';
import 'package:kajak/database_helper/database_helper.dart';
import 'package:kajak/database_helper/tembang.dart';
import 'package:kajak/presentation/footer/footer.dart';
import 'package:kajak/widgets/app_bar/appbar_image.dart';
import 'package:kajak/widgets/app_bar/appbar_title.dart';
import 'package:kajak/widgets/app_bar/custom_app_bar.dart';
import 'package:flutter/material.dart';

class HalamanKasusastraanScreen extends StatefulWidget {
  HalamanKasusastraanScreen({Key? key}) : super(key: key);

  @override
  _HalamanKasusastraanScreenState createState() =>
      _HalamanKasusastraanScreenState();
}

class _HalamanKasusastraanScreenState extends State<HalamanKasusastraanScreen> {
  var user;

  StreamSubscription<bool>? _connectivitySubscription;
  bool isConnected = true;

  @override
  void initState() {
    _connectivitySubscription =
        ConnectivityService.connectivityStream.listen((status) {
      setState(() {
        isConnected = status;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return SafeArea(
        child: Scaffold(
      appBar: CustomAppBar(
          leadingWidth: 36.h,
          leading: AppbarImage(
              svgPath: ImageConstant.imgArrowleft,
              margin: EdgeInsets.only(left: 11.h, top: 15.v, bottom: 15.v),
              onTap: () {
                onTapArrowleftone(context);
              }),
          centerTitle: true,
          title: AppbarTitle(text: "Kasusastraan")),
      body: Padding(
          padding: EdgeInsets.only(left: 25.h, top: 11.v, right: 25.h),
          child: ListView.separated(
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              separatorBuilder: (context, index) {
                return SizedBox(height: 14.v);
              },
              itemCount: 1,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Card(
                      clipBehavior: Clip.antiAlias,
                      elevation: 0,
                      color: Colors.white,
                      margin: EdgeInsets.all(0),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: appTheme.black900,
                          width: 1.h,
                        ),
                        borderRadius: BorderRadiusStyle.roundedBorder10,
                      ),
                      child: Container(
                        height: 154.v,
                        width: 330.h,
                        padding: EdgeInsets.symmetric(
                          horizontal: 5.h,
                          vertical: 3.v,
                        ),
                        decoration: AppDecoration.outlineBlack.copyWith(
                          borderRadius: BorderRadiusStyle.roundedBorder10,
                        ),
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: 13.h,
                                  top: 8.v,
                                ),
                                child: Text(
                                  "Ayo belajar Kasusastraan \n(Sastra) kanggo Lelakuning \ning jiwo",
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.titleMedium,
                                ),
                              ),
                            ),
                            CustomImageView(
                              imagePath: ImageConstant.imgFrame198x156,
                              height: 98.v,
                              width: 156.h,
                              alignment: Alignment.bottomRight,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 330.h,
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: 1.h,
                          left: 1.h,
                          top: 19.v,
                        ),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context,
                                    AppRoutes.halamanKasusastraanSubMenu,
                                    arguments: AppRoutes(id: 1, obj: {}));
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 29.h,
                                  vertical: 13.v,
                                ),
                                decoration:
                                    AppDecoration.outlineBlack900.copyWith(
                                  borderRadius:
                                      BorderRadiusStyle.roundedBorder10,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 3.v),
                                    Text(
                                      "Paribasan",
                                      style: theme.textTheme.titleMedium,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: 3.v,
                                        right: 22.h,
                                      ),
                                      child: Text(
                                        "Pelajari apa saja Paribasan (Pribahasa dalam bahasa jawa)"
                                        "                        ",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style:
                                            CustomTextStyles.labelLargeMedium,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 12.v,
                            ),
                            GestureDetector(
                              onTap: () async {
                                if (isConnected) {
                                  Navigator.pushNamed(context,
                                      AppRoutes.halamanKasusastraanSubMenu,
                                      arguments: AppRoutes(id: 2, obj: {}));
                                } else {
                                  var objData =
                                      await Tembang().getTembangData();
                                  if (objData.toString() != '[]') {
                                    Navigator.pushNamed(context,
                                        AppRoutes.halamanKasusastraanSubMenu,
                                        arguments: AppRoutes(id: 2, obj: {}));
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      backgroundColor: Colors.red,
                                      behavior: SnackBarBehavior.floating,
                                      content: Text(
                                          'Periksa kembali jaringan anda.',
                                          style: theme.textTheme.titleMedium
                                              ?.copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600)),
                                    ));
                                  }
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 29.h,
                                  vertical: 13.v,
                                ),
                                decoration:
                                    AppDecoration.outlineBlack900.copyWith(
                                  borderRadius:
                                      BorderRadiusStyle.roundedBorder10,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 3.v),
                                    Text(
                                      "Tembang",
                                      style: theme.textTheme.titleMedium,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: 3.v,
                                        right: 22.h,
                                      ),
                                      child: Text(
                                        "Pelajari apa saja tembang (Lirik/Sajak) dalam bahasa jawa"
                                        "                        ",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style:
                                            CustomTextStyles.labelLargeMedium,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 12.v,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context,
                                    AppRoutes.halamanKasusastraanSubMenu,
                                    arguments: AppRoutes(id: 3, obj: {}));
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 29.h,
                                  vertical: 13.v,
                                ),
                                decoration:
                                    AppDecoration.outlineBlack900.copyWith(
                                  borderRadius:
                                      BorderRadiusStyle.roundedBorder10,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 3.v),
                                    Text(
                                      "Parikan",
                                      style: theme.textTheme.titleMedium,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: 3.v,
                                        right: 22.h,
                                      ),
                                      child: Text(
                                        "Pelajari apa saja Parikan (Puisi) dalam bahasa jawa"
                                        "                        ",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style:
                                            CustomTextStyles.labelLargeMedium,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                );
              })),
      bottomNavigationBar: !isConnected
          ? Container(
              color: Colors.red,
              padding: EdgeInsets.symmetric(vertical: 2.5.h),
              child: FooterMenu())
          : SizedBox(),
    ));
  }

  /// Navigates back to the previous screen.
  ///
  /// This function takes a [BuildContext] object as a parameter, which is used
  /// to navigate back to the previous screen.
  onTapArrowleftone(BuildContext context) {
    Navigator.pop(context);
  }
}
