import 'dart:convert';
import 'dart:developer';

import 'package:kajak/core/app_export.dart';
import 'package:kajak/widgets/app_bar/appbar_image.dart';
import 'package:kajak/widgets/app_bar/appbar_title.dart';
import 'package:kajak/widgets/app_bar/custom_app_bar.dart';
import 'package:kajak/widgets/custom_outlined_button.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HalamanKasusastraanSubMenu extends StatefulWidget {
  int id = 0;

  HalamanKasusastraanSubMenu(this.id, {Key? key}) : super(key: key);

  @override
  _HalamanKasusastraanSubMenuState createState() =>
      _HalamanKasusastraanSubMenuState(id);
}

class _HalamanKasusastraanSubMenuState
    extends State<HalamanKasusastraanSubMenu> {
  _HalamanKasusastraanSubMenuState(this.id);

  TextEditingController searchController = TextEditingController();
  var user;
  bool isLoading = true;
  bool open = true;
  var objData;
  int id = 0;

  Future _getData() async {
    isLoading = true;
    SharedPreferences pref = await SharedPreferences.getInstance();
    user = json.decode(pref.getString("user")!);
    String token = user['token'];
    String link = (id == 1)
        ? 'paribasan'
        : (id == 2)
            ? 'tembang'
            : 'parikan';
    var apiResult = await http
        .get(Uri.parse('http://kaja.cemzpex.com/api/$link'), headers: {
      "Accept": "Application/json",
      "Authorization": "Bearer $token"
    });
    var data = json.decode(apiResult.body);

    objData = data;

    if (id == 1) {
      objData['data'].forEach((data) {
        data['is_open'] = false;
      });
    } else if (id == 2) {
      objData.forEach((data) {
        if (data['name'].toString() == 'Opo Niku Tembang') {
          data['is_open'] = true;
        } else {
          data['is_open'] = false;
        }
        if (data['child'].toString() != '[]') {
          data['child'].forEach((data) {
            data['is_open'] = false;
          });
        }
      });
    } else {
      objData['data'].forEach((data) {
        data['is_open'] = false;
      });
    }

    log(objData.toString());

    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return SafeArea(
        child: Scaffold(
            appBar: CustomAppBar(
                leadingWidth: 38.h,
                leading: AppbarImage(
                    svgPath: ImageConstant.imgArrowleft,
                    margin:
                        EdgeInsets.only(left: 13.h, top: 15.v, bottom: 15.v),
                    onTap: () {
                      onTapArrowleftone(context);
                    }),
                centerTitle: true,
                title: AppbarTitle(
                    text:
                        "Kasusastraan (${(id == 1) ? 'Paribasan' : (id == 2) ? 'Tembang' : 'Parikan'})")),
            body: (!isLoading)
                ? (id == 1)
                    ? SizedBox(
                        width: mediaQueryData.size.width,
                        child: SingleChildScrollView(
                            padding: EdgeInsets.only(top: 16.v),
                            child: Padding(
                                padding: EdgeInsets.only(
                                    left: 25.h, right: 25.h, bottom: 5.v),
                                child: (open == true)
                                    ? Column(children: [
                                        SizedBox(
                                            child: Column(children: [
                                          CustomOutlinedButton(
                                              onTap: () {
                                                open = !open;
                                                setState(() {});
                                              },
                                              // width: 329.h,
                                              text: "Opo Niku Paribasan",
                                              alignment: Alignment.topCenter),
                                          Align(
                                              alignment: Alignment.bottomCenter,
                                              child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 5.h,
                                                      vertical: 9.v),
                                                  decoration: AppDecoration
                                                      .outlineBlack901,
                                                  child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        SizedBox(height: 20.v),
                                                        CustomImageView(
                                                            imagePath:
                                                                ImageConstant
                                                                    .imgFrame22,
                                                            height: 83.v,
                                                            width: 174.h,
                                                            alignment: Alignment
                                                                .center),
                                                        SizedBox(height: 25.v),
                                                        SizedBox(
                                                            width: 314.h,
                                                            child: Text(
                                                                "Paribasan inggih menika ungkapan wonten ing \nbasa Jawi ingkang panganggenipun pasti, gadhah \nteges denotatif, saha boten ngewrat simile. \nParibasan dipunsebat ungkapan ingkang \npanganggenipun tamtu amargi ungkapan-ungkapan \ningkang kados mekaten menika sampun dangu wonten \ning pangrembakanipun kasusastran Jawi saha \ndipunwarisaken kanthi turun temurun dados carita lisan. ",
                                                                maxLines: 8,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: theme
                                                                    .textTheme
                                                                    .labelLarge)),
                                                        Container(
                                                            width: 301.h,
                                                            margin:
                                                                EdgeInsets.only(
                                                                    top: 11.v,
                                                                    right:
                                                                        15.h),
                                                            child: Text(
                                                                "(Peribahasa adalah ungkapan dalam\r\nBahasa Jawa yang pasti digunakan, punya\r\nmakna denotatif.\rUcapan disebut ekspresi\r\npenggunaannya tentu saja karena ekspresi\rhal seperti \nini sudah ada sejak lama\rdalam perkembangan \nsastra Jawa dan\rdiwariskan dari generasi ke generasi \nsebagai cerita lisan.)",
                                                                maxLines: 7,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: CustomTextStyles
                                                                    .labelLarge_1))
                                                      ]))),
                                        ])),
                                        SizedBox(height: 14.v),
                                        CustomOutlinedButton(
                                            onTap: () {
                                              Navigator.pushNamed(
                                                  context,
                                                  AppRoutes
                                                      .halamanKasusastraanSubMenuParibasanScreen,
                                                  arguments: AppRoutes(
                                                      id: 0,
                                                      obj: objData));
                                            },
                                            text: "Contohing Paribasan",
                                            buttonStyle:
                                                CustomButtonStyles.outlineBlack)
                                      ])
                                    : Column(
                                        children: [
                                          CustomOutlinedButton(
                                              onTap: () {
                                                open = !open;
                                                setState(() {});
                                              },
                                              // width: 329.h,
                                              text: "Opo Niku Paribasan",
                                              alignment: Alignment.topCenter),
                                          SizedBox(height: 14.v),
                                          CustomOutlinedButton(
                                              onTap: () {
                                                Navigator.pushNamed(
                                                    context,
                                                    AppRoutes
                                                        .halamanKasusastraanSubMenuParibasanScreen,
                                                    arguments: AppRoutes(
                                                        id: 0,
                                                        obj: objData));
                                              },
                                              text: "Contohing Paribasan",
                                              buttonStyle: CustomButtonStyles
                                                  .outlineBlack)
                                        ],
                                      ))))
                    : (id == 2)
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
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
                                itemCount: (objData != null)
                                    ? objData.length
                                    : 0,
                                itemBuilder: (context, index) {
                                  return SizedBox(
                                      child:
                                          (objData[index]['is_open'] ==
                                                  true)
                                              ? Container(
                                                  child: Column(
                                                    children: [
                                                      CustomOutlinedButton(
                                                          onTap: () {
                                                            objData[index]
                                                                    [
                                                                    'is_open'] =
                                                                !objData[
                                                                        index]
                                                                    ['is_open'];
                                                            print(objData[
                                                                    index]
                                                                ['is_open']);
                                                            setState(() {});
                                                          },
                                                          width: 329.h,
                                                          text: objData[
                                                                  index]['name']
                                                              .toString(),
                                                          alignment: Alignment
                                                              .topCenter),
                                                      Align(
                                                          alignment: Alignment
                                                              .bottomCenter,
                                                          child: Container(
                                                              width: 329.h,
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          14.h,
                                                                      vertical:
                                                                          22.v),
                                                              decoration:
                                                                  AppDecoration
                                                                      .outlineBlack901,
                                                              child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    SizedBox(
                                                                        height:
                                                                            7.v),
                                                                    (objData[index]['image'] !=
                                                                            null)
                                                                        ? CustomImageView(
                                                                            fit: BoxFit
                                                                                .contain,
                                                                            url: objData[index]['image'] ??
                                                                                '',
                                                                            imagePath:
                                                                                ImageConstant.imgFrame283x174,
                                                                            height: 83.v,
                                                                            width: 174.h,
                                                                            alignment: Alignment.center)
                                                                        : Container(),
                                                                    (objData[index]['image'] !=
                                                                            null)
                                                                        ? SizedBox(
                                                                            height:
                                                                                16.v)
                                                                        : Container(),
                                                                    Text(
                                                                        "${objData[index]['description'].toString().split('\\n').join('\n').split('\n ').join('\n')}",
                                                                        style: theme
                                                                            .textTheme
                                                                            .labelLarge),
                                                                    SizedBox(
                                                                        height:
                                                                            4.v),
                                                                  ]))),
                                                    ],
                                                  ),
                                                )
                                              : CustomOutlinedButton(
                                                  onTap: () {
                                                    if (objData[index]
                                                                ['child']
                                                            .toString() !=
                                                        '[]') {
                                                      Navigator.pushNamed(
                                                          context,
                                                          AppRoutes
                                                              .halamanKasusastraanSubMenuParibasanScreen,
                                                          arguments: AppRoutes(
                                                              id: 2,
                                                              obj:
                                                                  objData[
                                                                      index]));
                                                    } else {
                                                      objData[index]
                                                              ['is_open'] =
                                                          !objData[index]
                                                              ['is_open'];
                                                      print(objData[index]
                                                          ['is_open']);
                                                    }
                                                    setState(() {});
                                                  },
                                                  width: 329.h,
                                                  text: objData[index]
                                                          ['name']
                                                      .toString(),
                                                  alignment:
                                                      Alignment.topCenter));
                                }),
                          )
                        : SizedBox(
                width: mediaQueryData.size.width,
                child: SingleChildScrollView(
                    padding: EdgeInsets.only(top: 16.v),
                    child: Padding(
                        padding: EdgeInsets.only(
                            left: 25.h, right: 25.h, bottom: 5.v),
                        child: (open == true)
                            ? Column(children: [
                          SizedBox(
                              child: Column(children: [
                                CustomOutlinedButton(
                                    onTap: () {
                                      open = !open;
                                      setState(() {});
                                    },
                                    // width: 329.h,
                                    text: "Opo Niku Parikan",
                                    alignment: Alignment.topCenter),
                                Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5.h,
                                            vertical: 9.v),
                                        decoration: AppDecoration
                                            .outlineBlack901,
                                        child: Column(
                                            mainAxisSize:
                                            MainAxisSize.min,
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                            mainAxisAlignment:
                                            MainAxisAlignment.end,
                                            children: [
                                              SizedBox(height: 20.v),
                                              CustomImageView(
                                                  imagePath: ImageConstant
                                                      .imgFrame24,
                                                  height: 83.v,
                                                  width: 174.h,
                                                  alignment:
                                                  Alignment.center),
                                              Container(
                                                  width: 232.h,
                                                  margin: EdgeInsets.only(
                                                      top: 25.v,
                                                      right: 72.h),
                                                  child: Text(
                                                      "Unen-unen kang dumadi saka rong ukara. \nUkara sepisanan kanggo narik kawigaten, \nlan ukara kapindho minangka isi.",
                                                      maxLines: 3,
                                                      overflow: TextOverflow
                                                          .ellipsis,
                                                      style: theme.textTheme
                                                          .labelLarge)),
                                              SizedBox(height: 7.v),
                                              SizedBox(
                                                  width: 305.h,
                                                  child: Text(
                                                      "(Sebuah Kata-kata yang dibuat menjadi 2 kalimat.\nkalimat pertama berfungsi sebagai penarik perhatian,\nsementara kalimat ke dua menjadi isi pokok yang ingin\ndiutarakan)",
                                                      maxLines: 4,
                                                      overflow: TextOverflow
                                                          .ellipsis,
                                                      style: CustomTextStyles
                                                          .labelLarge_1)),
                                              Container(
                                                  width: 246.h,
                                                  margin: EdgeInsets.only(
                                                      top: 28.v,
                                                      right: 59.h),
                                                  child: Text(
                                                      "Parikan enten 2 macem :\nPitutur : Ngunakake ngaturake piweling, \npitutur, utawa amanat.\nPaseman : Ngunakake ngaturake hiburan\n lan ngemot guyonan utawa sindiran.",
                                                      maxLines: 5,
                                                      overflow: TextOverflow
                                                          .ellipsis,
                                                      style: theme.textTheme
                                                          .labelLarge)),
                                              Container(
                                                  width: 287.h,
                                                  margin: EdgeInsets.only(
                                                      top: 7.v,
                                                      right: 17.h),
                                                  child: Text(
                                                      "(Parikan ada 2 macam :\nPitutur : mengutarakan penyampaian pengingat,\nnasihat dan amanah.\nPaseman : mengutarakan penyampaian hiburan,\nbersendau-gurau ataupun sindiran)",
                                                      maxLines: 5,
                                                      overflow: TextOverflow
                                                          .ellipsis,
                                                      style: CustomTextStyles
                                                          .labelLarge_1))
                                            ]))),
                              ])),
                          SizedBox(height: 14.v),
                          CustomOutlinedButton(
                              onTap: () {
                                Navigator.pushReplacementNamed(
                                    context, AppRoutes.halamanKasusastraanSubMenuParibasanScreen,
                                    arguments: AppRoutes(id: 3, obj: objData));
                              },
                              text: "Contohing Parikan",
                              buttonStyle:
                              CustomButtonStyles.outlineBlack)
                        ])
                            : Column(
                          children: [
                            CustomOutlinedButton(
                                onTap: () {
                                  open = !open;
                                  setState(() {});
                                },
                                // width: 329.h,
                                text: "Opo Niku Parikan",
                                alignment: Alignment.topCenter),
                            SizedBox(height: 14.v),
                            CustomOutlinedButton(
                                onTap: () {
                                  Navigator.pushReplacementNamed(
                                      context, AppRoutes.halamanKasusastraanSubMenuParibasanScreen,
                                      arguments: AppRoutes(id: 3, obj: objData));
                                },
                                text: "Contohing Parikan",
                                buttonStyle: CustomButtonStyles
                                    .outlineBlack)
                          ],
                        ))))
                : Center(
                    child: Image.asset(
                      "assets/images/img_frame5.png",
                      width: MediaQuery.of(context).size.width / 1.4,
                      height: MediaQuery.of(context).size.width / 1.4,
                    ),
                  )));
  }

  /// Navigates back to the previous screen.
  ///
  /// This function takes a [BuildContext] object as a parameter, which is used
  /// to navigate back to the previous screen.
  onTapArrowleftone(BuildContext context) {
    Navigator.pop(context);
  }
}
