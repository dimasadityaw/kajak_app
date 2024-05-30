import 'package:kajak/core/app_export.dart';
import 'package:kajak/widgets/app_bar/appbar_image.dart';
import 'package:kajak/widgets/app_bar/appbar_title.dart';
import 'package:kajak/widgets/app_bar/custom_app_bar.dart';
import 'package:flutter/material.dart';

class HalamanAksaraJawaScreen extends StatelessWidget {
  const HalamanAksaraJawaScreen({Key? key}) : super(key: key);

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
                title: AppbarTitle(text: "Aksara Jawa")),
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
                              // width: 330.h,
                              padding: EdgeInsets.symmetric(
                                horizontal: 5.h,
                                vertical: 4.v,
                              ),
                              decoration: AppDecoration.outlineBlack.copyWith(
                                color: Colors.white,
                                borderRadius: BorderRadiusStyle.roundedBorder10,
                              ),
                              child: Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        left: 12.h,
                                        top: 7.v,
                                      ),
                                      child: Text(
                                        "Ayo belajar bebarengan \ntentang Aksara Jawa lan \njeneng e",
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: theme.textTheme.titleMedium,
                                      ),
                                    ),
                                  ),
                                  CustomImageView(
                                    imagePath: ImageConstant.imgFrame186x136,
                                    height: 86.v,
                                    width: 136.h,
                                    alignment: Alignment.bottomRight,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          ListView.separated(
                              physics: BouncingScrollPhysics(),
                              shrinkWrap: true,
                              separatorBuilder: (context, index) {
                                return SizedBox(height: 14.v);
                              },
                              itemCount: 1,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    Padding(
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
                                                    Navigator.pushNamed(
                                                        context,
                                                        AppRoutes
                                                            .halamanAksaraJawaSubMenu, arguments: AppRoutes(id: 1, obj: {}));
                                                  },
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal: 29.h,
                                                      vertical: 13.v,
                                                    ),
                                                    decoration: AppDecoration
                                                        .outlineBlack900
                                                        .copyWith(
                                                      borderRadius:
                                                          BorderRadiusStyle
                                                              .roundedBorder10,
                                                    ),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        SizedBox(height: 3.v),
                                                        Text(
                                                          "Sejarah Aksara Jawa",
                                                          style: theme.textTheme
                                                              .titleMedium,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                            top: 3.v,
                                                            right: 22.h,
                                                          ),
                                                          child: Text(
                                                            "Pelajari bagaiamana terciptanya huruf aksara jawa"
                                                            "                        ",
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: CustomTextStyles
                                                                .labelLargeMedium,
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
                                                    Navigator.pushNamed(
                                                        context,
                                                        AppRoutes
                                                            .halamanAksaraJawaSubMenu, arguments: AppRoutes(id: 2, obj: {}));
                                                  },
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal: 29.h,
                                                      vertical: 13.v,
                                                    ),
                                                    decoration: AppDecoration
                                                        .outlineBlack900
                                                        .copyWith(
                                                      borderRadius:
                                                          BorderRadiusStyle
                                                              .roundedBorder10,
                                                    ),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        SizedBox(height: 3.v),
                                                        Text(
                                                          "Ha na Ca ra ka",
                                                          style: theme.textTheme
                                                              .titleMedium,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                            top: 3.v,
                                                            right: 22.h,
                                                          ),
                                                          child: Text(
                                                            "Pelajari apa saja Aksara Jawa Biasa hingga Aksara Swara"
                                                            "                        ",
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: CustomTextStyles
                                                                .labelLargeMedium,
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
                                                    Navigator.pushNamed(
                                                        context,
                                                        AppRoutes
                                                            .halamanAksaraJawaSubMenu, arguments: AppRoutes(id: 3, obj: {}));
                                                  },
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal: 29.h,
                                                      vertical: 13.v,
                                                    ),
                                                    decoration: AppDecoration
                                                        .outlineBlack900
                                                        .copyWith(
                                                      borderRadius:
                                                          BorderRadiusStyle
                                                              .roundedBorder10,
                                                    ),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        SizedBox(height: 3.v),
                                                        Text(
                                                          "Sandhangan",
                                                          style: theme.textTheme
                                                              .titleMedium,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                            top: 3.v,
                                                            right: 22.h,
                                                          ),
                                                          child: Text(
                                                            "Pelajari apa saja Sandhangan (tanda bunyi) pada Aksara Jawa"
                                                            "                        ",
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: CustomTextStyles
                                                                .labelLargeMedium,
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
                                  ],
                                );
                              })
                        ],
                      );
                    }))));
  }

  /// Navigates back to the previous screen.
  ///
  /// This function takes a [BuildContext] object as a parameter, which is used
  /// to navigate back to the previous screen.
  onTapArrowleftone(BuildContext context) {
    Navigator.pop(context);
  }
}
