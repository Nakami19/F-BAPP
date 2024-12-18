import 'package:f_bapp/common/assets/theme/app_colors.dart';
import 'package:f_bapp/common/assets/theme/app_theme.dart';
import 'package:flutter/material.dart';

class CustomTextfield extends StatefulWidget {
  const CustomTextfield({
    super.key, 
    required this.hint, 
    this.onChanged,
    this.fieldIcon,
    this.textStyle,
    this.controller,
    });

  final Function(String)? onChanged;
  final String hint;
  final Icon? fieldIcon;
  final TextStyle? textStyle;
  final TextEditingController? controller;

  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  final _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusNode.unfocus();
        FocusScope.of(context).unfocus();
      },
      child: TextField(
        focusNode: _focusNode,
        onChanged: widget.onChanged,
        controller: widget.controller,
        decoration: InputDecoration(
          fillColor: Colors.white,
          hintText: widget.hint,
          hintStyle: widget.textStyle,
          prefixIcon: widget.fieldIcon,
          contentPadding: const EdgeInsets.symmetric(horizontal: 23, vertical: 13),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadiusValue),
            borderSide: BorderSide(
              color: primaryColor,
              width: 2
            ),
            
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadiusValue),
            borderSide: BorderSide(
              color: primaryColor,
              width: 2
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadiusValue),
            borderSide: BorderSide(
              color: primaryColor,
              width: 2
            ),
          ),
        ),
      ),
    );
  }
}
