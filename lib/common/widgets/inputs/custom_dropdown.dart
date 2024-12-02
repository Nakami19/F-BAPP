import 'package:f_bapp/common/assets/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dropdown_button2/dropdown_button2.dart';


class CustomDropdown extends StatefulWidget {
  const CustomDropdown({
    required this.options,
    required this.onChanged,
    required this.showError,
    required this.errorText,
    required this.title,
    this.label,
    super.key
    });
  final List<String> options;
  final ValueChanged<String?> onChanged;
  final String? errorText;
  final bool showError;
  final String? label;
  final String title;


  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.options.isNotEmpty ? widget.options[0] : null;  
  }

  @override
  Widget build(BuildContext context) {
  Size size = MediaQuery.of(context).size;
  final textStyle = Theme.of(context).textTheme;

    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            widget.title,
            style: GoogleFonts.lato(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 2),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: primaryColor, width: 2),
            borderRadius: BorderRadius.circular(BorderRadiusValue),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: DropdownButtonHideUnderline(
              child: DropdownButton2(
                isExpanded: true,
                value: selectedValue,
                // icon: Icon(Icons.keyboard_arrow_down),
                items: widget.options.map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedValue = newValue!;
                  });
                  widget.onChanged(newValue);

                  },
                dropdownStyleData: DropdownStyleData(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(BorderRadiusValue)
                  )
                ),
                  
                  )
                ,
              ),
            ),
          ),
      ],
    ) ;
  }
}