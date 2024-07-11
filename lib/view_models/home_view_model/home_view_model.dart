import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kajak/ConnectivityService.dart';
import 'package:kajak/database_helper/exam_results.dart';
import 'package:kajak/database_helper/questions.dart';
import 'package:kajak/database_helper/send_answer.dart';
import 'package:kajak/models/home_model.dart';
import 'package:kajak/routes/app_routes.dart';
import 'package:kajak/theme/theme_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HomeViewModel extends ChangeNotifier {
  TextEditingController searchController = TextEditingController();
  List<HomeModel> homeData = [
    HomeModel(
      route: AppRoutes.halamanTerjemahanScreen,
      title: "Terjemahan",
      desc:
          "Terjemahkan teks Bahasa Indonesia ke dalam Bahasa Jawa ngoko, madya dan krama",
    ),
    HomeModel(
      route: AppRoutes.halamanKawruhBasaScreen,
      title: "Rupa - Rupa Kawruh",
      desc: "Cari tahu penyebutan benda dan makhluk hidup dalam bahasa jawa",
    ),
    HomeModel(
      route: AppRoutes.halamanParamasastraScreen,
      title: "Paramasastra",
      desc:
          "Pelajari penggunaan kalimat bahasa jawa dalam bermacam jenis penggunaan",
    ),
    HomeModel(
      route: AppRoutes.halamanKasusastraanScreen,
      title: "Kasusastraan",
      desc: "Pelajari Peribahasa, Parikan dan tembang-tembang berbahasa jawa",
    ),
    HomeModel(
      route: AppRoutes.halamanAksaraJawaScreen,
      title: "Ha Na Ca Ra Ka",
      desc: "Cari tahu bagaimana membaca dan menulis aksara jawa",
    ),
    HomeModel(
      route: AppRoutes.kuisScreen,
      title: "Wulangan",
      desc:
          "Kerjakan kuis pengetahuan bahasa jawa untuk menguji kemampuanmu berbahasa jawa",
    ),
  ];

  var user;
  bool isLoading = false;
  bool isProfile = false;
  List<HomeModel> homeDatas = [];
  DateTime? currentBackPressTime;
  StreamSubscription<bool>? _connectivitySubscription;
  bool isConnected = true;
  bool hasConnectedRun = false;
  late FocusNode focusNode;

  TextEditingController nameTextController = TextEditingController();

  TextEditingController nisnTextController = TextEditingController();

  TextEditingController kelasTextController = TextEditingController();

  HomeViewModel() {
    initState();
  }

  void initState() {
    getDataFromDatabase();
    ConnectivityService.connectivityStream.listen((status) {
      isConnected = status;
      if (!hasConnectedRun) {
        Future.delayed(Duration.zero, () {
          hasConnectedRun = true;
        });
      }
      // notifyListeners();
    });
    searchController.addListener(_onSearchChanged);
    if (searchController.text.isEmpty) {
      homeDatas = homeData;
    }
    // untuk mengambil data user yang di tampilkan pada halaman profile
    getUser();
    focusNode = FocusNode();
    notifyListeners();
  }

  @override
  void dispose() {
    searchController.clear();
    nameTextController.clear();
    nisnTextController.clear();
    kelasTextController.clear();
    _connectivitySubscription?.cancel();
    focusNode.requestFocus();
    super.dispose();
  }

  bool isKeyboardOpen(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return !(mediaQuery.viewInsets.bottom == 0);
  }

  Future<bool> handleBackButton(BuildContext context) async {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.grey,
        behavior: SnackBarBehavior.floating,
        content: Text('Tekan sekali lagi untuk keluar.',
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.white, // Adjust color based on your theme
            )),
      ));
      // Fluttertoast.showToast(msg: 'Tekan kembali lagi untuk keluar');
      return Future.value(false);
    }
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    return Future.value(true);
  }

  void _onSearchChanged() {
    homeDatas = homeData
        .where((data) =>
            data.title
                .toLowerCase()
                .contains(searchController.text.toLowerCase()) ||
            data.desc
                .toLowerCase()
                .contains(searchController.text.toLowerCase()))
        .toList();
    notifyListeners();
  }

  Future<void> getUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    user = json.decode(pref.getString("user")!);
    nameTextController =
        TextEditingController(text: user['user']['name'].toString());
    nisnTextController =
        TextEditingController(text: user['user']['nisn'].toString());
    kelasTextController =
        TextEditingController(text: user['user']['kelas'].toString());
    notifyListeners();
  }

  var nilai = null;
  var quiz = null;

  Future<void> getDataFromDatabase() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var attemptPage = json.decode(pref.getString("user")!);
    attemptPage = attemptPage['attempt']['id'].toString() + '_1';
    // You need to implement the ExamResults and Questions class
    nilai = await ExamResults()
        .getExamResultData(attemptPage.toString().replaceAll('_1', ''));
    quiz = await Questions().getQuizData(attemptPage);
    notifyListeners();
  }

  Future<void> cekNilai(BuildContext context) async {
    bool hasRun = false;
    isLoading = true;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.grey,
      behavior: SnackBarBehavior.floating,
      content: Text('Tunggu sebentar.',
          style: theme.textTheme.titleMedium?.copyWith(
            color: Colors.white, // Adjust color based on your theme
          )),
    ));
    notifyListeners();

    ConnectivityService.connectivityStream.listen((status) async {
      if (!hasRun) {
        hasRun = true;
        isConnected = status;
        notifyListeners();

        if (status) {
          SharedPreferences pref = await SharedPreferences.getInstance();
          user = json.decode(pref.getString("user")!);
          String token = user['token'];
          String attempt_id = user['attempt']['id'].toString();
          var apiResult = await http.put(
              Uri.parse(
                  '${const String.fromEnvironment('apiUrl')}/exam/$attempt_id'),
              headers: {
                "Accept": "Application/json",
                "Authorization": "Bearer $token"
              });
          var data = json.decode(apiResult.body);
          await ExamResults().insertExamResultData(data);
          var hasBeenAnswered = await SendAnswer().hasBeenAnswered();
          if (data['message'].toString().toLowerCase().contains('berhasil') ==
                  true &&
              data['attempt']['score'].toString() != 'null' &&
              (hasBeenAnswered != null &&
                  hasBeenAnswered?['data']?['answer']?.length == 15)) {
            Navigator.pushNamed(
                context, AppRoutes.soalKuisHasilDanPembahasanScreen);
          } else {
            Navigator.pushNamed(context, AppRoutes.kuisScreen);
          }
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          isLoading = false;
          notifyListeners();
        } else {
          SharedPreferences pref = await SharedPreferences.getInstance();
          var attempt_page = json.decode(pref.getString("user")!);
          attempt_page = await attempt_page['attempt']['id'].toString() + '_1';
          nilai = await ExamResults()
              .getExamResultData(attempt_page.toString().replaceAll('_1', ''));
          var hasBeenAnswered = await SendAnswer().hasBeenAnswered();
          if (nilai != null) {
            if (nilai['message']
                        .toString()
                        .toLowerCase()
                        .contains('berhasil') ==
                    true &&
                nilai['attempt']['score'].toString() != 'null' &&
                (hasBeenAnswered != null &&
                    hasBeenAnswered?['data']?['answer']?.length == 15)) {
              if (quiz != null) {
                Navigator.pushNamed(
                    context, AppRoutes.soalKuisHasilDanPembahasanScreen);
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                isLoading = false;
                notifyListeners();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.grey,
                  behavior: SnackBarBehavior.floating,
                  content: Text('Periksa kembali jaringan anda.',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white, // Adjust color based on your theme
                      )),
                ));
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                isLoading = false;
                notifyListeners();
              }
            } else {
              Navigator.pushNamed(context, AppRoutes.kuisScreen);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              isLoading = false;
              notifyListeners();
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              content: Text('Periksa kembali jaringan anda!',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white, // Adjust color based on your theme
                  )),
            ));
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            isLoading = false;
            notifyListeners();
          }
        }
      }
    });
  }

  Future<void> logOut(BuildContext context) async {
    bool hasRun = false;
    isLoading = true;
    notifyListeners();

    ConnectivityService.connectivityStream.listen((status) async {
      if (!hasRun) {
        hasRun = true;
        isConnected = status;

        if (status) {
          SharedPreferences pref = await SharedPreferences.getInstance();
          user = json.decode(pref.getString("user")!);
          String token = user['token'];
          await http.post(
              Uri.parse('${const String.fromEnvironment('apiUrl')}/logout'),
              headers: {
                "Accept": "Application/json",
                "Authorization": "Bearer $token"
              });
          pref.remove('user');
          Navigator.pushReplacementNamed(context, AppRoutes.loginScreen);
          isLoading = false;
          notifyListeners();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            content: Text('Periksa kembali jaringan anda!'),
          ));
          isLoading = false;
          notifyListeners();
        }
      }
    });
  }
}
