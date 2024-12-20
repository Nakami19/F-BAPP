import 'package:f_bapp/common/assets/theme/app_colors.dart';
import 'package:f_bapp/common/assets/theme/app_theme.dart';
import 'package:flutter/material.dart';

class InformationCard extends StatefulWidget {
  const InformationCard({
    super.key,
    required this.title,
    required this.texts,
  });
  final String title;
  final List<Map<String, dynamic>> texts;

  @override
  State<InformationCard> createState() => _InformationCardState();
}

class _InformationCardState extends State<InformationCard> {
  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(widget.title,
          textAlign: TextAlign.center,
              style: textStyle.titleMedium!.copyWith(
                  color: primaryColor, fontWeight: FontWeight.w600)),

          SizedBox(height: 15,),

          Wrap(
            spacing: 16, // Espaciado horizontal entre columnas
            runSpacing: 16, // Espaciado vertical entre filas
            children: widget.texts.map((entry) {
              final label = entry['label'] ?? "";
              final value = entry['value'] ?? "";

              return SizedBox(
                width: MediaQuery.of(context).size.width / 3, // Dos elementos por fila
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: textStyle.bodySmall!.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4), // Espaciado entre label y value
                    Text(
                      value,
                      style: textStyle.bodyMedium!.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          // ... widget.texts.map((entry){
          //   final label = entry['label'] ?? "";
          //   final value = entry['value'] ?? "";
          // })
        ],
      ),
    );
  }
}
