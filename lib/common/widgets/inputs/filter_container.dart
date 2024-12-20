import 'package:f_bapp/common/assets/theme/app_theme.dart';
import 'package:f_bapp/common/data/date_formatter.dart';
import 'package:f_bapp/common/widgets/buttons/custom_button.dart';
import 'package:f_bapp/common/widgets/inputs/custom_dropdown.dart';
import 'package:f_bapp/common/widgets/inputs/custom_text_form_field.dart';
import 'package:f_bapp/common/widgets/inputs/custom_textfield.dart';
import 'package:f_bapp/common/widgets/inputs/date_input.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/pagination_provider.dart';

class Filter<T> extends StatefulWidget {
  const Filter({
    super.key,
    required this.inputs,
    required this.onApply,
    required this.onReset,
    required this.icons
  });

  final List<T> inputs;
  final VoidCallback onReset; // Acción al presionar icono de papelera
  final VoidCallback onApply; // Acción al presionar "Buscar"
  final List<Map<String,dynamic>> icons;

  @override
  State<Filter> createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  final form = GlobalKey<FormState>();
  bool _isFilterVisible = false;


  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PaginationProvider>();
    final textStyle = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadiusValue),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Botón para mostrar/ocultar filtro
          Padding(
            padding: const EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ...widget.icons.map((icon){
                  return IconButton(
                    onPressed: icon['onPressed'], icon: Icon(icon['icon'])
                    );
                }),
                // IconButton(
                //     onPressed: () {}, icon: Icon(Icons.download_rounded)),
                Row(
                  children: [
                    _isFilterVisible
                        ? IconButton(
                            onPressed: widget.onReset,
                            // _resetFilters, // Reinicia filtros aquí,
                            icon: Icon(Icons.delete_outline_rounded))
                        : Container(),
                    SizedBox(
                      width: 10,
                    ),
                    IconButton(
                      icon: Icon(
                        _isFilterVisible
                            ? Icons.expand_less
                            : Icons.expand_more,
                      ),
                      onPressed: () {
                        setState(() {
                          _isFilterVisible = !_isFilterVisible;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Filtro con animación
          AnimatedSize(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: _isFilterVisible
                ? Form(
                    key: form,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          ... widget.inputs.map((widget) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: widget,
                          );
                        }),
                        
                          CustomButton(
                            title: 'Buscar',
                            isPrimaryColor: true,
                            isOutline: false,
                            onTap: () {
                              widget.onApply?.call();
                            },
                            provider: provider)
                        ]
      
                      ),
                    ),
                  )
                : SizedBox.shrink(),
          )
        ],
      ),
    );
  }
}
