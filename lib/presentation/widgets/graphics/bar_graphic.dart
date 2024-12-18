import 'package:f_bapp/common/assets/theme/app_theme.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

//libreria fl chart
class Graphic extends StatefulWidget {
  const Graphic({super.key});

  final Color leftBarColor = Colors.yellow;
  final Color rightBarColor = Colors.red;
  final Color avgColor = Colors.blue;

  @override
  State<Graphic> createState() => _GraphicState();
}

class _GraphicState extends State<Graphic> {
  final double width = 7;

  final List<Map<String, dynamic>> basicData = [
    {'module': 'Merchant', 'sold': 275},
    {'module': 'Onboarding', 'sold': 115},
    {'module': 'Onboarding V1', 'sold': 120},
    {'module': 'Administración', 'sold': 350},
    {'module': 'Operaciones', 'sold': 150},
  ];

  int touchedGroupIndex = -1;

  List<BarChartGroupData> generateBarGroups() {
    return List.generate(basicData.length, (index) {
      final data = basicData[index];
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: data['sold']?.toDouble(),
            color: primaryColor,
            width: 16,
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Cantidad de operaciones realizadas',
                  textAlign: TextAlign.center,
                  style: textStyle.bodyMedium!
                      .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: BarChart(
                    BarChartData(
                      maxY: 400,
                      barGroups: generateBarGroups(),
                      barTouchData: BarTouchData(
                          touchTooltipData: BarTouchTooltipData(
                        getTooltipColor: ((group) {
                          return Colors.grey; // Aquí decides el color del fondo
                        }),
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          return BarTooltipItem(
                            '${basicData[groupIndex]['module']}\n${rod.toY}', // El texto que se muestra
                            textStyle.bodySmall!.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Colors.white
                            )
                          );
                        },
                      )),
                      titlesData: FlTitlesData(
                        topTitles: AxisTitles(
                            sideTitles: SideTitles(
                          showTitles: false,
                        )),
                        rightTitles: AxisTitles(
                            sideTitles: SideTitles(
                          showTitles: false,
                        )),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: false,
                            // getTitlesWidget: bottomTitles,
                            reservedSize: 42,
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 28,
                            interval: 50,
                            getTitlesWidget: (value, meta) => SideTitleWidget(
                              axisSide: meta.axisSide,
                              space: 0,
                              child: Text(
                                value.toInt().toString(),
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 60, 60, 60),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      gridData: const FlGridData(show: false),
                      borderData: FlBorderData(show: false),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 15, // Espaciado horizontal entre los elementos de la leyenda
          runSpacing: 12, // Espaciado vertical entre filas de la leyenda
          children: basicData.map((data) {
            // final colorIndex = basicData.indexOf(data);
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: primaryColor
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '${data['module']}-${data['sold']}',
                  style: textStyle.bodySmall!
                      .copyWith(fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    if (value.toInt() >= basicData.length) {
      return Container(); // Manejar índices fuera de rango
    }

    final genre = basicData[value.toInt()]['module'];
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 8, // Margen superior
      child: Text(
        genre,
        style: const TextStyle(
          color: Color.fromARGB(255, 60, 60, 60),
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return AspectRatio(
  //     aspectRatio: 1,
  //     child: Padding(
  //       padding: const EdgeInsets.all(16),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.stretch,
  //         children: <Widget>[
  //           //esto es lo que tiene el titulo arriba del grafico
  //           Row(
  //             mainAxisSize: MainAxisSize.min,
  //             children: <Widget>[
  //               makeTransactionsIcon(),
  //               const SizedBox(
  //                 width: 38,
  //               ),
  //               const Text(
  //                 'Transactions',
  //                 style: TextStyle(color: Colors.black, fontSize: 22),
  //               ),
  //               const SizedBox(
  //                 width: 4,
  //               ),
  //               const Text(
  //                 'state',
  //                 style: TextStyle(color: Color(0xff77839a), fontSize: 16),
  //               ),
  //             ],
  //           ),

  //           const SizedBox(
  //             height: 38,
  //           ),

  //           Expanded(
  //             child: BarChart(
  //               BarChartData(
  //                 maxY:
  //                     20, //cambia la altura del grafico, numero grande grafico mas pequeño
  //                 barTouchData: BarTouchData(
  //                   touchTooltipData: BarTouchTooltipData(
  //                     //en telf creo que esto no hace nada
  //                     getTooltipColor: ((group) {
  //                       return Colors.grey;
  //                     }),
  //                     getTooltipItem: (a, b, c, d) => null,
  //                   ),
  //                   touchCallback: (FlTouchEvent event, response) {
  //                     //accion al tocar/mantener presionado las barras, en este caso la animacion de que bajan hacia el promedio de ambas y se ponen de otro color
  //                     if (response == null || response.spot == null) {
  //                       setState(() {
  //                         touchedGroupIndex = -1;
  //                         showingBarGroups = List.of(rawBarGroups);
  //                       });
  //                       return;
  //                     }

  //                     touchedGroupIndex = response.spot!.touchedBarGroupIndex;

  //                     setState(() {
  //                       if (!event.isInterestedForInteractions) {
  //                         //hace que las barras regresen a su posicion si no se presionan
  //                         touchedGroupIndex = -1;
  //                         showingBarGroups = List.of(rawBarGroups);
  //                         return;
  //                       }
  //                       showingBarGroups = List.of(
  //                           rawBarGroups); //hace la animacion de las barras moviendose hacia el promedio
  //                       if (touchedGroupIndex != -1) {
  //                         //la logica para que las barras de muevan al estar presionadas
  //                         var sum = 0.0; // suma de los valores de ambas barras
  //                         for (final rod
  //                             in showingBarGroups[touchedGroupIndex].barRods) {
  //                           sum += rod.toY; //valor Y de la barra
  //                         }
  //                         final avg = sum / //calcula el promedio
  //                             showingBarGroups[touchedGroupIndex]
  //                                 .barRods
  //                                 .length;

  //                         showingBarGroups[touchedGroupIndex] =
  //                             showingBarGroups[touchedGroupIndex].copyWith(
  //                           barRods: //barRods lista de las barras individuales del grupo de barras seleccionado
  //                               showingBarGroups[touchedGroupIndex]
  //                                   .barRods
  //                                   .map((rod) {
  //                             return rod.copyWith(
  //                                 toY: avg,
  //                                 color: widget
  //                                     .avgColor); //toY cambia la altura de la barra
  //                           }).toList(),
  //                         );
  //                       }
  //                     });
  //                   },
  //                 ),
  //                 titlesData: FlTitlesData(
  //                   // cambia nombre de los ejes  y donde se muestran
  //                   show: true, //dice si se muestra puntos en los ejes
  //                   rightTitles: const AxisTitles(
  //                     //config del texto a la derecha del eje Y, esta puesto que no debe mostrarse
  //                     sideTitles: SideTitles(showTitles: false),
  //                   ),
  //                   topTitles: const AxisTitles(
  //                     //config del texto arriba, esta puesto que no debe mostrarse
  //                     sideTitles: SideTitles(showTitles: false),
  //                   ),
  //                   bottomTitles: AxisTitles(
  //                     //config del texto abajo, esta puesto que debe mostrarse
  //                     sideTitles: SideTitles(
  //                       showTitles: true,
  //                       getTitlesWidget:
  //                           bottomTitles, //se le indican que nombre tendran los puntos
  //                       reservedSize:
  //                           42, //indica el espacio que ocuparan los titulos, creo que afecta la altura
  //                     ),
  //                   ),
  //                   leftTitles: AxisTitles(
  //                     //config del texto a la izquierda del eje Y, esta puesto que debe mostrarse
  //                     sideTitles: SideTitles(
  //                       showTitles: true,
  //                       reservedSize: 28, //este parece afectar el ancho
  //                       interval:
  //                           1, //determina cada cuanto se muestra una etiqueta, si vale 1 se muestra algo en cada unidad
  //                       getTitlesWidget: leftTitles,
  //                     ),
  //                   ),
  //                 ),
  //                 borderData: FlBorderData(
  //                   //le pone un borde a la grafica
  //                   show: false,
  //                 ),
  //                 barGroups: showingBarGroups,
  //                 gridData: const FlGridData(show: false),
  //               ),
  //             ),
  //           ),
  //           const SizedBox(
  //             height: 12,
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Widget leftTitles(double value, TitleMeta meta) {
  //   const style = TextStyle(
  //     color: Color(0xff7589a2),
  //     fontWeight: FontWeight.bold,
  //     fontSize: 14,
  //   );
  //   String text;
  //   if (value == 0) {
  //     text = '1K';
  //   } else if (value == 10) {
  //     text = '5K';
  //   } else if (value == 19) {
  //     text = '10K';
  //   } else {
  //     return Container();
  //   }
  //   return SideTitleWidget(
  //     axisSide: meta.axisSide,
  //     space: 0,
  //     child: Text(text, style: style),
  //   );
  // }

  // Widget bottomTitles(double value, TitleMeta meta) {
  //   final titles = <String>['Mn', 'Te', 'Wd', 'Tu', 'Fr', 'St', 'Su'];

  //   final Widget text = Text(
  //     titles[value.toInt()],
  //     style: const TextStyle(
  //       color: Color(0xff7589a2),
  //       fontWeight: FontWeight.bold,
  //       fontSize: 14,
  //     ),
  //   );

  //   return SideTitleWidget(
  //     axisSide: meta.axisSide,
  //     space: 16, //margin top
  //     child: text,
  //   );
  // }

  // BarChartGroupData makeGroupData(int x, double y1, double y2) {
  //   return BarChartGroupData(
  //     barsSpace: 4,
  //     x: x,
  //     barRods: [
  //       BarChartRodData(
  //         toY: y1,
  //         color: widget.leftBarColor,
  //         width: width,
  //       ),
  //       BarChartRodData(
  //         toY: y2,
  //         color: widget.rightBarColor,
  //         width: width,
  //       ),
  //     ],
  //   );
  // }

  // Widget makeTransactionsIcon() {
  //   const width = 4.5;
  //   const space = 3.5;
  //   return Row(
  //     mainAxisSize: MainAxisSize.min,
  //     children: <Widget>[
  //       Container(
  //         width: width,
  //         height: 10,
  //         color: Colors.black.withOpacity(0.4),
  //       ),
  //       const SizedBox(
  //         width: space,
  //       ),
  //       Container(
  //         width: width,
  //         height: 28,
  //         color: Colors.black.withOpacity(0.8),
  //       ),
  //       const SizedBox(
  //         width: space,
  //       ),
  //       Container(
  //         width: width,
  //         height: 42,
  //         color: Colors.black.withOpacity(1),
  //       ),
  //       const SizedBox(
  //         width: space,
  //       ),
  //       Container(
  //         width: width,
  //         height: 28,
  //         color: Colors.black.withOpacity(0.8),
  //       ),
  //       const SizedBox(
  //         width: space,
  //       ),
  //       Container(
  //         width: width,
  //         height: 10,
  //         color: Colors.black.withOpacity(0.4),
  //       ),
  //     ],
  //   );
  // }
}
