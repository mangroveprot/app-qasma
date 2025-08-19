import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import 'app_box_shadows.dart';
import 'app_font_weight.dart';

extension ThemeAccess on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
  AppRadii get radii => Theme.of(this).extension<AppRadii>()!;
  AppBoxShadow get shadows => Theme.of(this).extension<AppBoxShadow>()!;
  AppFontWeights get weight => Theme.of(this).extension<AppFontWeights>()!;
}
