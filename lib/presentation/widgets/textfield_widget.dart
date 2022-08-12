import 'package:flutter/material.dart';
import 'package:webw_task/consts/decoration.dart';

class TextFieldWidget extends StatelessWidget {
  TextFieldWidget({
    Key? key,
    this.isNumbers = false,
    required this.titlecontroller,
  }) : super(key: key);
  bool isNumbers;
  final TextEditingController titlecontroller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: isNumbers ? TextInputType.phone : null,
      controller: titlecontroller,
      cursorColor: Colors.black,
      decoration: kInputDecoration,
      onChanged: (value) {},
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'This field can not be empty';
        }
        if (isNumbers == true && titlecontroller.text.length < 6) {
          return 'please enter a valid number';
        }
        return null;
      },
    );
  }
}
