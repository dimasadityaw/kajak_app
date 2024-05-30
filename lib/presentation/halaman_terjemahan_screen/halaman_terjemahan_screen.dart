import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kajak/core/app_export.dart';
import 'package:kajak/widgets/app_bar/appbar_image.dart';
import 'package:kajak/widgets/app_bar/appbar_title.dart';
import 'package:kajak/widgets/app_bar/custom_app_bar.dart';
import 'package:kajak/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class HalamanTerjemahanScreen extends StatefulWidget {
  const HalamanTerjemahanScreen({Key? key}) : super(key: key);

  @override
  _HalamanTerjemahanScreenState createState() =>
      _HalamanTerjemahanScreenState();
}

class _HalamanTerjemahanScreenState extends State<HalamanTerjemahanScreen> {
  TextEditingController textController = TextEditingController();
  TextEditingController textOutputController = TextEditingController();
  late ImagePicker _picker;

  Widget imagePickAlert({
    void Function()? onCameraPressed,
    void Function()? onGalleryPressed,
  }) {
    return AlertDialog(
      title: const Text(
        "Pick a source:",
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text(
              "Camera",
            ),
            onTap: onCameraPressed,
          ),
          ListTile(
            leading: const Icon(Icons.image),
            title: const Text(
              "Gallery",
            ),
            onTap: onGalleryPressed,
          ),
        ],
      ),
    );
  }

  Future<String?> obtainImage(ImageSource source) async {
    final file = await _picker.pickImage(source: source);
    return file?.path;
  }

  bool showInputBox = true;
  bool isLoadingOcr = false;

  Future checkPermissionStorage() async {
    if (Permission.storage.status.toString().contains('granted')) {
      final imgPath = await obtainImage(ImageSource.gallery);
      if (imgPath == null) return;
      final croppedFile = await ImageCropper.platform.cropImage(
        sourcePath: imgPath,
        // aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Pangkas',
              toolbarColor: Colors.white,
              toolbarWidgetColor: Colors.black,
              backgroundColor: Colors.white,
              activeControlsWidgetColor: Colors.grey,
              cropFrameColor: Colors.grey,
              dimmedLayerColor: Colors.grey.withOpacity(0.75),
              showCropGrid: false,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false)
        ],
        // compressQuality: 100,
        // maxWidth: 700,
        // maxHeight: 700,
        compressFormat: ImageCompressFormat.png,
      );

      if (croppedFile != null) {
        isLoadingOcr = true;
        textController.text = '';
        final ocrText = await FlutterTesseractOcr.extractText(croppedFile.path,
            language: 'ind', args: {"preserve_interword_spaces": "1"});
        setState(() {
          textController.text = ocrText;
          isLoadingOcr = false;
        });
      }
      // textController.text = await FlutterTesseractOcr.extractText(imgPath,
      //     language: 'ind', args: {"preserve_interword_spaces": "1"});
      setState(() {});
    } else {
      Permission.storage.request().then((value) async {
        if (value.toString().contains('granted')) {
          final imgPath = await obtainImage(ImageSource.gallery);
          if (imgPath == null) return;
          final croppedFile = await ImageCropper.platform.cropImage(
            sourcePath: imgPath,
            // aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
            uiSettings: [
              AndroidUiSettings(
                  toolbarTitle: 'Pangkas',
                  toolbarColor: Colors.white,
                  toolbarWidgetColor: Colors.black,
                  backgroundColor: Colors.white,
                  activeControlsWidgetColor: Colors.grey,
                  cropFrameColor: Colors.grey,
                  dimmedLayerColor: Colors.grey.withOpacity(0.75),
                  showCropGrid: false,
                  initAspectRatio: CropAspectRatioPreset.original,
                  lockAspectRatio: false)
            ],
            // compressQuality: 100,
            // maxWidth: 700,
            // maxHeight: 700,
            compressFormat: ImageCompressFormat.png,
          );

          if (croppedFile != null) {
            isLoadingOcr = true;
            textController.text = '';
            final ocrText = await FlutterTesseractOcr.extractText(
                croppedFile.path,
                language: 'ind',
                args: {"preserve_interword_spaces": "1"});
            setState(() {
              textController.text = ocrText;
              isLoadingOcr = false;
            });
          }
          // textController.text = await FlutterTesseractOcr.extractText(imgPath,
          //     language: 'ind', args: {"preserve_interword_spaces": "1"});
          setState(() {});
        }
      });
    }
  }

  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = "";

  Future checkPermissionMicrophone() async {
    if (Permission.microphone.status.toString().contains('granted')) {
      _speechToText.isNotListening ? _startListening() : _stopListening();
      setState(() {});
    } else {
      Permission.microphone.request().then((value) async {
        if (value.toString().contains('granted')) {
          _speechToText.isNotListening ? _startListening() : _stopListening();
          setState(() {});
        }
      });
    }
  }

  // void _initSpeech() async {
  //   _speechEnabled = await _speechToText.initialize();
  // }

  void _startListening() async {
    await _speechToText.listen(
      onResult: _onSpeechResult,
      listenFor: const Duration(seconds: 30),
      localeId: "en_En",
      cancelOnError: false,
      partialResults: false,
      listenMode: ListenMode.confirmation,
    );
    setState(() {});
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = "$_lastWords${result.recognizedWords} ";
      textController.text = _lastWords;
    });
  }

  bool isInputBox = true;

  void _onSearchChanged() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (textController.text == '') {
      isInputBox = true;
      pref.remove('textController');
    } else {
      isInputBox = false;
      pref.setString('textController', textController.text);
    }
    setState(() {});
  }

  final List<String> listTranslate = [
    'Bahasa Indonesia',
    'Bahasa Jawa (Ngoko)',
    'Bahasa Jawa (Madya)',
    'Bahasa Jawa (Krama)',
  ];

  String translateFrom = 'Bahasa Indonesia';
  String translateTo = 'Bahasa Jawa (Ngoko)';

  Future checkSharedPreferences() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    translateFrom = pref.getString('translateFrom') ?? 'Bahasa Indonesia';
    translateTo = pref.getString('translateTo') ?? 'Bahasa Jawa (Ngoko)';
    textController.text = pref.getString('textController') ?? '';
    setState(() {});
  }

  bool isLoading = false;
  var user;

  Future _terjemah() async {
    isLoading = true;
    SharedPreferences pref = await SharedPreferences.getInstance();
    user = json.decode(pref.getString("user")!);
    String token = user['token'];
    var from = translateFrom
        .toString()
        .replaceAll('Bahasa ', '')
        .replaceAll('Indonesia', 'Indonesian')
        .replaceAll('Jawa ', '')
        .replaceAll('(', '')
        .replaceAll(')', '')
        .toLowerCase();
    var to = translateTo
        .toString()
        .replaceAll('Bahasa ', '')
        .replaceAll('Indonesia', 'Indonesian')
        .replaceAll('Jawa ', '')
        .replaceAll('(', '')
        .replaceAll(')', '')
        .toLowerCase();
    var apiResult = await http
        .post(Uri.parse('http://kaja.cemzpex.com/api/translate'), body: {
      'from': from.toString(),
      'to': to.toString(),
      'text': textController.text.toString()
    }, headers: {
      "Accept": "Application/json",
      "Authorization": "Bearer $token"
    });
    var data = json.decode(apiResult.body);
    textOutputController.text = data.toString().trim();
    if (textOutputController.text == '') {
      // Fluttertoast.showToast(msg: 'Gaonok terjemahane...');
    }
    print('data');
    print(data);
    print(translateFrom
        .toString()
        .replaceAll('Bahasa ', '')
        .replaceAll('Indonesia', 'Indonesian')
        .replaceAll('Jawa ', '')
        .replaceAll('(', '')
        .replaceAll(')', '')
        .toLowerCase());
    print(translateTo
        .toString()
        .replaceAll('Bahasa ', '')
        .replaceAll('Indonesia', 'Indonesian')
        .replaceAll('Jawa ', '')
        .replaceAll('(', '')
        .replaceAll(')', '')
        .toLowerCase());
    print(textController.text.toString());

    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _picker = ImagePicker();
    textController.addListener(_onSearchChanged);
    checkSharedPreferences();
    // if (!_speechEnabled) {
    //   _initSpeech();
    // }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return SafeArea(
        child: Scaffold(
            appBar: CustomAppBar(
                height: 55.v,
                leadingWidth: 35.h,
                leading: AppbarImage(
                    svgPath: ImageConstant.imgArrowleft,
                    margin:
                        EdgeInsets.only(left: 10.h, top: 15.v, bottom: 15.v),
                    onTap: () {
                      onTapArrowleftone(context);
                    }),
                centerTitle: true,
                title: AppbarTitle(text: "Terjemahan")),
            body: SizedBox(
                width: mediaQueryData.size.width,
                child: SingleChildScrollView(
                    padding: EdgeInsets.only(top: 26.v),
                    child: Padding(
                        padding: EdgeInsets.only(
                            left: 24.h, right: 24.h, bottom: 5.v),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Pilih Bahasa",
                                  style: CustomTextStyles.labelLargeMedium_1),
                              SizedBox(height: 5.v),
                              Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 7.h, vertical: 10.v),
                                  decoration: AppDecoration.outlineGray
                                      .copyWith(
                                          borderRadius: BorderRadiusStyle
                                              .roundedBorder10),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Spacer(),
                                        DropdownButtonHideUnderline(
                                            child: DropdownButton2<String>(
                                          isExpanded: true,
                                          hint: Text(
                                            'Terjemah dari',
                                            style: CustomTextStyles
                                                .labelLargeMedium_1,
                                          ),
                                          items: listTranslate
                                              .map((String item) =>
                                                  DropdownMenuItem<String>(
                                                    value: item,
                                                    child: Text(
                                                      item,
                                                      style: (item.toString() ==
                                                              translateFrom
                                                                  .toString())
                                                          ? CustomTextStyles
                                                              .labelLargeMedium_2
                                                          : CustomTextStyles
                                                              .labelLargeMedium_1,
                                                    ),
                                                  ))
                                              .toList(),
                                          value: translateFrom,
                                          onChanged: (String? value) async {
                                            SharedPreferences pref =
                                                await SharedPreferences
                                                    .getInstance();
                                            setState(() {
                                              translateFrom = value!;
                                              pref.setString('translateFrom',
                                                  translateFrom);
                                            });
                                          },
                                          iconStyleData: IconStyleData(
                                              iconEnabledColor: Colors.grey,
                                              openMenuIcon:
                                                  Icon(Icons.arrow_drop_up)),
                                          buttonStyleData:
                                              const ButtonStyleData(
                                            decoration: BoxDecoration(
                                                color: Colors.white),
                                            width: 140,
                                          ),
                                          dropdownStyleData: DropdownStyleData(
                                              decoration: BoxDecoration(
                                                  color: Colors.white)),
                                          menuItemStyleData:
                                              const MenuItemStyleData(
                                            height: 40,
                                          ),
                                        )),
                                        // Text("Bahasa Indonesia",
                                        //     style: CustomTextStyles
                                        //         .labelLargeMedium_1),
                                        Spacer(),
                                        CustomImageView(
                                            svgPath:
                                                ImageConstant.imgArrowright),
                                        Spacer(),
                                        DropdownButtonHideUnderline(
                                            child: DropdownButton2<String>(
                                          isExpanded: true,
                                          hint: Text(
                                            'Terjemah ke',
                                            style: CustomTextStyles
                                                .labelLargeMedium_1,
                                          ),
                                          items: listTranslate
                                              .map((String item) =>
                                                  DropdownMenuItem<String>(
                                                    value: item,
                                                    child: Text(
                                                      item,
                                                      style: (item.toString() ==
                                                              translateTo
                                                                  .toString())
                                                          ? CustomTextStyles
                                                              .labelLargeMedium_2
                                                          : CustomTextStyles
                                                              .labelLargeMedium_1,
                                                    ),
                                                  ))
                                              .toList(),
                                          value: translateTo,
                                          onChanged: (String? value) async {
                                            SharedPreferences pref =
                                                await SharedPreferences
                                                    .getInstance();
                                            setState(() {
                                              translateTo = value!;
                                              pref.setString(
                                                  'translateTo', translateTo);
                                            });
                                          },
                                          iconStyleData: IconStyleData(
                                              iconEnabledColor: Colors.grey,
                                              openMenuIcon:
                                                  Icon(Icons.arrow_drop_up)),
                                          buttonStyleData:
                                              const ButtonStyleData(
                                            decoration: BoxDecoration(
                                                color: Colors.white),
                                            width: 140,
                                          ),
                                          dropdownStyleData: DropdownStyleData(
                                              decoration: BoxDecoration(
                                                  color: Colors.white)),
                                          menuItemStyleData:
                                              const MenuItemStyleData(
                                            height: 40,
                                          ),
                                        )),
                                        // Padding(
                                        //     padding: EdgeInsets.only(left: 6.h),
                                        //     child: Text("Bahasa Jawa (Ngoko)",
                                        //         style: CustomTextStyles
                                        //             .labelLargeMedium_1)),
                                        Spacer(),
                                        // CustomImageView(
                                        //     svgPath: ImageConstant.imgArrowdown,
                                        //     height: 15.adaptSize,
                                        //     width: 15.adaptSize,
                                        //     margin: EdgeInsets.only(
                                        //         right: 2.h, bottom: 2.v))
                                      ])),
                              SizedBox(height: 7.v),
                              Text(translateFrom.toString(),
                                  style: CustomTextStyles.labelLargeMedium_1),
                              SizedBox(height: 3.v),
                              Center(
                                  child: Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: appTheme.gray300,
                                                width: 1),
                                            borderRadius:
                                                BorderRadius.circular(10.h)),
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              // top: 10.v,
                                              right: 35.h),
                                          child: TextField(
                                            readOnly: (isLoadingOcr == true)
                                                ? true
                                                : false,
                                            keyboardType:
                                                TextInputType.multiline,
                                            maxLines: 8,
                                            style: theme.textTheme.titleMedium,
                                            controller: textController,
                                            cursorColor: Colors.grey,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 10.h,
                                                      vertical: 5.v),
                                              hintText: "",
                                              hintStyle:
                                                  CustomTextStyles.labelLarge13,
                                              isDense: true,
                                              fillColor:
                                                  theme.colorScheme.primary,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                            ),
                                            textInputAction:
                                                TextInputAction.newline,
                                          ),
                                        ),
                                      ),
                                      Text(
                                          (isInputBox == true)
                                              ? (isLoadingOcr == true)
                                                  ? "Tunggu..."
                                                  : "Input Box"
                                              : '',
                                          style: CustomTextStyles
                                              .labelLargeMedium_1)
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        bottom: 12.v, right: 16.h),
                                    // margin: EdgeInsets.fromLTRB(
                                    //     30.h, 10.v, 12.h, 9.v),
                                    child: Container(
                                      color: Colors.white,
                                      child: CustomImageView(
                                        height: 21.adaptSize,
                                        onTap: () {
                                          checkPermissionStorage();
                                          setState(() {});
                                        },
                                        color: Colors.grey,
                                        svgPath:
                                            ImageConstant.imgIconmediaimage,
                                      ),
                                    ),
                                  )
                                ],
                              )),
                              // Center(
                              //   child: SizedBox(
                              //       height: 160.v,
                              //       width: 330.h,
                              //       child: Stack(
                              //           alignment: Alignment.center,
                              //           children: [
                              //             _ocrText == ""
                              //                 ? Align(
                              //                     alignment: Alignment.center,
                              //                     child: Text("Input Box",
                              //                         style: CustomTextStyles
                              //                             .labelLargeMedium_1))
                              //                 : Padding(
                              //                   padding: const EdgeInsets.all(8.0),
                              //                   child: Align(
                              //                       alignment: Alignment.topLeft,
                              //                       child: Text(_ocrText)),
                              //                 ),
                              //             Align(
                              //                 alignment: Alignment.center,
                              //                 child: Container(
                              //                     padding: EdgeInsets.symmetric(
                              //                         horizontal: 10.h,
                              //                         vertical: 8.v),
                              //                     decoration: AppDecoration
                              //                         .outlineGray300
                              //                         .copyWith(
                              //                             borderRadius:
                              //                                 BorderRadiusStyle
                              //                                     .roundedBorder10),
                              //                     child: Row(
                              //                         mainAxisAlignment:
                              //                             MainAxisAlignment.end,
                              //                         crossAxisAlignment:
                              //                             CrossAxisAlignment
                              //                                 .end,
                              //                         children: [
                              //                           CustomImageView(
                              //                               onTap: () {
                              //                                 checkPermissionStorage();
                              //                                 setState(() {});
                              //                               },
                              //                               color: Colors.grey,
                              //                               svgPath: ImageConstant
                              //                                   .imgIconmediaimage,
                              //                               height:
                              //                                   20.adaptSize,
                              //                               width: 20.adaptSize,
                              //                               margin:
                              //                                   EdgeInsets.only(
                              //                                       top:
                              //                                           124.v)),
                              //                           // CustomImageView(
                              //                           //     onTap: () {
                              //                           //       checkPermissionMicrophone();
                              //                           //       setState(() {});
                              //                           //     },
                              //                           //     color: _speechToText
                              //                           //         .isNotListening
                              //                           //         ? Colors.grey : Colors.red,
                              //                           //     svgPath: ImageConstant
                              //                           //         .imgMicrophone,
                              //                           //     height: 20.v,
                              //                           //     width: 14.h,
                              //                           //     margin:
                              //                           //         EdgeInsets.only(
                              //                           //             left: 14.h,
                              //                           //             top: 124.v))
                              //                         ])))
                              //           ])),
                              // ),
                              SizedBox(height: 6.v),
                              Text("Terjemahkan ke " + translateTo.toString(),
                                  style: CustomTextStyles.labelLargeMedium_1),
                              SizedBox(height: 4.v),
                              Center(
                                  child: Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: appTheme.gray300,
                                                width: 1),
                                            borderRadius:
                                                BorderRadius.circular(10.h)),
                                        child: TextField(
                                          keyboardType: TextInputType.multiline,
                                          maxLines: 8,
                                          style: theme.textTheme.titleMedium,
                                          readOnly: true,
                                          controller: textOutputController,
                                          cursorColor: Colors.grey,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 10.h,
                                                    vertical: 5.v),
                                            hintText: "",
                                            hintStyle:
                                                CustomTextStyles.labelLarge13,
                                            isDense: true,
                                            fillColor:
                                                theme.colorScheme.primary,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                          ),
                                          textInputAction:
                                              TextInputAction.newline,
                                        ),
                                      ),
                                      Text(
                                          (textOutputController.text == "")
                                              ? "Output Box"
                                              : '',
                                          style: CustomTextStyles
                                              .labelLargeMedium_1)
                                    ],
                                  ),
                                ],
                              )),
                              SizedBox(height: 24.v),
                              CustomElevatedButton(
                                  onTap: () {
                                    if (textController.text.toString() != '') {
                                      _terjemah();
                                    }
                                    setState(() {});
                                  },
                                  text: (!isLoading)
                                      ? "Terjemahkan"
                                      : "Tunggu...")
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
