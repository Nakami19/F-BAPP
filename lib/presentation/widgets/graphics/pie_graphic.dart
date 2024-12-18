import 'package:f_bapp/common/assets/theme/app_colors.dart';
import 'package:f_bapp/common/assets/theme/app_theme.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieGraphic2 extends StatefulWidget {
  const PieGraphic2({super.key});

  @override
  State<PieGraphic2> createState() => _PieGraphic2State();
}

class _PieGraphic2State extends State<PieGraphic2> {
  int touchedIndex = -1;
  final List<Map<String, dynamic>> basicData = [
    {'module': 'Merchant', 'sold': 275},
    {'module': 'Onboarding', 'sold': 115},
    {'module': 'Onboarding V1', 'sold': 120},
    {'module': 'Administración', 'sold': 350},
    {'module': 'Operaciones', 'sold': 150},
  ];

  // Colores para las secciones
  final List<Color> sectionColors = [
    primaryColor,
    Color(0xffff0000),
    Color(0xff595959),
    Color.fromARGB(219, 246, 195, 26),
    Color(0xff02a8f5),
  ];

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    final totalSold = basicData.fold<double>(
      0,
      (sum, item) => sum + item['sold'],
    );

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'Cantidad de operaciones realizadas',
            textAlign: TextAlign.center,
            style: textStyle.bodyMedium!
                .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 35,
          ),
          // Gráfico
          AspectRatio(
            aspectRatio: 1.3,
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          pieTouchResponse == null ||
                          pieTouchResponse.touchedSection == null) {
                        touchedIndex = -1;
                        return;
                      }
                      touchedIndex =
                          pieTouchResponse.touchedSection!.touchedSectionIndex;
                    });
                  },
                ),
                borderData: FlBorderData(
                  show: false,
                ),
                sectionsSpace: 0,
                centerSpaceRadius: 45,
                sections: showingSections(),
              ),
            ),
          ),
          const SizedBox(height: 33),
          // Leyenda
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 16,
            runSpacing: 8,
            children: List.generate(basicData.length, (index) {
              final data = basicData[index];
              final percentage =
                  ((data['sold'] / totalSold) * 100).toStringAsFixed(1);
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle, //poner forma de circulo
                        color: sectionColors[index],
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${data['module']}',
                      style: textStyle.bodySmall!.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 13
                            ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  //se generan las secciones del pie
  List<PieChartSectionData> showingSections() {
    final totalSold = basicData.fold<double>(
      0,
      (sum, item) => sum + item['sold'],
    );
    final textStyle = Theme.of(context).textTheme;
    // se retorna una lista de PiecChartSectionData
    return List.generate(basicData.length, (i) {
      final isTouched = i == touchedIndex; //saber cual se mantiene presionado
      final fontSize = isTouched ? 20.0 : 16.0;
      final radius = isTouched ? 100.0 : 90.0;

      final data = basicData[i];
      final percentage = ((data['sold']! / totalSold) * 100).toStringAsFixed(1);

      return PieChartSectionData(
        color: sectionColors[i % sectionColors.length], // Color seccion
        value: data['sold']?.toDouble(),
        title: '${data['sold']}',
        badgeWidget: isTouched ? Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey,
            border: Border.all(
              color: Colors.white
            ),
            borderRadius: BorderRadius.circular(borderRadiusValue)
          ),
          child: Text('${data['module']}', style:textStyle.bodySmall!.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Colors.white
                            ) ,),
        ):null,
        badgePositionPercentageOffset: 0,
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    });
  }

}
