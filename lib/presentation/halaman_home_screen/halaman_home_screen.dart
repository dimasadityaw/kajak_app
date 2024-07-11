import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'package:kajak/core/app_export.dart';
import 'package:kajak/presentation/footer/footer.dart';
import 'package:kajak/view_models/home_view_model/home_view_model.dart';
import 'package:kajak/widgets/custom_elevated_button.dart';
import 'package:kajak/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HalamanHomeScreen extends StatefulWidget {
  HalamanHomeScreen({Key? key}) : super(key: key);

  @override
  _HalamanHomeScreenState createState() => _HalamanHomeScreenState();
}

class _HalamanHomeScreenState extends State<HalamanHomeScreen> {
  // late HomeViewModel homeViewModel;

  @override
  void initState() {
    // homeViewModel = HomeViewModel();
    super.initState();
  }

  @override
  void dispose() {
    // homeViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return ChangeNotifierProvider<HomeViewModel>(
      create: (_) => HomeViewModel(),
      child: Consumer<HomeViewModel>(builder: (context, viewModel, child) {
          return WillPopScope(
            onWillPop: () => viewModel.handleBackButton(context),
            child: SafeArea(
              child: GestureDetector(
                  onTap: () {
                    if (viewModel.focusNode.hasFocus) {
                      viewModel.focusNode.unfocus();
                    }
                  },
                  child: Scaffold(
                    resizeToAvoidBottomInset: false,
                    body: Center(
                      child: (!viewModel.isProfile)
                          ? Container(
                              alignment: Alignment.center,
                              width: 380.h,
                              padding: EdgeInsets.only(
                                right: 24.h,
                                left: 24.h,
                                top: 18.v,
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(
                                  bottom: 2.5.v,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: 200.h,
                                          child: Text(
                                            // "Sugeng Rawuh ing\nPepak Digital (Kajak)",
                                            "Sugeng Rawuh",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: theme.textTheme.titleLarge,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            // penggunaan true false untuk mengubah ke tampilan profile
                                            viewModel.isProfile =
                                                !viewModel.isProfile;
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
                                                size: MediaQuery.of(context)
                                                        .size
                                                        .width /
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
                                        // top: 7.v,
                                        top: 0.v,
                                      ),
                                      child: Container(
                                        // height: 154.v,
                                        height: 127.v,
                                        width: 330.h,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 1.h,
                                          vertical: 5.v,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            CustomImageView(
                                              svgPath:
                                                  ImageConstant.imgUndrawonlinel,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3.5,
                                              alignment: Alignment.centerLeft,
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2,
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
                                          ],
                                        ),
                                      ),
                                    ),
                                    // Card(
                                    //   clipBehavior: Clip.antiAlias,
                                    //   elevation: 0,
                                    //   color: Colors.white,
                                    //   margin: EdgeInsets.only(
                                    //     top: 7.v,
                                    //   ),
                                    //   shape: RoundedRectangleBorder(
                                    //     side: BorderSide(
                                    //       color: appTheme.black900,
                                    //       width: 1.h,
                                    //     ),
                                    //     borderRadius: BorderRadiusStyle.roundedBorder10,
                                    //   ),
                                    //   child: Container(
                                    //     height: 154.v,
                                    //     width: 330.h,
                                    //     padding: EdgeInsets.symmetric(
                                    //       horizontal: 1.h,
                                    //       vertical: 5.v,
                                    //     ),
                                    //     decoration: AppDecoration.outlineBlack.copyWith(
                                    //       borderRadius:
                                    //           BorderRadiusStyle.roundedBorder10,
                                    //     ),
                                    //     child: Stack(
                                    //       alignment: Alignment.topLeft,
                                    //       children: [
                                    //         CustomImageView(
                                    //           svgPath: ImageConstant.imgUndrawonlinel,
                                    //           height: 119.v,
                                    //           width: 164.h,
                                    //           alignment: Alignment.bottomRight,
                                    //         ),
                                    //         Align(
                                    //           alignment: Alignment.topLeft,
                                    //           child: Container(
                                    //             width: 201.h,
                                    //             margin: EdgeInsets.only(
                                    //               left: 17.h,
                                    //               top: 6.v,
                                    //             ),
                                    //             child: Text(
                                    //               "Belajar Bahasa Jawa Luwih Gampang lan Penak Ngo Aplikasi Pepak digital \n(Kajak)",
                                    //               maxLines: 4,
                                    //               overflow: TextOverflow.ellipsis,
                                    //               style: theme.textTheme.titleMedium,
                                    //             ),
                                    //           ),
                                    //         ),
                                    //       ],
                                    //     ),
                                    //   ),
                                    // ),
                                    CustomTextFormField(
                                      controller: viewModel.searchController,
                                      margin: EdgeInsets.only(
                                        top: 10.v,
                                      ),
                                      focusNode: viewModel.focusNode,
                                      hintText: viewModel.isKeyboardOpen(context)
                                          ? ''
                                          : "Golek Opo ?",
                                      hintStyle: theme.textTheme.labelLarge!
                                          .copyWith(
                                              fontSize: 13.fSize,
                                              color: Colors.grey),
                                      textInputAction: TextInputAction.done,
                                      suffix: Container(
                                        margin: EdgeInsets.fromLTRB(
                                            30.h, 10.v, 12.h, 9.v),
                                        child: CustomImageView(
                                          svgPath: ImageConstant.imgSearch,
                                        ),
                                      ),
                                      suffixConstraints: BoxConstraints(
                                        maxHeight: 38.v,
                                      ),
                                    ),
                                    (viewModel.homeDatas.length != 0)
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
                                                  itemCount: (viewModel.homeDatas !=
                                                          null)
                                                      ? viewModel.homeDatas.length
                                                      : 0,
                                                  itemBuilder: (context, index) {
                                                    return Column(
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () async {
                                                            SharedPreferences pref =
                                                                await SharedPreferences
                                                                    .getInstance();
                                                            viewModel.user =
                                                                json.decode(
                                                                    pref.getString(
                                                                        "user")!);
                                                            String attempt_id =
                                                                viewModel
                                                                    .user['attempt']
                                                                    .toString();
                                                            if (viewModel.homeDatas[
                                                                        index].title ==
                                                                'Wulangan') {
                                                              if (!viewModel
                                                                      .isLoading &&
                                                                  attempt_id !=
                                                                      'null') {
                                                                if (viewModel
                                                                    .hasConnectedRun) {
                                                                  viewModel
                                                                      .cekNilai(context);
                                                                }
                                                              } else if (!viewModel
                                                                      .isLoading &&
                                                                  attempt_id ==
                                                                      'null') {
                                                                ScaffoldMessenger
                                                                        .of(context)
                                                                    .showSnackBar(
                                                                        SnackBar(
                                                                  backgroundColor:
                                                                      Colors.grey,
                                                                  behavior:
                                                                      SnackBarBehavior
                                                                          .floating,
                                                                  content: Text(
                                                                      'Gaono wulangan.'),
                                                                ));
                                                              }
                                                            } else {
                                                              Navigator.pushNamed(
                                                                  context,
                                                                  viewModel.homeDatas[
                                                                          index].route);
                                                            }
                                                          },
                                                          child: Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                              horizontal: 29.h,
                                                              vertical: 13.v,
                                                            ),
                                                            decoration:
                                                                AppDecoration
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
                                                                SizedBox(
                                                                    height: 3.v),
                                                                Text(
                                                                  viewModel.homeDatas[
                                                                          index].title,
                                                                  style: theme
                                                                      .textTheme
                                                                      .titleMedium,
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .only(
                                                                    top: 3.v,
                                                                    right: 22.h,
                                                                  ),
                                                                  child: Text(
                                                                    viewModel.homeDatas[
                                                                                index].desc +
                                                                        "                        ",
                                                                    maxLines: 2,
                                                                    overflow:
                                                                        TextOverflow
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
                                                borderRadius: BorderRadiusStyle
                                                    .roundedBorder10,
                                              ),
                                              child: Container(
                                                width: 330.h,
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 1.h,
                                                ),
                                                decoration: AppDecoration
                                                    .outlineBlack
                                                    .copyWith(
                                                  borderRadius: BorderRadiusStyle
                                                      .roundedBorder10,
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
                                                          textAlign:
                                                              TextAlign.center,
                                                          overflow:
                                                              TextOverflow.ellipsis,
                                                          style: theme.textTheme
                                                              .titleMedium,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 12.v),
                                                    CustomImageView(
                                                      imagePath:
                                                          ImageConstant.notFound,
                                                    ),
                                                    SizedBox(height: 24.v),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                            )
                          : Container(
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
                                    Text(
                                        "Halo ${viewModel.nameTextController.text},",
                                        maxLines: 4,
                                        overflow: TextOverflow.ellipsis,
                                        style: theme.textTheme.titleMedium),
                                    SizedBox(height: 12.v),
                                    Text("Nisn",
                                        style: theme.textTheme.titleMedium),
                                    SizedBox(height: 6.v),
                                    CustomTextFormField(
                                        readonly: true,
                                        controller: viewModel.nisnTextController,
                                        borderDecoration:
                                            TextFormFieldStyleHelper.fillBlueGray,
                                        fillColor: appTheme.blueGray10001),
                                    SizedBox(height: 5.v),
                                    Text("Kelas",
                                        style: theme.textTheme.titleMedium),
                                    SizedBox(height: 6.v),
                                    CustomTextFormField(
                                        readonly: true,
                                        controller: viewModel.kelasTextController,
                                        borderDecoration:
                                            TextFormFieldStyleHelper.fillBlueGray,
                                        fillColor: appTheme.blueGray10001),
                                    SizedBox(height: 38.v),
                                    CustomElevatedButton(
                                        onTap: () {
                                          // penggunaan true false untuk mengubah ke tampilan home
                                          viewModel.isProfile =
                                              !viewModel.isProfile;
                                          setState(() {});
                                        },
                                        text: "Kembali ke Home",
                                        alignment: Alignment.center),
                                    SizedBox(height: 10.v),
                                    CustomElevatedButton(
                                        onTap: () {
                                          if (viewModel.isLoading != true) {
                                            if (viewModel.isConnected) {
                                              viewModel.logOut(context);
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .hideCurrentSnackBar();
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                backgroundColor: Colors.red,
                                                behavior: SnackBarBehavior.floating,
                                                content: Text(
                                                    'Periksa kembali jaringan anda.',
                                                    style: theme
                                                        .textTheme.titleMedium
                                                        ?.copyWith(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w600)),
                                              ));
                                            }
                                          }
                                          setState(() {});
                                        },
                                        buttonStyle: ButtonStyle(
                                            backgroundColor:
                                                WidgetStateProperty.all(
                                                    viewModel.isConnected
                                                        ? Colors.red
                                                        : Colors.grey)),
                                        text: (!viewModel.isLoading)
                                            ? "Keluar"
                                            : "Tunggu...",
                                        alignment: Alignment.center)
                                  ])),
                    ),
                    bottomNavigationBar: !viewModel.isConnected
                        ? Container(
                            color: Colors.red,
                            padding: EdgeInsets.symmetric(vertical: 2.5.h),
                            child: FooterMenu())
                        : SizedBox(),
                  ),
                ),
            ),
          );
        }
      ),
    );
  }
}
