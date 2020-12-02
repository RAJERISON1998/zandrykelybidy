
import 'package:flutter/material.dart';
import 'package:grocery_manager/styles/base.dart';
import 'package:grocery_manager/styles/colors.dart';
import 'package:grocery_manager/styles/text.dart';

abstract class TextFieldStyles {
  static double get textBoxHorizontal => BaseStyles.listFieldHorizontal;

  static double get textBoxVertical => BaseStyles.listFieldVertical;

  static double get textBoxPaddingTop => 25;
  static double get textBoxPaddingLeft => 20;
  static double get textBoxPaddingRight => 20;
  static double get textBoxPaddingBottom => 5;

  static TextStyle get text => TextStyles.body;

  static TextStyle get placeholder => TextStyles.suggestion;

  static TextStyle get labelText => TextStyles.labelText;

  static Color get cursorColor => AppColors.darkblue;

  static Widget iconPrefix(IconData icon) => BaseStyles.iconPrefix(icon);

  static TextAlign get textAlign => TextAlign.center;

  static InputDecoration materialDecoration(
    String hintText,
    String labelText,
    // IconData icon, 
    String errorText
  ) {
    return InputDecoration(
      contentPadding: EdgeInsets.only(
        left: BaseStyles.contentPadding + 5,
        right: BaseStyles.contentPadding,
        top: BaseStyles.contentPadding + 10
      ),
      hintText: hintText,
      hintStyle: TextFieldStyles.placeholder,
      border: InputBorder.none,
      errorText: errorText,
      errorStyle: TextStyles.error,
      labelText: labelText, 
      labelStyle: TextStyles.labelText,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      // labelStyle: TextFieldStyles.labelText,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.blue, 
          width: BaseStyles.borderWidth,
        ),
        borderRadius: BorderRadius.circular(
          BaseStyles.borderRadius
        )
      ),
      alignLabelWithHint: true,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.blue, 
          width: BaseStyles.borderWidth
        ),
        borderRadius: BorderRadius.circular(
          BaseStyles.borderRadius
        )
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.red, 
          width: BaseStyles.borderWidth
        ),
        borderRadius: BorderRadius.circular(
          BaseStyles.borderRadius
        )
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.red, 
          width: BaseStyles.borderWidth
        ),
        borderRadius: BorderRadius.circular(
          BaseStyles.borderRadius
        )
      ),
      // prefixIcon: iconPrefix(icon),
    );
  }

  static InputDecoration autocompleteDecoration(
    String hintText,
  ) {
    return InputDecoration(
      contentPadding: EdgeInsets.all(1.0),
      hintText: hintText,
      hintStyle: TextFieldStyles.placeholder,
      border: InputBorder.none,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.blue, 
          width: BaseStyles.borderWidth,
        ),
        borderRadius: BorderRadius.circular(
          BaseStyles.borderRadius
        )
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.blue, 
          width: BaseStyles.borderWidth
        ),
        borderRadius: BorderRadius.circular(
          BaseStyles.borderRadius
        )
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.red, 
          width: BaseStyles.borderWidth
        ),
        borderRadius: BorderRadius.circular(
          BaseStyles.borderRadius
        )
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.red, 
          width: BaseStyles.borderWidth
        ),
        borderRadius: BorderRadius.circular(
          BaseStyles.borderRadius
        )
      ),
    );
  }
}