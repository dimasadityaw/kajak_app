import 'dart:convert';
import 'dart:developer';

import 'package:kajak/core/app_export.dart';
import 'package:kajak/widgets/app_bar/appbar_image.dart';
import 'package:kajak/widgets/app_bar/appbar_title.dart';
import 'package:kajak/widgets/app_bar/custom_app_bar.dart';
import 'package:kajak/widgets/custom_outlined_button.dart';
import 'package:kajak/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

// ignore_for_file: must_be_immutable
class HalamanParamasastraScreen extends StatefulWidget {
  HalamanParamasastraScreen({Key? key}) : super(key: key);

  @override
  _HalamanParamasastraScreenState createState() =>
      _HalamanParamasastraScreenState();
}

class _HalamanParamasastraScreenState extends State<HalamanParamasastraScreen> {
  TextEditingController searchController = TextEditingController();
  var user;
  var tembungData;
  var tembungDatas;
  bool isLoading = true;

  Future _getData() async {
    isLoading = true;
    SharedPreferences pref = await SharedPreferences.getInstance();
    user = json.decode(pref.getString("user")!);
    String token = user['token'];
    var apiResult = await http
        .get(Uri.parse('http://kaja.cemzpex.com/api/paramasastra'), headers: {
      "Accept": "Application/json",
      "Authorization": "Bearer $token"
    });
    var data = json.decode(apiResult.body);
    // log(data.toString());

    tembungData = data;

    tembungData.forEach((data) {
      data['is_open'] = false;
      if (data['child'].toString() != '[]') {
        data['child'].forEach((datas) {
          datas['is_open'] = false;
        });
      }
    });
    // log(arananData.toString());
    if (searchController.text == '') {
      tembungDatas = tembungData;
    }
    print('tembungDatas');
    log(tembungDatas.toString());
    isLoading = false;
    setState(() {});
  }

  void _onSearchChanged() {
    tembungDatas = tembungData.where((data) {
      if (data['name'] != null && searchController.text != null) {
        return data['name']
            .toString()
            .toLowerCase()
            .contains(searchController.text.toLowerCase());
      }
      return false;
    }).toList();
    setState(() {});
  }

  late FocusNode _focusNode;
  bool _isKeyboardOpen(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return !(mediaQuery.viewInsets.bottom == 0);
  }
  @override
  void initState() {
    searchController.addListener(_onSearchChanged);
    _getData();
    _focusNode = FocusNode();
    setState(() {});
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return SafeArea(
        child: GestureDetector(
          onTap: () {
            if (_focusNode.hasFocus) {
              _focusNode.unfocus();
            }
          },
          child: Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: CustomAppBar(
                  height: 49.v,
                  leadingWidth: 38.h,
                  leading: AppbarImage(
                      svgPath: ImageConstant.imgArrowleft,
                      margin: EdgeInsets.only(left: 13.h),
                      onTap: () {
                        onTapArrowleftone(context);
                      }),
                  centerTitle: true,
                  title: AppbarTitle(text: "Paramasastra")),
              body: (!isLoading)
                  ? SizedBox(
                      width: mediaQueryData.size.width,
                      child: Padding(
                          padding: EdgeInsets.only(
                              left: 25.h, right: 25.h, bottom: 5.v, top: 5.v),
                          child: Column(children: [
                            Container(
                                padding: EdgeInsets.symmetric(horizontal: 4.h),
                                decoration: AppDecoration.outlineBlack.copyWith(
                                    borderRadius:
                                        BorderRadiusStyle.roundedBorder10),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          width: 190.h,
                                          margin: EdgeInsets.only(
                                              top: 11.v, bottom: 53.v),
                                          child: Text(
                                              "Ayo belajar Paramasastra\n(Tetembungan) ngo ngampangake \nPanulisan lan Wicara",
                                              maxLines: 4,
                                              overflow: TextOverflow.ellipsis,
                                              style:
                                                  theme.textTheme.titleMedium)),
                                      CustomImageView(
                                          imagePath: ImageConstant.imgFrame3,
                                          height: 95.v,
                                          width: 99.h,
                                          margin: EdgeInsets.only(
                                              left: 18.h, top: 59.v))
                                    ])),
                            SizedBox(height: 27.v),
                            CustomTextFormField(
                                controller: searchController,
                                focusNode: _focusNode,
                                hintText: _isKeyboardOpen(context) ? '' : "Golek Opo ?",
                                textInputAction: TextInputAction.done,
                                suffix: Container(
                                    margin: EdgeInsets.fromLTRB(
                                        30.h, 10.v, 11.h, 11.v),
                                    child: CustomImageView(
                                        svgPath: ImageConstant.imgSearch)),
                                suffixConstraints:
                                    BoxConstraints(maxHeight: 43.v)),
                            SizedBox(height: 20.v),
                            (tembungDatas.length != 0)
                                ? Flexible(
                                    child: ListView.separated(
                                        shrinkWrap: true,
                                        separatorBuilder: (
                                          context,
                                          index,
                                        ) {
                                          return SizedBox(
                                            height: 10.v,
                                          );
                                        },
                                        itemCount: (tembungDatas != null)
                                            ? tembungDatas.length
                                            : 0,
                                        itemBuilder: (context, index) {
                                          return CustomOutlinedButton(
                                              onTap: () {
                                                Navigator.pushNamed(
                                                    context,
                                                    AppRoutes
                                                        .halamanParamasastraSubMenu,
                                                    arguments: AppRoutes(
                                                        id: 0,
                                                        obj:
                                                            tembungDatas[index]));
                                              },
                                              text:
                                                  "${tembungDatas[index]['name']}",
                                              buttonStyle: CustomButtonStyles
                                                  .outlineBlack);
                                        }),
                                  )
                                : Card(
                                    clipBehavior: Clip.antiAlias,
                                    elevation: 0,
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        color: appTheme.black900,
                                        width: 1.h,
                                      ),
                                      borderRadius:
                                          BorderRadiusStyle.roundedBorder10,
                                    ),
                                    child: Container(
                                      width: 330.h,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 1.h,
                                      ),
                                      decoration:
                                          AppDecoration.outlineBlack.copyWith(
                                        borderRadius:
                                            BorderRadiusStyle.roundedBorder10,
                                      ),
                                      child: Column(
                                        children: [
                                          SizedBox(height: 24.v),
                                          Align(
                                            alignment: Alignment.center,
                                            child: Container(
                                              // width: 201.h,
                                              margin: EdgeInsets.only(
                                                left: 17.h,
                                                top: 6.v,
                                              ),
                                              child: Text(
                                                "Nuwun sewu, Panulusuran mboten ditemukake.\nCoba Golek Koncie Liyane.",
                                                maxLines: 4,
                                                textAlign: TextAlign.center,
                                                overflow: TextOverflow.ellipsis,
                                                style:
                                                    theme.textTheme.titleMedium,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 12.v),
                                          CustomImageView(
                                            imagePath: ImageConstant.notFound,
                                          ),
                                          SizedBox(height: 24.v),
                                        ],
                                      ),
                                    ),
                                  ),
                            SizedBox(height: 16.v),
                          ]
                              //         Column(children: [
                              //         Container(
                              //         padding:
                              //         EdgeInsets.symmetric(horizontal: 4.h),
                              //     decoration: AppDecoration.outlineBlack
                              //         .copyWith(
                              //         borderRadius: BorderRadiusStyle
                              //             .roundedBorder10),
                              //     child: Row(
                              //         mainAxisAlignment: MainAxisAlignment.end,
                              //         crossAxisAlignment:
                              //         CrossAxisAlignment.start,
                              //         children: [
                              //           Container(
                              //               width: 190.h,
                              //               margin: EdgeInsets.only(
                              //                   top: 11.v, bottom: 53.v),
                              //               child: Text(
                              //                   "Ayo belajar Paramasastra\n(Tetembungan) ngo ngampangake \nPanulisan lan Wicara",
                              //                   maxLines: 4,
                              //                   overflow: TextOverflow.ellipsis,
                              //                   style: theme
                              //                       .textTheme.titleMedium)),
                              //           CustomImageView(
                              //               imagePath: ImageConstant.imgFrame3,
                              //               height: 95.v,
                              //               width: 99.h,
                              //               margin: EdgeInsets.only(
                              //                   left: 18.h, top: 59.v))
                              //         ])),
                              // SizedBox(height: 27.v),
                              // CustomTextFormField(
                              //     controller: searchController,
                              //     hintText: "Golek Opo ?",
                              //     textInputAction: TextInputAction.done,
                              //     suffix: Container(
                              //         margin: EdgeInsets.fromLTRB(
                              //             30.h, 10.v, 11.h, 11.v),
                              //         child: CustomImageView(
                              //             svgPath: ImageConstant.imgSearch)),
                              //     suffixConstraints:
                              //     BoxConstraints(maxHeight: 43.v)),
                              // SizedBox(height: 20.v),
                              // CustomOutlinedButton(
                              //     onTap: () {
                              //       Navigator.pushNamed(
                              //           context,
                              //           AppRoutes
                              //               .halamanParamasastraSubMenu);
                              //     },
                              //     text: "Tembung Lingga",
                              //     buttonStyle: CustomButtonStyles.outlineBlack),
                              // SizedBox(height: 16.v),
                              // CustomOutlinedButton(
                              //     onTap: () {
                              //       Navigator.pushNamed(
                              //           context,
                              //           AppRoutes
                              //               .halamanParamasastraSubMenuTembungAndhahanSeventeenScreen);
                              //     },
                              //     text: "Tembung Andhahan",
                              //     buttonStyle: CustomButtonStyles.outlineBlack),
                              // SizedBox(height: 16.v),
                              // CustomOutlinedButton(
                              //     onTap: () {
                              //       Navigator.pushNamed(
                              //           context,
                              //           AppRoutes
                              //               .halamanParamasastraSubMenuTembungAndhahanTwentysevenScreen);
                              //     },
                              //     text: "Tembung Rangkep",
                              //     buttonStyle: CustomButtonStyles.outlineBlack),
                              // SizedBox(height: 16.v),
                              // CustomOutlinedButton(
                              //     onTap: () {
                              //       Navigator.pushNamed(
                              //           context,
                              //           AppRoutes
                              //               .halamanParamasastraSubMenuTembungAndhahanTwentynineScreen);
                              //     },
                              //     text: "Tembung Camboran",
                              //     buttonStyle: CustomButtonStyles.outlineBlack),
                              // SizedBox(height: 16.v),
                              // CustomOutlinedButton(
                              //     onTap: () {
                              //       Navigator.pushNamed(
                              //           context,
                              //           AppRoutes
                              //               .halamanParamasastraSubMenuTembungAndhahanScreen);
                              //     },
                              //     text: "Tembung Tanduk",
                              //     buttonStyle: CustomButtonStyles.outlineBlack),
                              // SizedBox(height: 16.v),
                              // CustomOutlinedButton(
                              //     onTap: () {
                              //       Navigator.pushNamed(
                              //           context,
                              //           AppRoutes
                              //               .halamanParamasastraSubMenuTembungAndhahanTwentyeightScreen);
                              //     },
                              //     text: "Tembung Tanggap",
                              //     buttonStyle: CustomButtonStyles.outlineBlack),
                              // SizedBox(height: 16.v),
                              // CustomOutlinedButton(
                              //     onTap: () {
                              //       Navigator.pushNamed(
                              //           context,
                              //           AppRoutes
                              //               .halamanParamasastraSubMenuTembungLinggaOneScreen);
                              //     },
                              //     text: "Ayahane Tembung",
                              //     buttonStyle: CustomButtonStyles.outlineBlack),
                              // SizedBox(height: 16.v),
                              // CustomOutlinedButton(
                              //     onTap: () {
                              //       Navigator.pushNamed(
                              //           context,
                              //           AppRoutes
                              //               .halamanParamasastraSubMenuTembungAndhahanThirteenScreen);
                              //     },
                              //     text: "Silah-Silahing Tembung",
                              //     buttonStyle: CustomButtonStyles.outlineBlack),
                              // SizedBox(height: 16.v),
                              // CustomOutlinedButton(
                              //     onTap: () {
                              //       Navigator.pushNamed(
                              //           context,
                              //           AppRoutes
                              //               .halamanParamasastraSubMenuTembungAndhahanFourteenScreen);
                              //     },
                              //     text: "Silah-Silahing Ukara",
                              //     buttonStyle: CustomButtonStyles.outlineBlack)
                              // ]
                              )))
                  : Center(
                      child: Image.asset(
                        "assets/images/img_frame5.png",
                        width: MediaQuery.of(context).size.width / 1.4,
                        height: MediaQuery.of(context).size.width / 1.4,
                      ),
                    )),
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
