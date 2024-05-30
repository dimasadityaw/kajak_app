import 'package:kajak/core/app_export.dart';
import 'package:kajak/widgets/app_bar/appbar_image.dart';
import 'package:kajak/widgets/app_bar/appbar_title.dart';
import 'package:kajak/widgets/app_bar/custom_app_bar.dart';
import 'package:kajak/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';

class KuisScreen extends StatelessWidget {
  const KuisScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return SafeArea(
        child: Scaffold(
            backgroundColor: appTheme.gray50,
            appBar: CustomAppBar(
                leadingWidth: 40.h,
                leading: AppbarImage(
                    svgPath: ImageConstant.imgArrowleft,
                    margin:
                        EdgeInsets.only(left: 15.h, top: 15.v, bottom: 15.v),
                    onTap: () {
                      onTapArrowleftone(context);
                    }),
                centerTitle: true,
                title: AppbarTitle(text: "Wulangan")),
            body: Container(
                width: 379.h,
                padding: EdgeInsets.symmetric(horizontal: 43.h),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          margin: EdgeInsets.only(
                              left: 37.h, top: 20.v, right: 37.h),
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.h, vertical: 17.v),
                          decoration: AppDecoration.outlineBlack9001.copyWith(
                              borderRadius: BorderRadiusStyle.roundedBorder10),
                          child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    width: 146.h,
                                    margin:
                                        EdgeInsets.only(left: 6.h, right: 40.h),
                                    child: Text(
                                        "Yuk, Uji Ketangksanmu\nNdek Wulangan",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: theme.textTheme.titleSmall)),
                                SizedBox(height: 44.v),
                                CustomImageView(
                                    imagePath: ImageConstant.imgFrame5,
                                    height: 149.v,
                                    width: 191.h),
                                SizedBox(height: 3.v)
                              ])),
                      SizedBox(height: 17.v),
                      Text("Kuis Bahasa Jawa",
                          style: theme.textTheme.titleMedium),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                              width: 270.h,
                              margin: EdgeInsets.only(top: 18.v, right: 22.h),
                              child: Text(
                                  "Uji Kemampuan Bahasa Jawamu dengan menjawab 15 soal pengetahuan bahasa Jawa. Silahkan klik tombol dibawah untuk mulai mengerjakan",
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.titleSmall))),
                      SizedBox(height: 20.v),
                      CustomElevatedButton(
                          onTap: () {
                            Navigator.pushNamed(context, AppRoutes.kuisTwoScreen);
                          },
                          text: "lanjut")
                    ]))));
  }

  /// Navigates back to the previous screen.
  ///
  /// This function takes a [BuildContext] object as a parameter, which is used
  /// to navigate back to the previous screen.
  onTapArrowleftone(BuildContext context) {
    Navigator.pop(context);
  }
}
