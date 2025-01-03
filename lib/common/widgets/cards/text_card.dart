import 'package:f_bapp/common/assets/theme/app_colors.dart';
import 'package:f_bapp/common/assets/theme/app_theme.dart';
import 'package:flutter/material.dart';

class TextCard extends StatelessWidget {
  const TextCard({
    super.key,
    this.height,
    this.width,
    this.onTap,
    this.textsStyle,
    this.statusTextStyle,
    required this.texts,
  });

  final VoidCallback? onTap;
  final double? height;
  final double? width;
  final List<Map<String, dynamic>> texts;
  final TextStyle? textsStyle;
  final TextStyle? statusTextStyle;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;

    // Buscar el status y su color
    final statusEntry = texts.firstWhere(
      (entry) => entry.containsValue('status'),
      orElse: () => {}, // Valor por defecto si no se encuentra
    );

    final status = statusEntry['value'];
    final statusColor = statusEntry['statusColor'];

    return InkWell(
      onTap: onTap ?? () {},
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadiusValue),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              spreadRadius: 3,
              blurRadius: 5,
              offset: Offset(0, 5),
            ),
          ],
        ),

        //Para que ocupe toda la altura disponible
        child: IntrinsicHeight(
          child: Row(
            children: [
              // Textos a la izquierda
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: texts
                      .where((entry) => (entry['label'] != 'status'))
                      .map((entry) {
                    final label = entry['label'] ?? "";
                    final value = entry['value'] ?? "";
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text(
                        //   '${entry['label']}${entry['value']}',
                        //   style: textStyle.bodySmall!.copyWith(fontSize: 13),
                        // ),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: label,
                                style: textsStyle?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ) ?? textStyle.bodySmall!.copyWith(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: value,
                                style: textsStyle?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ) ?? textStyle.bodySmall!.copyWith(
                                  fontSize: 13,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 4), // Espaciado entre textos
                      ],
                    );
                  }).toList(),
                ),
              ),

              // Botón y icono

              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Icon(
                    Icons.info_outline,
                    color: primaryColor,
                    size: 25,
                  ),


                  Spacer(),


                  if (status != null && status != "")
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        // padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        backgroundColor: Colors.transparent,
                        side: BorderSide(
                          color: statusColor ?? primaryColor,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(borderRadiusValue),
                        ),
                      ).copyWith(
                        //Quita efecto al presionar
                        overlayColor: MaterialStateProperty.all(Colors
                            .transparent), 
                        elevation: MaterialStateProperty.all(0),
                      ),
                      onPressed: () {},
                      child: SizedBox(
                        width: 90,
                        child: Text(
                          status,
                          style: statusTextStyle?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: statusColor ?? primaryColor,
                          ) ?? textStyle.bodySmall!.copyWith(
                            fontWeight: FontWeight.w600,
                            color: statusColor ?? primaryColor,
                            fontSize: 13,
                          ),
                          softWrap: true, // Permite saltos de línea
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  SizedBox(
                    height: 5,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
