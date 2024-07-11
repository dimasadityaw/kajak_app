import 'dart:async';
import 'dart:convert';

import 'package:kajak/ConnectivityService.dart';
import 'package:kajak/core/app_export.dart';
import 'package:kajak/database_helper/database_helper.dart';
import 'package:kajak/database_helper/questions.dart';
import 'package:kajak/database_helper/send_answer.dart';
import 'package:kajak/presentation/footer/footer.dart';
import 'package:kajak/widgets/app_bar/appbar_image.dart';
import 'package:kajak/widgets/app_bar/appbar_title.dart';
import 'package:kajak/widgets/app_bar/custom_app_bar.dart';
import 'package:kajak/widgets/custom_elevated_button.dart';
import 'package:kajak/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore_for_file: must_be_immutable
class KuisTwoScreen extends StatefulWidget {
  KuisTwoScreen({Key? key}) : super(key: key);

  @override
  _KuisTwoScreenState createState() => _KuisTwoScreenState();
}

class _KuisTwoScreenState extends State<KuisTwoScreen> {
  TextEditingController edittextController = TextEditingController();

  TextEditingController edittextoneController = TextEditingController();

  TextEditingController edittexttwoController = TextEditingController();

  TextEditingController edittextthreeController = TextEditingController();

  var user;

  Future getUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    user = json.decode(pref.getString("user")!);
    // print(user);
    edittextController =
        TextEditingController(text: user['user']['name'].toString());
    edittextoneController =
        TextEditingController(text: user['user']['nisn'].toString());
    edittexttwoController =
        TextEditingController(text: user['user']['kelas'].toString());
    setState(() {});
  }

  var quiz = null;
  var hasBeenAnswered = null;
  bool isLoading = true;

  void getDataFromDatabase() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var attempt = json.decode(pref.getString("user")!);
    attempt = await attempt['attempt']['id'].toString() + '_1';
    quiz = await Questions().getQuizData(attempt.toString());
    hasBeenAnswered = await SendAnswer().hasBeenAnswered();
    isLoading = false;
    setState(() {});
  }

  StreamSubscription<bool>? _connectivitySubscription;
  bool isConnected = true;
  bool hasConnectedRun = false;

  @override
  void initState() {
    getUser();
    getDataFromDatabase();
    _connectivitySubscription =
        ConnectivityService.connectivityStream.listen((status) {
      setState(() {
        isConnected = status;
        if (!hasConnectedRun) {
          Future.delayed(Duration.zero, () {
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
    return SafeArea(
        child: Scaffold(
      backgroundColor: appTheme.gray50,
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
          leadingWidth: 40.h,
          leading: AppbarImage(
              svgPath: ImageConstant.imgArrowleft,
              margin: EdgeInsets.only(left: 15.h, top: 15.v, bottom: 15.v),
              onTap: () {
                onTapArrowleftone(context);
              }),
          centerTitle: true,
          title: AppbarTitle(text: "Wulangan")),
      body: Container(
          width: 379.h,
          padding: EdgeInsets.only(left: 35.h, right: 35.h),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                    alignment: Alignment.center,
                    child: Container(
                        width: 286.h,
                        margin: EdgeInsets.only(left: 8.h, right: 13.h),
                        child: Text(
                            "Sebelum mengerjakan harap periksa data diri masing masing. Selamat mengerjakan.",
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleMedium))),
                SizedBox(height: 48.v),
                Text("Nisn", style: theme.textTheme.titleMedium),
                SizedBox(height: 6.v),
                CustomTextFormField(
                    readonly: true,
                    controller: edittextoneController,
                    borderDecoration: TextFormFieldStyleHelper.fillBlueGray,
                    fillColor: appTheme.blueGray10001),
                SizedBox(height: 5.v),
                Text("Nama", style: theme.textTheme.titleMedium),
                SizedBox(height: 6.v),
                CustomTextFormField(
                    readonly: true,
                    controller: edittextController,
                    borderDecoration: TextFormFieldStyleHelper.fillBlueGray,
                    fillColor: appTheme.blueGray10001),
                SizedBox(height: 5.v),
                Text("Kelas", style: theme.textTheme.titleMedium),
                SizedBox(height: 6.v),
                CustomTextFormField(
                    readonly: true,
                    controller: edittexttwoController,
                    borderDecoration: TextFormFieldStyleHelper.fillBlueGray,
                    fillColor: appTheme.blueGray10001),
                // SizedBox(height: 5.v),
                // Text("Token Kuis", style: theme.textTheme.titleMedium),
                // SizedBox(height: 6.v),
                // CustomTextFormField(
                //     controller: edittextthreeController,
                //     textInputAction: TextInputAction.done,
                //     borderDecoration:
                //         TextFormFieldStyleHelper.fillBlueGray,
                //     fillColor: appTheme.blueGray10001),
                CustomElevatedButton(
                    onTap: () async {
                      if (!isLoading) {
                        if (isConnected) {
                          Navigator.pushNamed(context, AppRoutes.soalKuisScreen);
                        } else {
                          SharedPreferences pref = await SharedPreferences.getInstance();
                          var attempt = json.decode(pref.getString("user")!);
                          attempt = await attempt['attempt']['id'].toString() + '_1';
                          quiz = await Questions().getQuizData(attempt.toString());
                          if (quiz != null) {
                            Navigator.pushNamed(
                                context, AppRoutes.soalKuisScreen);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.red,
                              behavior: SnackBarBehavior.floating,
                              content: Text('Periksa kembali jaringan anda.',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600)),
                            ));
                          }
                        }
                      }
                    },
                    text: (isLoading) ? 'Tunggu...' : (hasBeenAnswered == null) ? "Mulai Mengerjakan" : (hasBeenAnswered?['data']?['answer']?.length < 15) ? "Lanjut Mengerjakan" : "Mulai Mengerjakan",
                    margin: EdgeInsets.fromLTRB(8.h, 95.v, 8.h, 5.v),
                    alignment: Alignment.center)
              ])),
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
