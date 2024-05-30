import 'dart:developer';

import 'package:kajak/core/app_export.dart';
import 'package:kajak/widgets/app_bar/appbar_image.dart';
import 'package:kajak/widgets/app_bar/appbar_title.dart';
import 'package:kajak/widgets/app_bar/custom_app_bar.dart';
import 'package:kajak/widgets/custom_outlined_button.dart';
import 'package:flutter/material.dart';

class HalamanParamasastraSubMenu extends StatefulWidget {
  var obj = {};

  HalamanParamasastraSubMenu(this.obj, {Key? key}) : super(key: key);

  @override
  _HalamanParamasastraSubMenuState createState() =>
      _HalamanParamasastraSubMenuState(obj);
}

class _HalamanParamasastraSubMenuState
    extends State<HalamanParamasastraSubMenu> {
  _HalamanParamasastraSubMenuState(this.obj);

  bool open = true;
  var obj = {};

  @override
  void initState() {
    print('obj.toString()');
    log(obj.toString());
    // if (obj['child'].toString() != '[]') {
    //   obj['child'].forEach((data) {
    //     data['is_open'] = false;
    //   });
    // }
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
                title: AppbarTitle(text: "Paramasastra (${obj['name']})")),
            body: (obj['child'].toString() == '[]')
                ? SizedBox(
                    width: mediaQueryData.size.width,
                    child: SingleChildScrollView(
                        padding: EdgeInsets.only(top: 24.v),
                        child: Container(
                            // height: 147.v,
                            width: 329.h,
                            margin: EdgeInsets.only(
                                left: 25.h, right: 25.h, bottom: 5.v),
                            child: (obj['is_open'] == true)
                                ? Column(
                                    children: [
                                      CustomOutlinedButton(
                                          onTap: () {
                                            obj['is_open'] = !obj['is_open'];
                                            print(obj['is_open']);
                                            setState(() {});
                                          },
                                          width: 329.h,
                                          text: "${obj['name']}",
                                          alignment: Alignment.topCenter),
                                      Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Container(
                                              width: 329.h,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 15.h,
                                                  vertical: 19.v),
                                              decoration:
                                                  AppDecoration.outlineBlack901,
                                              child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                        "${obj['description'].toString().split('\\n').join('\n').split('\n ').join('\n')}",
                                                        style: theme.textTheme
                                                            .labelLarge),
                                                  ]))),
                                    ],
                                  )
                                : CustomOutlinedButton(
                                    onTap: () {
                                      obj['is_open'] = !obj['is_open'];
                                      print(obj['is_open']);
                                      setState(() {});
                                    },
                                    width: 329.h,
                                    text: "${obj['name']}",
                                    alignment: Alignment.topCenter))))
                : SizedBox(
                    width: mediaQueryData.size.width,
                    child: Padding(
                        padding: EdgeInsets.only(top: 9.v),
                        child: Padding(
                            padding: EdgeInsets.only(
                                left: 25.h, right: 25.h, bottom: 5.v),
                            child: ListView(shrinkWrap: true, children: [
                              Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 33.h, vertical: 36.v),
                                  decoration: AppDecoration.outlineBlack900
                                      .copyWith(
                                          borderRadius: BorderRadiusStyle
                                              .roundedBorder10),
                                  child: SizedBox(
                                      // width: 202.h,
                                      child: ListView(
                                    shrinkWrap: true,
                                    children: [
                                      Text(
                                          "${obj['description'].toString().split('\\n').join('\n').split('\n ').join('\n')}",
                                          maxLines: 9999,
                                          overflow: TextOverflow.ellipsis,
                                          style: theme.textTheme.titleMedium),
                                    ],
                                  ))),
                              SizedBox(height: 19.v),
                              ListView.separated(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  separatorBuilder: (
                                    context,
                                    index,
                                  ) {
                                    return SizedBox(
                                      height: 10.v,
                                    );
                                  },
                                  itemCount: (obj['child'] != null)
                                      ? obj['child'].length
                                      : 0,
                                  itemBuilder: (context, index) {
                                    return (obj['child'][index]['is_open'] ==
                                            true)
                                        ? Column(
                                            children: [
                                              CustomOutlinedButton(
                                                  onTap: () {
                                                    obj['child'][index]
                                                            ['is_open'] =
                                                        !obj['child'][index]
                                                            ['is_open'];
                                                    print(obj['child'][index]
                                                        ['is_open']);
                                                    setState(() {});
                                                  },
                                                  width: 329.h,
                                                  text:
                                                      "${obj['child'][index]['name']}",
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
                                                              vertical: 19.v),
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
                                                                "${obj['child'][index]['description'].toString().split('\\n').join('\n').split('\n ').join('\n')}",
                                                                style: theme
                                                                    .textTheme
                                                                    .labelLarge),
                                                          ]))),
                                            ],
                                          )
                                        : CustomOutlinedButton(
                                            onTap: () {
                                              obj['child'][index]['is_open'] =
                                                  !obj['child'][index]
                                                      ['is_open'];
                                              print(obj['child'][index]
                                                  ['is_open']);
                                              setState(() {});
                                            },
                                            width: 329.h,
                                            text:
                                                "${obj['child'][index]['name']}",
                                            alignment: Alignment.topCenter);
                                  }),
                            ]))))));
  }

  /// Navigates back to the previous screen.
  ///
  /// This function takes a [BuildContext] object as a parameter, which is used
  /// to navigate back to the previous screen.
  onTapArrowleftone(BuildContext context) {
    Navigator.pop(context);
  }
}
