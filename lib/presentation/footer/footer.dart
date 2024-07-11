import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kajak/theme/theme_helper.dart';

class FooterMenu extends StatelessWidget {
  const FooterMenu({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      "Dalam mode offline",
      maxLines: 2,
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
      style:
      theme.textTheme.titleLarge?.copyWith(
        color: Colors.white, // Adjust color based on your theme
      ),
    );
  }
}