import 'package:kajak/core/app_export.dart';
import 'package:kajak/widgets/app_bar/appbar_image.dart';
import 'package:kajak/widgets/app_bar/appbar_title.dart';
import 'package:kajak/widgets/app_bar/custom_app_bar.dart';
import 'package:flutter/material.dart';

class HalamanKawruhBasaScreen extends StatelessWidget {
  const HalamanKawruhBasaScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return SafeArea(
        child: Scaffold(
            appBar: CustomAppBar(
                leadingWidth: 36.h,
                leading: AppbarImage(
                    svgPath: ImageConstant.imgArrowleft,
                    margin:
                        EdgeInsets.only(left: 11.h, top: 15.v, bottom: 15.v),
                    onTap: () {
                      onTapArrowleftone(context);
                    }),
                centerTitle: true,
                title: AppbarTitle(text: "Rupa - Rupa Kawruh Basa")),
            body: Padding(
                padding: EdgeInsets.only(left: 25.h, top: 11.v, right: 25.h),
                child: Column(
                  children: [
                    Card(
                      clipBehavior: Clip.antiAlias,
                      elevation: 0,
                      color: Colors.white,
                      margin: EdgeInsets.only(
                        top: 7.v,
                      ),
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
                          horizontal: 1.h,
                          vertical: 5.v,
                        ),
                        decoration: AppDecoration.outlineBlack.copyWith(
                          borderRadius: BorderRadiusStyle.roundedBorder10,
                        ),
                        child: Stack(
                          alignment: Alignment.topLeft,
                          children: [
                            CustomImageView(
                              imagePath: ImageConstant.imgFrame1,
                              height: 86.v,
                              width: 136.h,
                              alignment: Alignment.bottomRight,
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                width: 201.h,
                                margin: EdgeInsets.only(
                                  left: 17.h,
                                  top: 6.v,
                                ),
                                child: Text(
                                  "Ayo belajar bebarengan \ntentang panyabutan (Aranan) \nsakitar arek dewe",
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.titleMedium,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 1.h,
                          top: 19.v,
                        ),
                        child: ListView.separated(
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            separatorBuilder: (
                                context,
                                index,
                                ) {
                              return SizedBox(
                                height: 12.v,
                              );
                            },
                            itemCount: 1,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      // DOKUMENTASI
                                      // Aranan Kembang, Aranan Bocah, Aranan Wektu, Aranan Anak Kewan jadi satu page
                                      // dibedakan hanya menggunakan id
                                      Navigator.pushNamed(context, AppRoutes.halamanKawruhBasaSubMenu, arguments: AppRoutes(id: 1, obj: {}));
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 29.h,
                                        vertical: 13.v,
                                      ),
                                      decoration: AppDecoration.outlineBlack900.copyWith(
                                        borderRadius: BorderRadiusStyle.roundedBorder10,
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SizedBox(height: 3.v),
                                          Text(
                                            "Aranan Kembang",
                                            style: theme.textTheme.titleMedium,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                              top: 3.v,
                                              right: 22.h,
                                            ),
                                            child: Text(
                                              "Pelajari apa saja penyebutan Bunga dalam bahasa jawa"
                                                  "                        ",
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: CustomTextStyles.labelLargeMedium,
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
                                      Navigator.pushNamed(context, AppRoutes.halamanKawruhBasaSubMenu, arguments: AppRoutes(id: 2, obj: {}));
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 29.h,
                                        vertical: 13.v,
                                      ),
                                      decoration: AppDecoration.outlineBlack900.copyWith(
                                        borderRadius: BorderRadiusStyle.roundedBorder10,
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SizedBox(height: 3.v),
                                          Text(
                                            "Aranan Bocah",
                                            style: theme.textTheme.titleMedium,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                              top: 3.v,
                                              right: 22.h,
                                            ),
                                            child: Text(
                                              "Pelajari apa saja penyebutan untuk Anak dalam bahasa jawa"
                                                  "                        ",
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: CustomTextStyles.labelLargeMedium,
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
                                      Navigator.pushNamed(context, AppRoutes.halamanKawruhBasaSubMenu, arguments: AppRoutes(id: 3, obj: {}));
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 29.h,
                                        vertical: 13.v,
                                      ),
                                      decoration: AppDecoration.outlineBlack900.copyWith(
                                        borderRadius: BorderRadiusStyle.roundedBorder10,
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SizedBox(height: 3.v),
                                          Text(
                                            "Aranan Wektu",
                                            style: theme.textTheme.titleMedium,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                              top: 3.v,
                                              right: 22.h,
                                            ),
                                            child: Text(
                                              "Pelajari apa saja penyebutan waktu sehari-hari dalam bahasa jawa"
                                                  "                        ",
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: CustomTextStyles.labelLargeMedium,
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
                                      Navigator.pushNamed(context, AppRoutes.halamanKawruhBasaSubMenu, arguments: AppRoutes(id: 4, obj: {}));
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 29.h,
                                        vertical: 13.v,
                                      ),
                                      decoration: AppDecoration.outlineBlack900.copyWith(
                                        borderRadius: BorderRadiusStyle.roundedBorder10,
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SizedBox(height: 3.v),
                                          Text(
                                            "Aranan Anak Kewan",
                                            style: theme.textTheme.titleMedium,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                              top: 3.v,
                                              right: 22.h,
                                            ),
                                            child: Text(
                                              "Pelajari apa saja penyebutan Nama anak binatang dalam bahasa jawa"
                                                  "                        ",
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: CustomTextStyles.labelLargeMedium,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                ],
                              );
                            }),
                      ),
                    ),
                  ],
                ))));
  }

  /// Navigates back to the previous screen.
  ///
  /// This function takes a [BuildContext] object as a parameter, which is used
  /// to navigate back to the previous screen.
  onTapArrowleftone(BuildContext context) {
    Navigator.pop(context);
  }
}
