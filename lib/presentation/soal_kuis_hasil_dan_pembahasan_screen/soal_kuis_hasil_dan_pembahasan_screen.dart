import 'dart:convert';

// import 'package:fluttertoast/fluttertoast.dart';
import 'package:kajak/core/app_export.dart';
import 'package:kajak/widgets/app_bar/appbar_subtitle.dart';
import 'package:kajak/widgets/app_bar/appbar_subtitle_1.dart';
import 'package:kajak/widgets/app_bar/custom_app_bar.dart';
import 'package:kajak/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SoalKuisHasilDanPembahasanScreen extends StatefulWidget {
  SoalKuisHasilDanPembahasanScreen({Key? key}) : super(key: key);

  @override
  _SoalKuisHasilDanPembahasanScreenState createState() =>
      _SoalKuisHasilDanPembahasanScreenState();
}

class _SoalKuisHasilDanPembahasanScreenState
    extends State<SoalKuisHasilDanPembahasanScreen> {
  var user;
  var nilai;
  var soal;
  var jawaban;
  int selectedId = 0;
  bool isLoading = true;
  int page = 1;

  Future _nilai() async {
    isLoading = true;
    SharedPreferences pref = await SharedPreferences.getInstance();
    user = json.decode(pref.getString("user")!);
    String token = user['token'];
    String attempt_id = user['attempt']['id'].toString();
    var apiResult = await http.put(
        Uri.parse('http://kaja.cemzpex.com/api/exam/$attempt_id'),
        headers: {
          "Accept": "Application/json",
          "Authorization": "Bearer $token"
        });
    var data = json.decode(apiResult.body);
    print(data);
    nilai = data;

    _getSoal();
    setState(() {});
  }

  Future _getSoal() async {
    isLoading = true;
    SharedPreferences pref = await SharedPreferences.getInstance();
    user = json.decode(pref.getString("user")!);
    // print(user);
    selectedId = 0;
    String token = user['token'];
    String attempt_id = user['attempt']['id'].toString();
    var apiResult = await http.get(
        Uri.parse(
            'http://kaja.cemzpex.com/api/exam/$attempt_id/question?page=$page'),
        headers: {
          "Accept": "Application/json",
          "Authorization": "Bearer $token"
        });
    var data = json.decode(apiResult.body);
    print("data['data']");
    print(data['data']);

    soal = data['data']['question'];
    jawaban = data['data']['answer'];

    selectedId = (data['data']['current_answer'] != null)
        ? data['data']['current_answer']['id']
        : 0;

    isLoading = false;
    setState(() {});
  }

  DateTime? currentBackPressTime;

  Future<bool> _handleBackButton() async {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      // Fluttertoast.showToast(msg: 'Tekan kembali lagi untuk keluar');
      return Future.value(false);
    }
    // SystemNavigator.pop();
    Navigator.pushNamed(context, AppRoutes.halamanHomeScreen);
    return Future.value(true);
  }

  @override
  void initState() {
    _nilai();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);

    return WillPopScope(
      onWillPop: _handleBackButton,
      child: SafeArea(
        child: Scaffold(
          body: (!isLoading)
              ? Center(
                  child: SizedBox(
                    width: 380.h,
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _nilai();
                          },
                          child: Container(
                            width: 340.h,
                            margin: EdgeInsets.only(
                              left: 20.h,
                              top: 20.v,
                              right: 20.h,
                            ),
                            padding: EdgeInsets.symmetric(vertical: 17.v),
                            decoration: AppDecoration.outlineBlack900,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                                  child: CustomAppBar(
                                    height: 20.v,
                                    title: AppbarSubtitle1(
                                      text: "${nilai['message']}",
                                      // margin: EdgeInsets.only(left: 43.h),
                                    ),
                                    actions: [
                                      AppbarSubtitle(
                                        // text: "Akredasi :",
                                        text:
                                            "Nilai : ${double.parse(nilai['attempt']['score']).toStringAsFixed(2)}",
                                        // margin: EdgeInsets.symmetric(
                                        //     horizontal: 53.h),
                                      ),
                                    ],
                                  ),
                                ),
                                // Padding(
                                //   padding: EdgeInsets.only(
                                //     top: 22.v,
                                //     right: 43.h,
                                //     bottom: 23.v,
                                //   ),
                                //   child: Text(
                                //     "A/B/C/D",
                                //     style: theme.textTheme.titleSmall,
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 19.v),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Container(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: 20.h,
                                  right: 20.h,
                                  bottom: 5.v,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Ayo Dibahas",
                                        style: CustomTextStyles
                                            .titleSmallExtraBold,
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          left: 14.h,
                                          top: 8.v,
                                          right: 14.h,
                                        ),
                                        child: Text(
                                          "Soal No $page",
                                          style: CustomTextStyles.titleMediumExtraBold,
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Container(
                                        width: 287.h,
                                        margin: EdgeInsets.only(
                                          left: 14.h,
                                          top: 10.v,
                                          right: 14.h,
                                        ),
                                        child: Text(
                                          (soal != null)
                                              ? soal['question']
                                              : '',
                                          maxLines: 99,
                                          overflow: TextOverflow.ellipsis,
                                          style: theme.textTheme.titleMedium,
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: 14.h, top: 10.v, right: 14.h),
                                        child: Text(
                                          "Jawaban",
                                          style: CustomTextStyles
                                              .titleMediumOnPrimary,
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child: Container(
                                        margin: EdgeInsets.only(
                                          // left: 14.h,
                                          top: 10.v,
                                          // right: 14.h,
                                        ),
                                        child: ListView.separated(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          separatorBuilder: (
                                            context,
                                            index,
                                          ) {
                                            return SizedBox(
                                              height: 10.v,
                                            );
                                          },
                                          itemCount: (jawaban != null)
                                              ? jawaban.length
                                              : 0,
                                          itemBuilder: (context, index) {
                                            return GestureDetector(
                                              onTap: () async {
                                                setState(() {
                                                  // selectedId = (selectedId ==
                                                  //         jawaban[index]
                                                  //             ['id'])
                                                  //     ? jawaban[index]['id']
                                                  //     : jawaban[index]['id'];
                                                });
                                              },
                                              child: Column(
                                                children: [
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal: 15.h,
                                                      vertical: 11.v,
                                                    ),
                                                    decoration: (selectedId ==
                                                                jawaban[index]
                                                                    ['id'] &&
                                                            jawaban[index]['is_correct']
                                                                    .toString() ==
                                                                '1')
                                                        ? AppDecoration
                                                            .fillLightGreen
                                                            .copyWith(
                                                            borderRadius:
                                                                BorderRadiusStyle
                                                                    .roundedBorder10,
                                                          )
                                                        //     : AppDecoration.fillOrange
                                                        //     .copyWith(
                                                        //   borderRadius:
                                                        //   BorderRadiusStyle
                                                        //       .roundedBorder10,
                                                        // )
                                                        : (selectedId != jawaban[index]['id'] &&
                                                                jawaban[index]['is_correct'].toString() ==
                                                                    '1')
                                                            ? AppDecoration
                                                                .fillLightGreen
                                                                .copyWith(
                                                                borderRadius:
                                                                    BorderRadiusStyle
                                                                        .roundedBorder10,
                                                              )
                                                            : (selectedId == jawaban[index]['id'] &&
                                                                    jawaban[index]['is_correct'].toString() !=
                                                                        '1')
                                                                ? AppDecoration
                                                                    .fillOrange
                                                                    .copyWith(
                                                                    borderRadius:
                                                                        BorderRadiusStyle
                                                                            .roundedBorder10,
                                                                  )
                                                                : AppDecoration
                                                                    .fillOnSecondaryContainer
                                                                    .copyWith(
                                                                    borderRadius:
                                                                        BorderRadiusStyle
                                                                            .roundedBorder10,
                                                                  ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          child: Stack(
                                                            alignment:
                                                                Alignment
                                                                    .topCenter,
                                                            children: [
                                                              Align(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child:
                                                                    Container(
                                                                  height: 25
                                                                      .adaptSize,
                                                                  width: 25
                                                                      .adaptSize,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                      12.h,
                                                                    ),
                                                                    border:
                                                                        Border
                                                                            .all(
                                                                      color: appTheme
                                                                          .black900,
                                                                      width:
                                                                          2.h,
                                                                      strokeAlign:
                                                                          strokeAlignOutside,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Align(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Text(
                                                                  String.fromCharCode(
                                                                      index +
                                                                          65),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: CustomTextStyles
                                                                      .titleMediumExtraBold,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Padding(
                                                            padding: EdgeInsets
                                                                .only(
                                                                    left:
                                                                        16.h),
                                                            child: Text(
                                                              jawaban[index][
                                                                      'answer']
                                                                  .toString(),
                                                              maxLines: 99,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: CustomTextStyles
                                                                  .titleSmallBold,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  (jawaban[index]['is_correct']
                                                              .toString() ==
                                                          '1')
                                                      ? Center(
                                                          child: Text(
                                                            "Iki seng bener...",
                                                            style: CustomTextStyles
                                                                .titleSmallBold,
                                                          ),
                                                        )
                                                      : Container(),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    // Container(
                                    //   margin: EdgeInsets.only(
                                    //     left: 29.h,
                                    //     top: 25.v,
                                    //     right: 1.h,
                                    //   ),
                                    //   padding: EdgeInsets.symmetric(
                                    //     horizontal: 15.h,
                                    //     vertical: 11.v,
                                    //   ),
                                    //   decoration: AppDecoration.fillOrange.copyWith(
                                    //     borderRadius: BorderRadiusStyle.roundedBorder10,
                                    //   ),
                                    //   child: Row(
                                    //     mainAxisAlignment: MainAxisAlignment.center,
                                    //     crossAxisAlignment: CrossAxisAlignment.start,
                                    //     mainAxisSize: MainAxisSize.min,
                                    //     children: [
                                    //       Container(
                                    //         height: 25.adaptSize,
                                    //         width: 25.adaptSize,
                                    //         margin: EdgeInsets.only(
                                    //           top: 1.v,
                                    //           bottom: 50.v,
                                    //         ),
                                    //         child: Stack(
                                    //           alignment: Alignment.topCenter,
                                    //           children: [
                                    //             Align(
                                    //               alignment: Alignment.center,
                                    //               child: Container(
                                    //                 height: 25.adaptSize,
                                    //                 width: 25.adaptSize,
                                    //                 decoration: BoxDecoration(
                                    //                   borderRadius: BorderRadius.circular(
                                    //                     12.h,
                                    //                   ),
                                    //                   border: Border.all(
                                    //                     color: appTheme.black900,
                                    //                     width: 2.h,
                                    //                     strokeAlign: strokeAlignOutside,
                                    //                   ),
                                    //                 ),
                                    //               ),
                                    //             ),
                                    //             Align(
                                    //               alignment: Alignment.topCenter,
                                    //               child: Text(
                                    //                 "A",
                                    //                 style: CustomTextStyles
                                    //                     .titleMediumExtraBold,
                                    //               ),
                                    //             ),
                                    //           ],
                                    //         ),
                                    //       ),
                                    //       Expanded(
                                    //         child: Container(
                                    //           width: 216.h,
                                    //           margin: EdgeInsets.only(
                                    //             left: 16.h,
                                    //             right: 4.h,
                                    //           ),
                                    //           child: Text(
                                    //             "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. ",
                                    //             maxLines: 4,
                                    //             overflow: TextOverflow.ellipsis,
                                    //             style: CustomTextStyles.titleSmallBold,
                                    //           ),
                                    //         ),
                                    //       ),
                                    //     ],
                                    //   ),
                                    // ),
                                    // Container(
                                    //   margin: EdgeInsets.only(
                                    //     left: 29.h,
                                    //     top: 26.v,
                                    //     right: 1.h,
                                    //   ),
                                    //   padding: EdgeInsets.symmetric(
                                    //     horizontal: 15.h,
                                    //     vertical: 9.v,
                                    //   ),
                                    //   decoration: AppDecoration.fillLightGreen.copyWith(
                                    //     borderRadius: BorderRadiusStyle.roundedBorder10,
                                    //   ),
                                    //   child: Row(
                                    //     crossAxisAlignment: CrossAxisAlignment.start,
                                    //     mainAxisSize: MainAxisSize.min,
                                    //     children: [
                                    //       Container(
                                    //         height: 25.adaptSize,
                                    //         width: 25.adaptSize,
                                    //         margin: EdgeInsets.only(
                                    //           top: 7.v,
                                    //           bottom: 45.v,
                                    //         ),
                                    //         child: Stack(
                                    //           alignment: Alignment.topCenter,
                                    //           children: [
                                    //             Align(
                                    //               alignment: Alignment.center,
                                    //               child: Container(
                                    //                 height: 25.adaptSize,
                                    //                 width: 25.adaptSize,
                                    //                 decoration: BoxDecoration(
                                    //                   borderRadius: BorderRadius.circular(
                                    //                     12.h,
                                    //                   ),
                                    //                   border: Border.all(
                                    //                     color: appTheme.black900,
                                    //                     width: 1.h,
                                    //                     strokeAlign: strokeAlignOutside,
                                    //                   ),
                                    //                 ),
                                    //               ),
                                    //             ),
                                    //             Align(
                                    //               alignment: Alignment.topCenter,
                                    //               child: Text(
                                    //                 "B",
                                    //                 style: CustomTextStyles
                                    //                     .titleMediumSemiBold,
                                    //               ),
                                    //             ),
                                    //           ],
                                    //         ),
                                    //       ),
                                    //       Expanded(
                                    //         child: Container(
                                    //           width: 209.h,
                                    //           margin: EdgeInsets.only(
                                    //             left: 14.h,
                                    //             right: 13.h,
                                    //             bottom: 1.v,
                                    //           ),
                                    //           child: Text(
                                    //             "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. ",
                                    //             maxLines: 4,
                                    //             overflow: TextOverflow.ellipsis,
                                    //             style: theme.textTheme.titleSmall,
                                    //           ),
                                    //         ),
                                    //       ),
                                    //     ],
                                    //   ),
                                    // ),
                                    // Padding(
                                    //   padding: EdgeInsets.only(right: 86.h),
                                    //   child: Text(
                                    //     "Iki seng bener....",
                                    //     style: CustomTextStyles.titleSmallBold,
                                    //   ),
                                    // ),
                                    // Container(
                                    //   margin: EdgeInsets.only(
                                    //     left: 29.h,
                                    //     top: 5.v,
                                    //     right: 1.h,
                                    //   ),
                                    //   padding: EdgeInsets.symmetric(
                                    //     horizontal: 15.h,
                                    //     vertical: 9.v,
                                    //   ),
                                    //   decoration:
                                    //       AppDecoration.fillOnSecondaryContainer.copyWith(
                                    //     borderRadius: BorderRadiusStyle.roundedBorder10,
                                    //   ),
                                    //   child: Row(
                                    //     crossAxisAlignment: CrossAxisAlignment.start,
                                    //     mainAxisSize: MainAxisSize.min,
                                    //     children: [
                                    //       Container(
                                    //         height: 25.adaptSize,
                                    //         width: 25.adaptSize,
                                    //         margin: EdgeInsets.only(
                                    //           top: 7.v,
                                    //           bottom: 45.v,
                                    //         ),
                                    //         child: Stack(
                                    //           alignment: Alignment.topCenter,
                                    //           children: [
                                    //             Align(
                                    //               alignment: Alignment.center,
                                    //               child: Container(
                                    //                 height: 25.adaptSize,
                                    //                 width: 25.adaptSize,
                                    //                 decoration: BoxDecoration(
                                    //                   borderRadius: BorderRadius.circular(
                                    //                     12.h,
                                    //                   ),
                                    //                   border: Border.all(
                                    //                     color: appTheme.black900,
                                    //                     width: 1.h,
                                    //                     strokeAlign: strokeAlignOutside,
                                    //                   ),
                                    //                 ),
                                    //               ),
                                    //             ),
                                    //             Align(
                                    //               alignment: Alignment.topCenter,
                                    //               child: Text(
                                    //                 "C",
                                    //                 style: CustomTextStyles
                                    //                     .titleMediumSemiBold,
                                    //               ),
                                    //             ),
                                    //           ],
                                    //         ),
                                    //       ),
                                    //       Expanded(
                                    //         child: Container(
                                    //           width: 209.h,
                                    //           margin: EdgeInsets.only(
                                    //             left: 14.h,
                                    //             right: 13.h,
                                    //             bottom: 1.v,
                                    //           ),
                                    //           child: Text(
                                    //             "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. ",
                                    //             maxLines: 4,
                                    //             overflow: TextOverflow.ellipsis,
                                    //             style: theme.textTheme.titleSmall,
                                    //           ),
                                    //         ),
                                    //       ),
                                    //     ],
                                    //   ),
                                    // ),
                                    // Container(
                                    //   margin: EdgeInsets.only(
                                    //     left: 29.h,
                                    //     top: 10.v,
                                    //     right: 1.h,
                                    //   ),
                                    //   padding: EdgeInsets.symmetric(
                                    //     horizontal: 15.h,
                                    //     vertical: 9.v,
                                    //   ),
                                    //   decoration:
                                    //       AppDecoration.fillOnSecondaryContainer.copyWith(
                                    //     borderRadius: BorderRadiusStyle.roundedBorder10,
                                    //   ),
                                    //   child: Row(
                                    //     crossAxisAlignment: CrossAxisAlignment.start,
                                    //     mainAxisSize: MainAxisSize.min,
                                    //     children: [
                                    //       Container(
                                    //         height: 25.adaptSize,
                                    //         width: 25.adaptSize,
                                    //         margin: EdgeInsets.only(
                                    //           top: 7.v,
                                    //           bottom: 45.v,
                                    //         ),
                                    //         child: Stack(
                                    //           alignment: Alignment.topCenter,
                                    //           children: [
                                    //             Align(
                                    //               alignment: Alignment.center,
                                    //               child: Container(
                                    //                 height: 25.adaptSize,
                                    //                 width: 25.adaptSize,
                                    //                 decoration: BoxDecoration(
                                    //                   borderRadius: BorderRadius.circular(
                                    //                     12.h,
                                    //                   ),
                                    //                   border: Border.all(
                                    //                     color: appTheme.black900,
                                    //                     width: 1.h,
                                    //                     strokeAlign: strokeAlignOutside,
                                    //                   ),
                                    //                 ),
                                    //               ),
                                    //             ),
                                    //             Align(
                                    //               alignment: Alignment.topCenter,
                                    //               child: Text(
                                    //                 "D",
                                    //                 style: CustomTextStyles
                                    //                     .titleMediumSemiBold,
                                    //               ),
                                    //             ),
                                    //           ],
                                    //         ),
                                    //       ),
                                    //       Expanded(
                                    //         child: Container(
                                    //           width: 209.h,
                                    //           margin: EdgeInsets.only(
                                    //             left: 14.h,
                                    //             right: 13.h,
                                    //             bottom: 1.v,
                                    //           ),
                                    //           child: Text(
                                    //             "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. ",
                                    //             maxLines: 4,
                                    //             overflow: TextOverflow.ellipsis,
                                    //             style: theme.textTheme.titleSmall,
                                    //           ),
                                    //         ),
                                    //       ),
                                    //     ],
                                    //   ),
                                    // ),
                                    (page == 1)
                                        ? Semantics(
                                            excludeSemantics: true,
                                            child: CustomElevatedButton(
                                              onTap: () async {
                                                if (selectedId != 0) {
                                                  page = page + 1;
                                                  _getSoal();
                                                  setState(() {});
                                                }
                                              },
                                              isDisabled: (selectedId == 0)
                                                  ? true
                                                  : false,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              text: "Berikutnya",
                                              margin: EdgeInsets.only(
                                                left: 6.h,
                                                top: 16.v,
                                                bottom: 5.v,
                                              ),
                                            ),
                                          )
                                        : (page == 15)
                                            ? CustomElevatedButton(
                                                onTap: () async {
                                                  setState(() {
                                                    Navigator.pushNamed(context, AppRoutes.halamanHomeScreen);
                                                  });
                                                },
                                                text: "Kembali Ke Home",
                                                margin: EdgeInsets.only(
                                                  // left: 29.h,
                                                  top: 26.v,
                                                ),
                                              )
                                            : Semantics(
                                                excludeSemantics: true,
                                                child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      CustomElevatedButton(
                                                        onTap: () async {
                                                          page = page - 1;
                                                          _getSoal();
                                                          setState(() {});
                                                        },
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            3,
                                                        text: "Sebelumnya",
                                                        margin: EdgeInsets.only(
                                                          left: 6.h,
                                                          top: 16.v,
                                                          bottom: 5.v,
                                                        ),
                                                      ),
                                                      CustomElevatedButton(
                                                        onTap: () async {
                                                          if (selectedId != 0) {
                                                            page = page + 1;
                                                            _getSoal();
                                                            setState(() {});
                                                          }
                                                        },
                                                        isDisabled:
                                                            (selectedId == 0)
                                                                ? true
                                                                : false,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            3,
                                                        text: "Berikutnya",
                                                        margin: EdgeInsets.only(
                                                          left: 6.h,
                                                          top: 16.v,
                                                          bottom: 5.v,
                                                        ),
                                                      )
                                                    ]),
                                              ),
                                    // CustomElevatedButton(
                                    //   text: "Kembali Ke Home",
                                    //   margin: EdgeInsets.only(
                                    //     // left: 29.h,
                                    //     top: 26.v,
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Center(
                  child: Image.asset(
                    "assets/images/img_frame1_86x136.png",
                    width: MediaQuery.of(context).size.width / 1.2,
                    height: MediaQuery.of(context).size.width / 1.2,
                  ),
                ),
        ),
      ),
    );
  }
}
