import 'package:flutter/material.dart';
import 'package:grocery_manager/models/unite.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:grocery_manager/styles/text_field.dart';

class AppAutoCompleteTextField extends StatefulWidget {
  final String hintText;
  final IconData materialIcon;
  final IconData cupertinoIcon;
  final TextInputType textInputType;
  final void Function(String) onChanged;
  final String errorText;
  final String labelText;
  final String initialText;
  final TextEditingController textController;
  final Future<List> suggestionCallback; 
  final Widget Function(BuildContext, dynamic) itemBuilder;
  final Function(dynamic) suggestionSelected;
  final bool hideOnKeyboard;
  final String helperText;


  AppAutoCompleteTextField({
    this.hintText,  
    this.materialIcon,
    this.cupertinoIcon,
    this.textInputType,
    this.onChanged,
    this.errorText,
    this.initialText,
    this.labelText,
    this.textController, 
    this.hideOnKeyboard,
    this.helperText,
    @required this.suggestionCallback, 
    @required this.itemBuilder, 
    @required this.suggestionSelected,
  });

  @override
  _AppAutoCompleteTextFieldState createState() => _AppAutoCompleteTextFieldState();
}

class _AppAutoCompleteTextFieldState extends State<AppAutoCompleteTextField> {
  GlobalKey<AutoCompleteTextFieldState<Unite>> key = new GlobalKey();
  TextEditingController _controller;
  FocusNode _focusNode = FocusNode();
  bool _focused = false;

  @override
  void initState() {
    _controller = TextEditingController();
    _focusNode.addListener(_handleFocusChange);
    if (widget.initialText != null) _controller.text = widget.initialText;
    super.initState();
  }

  void _handleFocusChange() {
    if (_focusNode.hasFocus != _focused) {
      setState(() {
        _focused = _focusNode.hasFocus;
      });
    }
  }

  @override
  Widget build(BuildContext context) {    
    return Padding(
      padding: EdgeInsets.only(
        top: TextFieldStyles.textBoxHorizontal, 
        right: TextFieldStyles.textBoxVertical,
        left:  TextFieldStyles.textBoxVertical 
      ),
      child: TypeAheadField(
        textFieldConfiguration: TextFieldConfiguration(
          autofocus: false,
          style:TextFieldStyles.text,
          decoration: TextFieldStyles.materialDecoration(
            widget.hintText,
            widget.labelText,
            // widget.helperText,
            widget.errorText
          ),
          focusNode: _focusNode,
          keyboardType: widget.textInputType,
          cursorColor: TextFieldStyles.cursorColor,
          textAlign: TextFieldStyles.textAlign,
          controller: ( widget.textController == null)
            ? _controller
            : widget.textController ,
          onChanged: widget.onChanged,
        ),
        hideOnEmpty: true,
        hideOnLoading: true,
        hideSuggestionsOnKeyboardHide: (widget.hideOnKeyboard == null)
          ? true
          : widget.hideOnKeyboard,
        keepSuggestionsOnLoading: false,
        suggestionsCallback: (pattern) async {
          return widget.suggestionCallback;
        },
        itemBuilder: widget.itemBuilder,
        onSuggestionSelected: widget.suggestionSelected,
      ),
    );
  }
}