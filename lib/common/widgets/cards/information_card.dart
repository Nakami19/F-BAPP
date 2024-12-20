import 'package:f_bapp/common/assets/theme/app_colors.dart';
import 'package:f_bapp/common/assets/theme/app_theme.dart';
import 'package:flutter/material.dart';

class InformationCard extends StatefulWidget {
  const InformationCard(
      {super.key,
      required this.title,
      required this.texts,
      this.subtitle,
      this.nextPage,
      this.onTapnextPage,
      this.nextPageRoute});
  final String title;
  final List<Map<String, dynamic>> texts;
  final String? subtitle;
  final String? nextPage;
  final String? nextPageRoute;
  final GestureTapCallback? onTapnextPage;

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
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(widget.title,
                style: textStyle.titleMedium!.copyWith(
                    color: primaryColor, fontWeight: FontWeight.w600)),
          ),

          SizedBox(
            height: 5,
          ),

          if (widget.subtitle != null) ...[
            Center(
              child: Text(
                widget.subtitle!,
                style: textStyle.bodyMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
          ],

          ...widget.texts.map((entry) {
            final label = entry['label'] ?? "";
            final value = entry['value'] ?? "";
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: textStyle.bodySmall!.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4), // Espaciado entre label y value
                Text(
                  value,
                  style: textStyle.bodyMedium!.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                  ),
                ),

                const SizedBox(height: 15),
              ],
            );
          }),

          if (widget.nextPage != null && widget.nextPageRoute != null)
            GestureDetector(
              onTap: widget.onTapnextPage,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    widget.nextPage!,
                    style: textStyle.bodyMedium!
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(Icons.arrow_forward)
                ],
              ),
            ),

          // Wrap(
          //   spacing: 16, // Espaciado horizontal entre columnas
          //   runSpacing: 16, // Espaciado vertical entre filas
          //   children: widget.texts.map((entry) {
          //     final label = entry['label'] ?? "";
          //     final value = entry['value'] ?? "";

          //     return SizedBox(
          //       width: MediaQuery.of(context).size.width / 3, // Dos elementos por fila
          //       child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Text(
          //             label,
          //             style: textStyle.bodySmall!.copyWith(
          //               fontSize: 14,
          //               fontWeight: FontWeight.bold,
          //             ),
          //           ),
          //           const SizedBox(height: 4), // Espaciado entre label y value
          //           Text(
          //             value,
          //             style: textStyle.bodyMedium!.copyWith(
          //               fontSize: 14,
          //               fontWeight: FontWeight.normal,
          //             ),
          //           ),
          //         ],
          //       ),
          //     );
          //   }).toList(),
          // ),
          // ... widget.texts.map((entry){
          //   final label = entry['label'] ?? "";
          //   final value = entry['value'] ?? "";
          // })
        ],
      ),
    );
  }
}
