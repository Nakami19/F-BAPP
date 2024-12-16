import 'package:f_bapp/common/assets/theme/app_theme.dart';
import 'package:flutter/material.dart';

class TextCard extends StatefulWidget {
  const TextCard(
      {super.key,
      this.height,
      this.width,
      this.onTap,
      required this.id,
      required this.status,
      this.telefono,
      this.banco,
      this.monto,
      this.balance,
      this.payType,
      this.sucursal,
      this.typeOrder,
      this.refundStatus,
      this.date,
      this.statusColor
      });

  final VoidCallback? onTap;
  final double? height;
  final double? width;
  final String id;
  final String status;
  final String? telefono;
  final String? banco;
  final String? monto;
  final String? balance;
  final String? payType;
  final String? sucursal;
  final String? typeOrder;
  final String? refundStatus;
  final String? date;
  final Color? statusColor;

  @override
  State<TextCard> createState() => _TextCardState();
}

class _TextCardState extends State<TextCard> {
  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    return InkWell(
      onTap: widget.onTap ?? () {},
      // child: Container(
      //   width: double.infinity, // Ancho ajustable
      //   padding: EdgeInsets.all(16),
      //   decoration: BoxDecoration(
      //     borderRadius: BorderRadius.circular(BorderRadiusValue),
      //     color: Colors.white,
      //     boxShadow: [
      //       BoxShadow(
      //         color: Colors.black.withOpacity(0.25),
      //         spreadRadius: 3,
      //         blurRadius: 5,
      //         offset: Offset(0, 5),
      //       ),
      //     ],
      //   ),
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       // Textos a la izquierda
      //       Expanded(
      //         child: Column(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: [
      //             Text(
      //               'Referencia: 123456',
      //               style: textStyle.bodyMedium!.copyWith(
      //                 fontWeight: FontWeight.bold
      //               ),
      //             ),
      //             SizedBox(height: 10),
      //             Text(
      //               'Teléfono: 41288888888',
      //               style: textStyle.bodyMedium
      //             ),
      //             SizedBox(height: 10),
      //             Text(
      //               'Banco: Banesco',
      //               style: textStyle.bodyMedium
      //             ),
      //             // SizedBox(height: 4),
      //             Row(
      //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //               children: [
      //                 Text(
      //                   'Monto: 1,00 BS',
      //                   style: textStyle.bodyMedium
      //                 ),
      //                 ElevatedButton(
      //                   style: ElevatedButton.styleFrom(
      //                     backgroundColor: Colors.transparent,
      //                     elevation: 0,
      //                     side: BorderSide(color: primaryColor),
      //                     shape: RoundedRectangleBorder(
      //                       borderRadius: BorderRadius.circular(20),
      //                     ),
      //                   ),
      //                   onPressed: () {
      //                     // Acción del botón
      //                   },
      //                   child: Text(
      //                     'Confirmada',
      //                     style: textStyle.bodyMedium!.copyWith(
      //                       color: primaryColor,
      //                       fontWeight: FontWeight.w600
      //                     ),
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           ],
      //         ),
      //       ),
      //       // Botón y el ícono alineados a la derecha
      //       Icon(
      //         Icons.info_outline,
      //         color: primaryColor,
      //         size: 30,
      //       ),
      //     ],
      //   ),
      // ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(BorderRadiusValue),
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
          // fuerza a los hijos a ocupar la altura total disponible.
          child: Row(
            children: [
              // Textos a la izquierda
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${widget.id}',
                        style: textStyle.bodySmall!.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 13)),
                    SizedBox(height: 4), // Espaciado entre textos

                    if (widget.date != null) ...[
                      Text('Fecha: ${widget.date}',
                          style: textStyle.bodySmall!.copyWith(fontSize: 13)),
                      SizedBox(height: 4),
                    ],

                    if (widget.telefono != null) ...[
                      Text('Teléfono: ${widget.telefono}',
                          style: textStyle.bodySmall!.copyWith(fontSize: 13)),
                      SizedBox(height: 4),
                    ],

                    if (widget.banco != null) ...[
                      Text('Banco: ${widget.banco}',
                          style: textStyle.bodySmall!.copyWith(fontSize: 13)),
                      SizedBox(height: 4),
                    ],

                    if (widget.sucursal != null) ...[
                      Text('Sucursal: ${widget.sucursal}',
                          style: textStyle.bodySmall!.copyWith(fontSize: 13)),
                      SizedBox(height: 4),
                    ],

                    if (widget.payType != null) ...[
                      Text('Tipo de pago: ${widget.payType}',
                          style: textStyle.bodySmall!.copyWith(fontSize: 13)),
                      SizedBox(height: 4),
                    ],

                    if (widget.refundStatus != null) ...[
                      Text('Estado de reverso: ${widget.refundStatus}',
                          style: textStyle.bodySmall!.copyWith(fontSize: 13)),
                      SizedBox(height: 4),
                    ],

                    if (widget.balance != null) ...[
                      Text('Balance: ${widget.balance} BS',
                          style: textStyle.bodySmall!.copyWith(fontSize: 13)),
                      SizedBox(height: 4),
                    ],

                    if(widget.monto!=null)...[
                       Text('Monto: ${widget.monto} BS',
                        style: textStyle.bodySmall!.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 13)),
                    ],

                   
                  ],
                ),
              ),

              //boton e icono
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Icon(
                    Icons.info_outline,
                    color: primaryColor,
                    size: 25,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      side: BorderSide(color: widget.statusColor!=null? widget.statusColor! : primaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(BorderRadiusValue),
                      ),
                    ),
                    onPressed: () {
                      // Acción del botón
                    },
                    child: Text(
                      widget.status,
                      style: textStyle.bodySmall!.copyWith(
                          fontWeight: FontWeight.w600,
                          color: widget.statusColor!=null? widget.statusColor! : primaryColor,
                          fontSize: 13),
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
