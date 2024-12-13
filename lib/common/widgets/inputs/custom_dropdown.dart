import 'package:f_bapp/common/assets/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class CustomDropdown<T> extends StatefulWidget {
  const CustomDropdown(
      {required this.options,
      required this.onChanged,
      this.autoSelectFirst = false,
       this.showError,
       this.errorText,
      this.title,
      required this.itemValueMapper,
      required this.itemLabelMapper,
      this.selectedValue,
      this.optionsTextsStyle,
      this.label,
      super.key});
  // final List<dynamic> options;
  final ValueChanged<String?> onChanged;
  final List<T> options;
  final String? errorText;
  final bool? showError;
  final String? label;
  final String? title;
  final String? selectedValue;
  final bool autoSelectFirst; // Nuevo parámetro
  final TextStyle? optionsTextsStyle;

  // final String Function(T option) itemValueMapper;

  // /// Función que mapea el texto que se muestra en el dropdown.
  // final String Function(T option) itemLabelMapper;

  final String Function(dynamic option) itemValueMapper;
  final String Function(dynamic option) itemLabelMapper;

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  String? value;

  @override
  void initState() {
    super.initState();
    // selectedValue = widget.options.isNotEmpty ? widget.options[0] : null;
    //   if (widget.options.isNotEmpty) {
    //   value = widget.itemValueMapper(widget.options.first); // Toma el primer elemento si no hay valor seleccionado
    // }

    // if (widget.selectedValue != null) {
    //   value = widget.selectedValue;
    // } else if (widget.options.isNotEmpty) {
    //   value = widget.itemValueMapper(widget.options.first);
    // }

     if (widget.selectedValue != null) {
      value = widget.selectedValue; // Si se pasa un valor seleccionado
    } else if (widget.autoSelectFirst && widget.options.isNotEmpty) {
      value = widget.itemValueMapper(widget.options.first); // Seleccionar primero
    } else {
      value = null; // No seleccionar nada (placeholder activo)
    }
  }

    @override
  void didUpdateWidget(covariant CustomDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Si el valor seleccionado ha cambiado, actualiza el estado.
    if (widget.selectedValue != oldWidget.selectedValue && widget.selectedValue != value) {
      setState(() {
        value = widget.selectedValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final textStyle = Theme.of(context).textTheme;

    return Column(
      children: [
        if(widget.title!=null)
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.title??"",
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
                hint: Text(
                    'Estado',
                    style: TextStyle(color: AppTheme.hintTextColor),
                  ),
                value: value,
                // icon: Icon(Icons.keyboard_arrow_down),
                items: widget.options.map((option) {
                  return DropdownMenuItem<String>(
                      value: widget.itemValueMapper(option),
                      child: Text(
                        widget.itemLabelMapper(option),
                        style: widget.optionsTextsStyle != null? widget.optionsTextsStyle!.copyWith(
                          fontWeight: value == widget.itemValueMapper(option)
                              ? FontWeight
                                  .w600 // Estilo especial solo en el menú desplegable
                              : FontWeight.normal,
                        ) :
                        TextStyle(
                          fontWeight: value == widget.itemValueMapper(option)
                              ? FontWeight
                                  .w600 // Estilo especial solo en el menú desplegable
                              : FontWeight.normal,
                        ),
                      ));
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null && newValue != value) {
                    setState(() {
                      value = newValue;
                    });
                    widget.onChanged(newValue); 
                  }
                },
                dropdownStyleData: DropdownStyleData(
                    maxHeight: MediaQuery.of(context).size.height / 3,
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(BorderRadiusValue))),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
