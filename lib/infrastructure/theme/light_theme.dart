import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_box_shadows.dart';
import 'app_colors.dart';
import 'app_font_weight.dart';
import 'app_radii.dart';

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: AppColors.lightColors.white,
  appBarTheme: const AppBarTheme(
    elevation: 1,
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
    systemOverlayStyle: SystemUiOverlayStyle.dark,
  ),
  textTheme: const TextTheme(), // use default system font
  extensions: [
    AppColors.lightColors,
    AppRadii.lightRadii,
    AppBoxShadow.lightShadows,
    AppFontWeights.lightFontWeights,
  ],
);
