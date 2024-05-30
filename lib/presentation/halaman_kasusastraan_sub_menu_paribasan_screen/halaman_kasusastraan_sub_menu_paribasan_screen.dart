import 'dart:developer';

import 'package:kajak/core/app_export.dart';
import 'package:kajak/widgets/app_bar/appbar_image.dart';
import 'package:kajak/widgets/app_bar/appbar_title.dart';
import 'package:kajak/widgets/app_bar/custom_app_bar.dart';
import 'package:kajak/widgets/custom_outlined_button.dart';
import 'package:kajak/widgets/custom_search_view.dart';
import 'package:flutter/material.dart';

// ignore_for_file: must_be_immutable
class HalamanKasusastraanSubMenuParibasanScreen extends StatefulWidget {
  int id = 0;
  var obj = {};

  HalamanKasusastraanSubMenuParibasanScreen(this.id, this.obj, {Key? key})
      : super(key: key);

  _HalamanKasusastraanSubMenuParibasanScreen createState() =>
      _HalamanKasusastraanSubMenuParibasanScreen(id, obj);
}

class _HalamanKasusastraanSubMenuParibasanScreen
    extends State<HalamanKasusastraanSubMenuParibasanScreen> {
  _HalamanKasusastraanSubMenuParibasanScreen(this.id, this.obj);

  TextEditingController searchController = TextEditingController();

  int id = 0;
  var obj = {};
  var objData;
  var objDatas;

  bool open = true;

  void _onSearchChanged() {
    objDatas = objData.where((data) {
      if (id == 2) {
        if (data['name'] != null && searchController.text != null) {
          return data['name']
              .toString()
              .toLowerCase()
              .contains(searchController.text.toLowerCase());
        }
      } else if (id == 3) {
        if (data['parikan'] != null && searchController.text != null) {
          return data['parikan']
              .toString()
              .toLowerCase()
              .contains(searchController.text.toLowerCase());
        }
      } else {
        if (data['paribasan'] != null && searchController.text != null) {
          return data['paribasan']
              .toString()
              .toLowerCase()
              .contains(searchController.text.toLowerCase());
        }
      }
      return false;
    }).toList();
    // objDatas = objData
    //     .where((data) =>
    //         data['paribasan']!
    //             .toLowerCase()
    //             .contains(searchController.text.toLowerCase()) ||
    //         data['meaning_in_java']!
    //             .toLowerCase()
    //             .contains(searchController.text.toLowerCase()) ||
    //         data['meaning_in_indo']!
    //             .toLowerCase()
    //             .contains(searchController.text.toLowerCase()))
    //     .toList();
    setState(() {});
  }

  late FocusNode _focusNode;
  bool _isKeyboardOpen(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return !(mediaQuery.viewInsets.bottom == 0);
  }
  @override
  void initState() {
    log(obj.toString());
    if (id == 2) {
      objData = obj['child'];
    } else {
      objData = obj['data'];
    }
    searchController.addListener(_onSearchChanged);
    if (searchController.text == '') {
      objDatas = objData;
    }
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
                          "Kasusastraan (${(id == 2) ? 'Tembang' : (id == 3) ? 'Parikan' : 'Paribasan'})")),
              body: SizedBox(
                  width: mediaQueryData.size.width,
                  child: Padding(
                      padding: EdgeInsets.only(top: 13.v),
                      child: Padding(
                          padding: EdgeInsets.only(
                              left: 25.h, right: 25.h, bottom: 5.v),
                          child: Column(children: [
                            CustomSearchView(
                                controller: searchController,
                                autofocus: false,
                                focusNode: _focusNode,
                                hintText: _isKeyboardOpen(context) ? '' : "Golek Opo?",
                                suffix: Container(
                                    margin: EdgeInsets.fromLTRB(
                                        30.h, 10.v, 11.h, 11.v),
                                    child: CustomImageView(
                                        svgPath: ImageConstant.imgSearch)),
                                suffixConstraints:
                                    BoxConstraints(maxHeight: 43.v)),
                            SizedBox(height: 30.v),
                            (objDatas.length != 0)
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
                                        itemCount: (objDatas != null)
                                            ? objDatas.length
                                            : 0,
                                        itemBuilder: (context, index) {
                                          return (objDatas[index]['is_open'] ==
                                                  true)
                                              ? Column(
                                                  children: [
                                                    CustomOutlinedButton(
                                                        onTap: () {
                                                          objDatas[index]
                                                                  ['is_open'] =
                                                              !objDatas[index]
                                                                  ['is_open'];
                                                          print(objDatas[index]
                                                              ['is_open']);
                                                          setState(() {});
                                                        },
                                                        width: 329.h,
                                                        text: (id == 2)
                                                            ? "${objDatas[index]['name']}"
                                                            : (id == 3)
                                                                ? "${objDatas[index]['parikan']}"
                                                                : "${objDatas[index]['paribasan']}",
                                                        alignment:
                                                            Alignment.topCenter),
                                                    Align(
                                                        alignment: Alignment
                                                            .bottomCenter,
                                                        child: Container(
                                                            width: 329.h,
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        15.h,
                                                                    vertical:
                                                                        19.v),
                                                            decoration: AppDecoration
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
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                      (id == 2)
                                                                          ? "${objDatas[index]['description'].toString().split('\\n').join('\n').split('\n ').join('\n')}"
                                                                          : "${objDatas[index]['meaning_in_java'].toString().split('\\n').join('\n').split('\n ').join('\n')}\n\n${objDatas[index]['meaning_in_indo'].toString().split('\\n').join('\n').split('\n ').join('\n')}",
                                                                      style: theme
                                                                          .textTheme
                                                                          .labelLarge),
                                                                ]))),
                                                  ],
                                                )
                                              : CustomOutlinedButton(
                                                  onTap: () {
                                                    objDatas[index]['is_open'] =
                                                        !objDatas[index]
                                                            ['is_open'];
                                                    print(objDatas[index]
                                                        ['is_open']);
                                                    setState(() {});
                                                  },
                                                  width: 329.h,
                                                  text: (id == 2)
                                                      ? "${objDatas[index]['name']}"
                                                      : (id == 3)
                                                          ? "${objDatas[index]['parikan']}"
                                                          : "${objDatas[index]['paribasan']}",
                                                  alignment: Alignment.topCenter);
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
                            SizedBox(
                              height: 10.v,
                            )
                          ]))))),
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
