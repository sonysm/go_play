import 'package:flutter/material.dart';
import 'package:kroma_sport/utils/input_style.dart';

class TeamButtonTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final VoidCallback? onTap;
  final bool isEditing;
  const TeamButtonTextField({Key? key, this.controller, this.labelText, this.isEditing = false , this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: true,
      controller: controller,
      enabled: isEditing,
      enableInteractiveSelection: false,
      style: Theme.of(context).textTheme.bodyText1, 
      decoration: InputDecoration(
        labelText: labelText,
        isDense: true,
        labelStyle: TextStyle(color: Colors.grey),
        focusedBorder: InputStyles.inputUnderlineEnabledBorder(),
        enabledBorder: isEditing ? InputStyles.inputUnderlineEnabledBorder() : UnderlineInputBorder(),
        suffixIcon: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey),
      ),
      onTap: onTap ?? () {},
    );
  }
}
