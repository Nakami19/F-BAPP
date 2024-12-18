import 'package:f_bapp/common/assets/theme/app_colors.dart';
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
}