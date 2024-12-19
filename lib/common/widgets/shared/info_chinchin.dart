import 'package:f_bapp/common/assets/theme/app_colors.dart';
import 'package:f_bapp/common/assets/theme/app_theme.dart';
import 'package:f_bapp/common/data/constants.dart';
import 'package:f_bapp/common/providers/general_provider.dart';
import 'package:f_bapp/common/providers/theme_provider.dart';
import 'package:f_bapp/common/widgets/buttons/custom_button.dart';
import 'package:f_bapp/config/data_constants/data_constants.dart';
import 'package:f_bapp/config/router/routes.dart';
import 'package:f_bapp/infrastructure/shared/secure_storage_service.dart';
import 'package:f_bapp/infrastructure/shared/storage_service_impl.dart';
import 'package:f_bapp/presentation/providers/auth/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoChinchin extends StatefulWidget {
  bool showVersion = false;
  InfoChinchin({super.key,  required this.showVersion});

  @override
  State<InfoChinchin> createState() => _InfoChinchinState();
}

class _InfoChinchinState extends State<InfoChinchin> {
  
  final storageService = SecureStorageService();
  final normalStorage = StorageService();

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    final themeProvider = context.watch<ThemeProvider>();
    final loginProvider = context.watch<LoginProvider>();

    return Container(
      //* Padding, modificar de ser necesario, sino, dejar estos valores (EdgeInsets.fromLTRB(50, 35, 50, 0)
      height: MediaQuery.of(context).size.height / 1.21, // valor original 1.2
      padding: const EdgeInsets.fromLTRB(42, 18, 42, 0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          //* logo chinchin
          // const LogoChinchin(
          //   size: 150,
          //   haveWidth: false,
          // ),
          //* titulo
          Text(
            'Soluciones Financieras Chinchin, C. A',
            style: textStyle.bodySmall!.copyWith(fontSize: 16),
          ),

          //* Número de rif
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'RIF: ',
                style: textStyle.bodySmall!
                    .copyWith(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                'J-415198282',
                style: textStyle.bodySmall!.copyWith(fontSize: 16),
              ),
            ],
          ),

          // const SizedBox(height: 0),

          //* Columna de Atención
          Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.call,
                    color: themeProvider.isDarkModeEnabled
                        ? primaryScaffoldColor
                        : primaryColor,
                    size: 17,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'Centro de Atención telefónica',
                    style: textStyle.bodySmall!
                        .copyWith(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              const Divider(height: 1, color: primaryColor),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(
                            Icons.circle,
                            size: 8,
                            color: themeProvider.isDarkModeEnabled
                                ? primaryScaffoldColor
                                : primaryColor,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '0212-8160340',
                            style: textStyle.bodySmall!.copyWith(fontSize: 15),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.circle,
                            size: 8,
                            color: themeProvider.isDarkModeEnabled
                                ? primaryScaffoldColor
                                : primaryColor,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '0212-8160350',
                            style: textStyle.bodySmall!.copyWith(fontSize: 15),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.circle,
                            size: 8,
                            color: themeProvider.isDarkModeEnabled
                                ? primaryScaffoldColor
                                : primaryColor,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '0412-3409942',
                            style: textStyle.bodySmall!.copyWith(fontSize: 15),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          // const SizedBox(height: 0),
          //* Columna de Horario de Atención
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.calendar_month,
                      size: 17,
                      color: themeProvider.isDarkModeEnabled
                          ? primaryScaffoldColor
                          : primaryColor),
                  const SizedBox(width: 5),
                  Text(
                    'Horario de Atención',
                    style: textStyle.bodySmall!
                        .copyWith(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              const Divider(height: 1, color: primaryColor),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(
                    Icons.circle,
                    size: 8,
                    color: themeProvider.isDarkModeEnabled
                        ? primaryScaffoldColor
                        : primaryColor,
                  ),
                  const SizedBox(width: 5),
                  Text('Lunes a Viernes de 8:00 am a 5:00 pm',
                      style: textStyle.bodySmall!.copyWith(fontSize: 15)),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.circle,
                    size: 8,
                    color: themeProvider.isDarkModeEnabled
                        ? primaryScaffoldColor
                        : primaryColor,
                  ),
                  const SizedBox(width: 5),
                  Text('Sábado de 9:00 am a 3:00 pm',
                      style: textStyle.bodySmall!.copyWith(fontSize: 15)),
                ],
              ),
            ],
          ),

          // const SizedBox(height: 0),
          //* Columna de Redes sociales
          Column(
            children: [
              Row(
                children: [
                  Icon(Icons.language_outlined,
                      size: 17,
                      color: themeProvider.isDarkModeEnabled
                          ? primaryScaffoldColor
                          : primaryColor),
                  const SizedBox(width: 5),
                  Text(
                    'Redes Sociales',
                    style: textStyle.bodySmall!
                        .copyWith(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              const Divider(height: 1, color: primaryColor),
              const SizedBox(height: 2),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  // whatsapp
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 3),
                      child: InkWell(
                          borderRadius: BorderRadius.circular(50),
                          onTap: () {
                            launchUrl(Uri.parse(
                                'https://api.whatsapp.com/send?phone=584123409942'));
                          },
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(borderRadiusValue),
                            child: Container(
                              padding: const EdgeInsets.all(0),
                              width: 50,
                              height: 50,
                              // color: primaryColor.withOpacity(0.1),
                              child:
                                  //* iconos para redes sociales, segun tema de la app cambian de color
                                  themeProvider.isDarkModeEnabled
                                      ? Image.asset(
                                          'lib/common/assets/images/social_media/icon_whatsapp.png',
                                          color: Colors.greenAccent[400],
                                          colorBlendMode: BlendMode.srcIn,
                                          scale: 2.8,
                                          filterQuality: FilterQuality.high,
                                        )
                                      : Image.asset(
                                          'lib/common/assets/images/social_media/icon_whatsapp.png',
                                          color: Colors.greenAccent[400],
                                          colorBlendMode: BlendMode.srcIn,
                                          scale: 2.8,
                                          filterQuality: FilterQuality.high,
                                        ),
                            ),
                          )),
                    ),
                  ),

                  const SizedBox(
                    width: 2,
                  ),

                  // instagram
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 3),
                      child: InkWell(
                          borderRadius: BorderRadius.circular(50),
                          onTap: () {
                            launchUrl(Uri.parse(
                                'https://www.instagram.com/pagochinchin/'));
                          },
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(borderRadiusValue),
                            child: Container(
                              padding: const EdgeInsets.all(0),
                              width: 50,
                              height: 50,
                              // color: primaryColor.withOpacity(0.1),
                              child:
                                  //* iconos para redes sociales, segun tema de la app cambian de color
                                  themeProvider.isDarkModeEnabled
                                      ? Image.asset(
                                          'lib/common/assets/images/social_media/icon_instagram.png',
                                          color: Colors.white,
                                          colorBlendMode: BlendMode.srcIn,
                                          scale: 2.8,
                                          filterQuality: FilterQuality.high,
                                        )
                                      : Image.asset(
                                          'lib/common/assets/images/social_media/icon_instagram.png',
                                          color: Colors.pink,
                                          colorBlendMode: BlendMode.srcIn,
                                          scale: 2.8,
                                          filterQuality: FilterQuality.high,
                                        ),
                            ),
                          )),
                    ),
                  ),

                  const SizedBox(
                    width: 2,
                  ),

                  // facebook
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 3),
                      child: InkWell(
                          borderRadius: BorderRadius.circular(50),
                          onTap: () {
                            launchUrl(Uri.parse(
                                'https://www.facebook.com/chinchinsolucionesfinancieras/'));
                          },
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(borderRadiusValue),
                            child: Container(
                              padding: const EdgeInsets.all(0),
                              width: 50,
                              height: 50,
                              // color: primaryColor.withOpacity(0.1),
                              child:
                                  //* iconos para redes sociales, segun tema de la app cambian de color
                                  themeProvider.isDarkModeEnabled
                                      ? Image.asset(
                                          'lib/common/assets/images/social_media/icon_facebook.png',
                                          color: Colors.blue,
                                          colorBlendMode: BlendMode.srcIn,
                                          scale: 2.8,
                                          filterQuality: FilterQuality.high,
                                        )
                                      : Image.asset(
                                          'lib/common/assets/images/social_media/icon_facebook.png',
                                          color: Colors.blue[900],
                                          colorBlendMode: BlendMode.srcIn,
                                          scale: 2.8,
                                          filterQuality: FilterQuality.high,
                                        ),
                            ),
                          )),
                    ),
                  ),

                  const SizedBox(
                    width: 2,
                  ),

                  // youtube
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 3),
                      child: InkWell(
                          borderRadius: BorderRadius.circular(50),
                          onTap: () {
                            launchUrl(Uri.parse(
                                'https://www.youtube.com/channel/UCa7YHvWz3NPMlwN0Z2YlleA'));
                          },
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(borderRadiusValue),
                            child: Container(
                              padding: const EdgeInsets.all(0),
                              width: 50,
                              height: 50,
                              // color: primaryColor.withOpacity(0.1),
                              child:
                                  //* iconos para redes sociales, segun tema de la app cambian de color
                                  themeProvider.isDarkModeEnabled
                                      ? Image.asset(
                                          'lib/common/assets/images/social_media/icon_youtube.png',
                                          color: Colors.red,
                                          colorBlendMode: BlendMode.srcIn,
                                          scale: 2.8,
                                          filterQuality: FilterQuality.high,
                                        )
                                      : Image.asset(
                                          'lib/common/assets/images/social_media/icon_youtube.png',
                                          color: Colors.red,
                                          colorBlendMode: BlendMode.srcIn,
                                          scale: 2.8,
                                          filterQuality: FilterQuality.high,
                                        ),
                            ),
                          )),
                    ),
                  ),

                  const SizedBox(
                    width: 2,
                  ),

                  // twitter
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 3),
                      child: InkWell(
                          borderRadius: BorderRadius.circular(50),
                          onTap: () {
                            launchUrl(
                                Uri.parse('https://twitter.com/PagoChinchin'));
                          },
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(borderRadiusValue),
                            child: Container(
                              padding: const EdgeInsets.all(0),
                              width: 50,
                              height: 50,
                              // color: primaryColor.withOpacity(0.1),
                              child:
                                  //* iconos para redes sociales, segun tema de la app cambian de color
                                  themeProvider.isDarkModeEnabled
                                      ? Image.asset(
                                          'lib/common/assets/images/social_media/icon_twitter.png',
                                          color: Colors.white,
                                          colorBlendMode: BlendMode.srcIn,
                                          scale: 2.8,
                                          filterQuality: FilterQuality.high,
                                        )
                                      : Image.asset(
                                          'lib/common/assets/images/social_media/icon_twitter.png',
                                          color: Colors.black,
                                          colorBlendMode: BlendMode.srcIn,
                                          scale: 2.8,
                                          filterQuality: FilterQuality.high,
                                        ),
                            ),
                          )),
                    ),
                  ),

                  const SizedBox(
                    width: 2,
                  ),

                  // linkedin
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 3),
                      child: InkWell(
                          borderRadius: BorderRadius.circular(50),
                          onTap: () {
                            launchUrl(Uri.parse(
                                'https://www.linkedin.com/company/soluciones-financieras-chinchin/mycompany/'));
                          },
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(borderRadiusValue),
                            child: Container(
                              padding: const EdgeInsets.all(0),
                              width: 50,
                              height: 50,
                              // color: primaryColor.withOpacity(0.1),
                              child:
                                  //* iconos para redes sociales, segun tema de la app cambian de color
                                  themeProvider.isDarkModeEnabled
                                      ? Image.asset(
                                          'lib/common/assets/images/social_media/icon_linkedin.png',
                                          color: Colors.blue,
                                          colorBlendMode: BlendMode.srcIn,
                                          scale: 2.8,
                                          filterQuality: FilterQuality.high,
                                        )
                                      : Image.asset(
                                          'lib/common/assets/images/social_media/icon_linkedin.png',
                                          color: Colors.blue[900],
                                          colorBlendMode: BlendMode.srcIn,
                                          scale: 2.8,
                                          filterQuality: FilterQuality.high,
                                        ),
                            ),
                          )),
                    ),
                  )
                ],
              )
            ],
          ),

          // const SizedBox(height: 0),
          //* Columna de versión
          Column(
            children: [
              if (widget.showVersion)
                Row(
                  children: [
                    Text(
                      'V-${Constants.appVersion}',
                      style: textStyle.bodySmall!.copyWith(fontSize: 15),
                    ),
                  ],
                ),
            ],
          ),

          // //* Columna de reiniciar auth
          if (loginProvider.enabledBiometric)
            Column(
              children: [
                // color: Colors.yellow,

                CustomButton(
                  title:'Reiniciar autenticación', 
                  isPrimaryColor: true, 
                  isOutline: false, 
                  onTap: () async {
                    // Borro todos la biometria del device
                    normalStorage.removeKey('enabledBiometric');
                    normalStorage.removeKey('userCompleteName');
                    storageService.deleteAll();

                    // redirigo al login
                    Navigator.popAndPushNamed(context, firstLoginScreen);

                    setState(() {});
                  }, 
                  provider: GeneralProvider())
                // CustomStaticButton(
                //   title: 'Reiniciar autenticación',
                //   isPrimaryColor: true,
                //   isOutline: false,
                //   paddingHorizontal: 0,
                //   paddingHorizontal2: 0,
                //   onTap: () async {
                //     // Borro todos la biometria del device
                //     normalStorage.removeKey('enabledBiometric');
                //     normalStorage.removeKey('userCompleteName');
                //     storageService.deleteAll();

                //     // redirigo al login
                //     Navigator.popAndPushNamed(context, firstLoginScreen);

                //     setState(() {});
                //   },
                // ),
              ],
            ),
        ],
      ),
    );
  }
}