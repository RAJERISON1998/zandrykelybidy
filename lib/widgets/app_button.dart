import 'package:flutter/material.dart';
import 'package:grocery_manager/styles/base.dart';
import 'package:grocery_manager/styles/buttons.dart';
import 'package:grocery_manager/styles/colors.dart';
import 'package:grocery_manager/styles/text.dart';

class AppButton extends StatefulWidget{
  final String buttonText;
  final ButtonType buttonType;
  final void Function() onPressed;
  final double height;

  AppButton({
    @required this.buttonText,
    this.buttonType,
    this.onPressed,
    this.height = 50,
  });

  @override
  _AppButtonState createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    TextStyle fontStyle;
    Color buttonColor;

    switch (widget.buttonType) {
      case ButtonType.LightBlue:
        fontStyle = TextStyles.buttonTextLight;
        buttonColor = AppColors.lightblue;
        break;
      case ButtonType.Green:
        fontStyle = TextStyles.buttonTextLight;
        buttonColor = AppColors.green;
        break;
      case ButtonType.Red:
        fontStyle = TextStyles.buttonTextLight;
        buttonColor = AppColors.red;
        break;
      case ButtonType.DarkBlue:
        fontStyle = TextStyles.buttonTextLight;
        buttonColor = AppColors.darkblue;
        break;
      case ButtonType.Disabled:
        fontStyle = TextStyles.buttonTextLight;
        buttonColor = AppColors.lightgray;
        break;
      case ButtonType.DarkGray:
        fontStyle = TextStyles.buttonTextLight;
        buttonColor = AppColors.darkgray;
        break;
      default: 
        fontStyle = TextStyles.buttonTextLight;
        buttonColor = AppColors.lightblue;
        break;
    }

    return AnimatedContainer(
      padding: EdgeInsets.only( 
        top: (pressed) ? BaseStyles.listFieldVertical + BaseStyles.animationOffset :  BaseStyles.listFieldVertical,
        bottom: (pressed) ? BaseStyles.listFieldVertical - BaseStyles.animationOffset :  BaseStyles.listFieldVertical,
        left: BaseStyles.listFieldHorizontal,
        right: BaseStyles.listFieldHorizontal
      ),
      child: GestureDetector(
        child: Container(  
          height: widget.height,
          width: ButtonStyles.width,
          decoration: BoxDecoration(  
            color: buttonColor,
            borderRadius: BorderRadius.circular(
              BaseStyles.borderRadius
            ),
            boxShadow: pressed 
              ? BaseStyles.boxShadowPressed 
              : BaseStyles.boxShadow
          ),
          child: Center(
            child: Text(
              widget.buttonText,
              style: fontStyle,
            )
          ),
        ),
        onTapDown: (details){
          setState(() {
            if (widget.buttonType != ButtonType.Disabled) pressed = !pressed;
          });
        },
        onTapUp: (details){
          setState(() {
            if (widget.buttonType != ButtonType.Disabled) pressed = !pressed;
          });
        },
        onTap: (){
          if (widget.buttonType != ButtonType.Disabled) {
            widget.onPressed();
          }
        },
      ),
      duration: Duration(milliseconds: 20),
    );
  }
}

enum ButtonType { 
  LightBlue,
  Straw, 
  Disabled, 
  DarkGray, 
  DarkBlue,
  Red,
  Green
}