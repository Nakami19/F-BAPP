import 'package:f_bapp/common/assets/theme/app_colors.dart';
import 'package:f_bapp/common/assets/theme/app_theme.dart';
import 'package:flutter/material.dart';

class TextCard extends StatefulWidget {
  const TextCard({
    super.key,
    this.height,
    this.width,
    this.onTap,
    required this.texts,
  });

  final VoidCallback? onTap;
  final double? height;
  final double? width;
  final List<Map<String, dynamic>> texts;

  @override
  State<TextCard> createState() => _TextCardState();
}

class _TextCardState extends State<TextCard> {
  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;

    // Buscar el status y su color
    final statusEntry = widget.texts.firstWhere(
      (entry) => entry.containsValue('status'),
      orElse: () => {}, // Valor por defecto si no se encuentra
    );

    final status = statusEntry['value'];
    final statusColor = statusEntry['statusColor'];

    return InkWell(
      onTap: widget.onTap ?? () {},
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
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
        child: IntrinsicHeight(
          child: Row(
            children: [
              // Textos a la izquierda
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widget.texts
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
                                style: textStyle.bodySmall!.copyWith(
                                  fontSize: 13,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: value, 
                                style: textStyle.bodySmall!.copyWith(
                                  fontSize: 13,
                                  fontWeight: FontWeight
                                      .normal, 
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
                  SizedBox(height: 20),
                  if (status != null && status != "")
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        side: BorderSide(
                          color: statusColor ?? primaryColor,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(borderRadiusValue),
                        ),
                      ),
                      onPressed: () {
                        // Acción del botón
                      },
                      child: SizedBox(
                        width: 90, // Ancho fijo para el botón
                        child: Text(
                          status,
                          style: textStyle.bodySmall!.copyWith(
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
