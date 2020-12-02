import 'package:flutter/material.dart';

import 'package:grocery_manager/styles/text_field.dart';

class MyTextField extends StatefulWidget {
  final String hintText;
  final IconData materialIcon;
  final IconData cupertinoIcon;
  final TextInputType textInputType;
  final bool obscureText;
  final void Function(String) onChanged;
  final String errorText;
  final String labelText;
  final String initialText;
  final TextEditingController textController;
  final String helperText;

  MyTextField({
    this.hintText,
    this.materialIcon,
    this.cupertinoIcon,
    this.textInputType,
    this.obscureText = false,
    this.onChanged,
    this.errorText,
    @required this.labelText,
    this.initialText, 
    this.textController,
    this.helperText
  });

  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    if (widget.initialText != null) _controller.text = widget.initialText;
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: TextFieldStyles.textBoxPaddingTop, 
        left: TextFieldStyles.textBoxPaddingLeft,
        right: TextFieldStyles.textBoxPaddingRight,
        bottom: TextFieldStyles.textBoxPaddingBottom
      ),
      child: Column(
        children: [
          // Text( 
          // widget.labelText,
          //   style: TextStyles.placeholder,
          // ),  

          TextField(  
            keyboardType: widget.textInputType,
            cursorColor: TextFieldStyles.cursorColor,
            style:TextFieldStyles.text,

            textAlign: TextFieldStyles.textAlign,
            decoration: TextFieldStyles.materialDecoration(
              widget.hintText, 
              widget.labelText,
              // widget.materialIcon,
              // widget.helperText,
              widget.errorText,
            ),

            obscureText: widget.obscureText,
            controller: ( widget.textController == null)
              ? _controller
              : widget.textController ,
            onChanged: widget.onChanged,
          ),
        ],
      ),
    );
  }
}