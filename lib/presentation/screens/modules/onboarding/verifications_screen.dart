import 'package:f_bapp/common/data/date_formatter.dart';
import 'package:f_bapp/common/providers/pagination_provider.dart';
import 'package:f_bapp/common/widgets/cards/text_card.dart';
import 'package:f_bapp/common/widgets/inputs/custom_dropdown.dart';
import 'package:f_bapp/common/widgets/inputs/custom_text_form_field.dart';
import 'package:f_bapp/common/widgets/inputs/date_input.dart';
import 'package:f_bapp/common/widgets/inputs/filter_container.dart';
import 'package:f_bapp/common/widgets/inputs/status_checkboxs.dart';
import 'package:f_bapp/common/widgets/shared/custom_skeleton.dart';
import 'package:f_bapp/common/widgets/shared/pagination.dart';
import 'package:f_bapp/config/data_constants/data_constants.dart';
import 'package:f_bapp/config/router/routes.dart';
import 'package:f_bapp/config/theme/business_app_colors.dart';
import 'package:f_bapp/presentation/providers/modules/onboarding/onboarding_provider.dart';
import 'package:f_bapp/presentation/providers/shared/navigation_provider.dart';
import 'package:f_bapp/presentation/providers/shared/user_provider.dart';
import 'package:f_bapp/presentation/widgets/shared/drawer_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../widgets/shared/screens_appbar.dart';

class VerificationsScreen extends StatefulWidget {
  const VerificationsScreen({super.key});

  @override
  State<VerificationsScreen> createState() => _VerificationsScreenState();
}

class _VerificationsScreenState extends State<VerificationsScreen> {
  final GlobalKey<ScaffoldState> _verificationsScaffoldKey =
      GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();

  late TextEditingController searchController;
  late TextEditingController dateController;
  String? dropdownValue;
  String template = "";
  String searchValue = '';
  String endDate = '';
  String startDate = '';
  List<String> statusesIdsList = [];
  Set<String> selectedStatuses={}; 

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchController = TextEditingController();
    dateController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final onboardingProvider = context.read<OnboardingProvider>();
      final paginationProvider = context.read<PaginationProvider>();

      //se reinicia la paginacion
      paginationProvider.resetPagination();

      //peticiones para obtener la lista de verificaciones y los tipos de plantillas
      await onboardingProvider.verificationTemplates();
      await onboardingProvider.listVerificationStatus();
      await onboardingProvider.listVerifications(
        limit: 5,
        page: 0,
      );

      //el total de elementos para la paginacion sera igual a la cantidad de ordenes que halla
      if (onboardingProvider.verifications != null) {
        paginationProvider.setTotal(onboardingProvider.verifications!['count']);
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    dateController.dispose();
    super.dispose();
  }

  //Reinicio de los valores de los filtros
  void resetFilters() async {
    final paginationProvider = context.read<PaginationProvider>();
    final onboardingProvider = context.read<OnboardingProvider>();

    setState(() {
      searchController.clear();
      dateController.clear();
      dropdownValue = null;
      selectedStatuses.clear();
    });

    template = "";
    searchValue = '';
    endDate = '';
    startDate = '';
    statusesIdsList = [];

    await onboardingProvider.listVerifications(
      page: paginationProvider.page,
      limit: 5,
      startDate: startDate,
      endDate: endDate,
      search: searchValue,
      idVerificationTemplate: template,
      statusesIdsLists: statusesIdsList,
    );

    paginationProvider.resetPagination();
    paginationProvider.setTotal(onboardingProvider.verifications!['count']);
  }

  void applyFilters() async {
    final paginationProvider = context.read<PaginationProvider>();

    // Procesar filtros aquí
    template = dropdownValue ?? "";
    searchValue = searchController.text;
    endDate =
        dateController.text != "" ? dateController.text.split(" - ")[1] : "";
    startDate =
        dateController.text != "" ? dateController.text.split(" - ")[0] : "";
            
    // Actualiza la lista con los valores seleccionados
    statusesIdsList = selectedStatuses.toList();


    print('Hola ${statusesIdsList}');

    //se hace la peticion con los filtros aplicados
    final onboardingProvider = context.read<OnboardingProvider>();
    await onboardingProvider.listVerifications(
      page: 0,
      limit: 5,
      startDate: startDate,
      endDate: endDate,
      search: searchValue,
      idVerificationTemplate: template,
      statusesIdsLists: statusesIdsList,
    );

    paginationProvider.resetPagination();
    paginationProvider.setTotal(onboardingProvider.verifications!['count']);
  }

  @override
  Widget build(BuildContext context) {
    final paginationProvider = context.watch<PaginationProvider>();
    final navProvider = context.watch<NavigationProvider>();
    final onboardingProvider = context.watch<OnboardingProvider>();
    final textStyle = Theme.of(context).textTheme;
    final userProvider = context.read<UserProvider>();

    //Componentes que tendra el filtro
    final List<Widget> filters = [
      CustomTextFormField(
          controller: searchController,
          hintText: 'Buscar por nombre, id, cédula',
          hintStyle:
              textStyle.bodySmall!.copyWith(fontSize: 17, color: Colors.grey),
          enabled: true,
          validator: (value) {
            if (value != null && value != "") {
             
            }

            return null;
          }),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: CustomDropdown(
          hintText: 'Opciones de vistas',
          options: onboardingProvider.templateTypes ?? [],
          onChanged: (value) {
            setState(() {
              dropdownValue = value;
            });
          },
          selectedValue: dropdownValue,
          itemValueMapper: (option) => option['idTemplate']!,
          itemLabelMapper: (option) => option['name']!,
          autoSelectFirst: false,
          optionsTextsStyle: textStyle.bodySmall!.copyWith(fontSize: 14),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: DateInput(
          controller: dateController,
          rangeDate: true,
          hintText: 'Fecha de emision',
        ),
      ),
      StatusCheckboxs(
        status: onboardingProvider.verificationStatus ?? [],
        selectedStatuses: selectedStatuses,
        // onTap: (Set<String> selectedStatuses) {
        //   setState(() {
        //     // Actualiza la lista con los valores seleccionados
        //     statusesIdsList = selectedStatuses.toList();
        //   });
        // },
      )
    ];

    return Scaffold(
      drawer: DrawerMenu(),
      key: _verificationsScaffoldKey,
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
            title: 'Verificaciones',
            screenKey: _verificationsScaffoldKey,
            poproute: onboardingScreen,
            onBack: () {
              onboardingProvider.disposeValues();
            },
          )),
      body: Column(
        children: [
          //esta cargando
          if (onboardingProvider.isLoading ||
              onboardingProvider.templateTypes == null ||
              onboardingProvider.verifications == null) ...[
            const SizedBox(
              height: 15,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 35, vertical: 15),
              child: Center(
                child: CustomSkeleton(
                  height: 65,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 35),
              child: CustomSkeleton(height: 140),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 35),
              child: CustomSkeleton(height: 140),
            ),
            const SizedBox(
              height: 15,
            ),
          ],

          //ya cargo
          if (!onboardingProvider.isLoading &&
              onboardingProvider.verifications != null) ...[
            //si no hay verificaciones
            if (onboardingProvider.verifications!['count'] == 0) ...[
              //Filtro
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 35, vertical: 15),
                child: Filter(
                  icons: [],
                  inputs: filters,
                  onReset: resetFilters,
                  onApply: applyFilters,
                ),
              ),

              //Aviso
              Expanded(
                child: SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      Center(
                        child: SvgPicture.asset(
                          '${DataConstant.imagesChinchin}/no-data.svg',
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const Center(child: Text('No hay datos disponibles')),
                    ],
                  ),
                ),
              )
            ],

            //si hay devoluciones
            if (onboardingProvider.verifications!['count'] > 0) ...[
              //Filtro
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 35, vertical: 15),
                child: Filter(
                  icons: [],
                  inputs: filters,
                  onReset: resetFilters,
                  onApply: applyFilters,
                ),
              ),

              //Tarjetas con informacion
              Expanded(
                child: ListView.builder(
                    controller: _scrollController,
                    itemCount: onboardingProvider.verifications!['rows'].length,
                    itemBuilder: (context, index) {
                      final verification =
                          onboardingProvider.verifications!['rows'][index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 35),
                        child: TextCard(
                          statusTextStyle: textStyle.bodySmall,
                          texts: buildTextsFromVerification(verification,
                              statusColors), // Lista con los textos generada
                          onTap: () {},
                        ),
                      );
                    }),
              ),

              //Paginacion
              Pagination(
                //Funcion al pasar a la siguiente pagina
                onNextPressed: () {
                  onboardingProvider.listVerifications(
                    page: paginationProvider.page,
                    limit: 5,
                    startDate: startDate,
                    endDate: endDate,
                    search: searchValue,
                    idVerificationTemplate: template,
                    statusesIdsLists: statusesIdsList,
                  );

                  //se mantienen los valores en el filtro si se hace una busqueda
                  if (template!="") {
                    dropdownValue=template;
                  } else {
                    dropdownValue = null;
                  }
                  searchController.text =searchValue;
                  if (startDate!="" && endDate!="") {
                      dateController.text = '$startDate - $endDate';
                    } else {
                      dateController.text='';
                    }
                  
                  selectedStatuses = statusesIdsList.toSet();

                },

                //Funcion al pasar a la pagina anterior
                onPreviousPressed: () {
                  onboardingProvider.listVerifications(
                    page: paginationProvider.page,
                    limit: 5,
                    startDate: startDate,
                    endDate: endDate,
                    search: searchValue,
                    idVerificationTemplate: template,
                    statusesIdsLists: statusesIdsList,
                  );

                  //se mantienen los valores en el filtro si se hace una busqueda
                  if (template!="") {
                    dropdownValue=template;
                  } else {
                    dropdownValue = null;
                  }
                  searchController.text =searchValue;
                  if (startDate!="" && endDate!="") {
                      dateController.text = '$startDate - $endDate';
                    } else {
                      dateController.text='';
                    }
                  
                  selectedStatuses = statusesIdsList.toSet();

                },
              )
            ],
          ],
        ],
      ),
    );
  }

  //Se contruye el contenido de la lista textos que tendra la tarjeta
  List<Map<String, dynamic>> buildTextsFromVerification(
      Map<String, dynamic> verification, Map<String, Color> statusColors) {
    List<Map<String, dynamic>> objects = [];

    if (verification['idVerification'] != null) {
      objects.add({'label': 'ID: ', 'value': verification['idVerification']});
    }

    if (verification['firstName'] != null &&
        verification['firstLastName'] != null) {
      objects.add({
        'label': 'Nombre: ',
        'value': "${verification['firstName']} ${verification['firstLastName']}"
      });
    }

    if (verification['documentNumber'] != null) {
      objects.add(
          {'label': 'Documento: ', 'value': verification['documentNumber']});
    }

    if (verification['verificationName'] != null) {
      objects.add(
          {'label': 'Plantilla: ', 'value': verification['verificationName']});
    }

    if (verification['createdDate'] != null) {
      objects.add({
        'label': 'Fecha: ',
        'value': DateFormatter.formatDate(
            DateTime.parse(verification['createdDate']))
      });
    }

    objects.add({
      'label': 'status',
      'value': verification['verificationStatusName'],
      'statusColor': statusColors[verification['verificationStatusName']]
    });

    return objects;
  }
}
