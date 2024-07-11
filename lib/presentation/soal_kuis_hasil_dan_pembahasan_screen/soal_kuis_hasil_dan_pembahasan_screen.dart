import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:kajak/ConnectivityService.dart';
import 'package:kajak/core/app_export.dart';
import 'package:kajak/database_helper/answers.dart';
import 'package:kajak/database_helper/current_answer.dart';
import 'package:kajak/database_helper/database_helper.dart';
import 'package:kajak/database_helper/exam_results.dart';
import 'package:kajak/database_helper/questions.dart';
import 'package:kajak/presentation/footer/footer.dart';
import 'package:kajak/widgets/app_bar/appbar_subtitle.dart';
import 'package:kajak/widgets/app_bar/appbar_subtitle_1.dart';
import 'package:kajak/widgets/app_bar/custom_app_bar.dart';
import 'package:kajak/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:skeletonizer/skeletonizer.dart';

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
  var penjelasan;
  int selectedId = 0;
  bool isLoading = true;
  int page = 1;

  Future _nilai() async {
    isLoading = true;
    if (isConnected) {
      SharedPreferences pref = await SharedPreferences.getInstance();
      user = json.decode(pref.getString("user")!);
      String token = user['token'];
      String attempt_id = user['attempt']['id'].toString();
      var apiResult = await http.put(
          Uri.parse(
              '${const String.fromEnvironment('apiUrl')}/exam/$attempt_id'),
          headers: {
            "Accept": "Application/json",
            "Authorization": "Bearer $token"
          });
      var data = json.decode(apiResult.body);
      nilai = data;

      _getSoal();
      setState(() {});
    } else {
      _getSoal();
    }
  }

  Future _getSoal() async {
    bool hasRun = false;

    ConnectivityService.connectivityStream.listen((status) async {
      if (!hasRun) {
        setState(() {
          hasRun = true;
          isConnected = status;
        });

        if (status) {
          SharedPreferences pref = await SharedPreferences.getInstance();
          user = json.decode(pref.getString("user")!);
          selectedId = 0;
          String token = user['token'];
          String attempt_id = user['attempt']['id'].toString();
          var apiResult = await http.get(
              Uri.parse(
                  '${const String.fromEnvironment('apiUrl')}/exam/$attempt_id/question?page=$page'),
              headers: {
                "Accept": "Application/json",
                "Authorization": "Bearer $token"
              });
          var data = json.decode(apiResult.body);

          var attempt_page = json.decode(pref.getString("user")!);
          attempt_page = await attempt_page['attempt']['id'].toString() +
              '_' +
              page.toString();

          await Questions().insertQuestionData(attempt_page, data['data']);
          await Answers().insertAnswerData(data['data']['answer']);
          if (data['data']['current_answer'] != null) {
            await CurrentAnswer().insertCurrentAnswerData(data['data']);
          }
          soal = data['data']['question'];
          jawaban = data['data']['answer'];
          penjelasan = data['data']['explanation'];

          selectedId = (data['data']['current_answer'] != null)
              ? data['data']['current_answer']['id']
              : 0;

          isLoading = false;
          setState(() {});
        } else {
          SharedPreferences pref = await SharedPreferences.getInstance();
          var attempt_page = json.decode(pref.getString("user")!);
          attempt_page = await attempt_page['attempt']['id'].toString() +
              '_' +
              page.toString();
          quiz = await Questions().getQuizData(attempt_page);
          Future.delayed(Duration(microseconds: 2500), () async {
            soal = quiz['data']['question'];
            jawaban = quiz['data']['answer'];
            penjelasan = quiz['data']['explanation'];

            selectedId = (quiz['data']['current_answer'] != null)
                ? quiz['data']['current_answer']['id']
                : 0;

            isLoading = false;
          });
          setState(() {});
        }
      }
    });
  }

  DateTime? currentBackPressTime;

  Future<bool> _handleBackButton() async {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.grey,
        behavior: SnackBarBehavior.floating,
        content: Text('Tekan sekali lagi untuk keluar.',
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.white, // Adjust color based on your theme
            )),
      ));
      // Fluttertoast.showToast(msg: 'Tekan kembali lagi untuk keluar');
      return Future.value(false);
    }
    // SystemNavigator.pop();
    Navigator.pushNamed(context, AppRoutes.halamanHomeScreen);
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    return Future.value(true);
  }

  var quiz = null;

  void getDataFromDatabase() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var attempt_page = json.decode(pref.getString("user")!);
    attempt_page =
        await attempt_page['attempt']['id'].toString() + '_' + page.toString();
    nilai = await ExamResults().getExamResultData(attempt_page.toString().replaceAll('_1', ''));
    quiz = await Questions().getQuizData(attempt_page);
  }

  StreamSubscription<bool>? _connectivitySubscription;
  bool isConnected = true;
  bool hasConnectedRun = false;

  @override
  void initState() {
    getDataFromDatabase();
    _connectivitySubscription =
        ConnectivityService.connectivityStream.listen((status) {
      setState(() {
        isConnected = status;
        if (!hasConnectedRun) {
          Future.delayed(Duration.zero, () {
            _nilai();
            hasConnectedRun = true;
          });
        }
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

    return WillPopScope(
      onWillPop: _handleBackButton,
      child: SafeArea(
        child: Scaffold(
          body: (isLoading && page == 1 && nilai == null && quiz == null)
              ? Center(
                  child: Image.asset(
                    "assets/images/img_frame1_86x136.png",
                    width: MediaQuery.of(context).size.width / 1.2,
                    height: MediaQuery.of(context).size.width / 1.2,
                  ),
                )
              : Center(
                  child: SizedBox(
                    width: 380.h,
                    child: Column(
                      children: [
                        Container(
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14.0),
                                child: CustomAppBar(
                                  height: 20.v,
                                  title: (isLoading && page == 1)
                                      ? Skeletonizer(
                                    child: Container(
                                      child: LayoutBuilder(
                                        builder:
                                            (BuildContext context,
                                            BoxConstraints
                                            constraints) {
                                          return ClipRRect(
                                            borderRadius:
                                            BorderRadius.circular(
                                                10),
                                            child: Skeleton.replace(
                                              width: 100.h,
                                              height: theme
                                                  .textTheme
                                                  .titleMedium
                                                  ?.fontSize!,
                                              child: SizedBox(),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ) : AppbarSubtitle1(
                                    text: "${nilai['message']}",
                                    // margin: EdgeInsets.only(left: 43.h),
                                  ),
                                  actions: [
                                    (isLoading && page == 1)
                                        ? Skeletonizer(
                                      child: Container(
                                        child: LayoutBuilder(
                                          builder:
                                              (BuildContext context,
                                              BoxConstraints
                                              constraints) {
                                            return ClipRRect(
                                              borderRadius:
                                              BorderRadius.circular(
                                                  10),
                                              child: Skeleton.replace(
                                                width: 50.h,
                                                height: theme
                                                    .textTheme
                                                    .titleMedium
                                                    ?.fontSize!,
                                                child: SizedBox(),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ) : AppbarSubtitle(
                                      // text: "Akredasi :",
                                      text:
                                          "Nilai : ${double.parse(nilai['attempt']['score'].toString()).toStringAsFixed(2)}",
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
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Ayo Dibahas",
                                            style: CustomTextStyles
                                                .titleSmallExtraBold,
                                          ),
                                        ),
                                        (selectedId == 0 && !isLoading) ? Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            "Dereng dijawab",
                                            style: CustomTextStyles
                                                .titleSmallExtraBold.copyWith(
                                              color: Colors.red, // Adjust color based on your theme
                                            ),
                                          ),
                                        ) : SizedBox(),
                                      ],
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
                                          style: CustomTextStyles
                                              .titleMediumExtraBold,
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: (isLoading && page == 1)
                                          ? Skeletonizer(
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                  left: 14.h,
                                                  top: 10.v,
                                                  right: 14.h,
                                                ),
                                                child: LayoutBuilder(
                                                  builder:
                                                      (BuildContext context,
                                                          BoxConstraints
                                                              constraints) {
                                                    return ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      child: Skeleton.replace(
                                                        width: 287.h,
                                                        height: theme
                                                            .textTheme
                                                            .titleMedium
                                                            ?.fontSize!,
                                                        child: SizedBox(),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            )
                                          : Skeletonizer(
                                              enabled: isLoading,
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
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: theme
                                                      .textTheme.titleMedium,
                                                ),
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
                                              : 4,
                                          itemBuilder: (context, index) {
                                            return isLoading
                                                ? Skeletonizer(
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                        horizontal: 15.h,
                                                        vertical: 11.v,
                                                      ),
                                                      child: LayoutBuilder(
                                                        builder: (BuildContext
                                                                context,
                                                            BoxConstraints
                                                                constraints) {
                                                          return ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            child: Skeleton
                                                                .replace(
                                                              width: constraints
                                                                  .maxWidth,
                                                              height:
                                                                  25.adaptSize,
                                                              child: SizedBox(),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  )
                                                : Column(
                                                    children: [
                                                      Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                          horizontal: 15.h,
                                                          vertical: 11.v,
                                                        ),
                                                        decoration: (selectedId ==
                                                                    jawaban[index][
                                                                        'id'] &&
                                                                jawaban[index]['is_correct'].toString() ==
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
                                                                            BorderRadiusStyle.roundedBorder10,
                                                                      )
                                                                    : AppDecoration
                                                                        .fillOnSecondaryContainer
                                                                        .copyWith(
                                                                        borderRadius:
                                                                            BorderRadiusStyle.roundedBorder10,
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
                                                                            BorderRadius.circular(
                                                                          12.h,
                                                                        ),
                                                                        border:
                                                                            Border.all(
                                                                          color:
                                                                              appTheme.black900,
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
                                                                        left: 16
                                                                            .h),
                                                                child: Text(
                                                                  jawaban[index]
                                                                          [
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
                                                  );
                                          },
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: 14.h, top: 10.v, right: 14.h),
                                        child: Text(
                                          "Penjelasan",
                                          style: CustomTextStyles
                                              .titleMediumOnPrimary,
                                        ),
                                      ),
                                    ),
                                    (isLoading && page == 1)
                                        ? Skeletonizer(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 15.h,
                                                  vertical: 6.v),
                                              child: LayoutBuilder(
                                                builder: (BuildContext context,
                                                    BoxConstraints
                                                        constraints) {
                                                  return ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: Skeleton.replace(
                                                      width:
                                                          constraints.maxWidth,
                                                      height: CustomTextStyles
                                                          .titleMediumSemiBold2
                                                          .fontSize!,
                                                      child: SizedBox(),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          )
                                        : Skeletonizer(
                                            enabled: isLoading,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 15.h,
                                                vertical: 6.v,
                                              ),
                                              child: Container(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  penjelasan,
                                                  style: CustomTextStyles
                                                      .titleMediumSemiBold2,
                                                ),
                                              ),
                                            ),
                                          ),
                                    (!isLoading)
                                        ? (page == 1)
                                            ? Semantics(
                                                excludeSemantics: true,
                                                child: CustomElevatedButton(
                                                  onTap: () async {
                                                    SharedPreferences pref =
                                                        await SharedPreferences
                                                            .getInstance();
                                                    var attempt_page = json
                                                        .decode(pref.getString(
                                                            "user")!);
                                                    attempt_page =
                                                        await attempt_page[
                                                                        'attempt']
                                                                    ['id']
                                                                .toString() +
                                                            '_' +
                                                            (page + 1)
                                                                .toString();
                                                    var nextQuiz = null;
                                                    if (page < 15) {
                                                      nextQuiz =
                                                      await Questions()
                                                          .getQuizData(
                                                          (attempt_page));
                                                    }
                                                    if ((nextQuiz != null &&
                                                        !isConnected) ||
                                                        (nextQuiz != null &&
                                                            isConnected) ||
                                                        (nextQuiz == null &&
                                                            isConnected)) {
                                                      isLoading = true;
                                                      page = page + 1;
                                                      _getSoal();
                                                      setState(() {});
                                                    } else {
                                                      ScaffoldMessenger.of(
                                                          context)
                                                          .showSnackBar(
                                                          SnackBar(
                                                            backgroundColor:
                                                            Colors.red,
                                                            behavior:
                                                            SnackBarBehavior
                                                                .floating,
                                                            content: Text(
                                                                'Periksa kembali jaringan anda.',
                                                                style: theme
                                                                    .textTheme
                                                                    .titleMedium
                                                                    ?.copyWith(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w600)),
                                                          ));
                                                    }
                                                  },
                                                  // isDisabled: (selectedId == 0)
                                                  //     ? true
                                                  //     : false,
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
                                                        Navigator.pushNamed(
                                                            context,
                                                            AppRoutes
                                                                .halamanHomeScreen);
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
                                                              isLoading = true;
                                                              page = page - 1;
                                                              _getSoal();
                                                              setState(() {});
                                                            },
                                                            // isDisabled:
                                                            //     (selectedId ==
                                                            //             0)
                                                            //         ? true
                                                            //         : false,
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                3,
                                                            text: "Sebelumnya",
                                                            margin:
                                                                EdgeInsets.only(
                                                              left: 6.h,
                                                              top: 16.v,
                                                              bottom: 5.v,
                                                            ),
                                                          ),
                                                          CustomElevatedButton(
                                                            onTap: () async {
                                                              SharedPreferences
                                                                  pref =
                                                                  await SharedPreferences
                                                                      .getInstance();
                                                              var attempt_page =
                                                                  json.decode(pref
                                                                      .getString(
                                                                          "user")!);
                                                              attempt_page = await attempt_page[
                                                                              'attempt']
                                                                          ['id']
                                                                      .toString() +
                                                                  '_' +
                                                                  (page + 1)
                                                                      .toString();
                                                              var nextQuiz =
                                                                  null;
                                                              if (page < 15) {
                                                                nextQuiz = await Questions()
                                                                    .getQuizData(
                                                                    (attempt_page));
                                                              }
                                                              if ((nextQuiz != null && !isConnected) ||
                                                                  (nextQuiz !=
                                                                      null &&
                                                                      isConnected) ||
                                                                  (nextQuiz ==
                                                                      null &&
                                                                      isConnected)) {
                                                                isLoading =
                                                                true;
                                                                page =
                                                                    page + 1;
                                                                _getSoal();
                                                                setState(
                                                                        () {});
                                                              } else {
                                                                ScaffoldMessenger.of(
                                                                    context)
                                                                    .showSnackBar(
                                                                    SnackBar(
                                                                      backgroundColor:
                                                                      Colors
                                                                          .red,
                                                                      behavior:
                                                                      SnackBarBehavior
                                                                          .floating,
                                                                      content: Text(
                                                                          'Periksa kembali jaringan anda.',
                                                                          style: theme
                                                                              .textTheme
                                                                              .titleMedium
                                                                              ?.copyWith(
                                                                              color: Colors.white,
                                                                              fontWeight: FontWeight.w600)),
                                                                    ));
                                                              }
                                                            },
                                                            // isDisabled:
                                                            //     (selectedId ==
                                                            //             0)
                                                            //         ? true
                                                            //         : false,
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                3,
                                                            text: "Berikutnya",
                                                            margin:
                                                                EdgeInsets.only(
                                                              left: 6.h,
                                                              top: 16.v,
                                                              bottom: 5.v,
                                                            ),
                                                          )
                                                        ]),
                                                  )
                                        : SizedBox(),
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
                ),
          bottomNavigationBar: !isConnected
              ? Container(
                  color: Colors.red,
                  padding: EdgeInsets.symmetric(vertical: 2.5.h),
                  child: FooterMenu())
              : SizedBox(),
        ),
      ),
    );
  }
}
