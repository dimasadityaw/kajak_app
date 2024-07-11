import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:kajak/ConnectivityService.dart';
import 'package:kajak/database_helper/answers.dart';
import 'package:kajak/database_helper/current_answer.dart';
import 'package:kajak/database_helper/database_helper.dart';
import 'package:kajak/database_helper/questions.dart';
import 'package:kajak/database_helper/send_answer.dart';
import 'package:kajak/presentation/footer/footer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:kajak/core/app_export.dart';
import 'package:kajak/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:skeletonizer/skeletonizer.dart';

class SoalKuisScreen extends StatefulWidget {
  SoalKuisScreen({Key? key}) : super(key: key);

  @override
  _SoalKuisScreenState createState() => _SoalKuisScreenState();
}

class _SoalKuisScreenState extends State<SoalKuisScreen> {
  @override
  var user;
  var soal;
  var jawaban;
  var temporary_answer = null;
  bool isLoading = true;
  int page = 1;
  int selectedId = 0;

  Future _getSoal() async {
    bool hasRun = false;
    if (temporary_answer != null) {
      var datas = {'question': soal, 'current_answer': temporary_answer};
      await CurrentAnswer().insertCurrentAnswerData(datas);

      temporary_answer = null;
    }
    setState(() {
      isLoading = true;
    });

    ConnectivityService.connectivityStream.listen((status) async {
      if (!hasRun) {
        setState(() {
          hasRun = true;
          isConnected = status;
        });

        if (status) {
          selectedId = 0;
          SharedPreferences pref = await SharedPreferences.getInstance();
          user = json.decode(pref.getString("user")!);
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

          soal = data['data']['question'];
          jawaban = data['data']['answer'];

          selectedId = (data['data']['current_answer'] != null)
              ? data['data']['current_answer']['id']
              : 0;

          if (data?['data']?['current_answer'] == null) {
            // SharedPreferences pref = await SharedPreferences.getInstance();
            // var attempt_page = json.decode(pref.getString("user")!);
            // attempt_page = await attempt_page['attempt']['id'].toString() +
            //     '_' +
            //     page.toString();
            quiz = await Questions().getQuizData(attempt_page);

            selectedId = (quiz['data']['current_answer'] != null)
                ? quiz['data']['current_answer']['id']
                : 0;
          } else {
            await CurrentAnswer().insertCurrentAnswerData(data['data']);
          }

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

  Future _simpanJawaban() async {
    bool hasRun = false;
    setState(() {
      isLoading = true;
    });

    ConnectivityService.connectivityStream.listen((status) async {
      if (!hasRun) {
        setState(() {
          hasRun = true;
          isConnected = status;
        });

        if (status) {
          SharedPreferences pref = await SharedPreferences.getInstance();
          user = json.decode(pref.getString("user")!);
          String token = user['token'];
          String attempt_id = user['attempt']['id'].toString();
          var apiResult = await http.post(
              Uri.parse(
                  '${const String.fromEnvironment('apiUrl')}/exam/$attempt_id/question'),
              body: {
                'question_id': soal['id'].toString(),
                'answer_id': selectedId.toString(),
                'attempt_id': attempt_id.toString()
              },
              headers: {
                "Accept": "Application/json",
                "Authorization": "Bearer $token"
              });
          var data = json.decode(apiResult.body);

          user = json.decode(pref.getString("user")!);
          var datas = {
            'question_id': int.parse(soal['id'].toString()),
            'answer_id': int.parse(selectedId.toString()),
            'attempt_id': int.parse(attempt_id.toString()),
            'is_send': 1,
          };
          await SendAnswer().insertSendAnswer(datas);

          temporary_answer = null;
          if (page <= 15) {
            _getSoal();
          } else {
            Navigator.pushNamed(
                context, AppRoutes.soalKuisHasilDanPembahasanScreen);
          }
          // isLoading = false;
          setState(() {});
        } else {
          isLoading = false;
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            content: Text('Periksa kembali jaringan anda.',
                style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white, fontWeight: FontWeight.w600)),
          ));
          setState(() {});
        }
      }
    });
  }

  var quiz = null;

  void getDataFromDatabase() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var attempt = json.decode(pref.getString("user")!);
    attempt = await attempt['attempt']['id'].toString() + '_' + page.toString();
    quiz = await Questions().getQuizData(attempt.toString());
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
            _getSoal();
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

  DateTime? currentBackPressTime;

  Future<bool> _handleBackButton() async {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.grey,
        behavior: SnackBarBehavior.floating,
        // content: Text('Selesaikan ujian anda terlebih dahulu!',
        content: Text('Tekan kembali lagi untuk keluar',
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.white, // Adjust color based on your theme
            )),
      ));
      return Future.value(false);
    }
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    return Future.value(true);
  }

  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return WillPopScope(
      onWillPop: _handleBackButton,
      child: SafeArea(
        child: Scaffold(
          body: (isLoading && page == 1)
              ? Center(
                  child: Image.asset(
                    "assets/images/img_frame5.png",
                    width: MediaQuery.of(context).size.width / 1.4,
                    height: MediaQuery.of(context).size.width / 1.4,
                  ),
                )
              : Container(
                  width: 379.h,
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.h,
                    vertical: 50.v,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      (isLoading && page == 16)
                          ? Skeletonizer(
                              child: Container(
                                child: LayoutBuilder(
                                  builder: (BuildContext context,
                                      BoxConstraints constraints) {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Skeleton.replace(
                                        width: 100.h,
                                        height: theme
                                            .textTheme.titleMedium?.fontSize!,
                                        child: SizedBox(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            )
                          : Text(
                              "Soal No $page",
                              style: CustomTextStyles.titleMediumExtraBold,
                            ),
                      Skeletonizer(
                        enabled: isLoading,
                        child: Container(
                          width: 287.h,
                          margin: EdgeInsets.only(
                            left: 1.h,
                            top: 10.v,
                            right: 9.h,
                          ),
                          child: Text(
                            (soal != null) ? soal['question'] : '',
                            maxLines: 20,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleMedium,
                          ),
                        ),
                      ),
                      SizedBox(height: 22.v),
                      Text(
                        "Jawaban",
                        style: CustomTextStyles.titleMediumOnPrimary,
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: 6.h,
                            top: 25.v,
                          ),
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
                            itemCount: (jawaban != null) ? jawaban.length : 4,
                            itemBuilder: (context, index) {
                              return isLoading
                                  ? Skeletonizer(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 15.h,
                                          vertical: 11.v,
                                        ),
                                        child: LayoutBuilder(
                                          builder: (BuildContext context,
                                              BoxConstraints constraints) {
                                            return ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Skeleton.replace(
                                                width: constraints.maxWidth,
                                                height: 25.adaptSize,
                                                child: SizedBox(),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    )
                                  : GestureDetector(
                                      onTap: () async {
                                        setState(() {
                                          temporary_answer = jawaban[index];
                                          selectedId = jawaban[index]['id'];
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 15.h,
                                          vertical: 11.v,
                                        ),
                                        decoration: (selectedId ==
                                                jawaban[index]['id'])
                                            ? AppDecoration.fillLightGreen
                                                .copyWith(
                                                borderRadius: BorderRadiusStyle
                                                    .roundedBorder10,
                                              )
                                            : AppDecoration.fillOrange.copyWith(
                                                borderRadius: BorderRadiusStyle
                                                    .roundedBorder10,
                                              ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              child: Stack(
                                                alignment: Alignment.topCenter,
                                                children: [
                                                  Align(
                                                    alignment: Alignment.center,
                                                    child: Container(
                                                      height: 25.adaptSize,
                                                      width: 25.adaptSize,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          12.h,
                                                        ),
                                                        border: Border.all(
                                                          color:
                                                              appTheme.black900,
                                                          width: 2.h,
                                                          strokeAlign:
                                                              strokeAlignOutside,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      String.fromCharCode(
                                                          index + 65),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: CustomTextStyles
                                                          .titleMediumExtraBold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    EdgeInsets.only(left: 16.h),
                                                child: Text(
                                                  jawaban[index]['answer']
                                                      .toString(),
                                                  maxLines: 4,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: CustomTextStyles
                                                      .titleSmallBold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                            },
                          ),
                        ),
                      ),
                      (!isLoading)
                          ? (page == 1)
                              ? Semantics(
                                  excludeSemantics: true,
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CustomElevatedButton(
                                          onTap: () async {
                                            Navigator.pop(context);
                                            setState(() {});
                                          },
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              3,
                                          text: "Kembali",
                                          margin: EdgeInsets.only(
                                            left: 6.h,
                                            top: 16.v,
                                            bottom: 5.v,
                                          ),
                                        ),
                                        CustomElevatedButton(
                                          onTap: () async {
                                            if (selectedId != 0) {
                                              if (isConnected) {
                                                page = page + 1;
                                                if (temporary_answer != null) {
                                                  var datas = {
                                                    'question': soal,
                                                    'current_answer':
                                                        temporary_answer
                                                  };
                                                  await CurrentAnswer()
                                                      .insertCurrentAnswerData(
                                                          datas);
                                                }
                                                _simpanJawaban();
                                                setState(() {});
                                              } else {
                                                SharedPreferences pref =
                                                    await SharedPreferences
                                                        .getInstance();
                                                var attempt_page = json.decode(
                                                    pref.getString("user")!);
                                                attempt_page =
                                                    await attempt_page[
                                                                'attempt']['id']
                                                            .toString() +
                                                        '_' +
                                                        page.toString();
                                                var current_answer =
                                                    await Questions()
                                                        .getQuizData(
                                                            attempt_page);

                                                var attempt_next_page =
                                                    attempt_page
                                                            .toString()
                                                            .split('_')[0] +
                                                        '_' +
                                                        (page + 1).toString();
                                                var current_next_answer =
                                                    await Questions()
                                                        .getQuizData(
                                                            attempt_next_page);

                                                if (current_answer?['data']?[
                                                                    'current_answer']
                                                                ?['id']
                                                            ?.toString() ==
                                                        selectedId.toString() &&
                                                    current_next_answer?[
                                                            'data'] !=
                                                        null) {
                                                  page = page + 1;
                                                  _getSoal();
                                                  setState(() {});
                                                } else {
                                                  user = json.decode(
                                                      pref.getString("user")!);
                                                  String attempt_id =
                                                      user['attempt']['id']
                                                          .toString();
                                                  var datas = {
                                                    'question_id': int.parse(
                                                        soal['id'].toString()),
                                                    'answer_id': int.parse(
                                                        selectedId.toString()),
                                                    'attempt_id': int.parse(
                                                        attempt_id.toString()),
                                                    'is_send': 0,
                                                  };
                                                  await SendAnswer()
                                                      .insertSendAnswer(datas);

                                                  if (temporary_answer !=
                                                      null) {
                                                    var data = {
                                                      'question': soal,
                                                      'current_answer':
                                                          temporary_answer
                                                    };
                                                    await CurrentAnswer()
                                                        .insertCurrentAnswerData(
                                                            data);
                                                  }

                                                  ScaffoldMessenger.of(context)
                                                      .hideCurrentSnackBar();
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                    backgroundColor: Colors.red,
                                                    behavior: SnackBarBehavior
                                                        .floating,
                                                    content: Text(
                                                        'Periksa kembali jaringan anda.',
                                                        style: theme.textTheme
                                                            .titleMedium
                                                            ?.copyWith(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600)),
                                                  ));
                                                  setState(() {});
                                                }
                                              }
                                            }
                                          },
                                          isDisabled:
                                              (selectedId == 0) ? true : false,
                                          width: MediaQuery.of(context)
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
                                )
                              : (page == 15)
                                  ? Semantics(
                                      excludeSemantics: true,
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            CustomElevatedButton(
                                              onTap: () async {
                                                if (isConnected) {
                                                  page = page - 1;
                                                  _getSoal();
                                                  setState(() {});
                                                } else {
                                                  ScaffoldMessenger.of(context)
                                                      .hideCurrentSnackBar();
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                    backgroundColor: Colors.red,
                                                    behavior: SnackBarBehavior
                                                        .floating,
                                                    content: Text(
                                                        'Periksa kembali jaringan anda.',
                                                        style: theme.textTheme
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
                                              width: MediaQuery.of(context)
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
                                                  // page = page + 1;
                                                  if (isConnected) {
                                                    AwesomeDialog(
                                                      context: context,
                                                      dialogType:
                                                          DialogType.warning,
                                                      animType: AnimType.scale,
                                                      title: 'Sampun?',
                                                      btnCancelText: 'Dereng',
                                                      btnOkText: 'Sampun',
                                                      btnCancelOnPress: () {},
                                                      btnOkOnPress: () async {
                                                        page = page + 1;
                                                        if (temporary_answer !=
                                                            null) {
                                                          var datas = {
                                                            'question': soal,
                                                            'current_answer':
                                                                temporary_answer
                                                          };
                                                          await CurrentAnswer()
                                                              .insertCurrentAnswerData(
                                                                  datas);
                                                        }
                                                        _simpanJawaban();
                                                        setState(() {});
                                                      },
                                                    )..show();
                                                  } else {
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
                                                            page.toString();
                                                    var current_answer =
                                                        await Questions()
                                                            .getQuizData(
                                                                attempt_page);

                                                    var attempt_next_page =
                                                        attempt_page
                                                                .toString()
                                                                .split('_')[0] +
                                                            '_' +
                                                            (page + 1)
                                                                .toString();
                                                    var current_next_answer =
                                                        await Questions()
                                                            .getQuizData(
                                                                attempt_next_page);

                                                    if (current_answer?['data']
                                                                        ?[
                                                                        'current_answer']
                                                                    ?['id']
                                                                ?.toString() ==
                                                            selectedId
                                                                .toString() &&
                                                        current_next_answer?[
                                                                'data'] !=
                                                            null) {
                                                      page = page + 1;
                                                      _getSoal();
                                                      setState(() {});
                                                    } else {
                                                      user = json.decode(pref
                                                          .getString("user")!);
                                                      String attempt_id =
                                                          user['attempt']['id']
                                                              .toString();
                                                      var datas = {
                                                        'question_id':
                                                            int.parse(soal['id']
                                                                .toString()),
                                                        'answer_id': int.parse(
                                                            selectedId
                                                                .toString()),
                                                        'attempt_id': int.parse(
                                                            attempt_id
                                                                .toString()),
                                                        'is_send': 0,
                                                      };
                                                      await SendAnswer()
                                                          .insertSendAnswer(
                                                              datas);

                                                      if (temporary_answer !=
                                                          null) {
                                                        var data = {
                                                          'question': soal,
                                                          'current_answer':
                                                              temporary_answer
                                                        };
                                                        await CurrentAnswer()
                                                            .insertCurrentAnswerData(
                                                                data);
                                                      }

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
                                                      setState(() {});
                                                    }
                                                  }
                                                }
                                                setState(() {});
                                              },
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3,
                                              text: "Selesai",
                                              margin: EdgeInsets.only(
                                                left: 6.h,
                                                top: 16.v,
                                                bottom: 5.v,
                                              ),
                                            )
                                          ]),
                                    )
                                  : Semantics(
                                      excludeSemantics: true,
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            CustomElevatedButton(
                                              onTap: () async {
                                                page = page - 1;
                                                _getSoal();
                                                setState(() {});
                                              },
                                              width: MediaQuery.of(context)
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
                                                  if (isConnected) {
                                                    page = page + 1;
                                                    if (temporary_answer !=
                                                        null) {
                                                      var datas = {
                                                        'question': soal,
                                                        'current_answer':
                                                            temporary_answer
                                                      };
                                                      await CurrentAnswer()
                                                          .insertCurrentAnswerData(
                                                              datas);
                                                    }
                                                    _simpanJawaban();
                                                    setState(() {});
                                                  } else {
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
                                                            page.toString();
                                                    var current_answer =
                                                        await Questions()
                                                            .getQuizData(
                                                                attempt_page);

                                                    var attempt_next_page =
                                                        attempt_page
                                                                .toString()
                                                                .split('_')[0] +
                                                            '_' +
                                                            (page + 1)
                                                                .toString();
                                                    var current_next_answer =
                                                        await Questions()
                                                            .getQuizData(
                                                                attempt_next_page);
                                                    if (current_answer?['data']
                                                                        ?[
                                                                        'current_answer']
                                                                    ?['id']
                                                                ?.toString() ==
                                                            selectedId
                                                                .toString() &&
                                                        current_next_answer?[
                                                                'data'] !=
                                                            null) {
                                                      page = page + 1;
                                                      _getSoal();
                                                      setState(() {});
                                                    } else {
                                                      user = json.decode(pref
                                                          .getString("user")!);
                                                      String attempt_id =
                                                          user['attempt']['id']
                                                              .toString();
                                                      var datas = {
                                                        'question_id':
                                                            int.parse(soal['id']
                                                                .toString()),
                                                        'answer_id': int.parse(
                                                            selectedId
                                                                .toString()),
                                                        'attempt_id': int.parse(
                                                            attempt_id
                                                                .toString()),
                                                        'is_send': 0,
                                                      };
                                                      await SendAnswer()
                                                          .insertSendAnswer(
                                                              datas);

                                                      if (temporary_answer !=
                                                          null) {
                                                        var data = {
                                                          'question': soal,
                                                          'current_answer':
                                                              temporary_answer
                                                        };
                                                        await CurrentAnswer()
                                                            .insertCurrentAnswerData(
                                                                data);
                                                      }

                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .hideCurrentSnackBar();
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
                                                      setState(() {});
                                                    }
                                                  }
                                                }
                                              },
                                              isDisabled: (selectedId == 0)
                                                  ? true
                                                  : false,
                                              width: MediaQuery.of(context)
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
                                    )
                          : SizedBox(),
                    ],
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
