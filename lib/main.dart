import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kajak/theme/theme_helper.dart';
import 'package:kajak/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  ///Please update theme as per your need if required.
  ThemeHelper().changeTheme('primary');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      title: 'kajak',
      debugShowCheckedModeBanner: false,
      // DOKUMENTASI
      // dijalankan ketika pertama membuka apps di arahkan ke route halaman login
      initialRoute: AppRoutes.loginScreen,
      routes: AppRoutes.routes,
    );
  }
}
