import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_manager/styles/base.dart';
import 'package:grocery_manager/styles/colors.dart';
import 'package:grocery_manager/styles/text.dart';

class AppDropdownButton extends StatelessWidget {
  final List<DropdownMenuItem<String>> dropdownItem;
  final String hintText;
  final String labelText;
  final IconData materialIcon;
  final IconData cupertinoIcon;
  final String value;
  final String initialValue;
  final Function(String) onChanged;
  final Function() onPressedIcon;

  AppDropdownButton({
    @required this.hintText,
    this.labelText,
    this.materialIcon,
    this.cupertinoIcon,
    this.value,
    this.onChanged,
    this.dropdownItem,
    this.onPressedIcon, 
    this.initialValue
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: BaseStyles.listPadding,
      child: Column(
        children: [
          Container(
            height: BaseStyles.heightDropdown,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(BaseStyles.borderRadius),
              border: Border.all(
                color: AppColors.blue, 
                width: BaseStyles.borderWidth
              )
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                DropdownButton<String>(
                  items: dropdownItem,
                  value: (initialValue == null) 
                    ? value
                    : initialValue,
                  hint: Text(
                    hintText,
                    textAlign: TextAlign.center, 
                    style: TextStyles.suggestion
                  ),
                  style: TextStyles.body,
                  underline: Container(),
                  onChanged: (value)  => onChanged(value),
                ),
                SizedBox(width: 10,),
                IconButton(
                  icon: Icon(Icons.add),
                  color: AppColors.green,
                  onPressed: onPressedIcon,  
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
