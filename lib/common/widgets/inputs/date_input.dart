import 'package:f_bapp/common/assets/theme/app_theme.dart';
import 'package:f_bapp/common/data/data_formatter.dart';
import 'package:f_bapp/common/providers/theme_provider.dart';
import 'package:f_bapp/common/widgets/inputs/custom_text_form_field.dart';
import 'package:f_bapp/presentation/providers/shared/utils_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class DateInput extends StatelessWidget {
  final TextEditingController controller;
  final bool rangeDate;

  const DateInput(
      {super.key, required this.controller, required this.rangeDate});

  @override
  Widget build(BuildContext context) {
    final utilsProvider = context.read<UtilsProvider>();
    final themeProvider = context.read<ThemeProvider>();

    return CustomTextFormField(
        controller: controller,
        inputType: TextInputType.none,
        isPaddingZero: true,
        // label: 'Fecha de la transacción *',
        hintText: 'Fecha de la transacción *',
        readOnly: true,
        enabled: !utilsProvider.isLoading,
        showCursor: false,
        suffixIcon: const Icon(
          Icons.calendar_month_rounded,
          size: 20,
        ),
        onTap: () => {
              if (!rangeDate)
                {
                  showDatePicker(
                      context: context,
                      // locale: const Locale('es'),
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                      cancelText: 'CANCELAR',
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: themeProvider.isDarkModeEnabled
                                ? const ColorScheme.dark(
                                    primary: primaryColor,
                                    onPrimary: darkColor,
                                  )
                                : const ColorScheme.light(
                                    primary: primaryColor,
                                  ),
                          ),
                          child: child!,
                        );
                      }).then(
                    (value) {
                      if (value != null) {
                        String serviceFormattedDate =
                            DateFormatter.formatDatePicker(
                          value,
                          "yyyy/MM/dd",
                        );

                        String formattedDate = DateFormatter.formatDatePicker(
                          value,
                          'dd/MM/yyyy',
                        );

                        controller.text = formattedDate;
                      }
                    },
                  ),
                }
              else
                {
                  showDateRangePicker(
                    context: context,
                    // locale: const Locale('es'),
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                    cancelText: 'CANCELAR',
                    confirmText: 'SELECCIONAR',
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: themeProvider.isDarkModeEnabled
                              ? const ColorScheme.dark(
                                  primary: primaryColor,
                                  onPrimary: darkColor,
                                )
                              : const ColorScheme.light(
                                  primary: primaryColor,
                                ),
                        ),
                        child: child!,
                      );
                    },
                  )
                  .then((value) {
                    if (value != null) {
                      // Formatear las fechas seleccionadas
                      String formattedStartDate =
                          DateFormatter.formatDatePicker(
                        value.start,
                        'dd/MM/yyyy',
                      );
                      String formattedEndDate = DateFormatter.formatDatePicker(
                        value.end,
                        'dd/MM/yyyy',
                      );

                      controller.text =
                          "$formattedStartDate - $formattedEndDate";
                    }
                  })
                }
            },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Campo requerido';
          }
          if (value.contains(' ')) {
            return 'El campo no permite espacios';
          }

          return null;
        });
  }
}