import 'package:f_bapp/common/assets/theme/app_colors.dart';
import 'package:f_bapp/common/widgets/buttons/custom_button.dart';
import 'package:f_bapp/common/widgets/inputs/custom_amount_field.dart';
import 'package:f_bapp/common/widgets/inputs/custom_dropdown.dart';
import 'package:f_bapp/common/widgets/inputs/custom_text_form_field.dart';
import 'package:f_bapp/common/widgets/shared/custom_skeleton.dart';
import 'package:f_bapp/config/router/routes.dart';
import 'package:f_bapp/presentation/providers/modules/merchant/merchant_provider.dart';
import 'package:f_bapp/presentation/providers/shared/navigation_provider.dart';
import 'package:f_bapp/presentation/providers/shared/session_provider.dart';
import 'package:f_bapp/presentation/widgets/shared/drawer_menu.dart';
import 'package:f_bapp/presentation/widgets/shared/screens_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateOrderScreen extends StatefulWidget {
  const CreateOrderScreen({super.key});

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  final GlobalKey<ScaffoldState> _createorderScaffoldKey =
      GlobalKey<ScaffoldState>();

  late TextEditingController amountController;
  late TextEditingController expirationTimeController;
  late TextEditingController referenceController;

//Lista de controladores para la informacion adicional
  List<Map<String, TextEditingController>> additionalInfoControllers = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    amountController = TextEditingController(text: "");
    expirationTimeController = TextEditingController(text: "");
    referenceController = TextEditingController(text: "");

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final sessionProvider = context.read<SessionProvider>();

      //peticiones para obtener listado de monedas
      await sessionProvider.listCurrencies();
    });
  }

  void addAdditionalInfoWidget() {
    setState(() {
      additionalInfoControllers.add({
        'key': TextEditingController(),
        'value': TextEditingController(),
      });
    });
  }

  void removeAdditionalInfoWidget(int index) {
    setState(() {
      if (index >= 0 && index < additionalInfoControllers.length) {
        // Libera los controladores para evitar fugas de memoria
        additionalInfoControllers[index]['key']?.dispose();
        additionalInfoControllers[index]['value']?.dispose();
        additionalInfoControllers.removeAt(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final navProvider = context.watch<NavigationProvider>();
    final merchantProvider = context.watch<MerchantProvider>();
    final textStyle = Theme.of(context).textTheme;
    final sessionProvider = context.watch<SessionProvider>();

    return Scaffold(
      drawer: DrawerMenu(),
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
      key: _createorderScaffoldKey,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(110),
          child: Screensappbar(
            title: 'Crear orden de pasarela',
            screenKey: _createorderScaffoldKey,
            poproute: merchantScreen,
          )),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (sessionProvider.isLoading) ...[
                //Cargando monto y tipo de moneda
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2.4,
                      child: Center(
                        child: CustomSkeleton(
                          height: 55,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2.4,
                      child: Center(
                        child: CustomSkeleton(
                          height: 55,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 30,
                ),
                //Cargando inputs tiempo de expiracion y referencia
                const CustomSkeleton(
                  height: 55,
                ),
                const SizedBox(
                  height: 35,
                ),

                const CustomSkeleton(
                  height: 55,
                ),

                //boton 
                const SizedBox(height: 55,),
                const CustomSkeleton(height: 60)
              ],
              if (!sessionProvider.isLoading) ...[
                //Seleccionar moneda
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: SizedBox(
                    width: double.infinity,
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomAmountField(
                              hintText: 'Monto *',
                              hintStyle: textStyle.bodyMedium!
                                  .copyWith(color: hintTextColor),
                              useDecimals: true,
                              amountcontroller: amountController),
                        ),
                        Expanded(
                          child: CustomDropdown(
                            autoSelectFirst: false,
                            hintText: 'Seleccione una moneda *',
                            hintTextStyle: textStyle.bodyMedium!
                                .copyWith(color: hintTextColor),
                            options: sessionProvider.currencies!,
                            onChanged: (value) {},
                            itemValueMapper: (options) => options['idCurrency'],
                            itemLabelMapper: (options) =>
                                options['nameCurrency'],
                          ),
                        )
                      ],
                    ),
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

                //Tiempo de expiracion
                CustomTextFormField(
                  controller: expirationTimeController,
                  enabled: true,
                  hintText: 'Tiempo de expiración (opcional)',
                  hintStyle:
                      textStyle.bodyMedium!.copyWith(color: hintTextColor),
                  inputType: TextInputType.number,
                  suffixText: 'MIN',
                  suffixTextStyle: textStyle.bodyMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),

                const SizedBox(
                  height: 20,
                ),

                //Referencia
                CustomTextFormField(
                  controller: referenceController,
                  enabled: true,
                  hintText: 'Referencia externa (opcional)',
                  hintStyle:
                      textStyle.bodyMedium!.copyWith(color: hintTextColor),
                ),

                const SizedBox(
                  height: 20,
                ),

                //Añadir informacion
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Text('Información adicional (metadata)'),
                      IconButton(
                          onPressed: addAdditionalInfoWidget,
                          icon: Icon(Icons.add))
                    ],
                  ),
                ),

                Column(
                  children:
                      List.generate(additionalInfoControllers.length, (index) {
                    final controllers = additionalInfoControllers[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: SizedBox(
                        width: double.infinity,
                        child: Row(
                          children: [
                            Expanded(
                              child: CustomTextFormField(
                                enabled: true,
                                hintText: 'Llave *',
                                hintStyle: textStyle.bodyMedium!
                                    .copyWith(color: hintTextColor),
                                controller: controllers['key']!,
                              ),
                            ),
                            Expanded(
                              child: CustomTextFormField(
                                enabled: true,
                                hintText: 'Valor *',
                                controller: controllers['value']!,
                              ),
                            ),
                            IconButton(
                              onPressed: () =>
                                  removeAdditionalInfoWidget(index),
                              icon: Icon(Icons.delete_rounded),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),

                //Boton
                CustomButton(
                    title: 'Aceptar',
                    isPrimaryColor: true,
                    isOutline: false,
                    onTap: () {},
                    provider: merchantProvider)
              ],
            ],
          ),
        ),
      ),
    );
  }
}
