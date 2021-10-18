import 'package:flutter/material.dart';
import 'package:kroma_sport/utils/dimensions.dart';
import 'package:kroma_sport/utils/input_style.dart';

class TeamTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final bool? isEditing;
  const TeamTextField({Key? key, this.controller, this.labelText, this.isEditing}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: Theme.of(context).textTheme.bodyText1,
      enabled: isEditing,
      decoration: InputDecoration(
        labelText: labelText,
        isDense: true,
        labelStyle: TextStyle(color: Colors.grey, fontSize: Dimensions.FONT_SIZE_LARGE),
        floatingLabelStyle: TextStyle(color: Colors.grey, fontSize: Dimensions.FONT_SIZE_LARGE),
        focusedBorder: InputStyles.inputUnderlineFocusBorder(),
        enabledBorder: InputStyles.inputUnderlineEnabledBorder(),
        //contentPadding: const EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
      ),
    );
  }
}
