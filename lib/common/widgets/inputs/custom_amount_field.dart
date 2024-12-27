import 'package:f_bapp/common/assets/theme/app_colors.dart';
import 'package:f_bapp/common/assets/theme/app_theme.dart';
import 'package:f_bapp/common/data/digit_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomAmountField extends StatelessWidget {
  const CustomAmountField(
      {this.hintText = 'Ej: 10',
      this.hintStyle,
      this.suffixTextStyle,
      this.suffixIcon,
      this.useDecimals = true,
      this.currencyName = '',
      this.minLength = 3,
      this.maxLength = 80,
      this.readOnly = false,
      this.showMaxFundsButton = false,
      this.onChanged,
      this.onMaxFunds,
      this.errorMessage,
      required this.amountcontroller,
      this.paddingV = 5,
      this.paddingH = 5,
      this.validator,
      this.node,
      super.key});

  final TextEditingController amountcontroller;
  final String? errorMessage;
  final FocusNode? node;

  final String hintText;
  final TextStyle? hintStyle;
  final TextStyle? suffixTextStyle;
  final Widget? suffixIcon;
  final bool useDecimals;
  final double paddingV;
  final double paddingH;
  final String currencyName;
  final int minLength;
  final int maxLength;
  final bool readOnly;
  final bool showMaxFundsButton;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onMaxFunds;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: paddingV, horizontal: paddingH),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  //configura con las opciones proporcionadas
                  controller: amountcontroller,
                  //input numerico
                  keyboardType:
                      TextInputType.numberWithOptions(decimal: useDecimals),
                  inputFormatters: [
                    //formato 00,00
                    DigitFormatter.inputMoneyFormatter,
                  ],

                  readOnly: readOnly,
                  showCursor: true,

                  //validaciones
                  validator: validator,
                  focusNode: node,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 23, vertical: 13),
                    fillColor: Colors.white,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    counterText: '',
                    suffixIcon: suffixIcon,
                    suffixText: currencyName,
                    suffixStyle: suffixTextStyle,
                    isDense: true,
                    hintText: hintText,
                    hintStyle: hintStyle ??
                        const TextStyle(
                          color: hintTextColor,
                        ),

                    errorText: errorMessage,
                    focusColor: colors.primary,

                    // Bordes según el estado del campo.
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(borderRadiusValue),
                      borderSide: const BorderSide(
                        color: primaryColor,
                        width: 2,
                      ),
                    ),

                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(borderRadiusValue),
                      borderSide: const BorderSide(
                        color: hintTextColor,
                        width: 2,
                      ),
                    ),

                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(borderRadiusValue),
                      borderSide: const BorderSide(
                        color: primaryColor,
                        width: 2,
                      ),
                    ),

                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(borderRadiusValue),
                      borderSide: const BorderSide(
                        color: errorColor,
                        width: 2,
                      ),
                    ),

                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(borderRadiusValue),
                      borderSide: const BorderSide(
                        color: errorColor,
                        width: 2,
                      ),
                    ),
                  ),
                  onTap: () {
                    //Oculta el teclado en dispositivos iOS si el tipo es numérico.

                    FocusScope.of(context).unfocus();
                  },
                  onChanged: onChanged,
                ),
              ),
              if (showMaxFundsButton)
                TextButton(
                  onPressed: onMaxFunds,
                  child: Text('Máx'),
                ),
            ],
          ),
          if (errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                errorMessage!,
                style: TextStyle(color: Colors.red),
              ),
            ),
        ],
      ),
    );
  }
}
