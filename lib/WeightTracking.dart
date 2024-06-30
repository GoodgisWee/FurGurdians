import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fur_guardian/chat.dart';

void main() => runApp(WeightTrackingApp());

class WeightTrackingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WeightTrackingScreen(),
    );
  }
}

class WeightTrackingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weight'),
        backgroundColor: Colors.lightBlue,
        actions: [
          Padding(padding: EdgeInsets.all(8),
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white, 
              borderRadius: BorderRadius.circular(20)), 
              child: Row(children: [
                Icon(Icons.filter_alt_outlined),
                Text('Month'),
              ],),))
        ],
      ),
      body: Padding(
  padding: const EdgeInsets.all(16.0),
  child: Column(
    children: [
      _buildWeightChart(),
      SizedBox(height: 16),
      _buildWeightDetails(),
      SizedBox(height: 16),
      Expanded(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
  decoration: BoxDecoration(
    color: Colors.lightGreen, // Set container background color to light green
    borderRadius: BorderRadius.circular(10), // Optional: add rounded corners
  ),
  padding: EdgeInsets.all(16.0), // Add padding inside the container
  child: Center(
    child: Row(
      mainAxisSize: MainAxisSize.min, // Ensure the Row takes minimal width needed
      children: <Widget>[
        Icon(Icons.thumb_up, color: Colors.white), // Change icon color to white
        SizedBox(width: 10), // Set SizedBox width to 10
        Text(
          'Healthy',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white, // Change text color to white
          ),
        ),
      ],
    ),
  ),
),



          ),
      ),
      SizedBox(height: 16),
      _buildSuggestionCard(context),
    ],
  ),
),

      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildWeightChart() {
    return Container(
      padding: EdgeInsets.all(8),
      height: 200,
      color: Colors.blue[50],
      child: Center(
        child: LineChart(
          LineChartData(
            lineBarsData: [
              LineChartBarData(
                spots: [
                  FlSpot(0,10),
                  FlSpot(1,12),
                  FlSpot(2,11),
                  FlSpot(3,13.2),
                ],
                isCurved: false,
                colors: [Colors.black],
                dotData: FlDotData(show: true),
                belowBarData: BarAreaData(show: false),
                barWidth: 2,
                isStrokeCapRound: true,
              )
            ],
            titlesData: FlTitlesData(
  bottomTitles: SideTitles(
    showTitles: true,
    reservedSize: 22,
    getTextStyles: (value) => const TextStyle(
      color: Color(0xff68737d),
      fontWeight: FontWeight.bold,
      fontSize: 16,
    ),
    getTitles: (value) {
      switch (value.toInt()) {
        case 0:
          return '';
        case 1:
          return 'Jan';
        case 2:
          return 'Feb';
        case 3:
          return 'Mar';
        case 4:
          return 'Apr';
        case 5:
          return 'May';
        case 6:
          return 'Jun';
      }
      return '';
    },
    margin: 8,
  ),
  leftTitles: SideTitles(
    showTitles: true,
    reservedSize: 28,
    getTextStyles: (value) => const TextStyle(
      color: Color(0xff68737d),
      fontWeight: FontWeight.bold,
      fontSize: 15,
    ),
    getTitles: (value) {
      return value.toInt().toString();
    },
    margin: 12,
  ),
),

            gridData: FlGridData(
              show: true,
            ),
            borderData: FlBorderData(show: true),
          )
        )),

    );
  }

  Widget _buildWeightDetails() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20)), 
        child: Row(
      children: [
        Expanded(child: DataWidget('15.20 kg', 'Current\nWeight')),
        SizedBox(width: 10),
        Expanded(child: DataWidget('-3.1 kg', 'from last\nmonth')),

      ],
    ),);
  }

  Widget DataWidget(String value, String label){
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(20)),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
            Text(label),
          ],
        ),);
  }

  Widget _buildSuggestionCard(BuildContext context) {
  return Card(
    color: Colors.white,  // Use 'color' property to set the background color
    margin: EdgeInsets.only(bottom: 16),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Oops, seems like your dog is slightly under weight.'),
          SizedBox(height: 8),
          Text('You can consider giving your doggy tasty treats like chicken or peanut butter for them to grow big, but ask a vet first to make sure it’s okay!'),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen()));
            },
            child: Text('Tell me more about your dog...'),
          ),
        ],
      ),
    ),
  );
}
}
