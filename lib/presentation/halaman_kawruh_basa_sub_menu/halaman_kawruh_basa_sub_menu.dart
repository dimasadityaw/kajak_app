import 'dart:async';
import 'dart:convert';

import 'package:kajak/ConnectivityService.dart';
import 'package:kajak/core/app_export.dart';
import 'package:kajak/database_helper/kawruh_basa.dart';
import 'package:kajak/presentation/footer/footer.dart';
import 'package:kajak/widgets/app_bar/appbar_image.dart';
import 'package:kajak/widgets/app_bar/appbar_title.dart';
import 'package:kajak/widgets/app_bar/custom_app_bar.dart';
import 'package:kajak/widgets/custom_outlined_button.dart';
import 'package:kajak/widgets/custom_search_view.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';

import 'package:skeletonizer/skeletonizer.dart';

class HalamanKawruhBasaSubMenu extends StatefulWidget {
  int id = 0;

  HalamanKawruhBasaSubMenu(this.id, {Key? key}) : super(key: key);

  _HalamanKawruhBasaSubMenu createState() => _HalamanKawruhBasaSubMenu(id);
}

class _HalamanKawruhBasaSubMenu extends State<HalamanKawruhBasaSubMenu> {
  _HalamanKawruhBasaSubMenu(this.id);

  TextEditingController searchController = TextEditingController();
  bool open = true;
  int id = 0;
  var user;
  var data = {};
  var arananData;
  var arananDatas;
  bool isLoading = true;

  var datas = [
    {
      "id": 1,
      "title": "Rupa - Rupa Kawruh Basa Aranan Kembang",
    },
    {
      "id": 2,
      "title": "Rupa - Rupa Kawruh Basa Aranan Bocah",
    },
    {
      "id": 3,
      "title": "Rupa - Rupa Kawruh Basa Aranan Wektu",
    },
    {
      "id": 4,
      "title": "Rupa - Rupa Kawruh Basa Aranan Anak Kewan",
    },
  ];

  Future _getData() async {
    isLoading = true;
    if (isConnected) {
      SharedPreferences pref = await SharedPreferences.getInstance();
      user = json.decode(pref.getString("user")!);
      String token = user['token'];
      // id untuk get data apakah Aranan Kembang, Aranan Bocah, Aranan Wektu, atau Aranan Anak Kewan
      var apiResult = await http.get(
          Uri.parse(
              '${const String.fromEnvironment('apiUrl')}/aranan?type=$id'),
          headers: {
            "Accept": "Application/json",
            "Authorization": "Bearer $token"
          });
      var data = json.decode(apiResult.body);

      arananData = data['data'];

      await KawruhBasa().insertKawruhBasaData(data);

      if (searchController.text == '') {
        arananDatas = arananData;
      }
      isLoading = false;
      setState(() {});
    } else {
      arananData = await KawruhBasa().getKawruhBasaData(id.toString());
      if (searchController.text == '') {
        arananDatas = arananData['data'];
      }
      isLoading = false;
      setState(() {});
    }
  }

  void _onSearchChanged() {
    arananDatas = arananData.where((data) {
      if (data['javanese'] != null &&
          data['aranan'] != null &&
          data['indonesian'] != null &&
          searchController.text != null) {
        return data['javanese']
                .toString()
                .toLowerCase()
                .contains(searchController.text.toLowerCase()) ||
            data['aranan']
                .toString()
                .toLowerCase()
                .contains(searchController.text.toLowerCase()) ||
            data['indonesian']
                .toString()
                .toLowerCase()
                .contains(searchController.text.toLowerCase());
      }
      return false;
    }).toList();
    setState(() {});
  }

  late FocusNode _focusNode;

  bool _isKeyboardOpen(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return !(mediaQuery.viewInsets.bottom == 0);
  }

  StreamSubscription<bool>? _connectivitySubscription;
  bool isConnected = true;
  bool hasConnectedRun = false;

  @override
  void initState() {
    searchController.addListener(_onSearchChanged);
    // mengambil title berdasarkan id dari halaman sebelumnya
    data = datas.firstWhere((element) => element['id'] == id, orElse: () => {});
    _connectivitySubscription =
        ConnectivityService.connectivityStream.listen((status) {
      setState(() {
        isConnected = status;
        if (!hasConnectedRun) {
          Future.delayed(Duration.zero, () {
            _getData();
            hasConnectedRun = true;
          });
        }
      });
    });
    _focusNode = FocusNode();
    setState(() {});
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    _focusNode.dispose();
    _connectivitySubscription?.cancel();
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
                margin: EdgeInsets.only(left: 13.h, top: 15.v, bottom: 15.v),
                onTap: () {
                  onTapArrowleftone(context);
                }),
            centerTitle: true,
            title: AppbarTitle(
                text: (data['title'] ?? 'Kesalahan Data').toString())),
        body: SizedBox(
            width: mediaQueryData.size.width,
            child: Padding(
                padding: EdgeInsets.only(top: 13.v, bottom: 13.v),
                child: Padding(
                    padding:
                        EdgeInsets.only(left: 25.h, right: 25.h, bottom: 5.v),
                    child: Column(children: [
                      CustomSearchView(
                          controller: searchController,
                          focusNode: _focusNode,
                          hintText:
                              _isKeyboardOpen(context) ? '' : "Golek Opo?",
                          autofocus: false,
                          suffix: Container(
                              margin:
                                  EdgeInsets.fromLTRB(30.h, 10.v, 11.h, 11.v),
                              child: CustomImageView(
                                  svgPath: ImageConstant.imgSearch)),
                          suffixConstraints: BoxConstraints(maxHeight: 43.v)),
                      SizedBox(height: 30.v),
                      (!isLoading && arananDatas.length == 0)
                          ? Card(
                              clipBehavior: Clip.antiAlias,
                              elevation: 0,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: appTheme.black900,
                                  width: 1.h,
                                ),
                                borderRadius: BorderRadiusStyle.roundedBorder10,
                              ),
                              child: Container(
                                width: 330.h,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 1.h,
                                ),
                                decoration: AppDecoration.outlineBlack.copyWith(
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
                                          style: theme.textTheme.titleMedium,
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
                            )
                          : Flexible(
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
                                  itemCount: (arananDatas != null)
                                      ? arananDatas.length
                                      : isLoading
                                          ? 12
                                          : 0,
                                  itemBuilder: (context, index) {
                                    return isLoading
                                        ? Skeletonizer(
                                            enabled: isLoading,
                                            containersColor: Colors.grey,
                                            child: CustomOutlinedButton(
                                                width: 329.h,
                                                text: 'Tunggu sebentar . . .',
                                                alignment: Alignment.topCenter),
                                          )
                                        : SizedBox(
                                            child:
                                                (arananDatas[index]
                                                            ['is_open'] ==
                                                        true)
                                                    ? Container(
                                                        child: Column(
                                                          children: [
                                                            CustomOutlinedButton(
                                                                onTap: () {
                                                                  arananDatas[
                                                                          index]
                                                                      [
                                                                      'is_open'] = !arananDatas[
                                                                          index]
                                                                      [
                                                                      'is_open'];
                                                                  setState(
                                                                      () {});
                                                                },
                                                                width: 329.h,
                                                                text: arananDatas[
                                                                            index]
                                                                        [
                                                                        'indonesian']
                                                                    .toString(),
                                                                alignment: Alignment
                                                                    .topCenter),
                                                            Align(
                                                                alignment: Alignment
                                                                    .bottomCenter,
                                                                child:
                                                                    Container(
                                                                        width: 329
                                                                            .h,
                                                                        padding: EdgeInsets.symmetric(
                                                                            horizontal: 14
                                                                                .h,
                                                                            vertical: 22
                                                                                .v),
                                                                        decoration:
                                                                            AppDecoration
                                                                                .outlineBlack901,
                                                                        child: Column(
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            mainAxisAlignment: MainAxisAlignment.end,
                                                                            children: [
                                                                              SizedBox(height: 7.v),
                                                                              CustomImageView(fit: BoxFit.contain, url: arananDatas[index]['img'] ?? '', imagePath: ImageConstant.imgFrame283x174, height: 183.v, width: 224.h, alignment: Alignment.center),
                                                                              SizedBox(height: 16.v),
                                                                              Text("${arananDatas[index]['indonesian'][0].toUpperCase()}${arananDatas[index]['indonesian'].toString().substring(1).toLowerCase()}", style: theme.textTheme.titleMedium),
                                                                              SizedBox(height: 2.v),
                                                                              Text("Aranan: ${arananDatas[index]['aranan']}", style: theme.textTheme.titleMedium),
                                                                              SizedBox(height: 4.v),
                                                                              SizedBox(child: Text("(${arananDatas[index]['indonesian']} dalam bahasa jawa\ndisebut ${(arananDatas[index]['javanese'].toString().contains(' ')) ? arananDatas[index]['javanese'].toString().trimRight() : arananDatas[index]['javanese'].toString()})", maxLines: 8, overflow: TextOverflow.ellipsis, style: theme.textTheme.titleMedium))
                                                                            ]))),
                                                          ],
                                                        ),
                                                      )
                                                    : CustomOutlinedButton(
                                                        onTap: () {
                                                          arananDatas[index]
                                                                  ['is_open'] =
                                                              !arananDatas[
                                                                      index]
                                                                  ['is_open'];
                                                          setState(() {});
                                                        },
                                                        width: 329.h,
                                                        text: arananDatas[index]
                                                                ['indonesian']
                                                            .toString(),
                                                        alignment: Alignment
                                                            .topCenter));
                                  }),
                            ),
                    ])))),
        bottomNavigationBar: !isConnected
            ? Container(
                color: Colors.red,
                padding: EdgeInsets.symmetric(vertical: 2.5.h),
                child: FooterMenu())
            : SizedBox(),
      ),
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
