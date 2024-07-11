import 'package:flutter/material.dart';
import '../core/app_export.dart';

/// A collection of pre-defined text styles for customizing text appearance,
/// categorized by different font families and weights.
/// Additionally, this class includes extensions on [TextStyle] to easily apply specific font families to text.

class CustomTextStyles {
  // Label text style
  static get labelLarge13 => theme.textTheme.labelLarge!.copyWith(
        fontSize: 13.fSize,
      );

  static get labelLargeMedium => theme.textTheme.labelLarge!.copyWith(
        fontSize: 15.fSize,
        fontWeight: FontWeight.w500,
      );

  static get labelLargeMedium_1 => theme.textTheme.labelLarge!.copyWith(
        fontSize: 14.fSize,
        fontWeight: FontWeight.w500,
      );

  static get labelLargeMedium_2 => theme.textTheme.labelLarge!.copyWith(
    fontSize: 14.fSize,
    fontWeight: FontWeight.w500,
    color: Colors.grey
  );

  static get labelLarge_1 => theme.textTheme.labelLarge!;

  // Title text style
  static get titleMediumExtraBold => theme.textTheme.titleMedium!.copyWith(
        fontSize: 18.fSize,
        fontWeight: FontWeight.w800,
      );

  static get titleMediumOnPrimary => theme.textTheme.titleMedium!.copyWith(
        color: theme.colorScheme.onPrimary.withOpacity(1),
      );

  static get titleMediumSemiBold => theme.textTheme.titleMedium!.copyWith(
        fontSize: 18.fSize,
        fontWeight: FontWeight.w600,
      );

  static get titleMediumSemiBold2 => theme.textTheme.titleMedium!.copyWith(
    fontSize: 16.fSize,
    fontWeight: FontWeight.w700,
  );

  static get titleSmallBold => theme.textTheme.titleSmall!.copyWith(
        fontWeight: FontWeight.w700,
      );

  static get titleSmallExtraBold => theme.textTheme.titleSmall!.copyWith(
        fontWeight: FontWeight.w800,
      );

  static get titleSmallPrimary => theme.textTheme.titleSmall!.copyWith(
        color: theme.colorScheme.primary,
        fontWeight: FontWeight.w700,
      );
}

extension on TextStyle {
  TextStyle get nunito {
    return copyWith(
      fontFamily: 'Nunito',
    );
  }
}
