import 'package:f_bapp/common/data/constants.dart';
import 'package:f_bapp/common/widgets/buttons/custom_button.dart';
import 'package:f_bapp/common/widgets/inputs/custom_amount_field.dart';
import 'package:f_bapp/common/widgets/inputs/custom_dropdown.dart';
import 'package:f_bapp/common/widgets/inputs/custom_text_form_field.dart';
import 'package:f_bapp/config/router/routes.dart';
import 'package:f_bapp/presentation/providers/modules/merchant_provider.dart';
import 'package:f_bapp/presentation/providers/shared/navigation_provider.dart';
import 'package:f_bapp/presentation/providers/shared/session_provider.dart';
import 'package:f_bapp/presentation/widgets/shared/custom_navbar.dart';
import 'package:f_bapp/presentation/widgets/shared/drawer_menu.dart';
import 'package:f_bapp/presentation/widgets/shared/screens_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RefundPaymentsScreen extends StatefulWidget {
  const RefundPaymentsScreen({super.key});

  @override
  State<RefundPaymentsScreen> createState() => _RefundPaymentsScreenState();
}

class _RefundPaymentsScreenState extends State<RefundPaymentsScreen> {
  final GlobalKey<ScaffoldState> _refundpaymentsScaffoldKey =
      GlobalKey<ScaffoldState>();

  String? dropdownBankValue;
  String? dropdownDocumentTypeValue;
  late TextEditingController phoneController;
  late TextEditingController documentController;
  late TextEditingController descriptionController;
  late TextEditingController amountController;

  @override
  void initState() {
    super.initState();
    phoneController = TextEditingController(text: "");
    documentController = TextEditingController(text: "");
    descriptionController = TextEditingController(text: "");
    amountController = TextEditingController(text: "");
  }

  @override
  Widget build(BuildContext context) {
    final navProvider = context.watch<NavigationProvider>();
    final textStyle = Theme.of(context).textTheme;
    final merchantProvider = context.watch<MerchantProvider>();
    final sessionProvider = context.watch<SessionProvider>();

    return Scaffold(
      drawer: DrawerMenu(),
      key: _refundpaymentsScaffoldKey,
      onDrawerChanged: (isOpened) {
        if (!isOpened) {
          Future.delayed(Duration(milliseconds: navProvider.showNavBarDelay),
              () {
            navProvider.updateShowNavBar(true);
          });
        } else {
          navProvider.updateShowNavBar(false);
        }
      },
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(110),
          child: Screensappbar(
            title: 'Envío de pago móvil (vuelto)',
            screenKey: _refundpaymentsScaffoldKey,
            poproute: merchantScreen,
          )),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              //Titulo
              Text(
                "Indique los datos del receptor de la devolución",
                style: textStyle.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              //Seleccionar banco
              CustomDropdown(
                options: [],
                onChanged: (value) {
                  setState(() {
                    dropdownBankValue = value;
                  });
                },
                itemValueMapper: (option) => option['tagStatus']!,
                itemLabelMapper: (option) => option['tagStatus']!,
                hintText: "Seleccione un banco *",
              ),
              const SizedBox(height: 20),

              //telefono
              CustomTextFormField(
                paddingH: 2,
                controller: phoneController,
                hintText: 'Teléfono *',
                inputType: TextInputType.number,
                maxLength: 11,
                hintStyle: textStyle.bodySmall!
                    .copyWith(fontSize: 17, color: Colors.grey),
                enabled: true,
                validator: (value) {
                  if (value != null && value != "") {
                    if (value.length < 11) {
                      return 'El formato no es válido ';
                    }
                    if (phoneRegex.hasMatch(value.trim())) {
                      return 'El código de área no es válido';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),

              // tipo de documento e input para el numero
              Padding(
                padding: const EdgeInsets.only(left: 3),
                child: SizedBox(
                  width: double.infinity,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Tipo documento
                      SizedBox(
                        width: 90, // Define un ancho fijo para el dropdown
                        child: CustomDropdown(
                          title: "Tipo *",
                          titleAlignment: Alignment.center,
                          autoSelectFirst: true,
                          options: [],
                          onChanged: (value) {
                            setState(() {
                              dropdownDocumentTypeValue = value;
                            });
                          },
                          selectedValue: dropdownDocumentTypeValue,
                          itemValueMapper: (option) => "",
                          itemLabelMapper: (option) => "",
                        ),
                      ),
                      //input para numero de documento
                      Expanded(
                        child: Column(
                          
                          children: [
                            const SizedBox(
                                height:
                                    16), // Espacio adicional para bajar el input
                            CustomTextFormField(
                              controller: documentController,
                              inputType: TextInputType.number,
                              hintText: 'CI/RIF *',
                              enabled: true,
                              maxLength: 8,
                              validator: (value) {
                                if (value != null && value != "") {
                                  if (value.length < 8) {
                                    return 'El formato no es válido ';
                                  }
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              //input de monto
              CustomAmountField(
                amountcontroller: amountController,
                hintText: 'Monto *',
                useDecimals: true,
                currencyName: 'Bs',
              ),

              const SizedBox(height: 20),

              //input descripcion
              CustomTextFormField(
                controller: descriptionController,
                enabled: true,
                hintText: 'Descripción *',
              ),
              const SizedBox(height: 20),

              //boton
              CustomButton(
                title: "Realizar devolución",
                styleText: textStyle.titleMedium!
                    .copyWith(fontWeight: FontWeight.bold, color: Colors.white),
                isPrimaryColor: true,
                isOutline: false,
                onTap: () {},
                provider: merchantProvider,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
