import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ExpensesByCategoryPieChart extends StatelessWidget {
  const ExpensesByCategoryPieChart({Key? key, this.statistic}) : super(key: key);

  final dynamic statistic;

  List<PieChartSectionData> showingSections(dynamic statistic) {
    return (statistic['byCategory'] as List<dynamic>).map((data) {
      return PieChartSectionData(
        color: Color(data['categoryColor'] ?? 0xff0293ee),
        value: double.parse(data['totalEuro']),
        title: '',
        radius: 60.0,
        titleStyle: const TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.bold,
          color: Color(0xffffffff),
        ),
      );
    }).toList();
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      height: 280,
      child: PieChart(
        PieChartData(
          // pieTouchData: PieTouchData(
          //   touchCallback: (FlTouchEvent event, pieTouchResponse) {
          //     setState(() {
          //       if (!event.isInterestedForInteractions ||
          //           pieTouchResponse == null ||
          //           pieTouchResponse.touchedSection == null) {
          //         touchedIndex = -1;
          //         return;
          //       }
          //       touchedIndex =
          //           pieTouchResponse.touchedSection!.touchedSectionIndex;
          //     });
          //   },
          // ),
          borderData: FlBorderData(
            show: false,
          ),
          sectionsSpace: 0,
          centerSpaceRadius: 60,
          sections: showingSections(statistic),
        ),
      ),
    );
  }
}
