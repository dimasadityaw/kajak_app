import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'package:kajak/core/app_export.dart';
import 'package:kajak/widgets/custom_elevated_button.dart';
import 'package:kajak/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HalamanHomeScreen extends StatefulWidget {
  HalamanHomeScreen({Key? key}) : super(key: key);

  @override
  _HalamanHomeScreenState createState() => _HalamanHomeScreenState();
}

class _HalamanHomeScreenState extends State<HalamanHomeScreen> {
  TextEditingController searchController = TextEditingController();

  var homeData = [
    {
      "route": AppRoutes.halamanTerjemahanScreen,
      "title": "Terjemahan",
      "desc":
          "Terjemahkan teks Bahasa Indonesia ke dalam Bahasa Jawa ngoko, madya dan krama"
    },
    {
      "route": AppRoutes.halamanKawruhBasaScreen,
      "title": "Rupa - Rupa Kawruh",
      "desc": "Cari tahu penyebutan benda dan makhluk hidup dalam bahasa jawa"
    },
    {
      "route": AppRoutes.halamanParamasastraScreen,
      "title": "Paramasastra",
      "desc":
          "Pelajari penggunaan kalimat bahasa jawa dalam bermacam jenis penggunaan"
    },
    {
      "route": AppRoutes.halamanKasusastraanScreen,
      "title": "Kasustraan",
      "desc": "Pelajari Peribahasa, Parikan dan tembang-tembang berbahasa jawa"
    },
    {
      "route": AppRoutes.halamanAksaraJawaScreen,
      "title": "Ha Na Ca Ra Ka",
      "desc": "Cari tahu bagaimana membaca dan menulis aksara jawa"
    },
    {
      "route": AppRoutes.kuisScreen,
      "title": "Wulangan",
      "desc":
          "Kerjakan kuis pengetahuan bahasa jawa untuk menguji kemampuanmu berbahasa jawa"
    },
  ];

  var user;
  bool isLoading = false;
  bool isProfile = false;

  var homeDatas = [];

  DateTime? currentBackPressTime;

  Future<bool> _handleBackButton() async {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      // Fluttertoast.showToast(msg: 'Tekan kembali lagi untuk keluar');
      return Future.value(false);
    }
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    return Future.value(true);
  }

  void _onSearchChanged() {
    homeDatas = homeData
        .where((data) =>
            data['title']!
                .toLowerCase()
                .contains(searchController.text.toLowerCase()) ||
            data['desc']!
                .toLowerCase()
                .contains(searchController.text.toLowerCase()))
        .toList();
    setState(() {});
  }

  Future _nilai() async {
    isLoading = true;
    // Fluttertoast.showToast(msg: 'Tunggu sebentar');
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
    log(data.toString());
    if (data['message'].toString().toLowerCase().contains('berhasil') == true &&
        data['attempt']['score'].toString() != 'null') {
      Navigator.pushNamed(context, AppRoutes.soalKuisHasilDanPembahasanScreen);
    } else {
      Navigator.pushNamed(context, AppRoutes.kuisScreen);
    }
    isLoading = false;
    setState(() {});
  }

  Future logOut() async {
    isLoading = true;
    SharedPreferences pref = await SharedPreferences.getInstance();
    user = json.decode(pref.getString("user")!);
    String token = user['token'];
    var apiResult = await http
        .post(Uri.parse('http://kaja.cemzpex.com/api/logout'), headers: {
      "Accept": "Application/json",
      "Authorization": "Bearer $token"
    });
    // var data = json.decode(apiResult.body);
    pref.remove('user');
    Navigator.pushReplacementNamed(context, AppRoutes.loginScreen);
    isLoading = false;
    setState(() {});
  }

  TextEditingController edittextController = TextEditingController();

  TextEditingController edittextoneController = TextEditingController();

  TextEditingController edittexttwoController = TextEditingController();

  TextEditingController edittextthreeController = TextEditingController();

  Future getUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    user = json.decode(pref.getString("user")!);
    edittextController =
        TextEditingController(text: user['user']['name'].toString());
    edittextoneController =
        TextEditingController(text: user['user']['nisn'].toString());
    edittexttwoController =
        TextEditingController(text: user['user']['kelas'].toString());
    setState(() {});
  }

  late FocusNode _focusNode;
  bool _isKeyboardOpen(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return !(mediaQuery.viewInsets.bottom == 0);
  }
  @override
  void initState() {
    // DOKUMENTASI
    // initState dijalankan ketika pertama kali memasuki halaman ini
    searchController.addListener(_onSearchChanged);
    if (searchController.text == '') {
      // DOKUMENTASI
      // ketika pertamakali memasuki halaman ini field search sudah pasti kosong
      // maka array homeDatas menggunakan data dari homeData
      homeDatas = homeData;
    }
    // DOKUMENTASI
    // getUser untuk mengambil data user yang di tampilkan untuk tampilan profile
    getUser();
    _focusNode = FocusNode();
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

    return WillPopScope(
      // DOKUMENTASI
      // untuk deteksi button back pada hp
      // agar tidak kembali ke halaman home dan keluar dari app
      onWillPop: _handleBackButton,
      child: SafeArea(
        child: GestureDetector(
          onTap: () {
            if (_focusNode.hasFocus) {
              _focusNode.unfocus();
            }
          },
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: (!isProfile)
                ? Center(
                    child: Container(
                      alignment: Alignment.center,
                      width: 380.h,
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.h,
                        vertical: 18.v,
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                          bottom: 5.v,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 200.h,
                                  child: Text(
                                    "Sugeng Rawuh ing\nPepak Digital (Kajak)",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.titleLarge,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    // DOKUMENTASI
                                    // menggunakan true false untuk mengubah ke tampilan profile
                                    // tanpa perlu pindah halaman
                                    isProfile = !isProfile;
                                    setState(() {});
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(7.5),
                                    decoration: new BoxDecoration(
                                      color: Colors.grey,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.person_outline_rounded,
                                        color: Colors.white,
                                        size: MediaQuery.of(context).size.width /
                                            16.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
                                      svgPath: ImageConstant.imgUndrawonlinel,
                                      height: 119.v,
                                      width: 164.h,
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
                                          "Belajar Bahasa Jawa Luwih Gampang lan Penak Ngo Aplikasi Pepak digital \n(Kajak)",
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
                            CustomTextFormField(
                              controller: searchController,
                              margin: EdgeInsets.only(
                                top: 10.v,
                              ),
                              focusNode: _focusNode,
                              hintText: _isKeyboardOpen(context) ? '' : "Golek Opo ?",
                              hintStyle: CustomTextStyles.labelLarge13,
                              textInputAction: TextInputAction.done,
                              suffix: Container(
                                margin:
                                    EdgeInsets.fromLTRB(30.h, 10.v, 12.h, 9.v),
                                child: CustomImageView(
                                  svgPath: ImageConstant.imgSearch,
                                ),
                              ),
                              suffixConstraints: BoxConstraints(
                                maxHeight: 38.v,
                              ),
                            ),
                            (homeDatas.length != 0)
                                ? Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        top: 19.v,
                                      ),
                                      child: ListView.separated(
                                          shrinkWrap: true,
                                          physics: BouncingScrollPhysics(),
                                          separatorBuilder: (
                                            context,
                                            index,
                                          ) {
                                            return SizedBox(
                                              height: 10.v,
                                            );
                                          },
                                          itemCount: (homeDatas != null)
                                              ? homeDatas.length
                                              : 0,
                                          itemBuilder: (context, index) {
                                            return Column(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    if (homeDatas[index]
                                                            ['title']! ==
                                                        'Wulangan') {
                                                      if (isLoading == false) {
                                                        _nilai();
                                                      }
                                                    } else {
                                                      Navigator.pushNamed(
                                                          context,
                                                          homeDatas[index]
                                                              ['route']!);
                                                    }
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.symmetric(
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
                                                          homeDatas[index]
                                                              ['title']!,
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
                                                            homeDatas[index]
                                                                    ['desc']! +
                                                                "                        ",
                                                            maxLines: 2,
                                                            overflow: TextOverflow
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
                                              ],
                                            );
                                          }),
                                    ),
                                  )
                                : Padding(
                                    padding: EdgeInsets.only(
                                      top: 19.v,
                                    ),
                                    child: Card(
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
                                  )
                          ],
                        ),
                      ),
                    ),
                  )
                : Center(
                    child: Container(
                        width: 379.h,
                        padding: EdgeInsets.only(left: 35.h, right: 35.h),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 200.h,
                                child: Text(
                                  "Sugeng Rawuh ing\nPepak Digital (Kajak)",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.titleLarge,
                                ),
                              ),
                              SizedBox(height: 38.v),
                              Text("Halo ${edittextController.text},",
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.titleMedium),
                              SizedBox(height: 12.v),
                              Text("Nisn", style: theme.textTheme.titleMedium),
                              SizedBox(height: 6.v),
                              CustomTextFormField(
                                  readonly: true,
                                  controller: edittextoneController,
                                  borderDecoration:
                                      TextFormFieldStyleHelper.fillBlueGray,
                                  fillColor: appTheme.blueGray10001),
                              SizedBox(height: 5.v),
                              Text("Kelas", style: theme.textTheme.titleMedium),
                              SizedBox(height: 6.v),
                              CustomTextFormField(
                                  readonly: true,
                                  controller: edittexttwoController,
                                  borderDecoration:
                                      TextFormFieldStyleHelper.fillBlueGray,
                                  fillColor: appTheme.blueGray10001),
                              SizedBox(height: 38.v),
                              CustomElevatedButton(
                                  onTap: () {
                                    // DOKUMENTASI
                                    // menggunakan true false untuk mengubah ke tampilan home
                                    // tanpa perlu pindah halaman
                                    isProfile = !isProfile;
                                    setState(() {});
                                  },
                                  text: "Kembali ke Home",
                                  alignment: Alignment.center),
                              SizedBox(height: 10.v),
                              CustomElevatedButton(
                                  onTap: () {
                                    if (isLoading != true) {
                                      logOut();
                                    }
                                    setState(() {});
                                  },
                                  buttonStyle: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(Colors.red)),
                                  text: (!isLoading) ? "Keluar" : "Tunggu...",
                                  alignment: Alignment.center)
                            ])),
                  ),
          ),
        ),
      ),
    );
  }
}
