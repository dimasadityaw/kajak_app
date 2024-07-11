import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kajak/ConnectivityService.dart';
import 'package:kajak/core/utils/size_utils.dart';
import 'package:kajak/presentation/footer/footer.dart';
import 'package:kajak/routes/app_routes.dart';
import 'package:kajak/theme/theme_helper.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CustomScroll extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

class LoginActivity extends StatefulWidget {
  const LoginActivity({Key? key}) : super(key: key);

  @override
  _LoginActivityState createState() => _LoginActivityState();
}

class _LoginActivityState extends State<LoginActivity> {
  final TextEditingController fieldNisn = TextEditingController(text: "");
  final TextEditingController fieldPassword = TextEditingController(text: "");

  FocusNode? focusPassword;
  bool _obscureText = true;
  bool isLoading = false;
  bool check = true;
  String warning = '';

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future checkToken() async {
    check = true;
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString("user") != null) {
      if (!mounted) return;
      Future.delayed(Duration(milliseconds: 350), () {
        Navigator.pushNamed(context, AppRoutes.halamanHomeScreen);
      });
    } else {
      pref.remove('user');
      check = false;
    }
    setState(() {});
  }

  Future _login(String email, String password) async {
    if (email != "" && password != "") {
      setState(() {
        isLoading = true;
      });
      var apiResult = await http.post(
          Uri.parse('${const String.fromEnvironment('apiUrl')}/login'),
          body: {
            'nisn': email,
            'password': password,
          });
      var data = json.decode(apiResult.body);
      // log(data.toString());

      if (!data['message'].toString().contains('salah')) {
        warning = data['message'].toString();

        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setString("user", apiResult.body);
        if (!mounted) return;
        Navigator.pushNamed(context, AppRoutes.halamanHomeScreen);
      } else {
        warning = data['message'].toString();
      }
    } else {
      warning = "Datamu durung lengkap";
    }
    setState(() {
      isLoading = false;
    });
  }

  StreamSubscription<bool>? _connectivitySubscription;
  bool isConnected = true;

  @override
  void initState() {
    // melakukan pengecheckan Token user
    checkToken();
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
    // TODO: implement dispose
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: (!check)
          ? Scaffold(
              body: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width / 18),
                  child: ListView(
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 24,
                      ),
                      // ------------------------------------ Masuk login ------------------------------------
                      Container(
                          child: AutoSizeText(
                        "Monggo Mlebet Dhisik\nSadurunge Mlebu ing\nPepak Digital (Kajak)",
                        style: GoogleFonts.inter(
                            textStyle: TextStyle(
                                fontSize: double.parse(
                                    ((MediaQuery.of(context).size.width * 0.045)
                                                .toString()
                                                .contains('.') ==
                                            true)
                                        ? (MediaQuery.of(context).size.width *
                                                0.045)
                                            .toString()
                                            .split('.')[0]
                                        : (MediaQuery.of(context).size.width *
                                                0.045)
                                            .toString()),
                                fontWeight: FontWeight.w600,
                                color: Colors.black)),
                        minFontSize: 0,
                        maxLines: 3,
                      )),

                      SizedBox(
                        height: MediaQuery.of(context).size.height / 24,
                      ),

                      Center(
                        child: Image.asset(
                          "assets/images/login.png",
                          width: MediaQuery.of(context).size.width / 1.4,
                          height: MediaQuery.of(context).size.width / 1.4,
                        ),
                      ),

                      SizedBox(
                        height: MediaQuery.of(context).size.height / 24,
                      ),
                      // ------------------------------------ Text Field NISN ------------------------------------
                      Container(
                        height: MediaQuery.of(context).size.height! / 16,
                        decoration: BoxDecoration(
                            color: const Color(0xffF5F5F5),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.brown.shade300)),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width! / 32),
                          child: Center(
                            child: TextField(
                              readOnly: false,
                              controller: fieldNisn,
                              keyboardType: TextInputType.number,
                              cursorColor: appTheme.orange100,
                              style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                      fontSize: double.parse(
                                          ((MediaQuery.of(context).size.width *
                                                          0.03)
                                                      .toString()
                                                      .contains('.') ==
                                                  true)
                                              ? (MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.03)
                                                  .toString()
                                                  .split('.')[0]
                                              : (MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.03)
                                                  .toString()),
                                      color: Colors.brown.shade300)),
                              decoration: InputDecoration(
                                isDense: true,
                                hintText: 'Lebokno NISN',
                                contentPadding: const EdgeInsets.all(0),
                                hintStyle: GoogleFonts.inter(
                                    textStyle: TextStyle(
                                        fontSize: double.parse(
                                            ((MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.03)
                                                        .toString()
                                                        .contains('.') ==
                                                    true)
                                                ? (MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.03)
                                                    .toString()
                                                    .split('.')[0]
                                                : (MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.03)
                                                    .toString()),
                                        color: Colors.brown.shade300)),
                                helperStyle: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        fontSize: double.parse(
                                            ((MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.03)
                                                        .toString()
                                                        .contains('.') ==
                                                    true)
                                                ? (MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.03)
                                                    .toString()
                                                    .split('.')[0]
                                                : (MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.03)
                                                    .toString()))),
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(
                        height: MediaQuery.of(context).size.height / 48,
                      ),
                      // ------------------------------------ Text Field Password ------------------------------------
                      Container(
                        height: MediaQuery.of(context).size.height! / 16,
                        decoration: BoxDecoration(
                            color: const Color(0xffF5F5F5),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.brown.shade300)),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width! / 32),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  enableInteractiveSelection: false,
                                  autocorrect: false,
                                  focusNode: focusPassword,
                                  obscureText: _obscureText,
                                  controller: fieldPassword,
                                  cursorColor: appTheme.orange100,
                                  style: GoogleFonts.inter(
                                      textStyle: TextStyle(
                                          fontSize: double.parse(
                                              ((MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.03)
                                                          .toString()
                                                          .contains('.') ==
                                                      true)
                                                  ? (MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.03)
                                                      .toString()
                                                      .split('.')[0]
                                                  : (MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.03)
                                                      .toString()),
                                          color: Colors.brown.shade300)),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    hintText: 'Lebokno Password',
                                    contentPadding: const EdgeInsets.all(0),
                                    hintStyle: GoogleFonts.inter(
                                        textStyle: TextStyle(
                                            fontSize: double.parse(
                                                ((MediaQuery.of(context)
                                                                    .size
                                                                    .width *
                                                                0.03)
                                                            .toString()
                                                            .contains('.') ==
                                                        true)
                                                    ? (MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.03)
                                                        .toString()
                                                        .split('.')[0]
                                                    : (MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.03)
                                                        .toString()),
                                            color: Colors.brown.shade300)),
                                    helperStyle: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            fontSize: double.parse(
                                                ((MediaQuery.of(context)
                                                                    .size
                                                                    .width *
                                                                0.03)
                                                            .toString()
                                                            .contains('.') ==
                                                        true)
                                                    ? (MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.03)
                                                        .toString()
                                                        .split('.')[0]
                                                    : (MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.03)
                                                        .toString()))),
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: _toggle,
                                child: Icon(
                                    _obscureText
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.brown.shade300),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 36,
                      ),

                      // ------------------------------------ Button Masuk ------------------------------------
                      GestureDetector(
                        onTap: () {
                          if (isLoading == false) {
                            if (isConnected) {
                              _login(fieldNisn.text, fieldPassword.text);
                            } else {
                              ScaffoldMessenger.of(context).hideCurrentSnackBar();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                backgroundColor: Colors.red,
                                behavior: SnackBarBehavior.floating,
                                content: Text('Periksa kembali jaringan anda.',
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600)),
                              ));
                            }
                          }
                          setState(() {});
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height! / 18,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: (isConnected)
                                  ? Color.fromRGBO(59, 39, 30, 1)
                                  : Colors.grey,
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              (!isLoading)
                                  ? Text(
                                      "Login",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white),
                                    )
                                  : Text(
                                      "Tunggu...",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white),
                                    ),
                            ],
                          ),
                        ),
                      ),
                      // CustomElevatedButton(
                      //     onTap: () {
                      //       if (isLoading == false){
                      //         _login(fieldNisn.text, fieldPassword.text);
                      //       }
                      //       setState(() {});
                      //     },
                      //     height: 45.v,
                      //     text: (!isLoading)?"Login":"Tunggu...",
                      //     alignment: Alignment.center),

                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.005,
                      ),

                      (warning != "" && warning != "null")
                          ? Center(
                              child: AutoSizeText(
                                warning,
                                style: GoogleFonts.inter(
                                    textStyle: TextStyle(
                                        fontSize: double.parse(
                                            ((MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.03)
                                                        .toString()
                                                        .contains('.') ==
                                                    true)
                                                ? (MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.03)
                                                    .toString()
                                                    .split('.')[0]
                                                : (MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.03)
                                                    .toString()),
                                        fontWeight: FontWeight.w600,
                                        color: (!warning.contains(
                                                'Datamu durung lengkap'))
                                            ? (warning.contains('salah'))
                                                ? Colors.redAccent
                                                : Colors.greenAccent
                                            : Colors.redAccent)),
                                minFontSize: 0,
                                maxLines: 1,
                              ),
                            )
                          : Container(),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 48,
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
            )
          : Scaffold(
              body: Center(
                child: Image.asset(
                  "assets/images/img_frame5.png",
                  width: MediaQuery.of(context).size.width / 1.2,
                  height: MediaQuery.of(context).size.width / 1.2,
                ),
              ),
            ),
    );
  }
}
