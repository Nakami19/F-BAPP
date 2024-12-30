import 'package:f_bapp/common/assets/theme/app_colors.dart';
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
      this.titleTextStyle,
      this.hintText,
      this.hintTextStyle,
      required this.itemValueMapper,
      required this.itemLabelMapper,
      this.selectedValue,
      this.optionsTextsStyle,
      this.titleAlignment,
      this.label,
      super.key});

  final ValueChanged<String?> onChanged;
  final List<T> options;
  final String? errorText;
  final bool? showError;
  final String? label;
  final String? title;
  final String? hintText;
  final String? selectedValue;
  final bool autoSelectFirst;
  final TextStyle? optionsTextsStyle;
  final TextStyle? hintTextStyle;
  final TextStyle? titleTextStyle;
  final AlignmentGeometry? titleAlignment;


  //Funciones que toman un objeto option y devuelve un String, permiten que el widget sea reutilizable
  final String Function(dynamic option) itemValueMapper;
  final String Function(dynamic option) itemLabelMapper;

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  // Variable para almacenar el valor seleccionado actualmente.
  String? value;

  @override
  void initState() {
    super.initState();

     if (widget.selectedValue != null) {
      value = widget.selectedValue; // Si se pasa un valor seleccionado
    } else if (widget.autoSelectFirst && widget.options.isNotEmpty) {
      value = widget.itemValueMapper(widget.options.first); // Selecciona la primera opción automáticamente.
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

    return Column(
      children: [

        //Si hay un titulo se muestra sobre el dropdown
        if(widget.title!=null)
          Align(
            alignment: widget.titleAlignment ?? Alignment.centerLeft,
            child: Text(
              widget.title??"",
              style: GoogleFonts.lato(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

        const SizedBox(height: 2),

        //Contenerdor del dropdown
        Container(
          //Color y radio del borde
          decoration: BoxDecoration(
            border: Border.all(color: primaryColor, width: 2),
            borderRadius: BorderRadius.circular(borderRadiusValue),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: DropdownButtonHideUnderline(
              child: DropdownButton2(
                isExpanded: true, //se ocupa todo el ancho
                hint: Text(
                    widget.hintText??"",
                    style: widget.hintTextStyle?? TextStyle(color: hintTextColor),
                  ),

                value: value, //valor seleccionado

                //opciones del dropdown
                items: widget.options.map((option) {
                  return DropdownMenuItem<String>(
                      value: widget.itemValueMapper(option), //valor del elemento
                      child: Text(
                        widget.itemLabelMapper(option), //texto que se muestra

                        // Aplica estilo adicional si es el elemento seleccionado.
                        style: widget.optionsTextsStyle != null? widget.optionsTextsStyle!.copyWith(
                          fontWeight: value == widget.itemValueMapper(option)
                              ? FontWeight
                                  .w600 
                              : FontWeight.normal,
                        ) :
                        TextStyle(
                          fontWeight: value == widget.itemValueMapper(option)
                              ? FontWeight
                                  .w600 
                              : FontWeight.normal,
                        ),
                      ));
                }).toList(),

                onChanged: (String? newValue) {
                  if (newValue != null && newValue != value) {
                    //cambia el valor de manera local
                    setState(() {
                      value = newValue;
                    });
                    //notifica el cambio
                    widget.onChanged(newValue); 
                  }
                },

                //Configuracion del dropdown al abrise
                dropdownStyleData: DropdownStyleData(
                    maxHeight: MediaQuery.of(context).size.height / 3,
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(borderRadiusValue))),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
