import 'package:flutter/material.dart';
import 'package:grocery_manager/blocs/unite_bloc.dart';
import 'package:grocery_manager/models/unite.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:grocery_manager/styles/text_field.dart';
import 'package:provider/provider.dart';

class AppAutoCompleteTextField extends StatefulWidget {
  final String hintText;
  final IconData materialIcon;
  final IconData cupertinoIcon;
  final TextInputType textInputType;
  final void Function(String) onChanged;
  final String errorText;
  final String initialText;
  final String labelText;
  final String helperText;
  final TextEditingController textController;


  AppAutoCompleteTextField({
    this.hintText,
    this.materialIcon,
    this.cupertinoIcon,
    this.textInputType,
    this.onChanged,
    this.errorText,
    this.initialText,
    this.textController,
    this.labelText,
    this.helperText
  });

  @override
  _AppAutoCompleteTextFieldState createState() => _AppAutoCompleteTextFieldState();
}

class _AppAutoCompleteTextFieldState extends State<AppAutoCompleteTextField> {
  AutoCompleteTextField searchTextField;
  GlobalKey<AutoCompleteTextFieldState<Unite>> key = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    var uniteBloc = Provider.of<UniteBloc>(context);
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: TextFieldStyles.textBoxHorizontal, vertical: TextFieldStyles.textBoxVertical),
      child: TypeAheadField(
        textFieldConfiguration: TextFieldConfiguration(
          autofocus: true,
          style:TextFieldStyles.text,
          decoration: TextFieldStyles.materialDecoration(
            widget.hintText,
            widget.labelText,
            widget.errorText,
            // widget.helperText,
          ),
          keyboardType: widget.textInputType,
          cursorColor: TextFieldStyles.cursorColor,
          textAlign: TextFieldStyles.textAlign,
          controller: widget.textController,
          onChanged: widget.onChanged,
        ),

        suggestionsCallback: (pattern) async {
          return uniteBloc.getSuggestionUnite(pattern);
        },
        itemBuilder: (context,Unite suggestion) {
          return ListTile(
            title: Text(suggestion.nomUnite),
          );
        },
        onSuggestionSelected: (suggestion) {
          widget.textController.text = suggestion;
        },
      ),
    );
  }
}