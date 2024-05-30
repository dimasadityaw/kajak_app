import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:kajak/core/app_export.dart';
import 'package:kajak/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
  bool isLoading = true;
  int page = 1;
  int selectedId = 0;

  Future _getSoal() async {
    isLoading = true;
    selectedId = 0;
    SharedPreferences pref = await SharedPreferences.getInstance();
    user = json.decode(pref.getString("user")!);
    // print(user);
    print('page');
    print(page);
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
    print(data['data']);

    soal = data['data']['question'];
    jawaban = data['data']['answer'];

    selectedId = (data['data']['current_answer'] != null)
        ? data['data']['current_answer']['id']
        : 0;

    isLoading = false;
    setState(() {});
  }

  Future _simpanJawaban() async {
    isLoading = true;
    SharedPreferences pref = await SharedPreferences.getInstance();
    user = json.decode(pref.getString("user")!);
    String token = user['token'];
    String attempt_id = user['attempt']['id'].toString();
    print(int.parse(soal['id'].toString()));
    print(int.parse(selectedId.toString()));
    print(int.parse(attempt_id.toString()));
    print('http://kaja.cemzpex.com/api/exam/$attempt_id/question');
    var apiResult = await http.post(
        Uri.parse('http://kaja.cemzpex.com/api/exam/$attempt_id/question'),
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
    print('data');
    print(data);

    if (page != 16) {
      _getSoal();
    } else {
      Navigator.pushNamed(context, AppRoutes.soalKuisHasilDanPembahasanScreen);
    }
    setState(() {});
  }

  @override
  void initState() {
    _getSoal();
    super.initState();
  }

  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return SafeArea(
      child: Scaffold(
        body: (!isLoading)
            ? Container(
                width: 379.h,
                padding: EdgeInsets.symmetric(
                  horizontal: 40.h,
                  vertical: 50.v,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Soal No $page",
                      style: CustomTextStyles.titleMediumExtraBold,
                    ),
                    Container(
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
                          itemCount: (jawaban != null) ? jawaban.length : 0,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () async {
                                setState(() {
                                  selectedId =
                                      (selectedId == jawaban[index]['id'])
                                          ? jawaban[index]['id']
                                          : jawaban[index]['id'];
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 15.h,
                                  vertical: 11.v,
                                ),
                                decoration: (selectedId == jawaban[index]['id'])
                                    ? AppDecoration.fillLightGreen.copyWith(
                                        borderRadius:
                                            BorderRadiusStyle.roundedBorder10,
                                      )
                                    : AppDecoration.fillOrange.copyWith(
                                        borderRadius:
                                            BorderRadiusStyle.roundedBorder10,
                                      ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                                    BorderRadius.circular(
                                                  12.h,
                                                ),
                                                border: Border.all(
                                                  color: appTheme.black900,
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
                                              String.fromCharCode(index + 65),
                                              textAlign: TextAlign.center,
                                              style: CustomTextStyles
                                                  .titleMediumExtraBold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 16.h),
                                        child: Text(
                                          jawaban[index]['answer'].toString(),
                                          maxLines: 4,
                                          overflow: TextOverflow.ellipsis,
                                          style:
                                              CustomTextStyles.titleSmallBold,
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
                    (page == 1)
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
                                    width:
                                        MediaQuery.of(context).size.width / 3,
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
                                        page = page + 1;
                                        _simpanJawaban();
                                        setState(() {});
                                      }
                                    },
                                    isDisabled:
                                        (selectedId == 0) ? true : false,
                                    width:
                                        MediaQuery.of(context).size.width / 3,
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
                                          page = page - 1;
                                          _getSoal();
                                          setState(() {});
                                        },
                                        width:
                                            MediaQuery.of(context).size.width /
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
                                            AwesomeDialog(
                                              context: context,
                                              dialogType: DialogType.warning,
                                              animType: AnimType.scale,
                                              title: 'Sampun?',
                                              btnCancelText: 'Dereng',
                                              btnOkText: 'Sampun',
                                              btnCancelOnPress: () {},
                                              btnOkOnPress: () async {
                                                page = page + 1;
                                                _simpanJawaban();
                                                setState(() {});
                                              },
                                            )..show();
                                          }
                                          setState(() {});
                                        },
                                        width:
                                            MediaQuery.of(context).size.width /
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
                                        width:
                                            MediaQuery.of(context).size.width /
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
                                            _simpanJawaban();
                                            setState(() {});
                                          }
                                        },
                                        isDisabled:
                                            (selectedId == 0) ? true : false,
                                        width:
                                            MediaQuery.of(context).size.width /
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
                  ],
                ),
              )
            : Center(
                child: Image.asset(
                  "assets/images/img_frame5.png",
                  width: MediaQuery.of(context).size.width / 1.4,
                  height: MediaQuery.of(context).size.width / 1.4,
                ),
              ),
      ),
    );
  }
}
