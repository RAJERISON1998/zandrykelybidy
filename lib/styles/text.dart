import 'package:grocery_manager/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class TextStyles {
  static TextStyle get title {
    return GoogleFonts.poppins(
      textStyle: TextStyle(
        color: AppColors.black,
        fontWeight: FontWeight.bold,
        fontSize: 40.0
      )
    );
  }

  static TextStyle get subtitle {
    return GoogleFonts.economica(
      textStyle: TextStyle(
        color: AppColors.black,
        fontWeight: FontWeight.bold,
        fontSize: 30.0
      )
    );  
  }

  static TextStyle get listTitle {
    return GoogleFonts.economica(
      textStyle: TextStyle(
        color: AppColors.black,
        fontWeight: FontWeight.bold,
        fontSize: 25.0
      )
    );
  }

  static TextStyle get navTitle {
    return GoogleFonts.poppins(
        textStyle:
            TextStyle(color: AppColors.darkblue, fontWeight: FontWeight.bold));
  }

  static TextStyle get navTitleMaterial {
    return GoogleFonts.poppins(
        textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold));
  }

  static TextStyle get body {
    return GoogleFonts.roboto(
        textStyle: TextStyle(
          color: AppColors.darkgray, 
          fontSize: 16.0
        )
      );
  }

    static TextStyle get bodyLightBlue {
    return GoogleFonts.roboto(
        textStyle: TextStyle(color: AppColors.lightblue, fontSize: 16.0));
  }


  static TextStyle get picker {
    return GoogleFonts.roboto(
        textStyle: TextStyle(color: AppColors.darkgray, fontSize: 35.0));
  }

  static TextStyle get suggestion {
    return GoogleFonts.roboto(
      textStyle: TextStyle(
        color: AppColors.lightgray, 
        fontSize: 14.0 ,
      )
    );
  }

  static TextStyle get labelText {
    return GoogleFonts.roboto(
      textStyle: TextStyle(
        // color: AppColors.darkgray, 
        fontSize: 18.0,
        height: -10,
        fontWeight: FontWeight.w500,        
      )
    );
  }

  static TextStyle get helperText {
    return GoogleFonts.roboto(
      textStyle: TextStyle(
        color: AppColors.darkblue, 
        fontSize: 16.0,
      )
    );
  }

  static TextStyle get placeholder {
    return GoogleFonts.roboto(
      textStyle: TextStyle(
        color: AppColors.black, 
        fontSize: 14.0,
        fontWeight: FontWeight.w300
      )
    );
  }

  static TextStyle get error {
    return GoogleFonts.roboto(
        textStyle: TextStyle(color: AppColors.red, fontSize: 12.0));
  }

  static TextStyle get buttonTextLight {
    return GoogleFonts.roboto(
        textStyle: TextStyle(
            color: Colors.white, fontSize: 17.0, fontWeight: FontWeight.bold));
  }

  static TextStyle get buttonTextDark {
    return GoogleFonts.roboto(
        textStyle: TextStyle(
            color: AppColors.darkgray,
            fontSize: 17.0,
            fontWeight: FontWeight.bold));
  }
}
