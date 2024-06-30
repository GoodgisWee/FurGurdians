import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Simple Line Chart Example'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: 150, // Adjust width as needed
            height: 100, // Adjust height as needed
            child: LineChart(
              LineChartData(
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      FlSpot(0, 1),
                      FlSpot(1, 3),
                      FlSpot(2, 2),
                      FlSpot(3, 5),
                      FlSpot(4, 4),
                      FlSpot(5, 6),
                    ],
                    isCurved: false, // Set to false for straight lines
                    colors: [Colors.blue],
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(show: false),
                    barWidth: 2,
                    isStrokeCapRound: true,
                  ),
                ],
                titlesData: FlTitlesData(
                  show: false,
                ),
                gridData: FlGridData(show: false),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Colors.blue, width: 1),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: LineChartExample(),
  ));
}
