import 'package:f_bapp/common/assets/theme/app_theme.dart';
import 'package:f_bapp/common/data/filterdef.dart';
import 'package:f_bapp/common/widgets/inputs/custom_dropdown.dart';
import 'package:f_bapp/common/widgets/inputs/custom_textfield.dart';
import 'package:f_bapp/common/widgets/inputs/date_input.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/pagination_provider.dart';

class Filter<T> extends StatefulWidget {
  const Filter({
    super.key,
    required this.options,
  });

  final List<T> options;

  @override
  State<Filter> createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  final _textController1 = TextEditingController();
  final _textController2 = TextEditingController();
  final _textController3 = TextEditingController();
  String? _dropdownValue;
  bool _isFilterVisible = false;

  @override
  void dispose() {
    _textController1.dispose();
    _textController2.dispose();
    _textController3.dispose();
    super.dispose();
  }

  void _resetFilters() {
    setState(() {
      _textController1.clear();
      _textController2.clear();
      _textController3.clear();
      _dropdownValue = null; // Reinicia el valor del Dropdown
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PaginationProvider>();
    final textStyle = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(BorderRadiusValue),
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
                IconButton(
                    onPressed: () {}, icon: Icon(Icons.download_rounded)),
                Row(
                  children: [
                    _isFilterVisible
                        ? IconButton(
                            onPressed: _resetFilters, // Reinicia filtros aquí,
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
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: CustomTextfield(
                          hint: 'Buscar nro referencia',
                          onChanged: (value) {
                            setState(() {});
                          },
                          controller: _textController1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: CustomTextfield(
                          hint: 'Buscar nro telefono emisor',
                          onChanged: (value) {
                            setState(() {});
                          },
                        controller: _textController2,
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: CustomDropdown(
                              options: widget.options,
                              onChanged: (value) {
                                setState(() {
                                _dropdownValue = value;
                              });
                              },
                              selectedValue: _dropdownValue,
                              itemValueMapper:(option) => option['nameStatus']!,
                              itemLabelMapper: (option) => option['nameStatus']!,
                              autoSelectFirst: false,
                              
                              optionsTextsStyle:textStyle.bodySmall!.copyWith(
                                fontSize: 14
                              ),
                              )
                              ),

                              DateInput(
                                controller: _textController3, 
                                rangeDate: true,
                                )
                    ]),
                  )
                : SizedBox.shrink(),
          )
        ],
      ),
    );
  }
}
