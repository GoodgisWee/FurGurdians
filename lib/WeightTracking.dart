import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vitroxfurguardians/chatbot.dart';
import 'chatbot.dart';
class WeightTrackingScreen extends StatefulWidget {
  @override
  _WeightTrackingScreenState createState() => _WeightTrackingScreenState();
}

class _WeightTrackingScreenState extends State<WeightTrackingScreen> {
  List<double?> weightDataFirebase = List.filled(12, null);
  List<double?> weightData = [];
  List<FlSpot> spots = [];
  bool isLoading = true;
  String weightDiff = '';
  bool weightIsPositive = true;
  int healthyLevel = 3;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    try {
      DocumentSnapshot docSnapshot =
          await FirebaseFirestore.instance.collection('Dog').doc('1').collection('Data').doc('Weight').get();

      // Initialize with smallest available month data
      double smallestMonthData = double.infinity;

      // Check if docSnapshot exists and cast data to Map<String, dynamic>
      if (docSnapshot.exists) {
        Map<String, dynamic>? data = docSnapshot.data() as Map<String, dynamic>?;

        if (data != null) {
          // Function to safely convert values to double
          double? toDouble(dynamic value) {
            if (value is int) {
              return value.toDouble();
            } else if (value is double) {
              return value;
            }
            return null;
          }

          // Check for each month and update weightDataFirebase
          if (data.containsKey('January')) {
            weightDataFirebase[0] = toDouble(data['January']);
            smallestMonthData = weightDataFirebase[0] ?? smallestMonthData;
          }
          if (data.containsKey('February')) {
            weightDataFirebase[1] = toDouble(data['February']);
            smallestMonthData = weightDataFirebase[1] ?? smallestMonthData;
          }
          if (data.containsKey('March')) {
            weightDataFirebase[2] = toDouble(data['March']);
            smallestMonthData = weightDataFirebase[2] ?? smallestMonthData;
          }
          if (data.containsKey('April')) {
            weightDataFirebase[3] = toDouble(data['April']);
            smallestMonthData = weightDataFirebase[3] ?? smallestMonthData;
          }
          if (data.containsKey('May')) {
            weightDataFirebase[4] = toDouble(data['May']);
            smallestMonthData = weightDataFirebase[4] ?? smallestMonthData;
          }
          if (data.containsKey('June')) {
            weightDataFirebase[5] = toDouble(data['June']);
            smallestMonthData = weightDataFirebase[5] ?? smallestMonthData;
          }
          if (data.containsKey('July')) {
            weightDataFirebase[6] = toDouble(data['July']);
            smallestMonthData = weightDataFirebase[6] ?? smallestMonthData;
          }
          if (data.containsKey('August')) {
            weightDataFirebase[7] = toDouble(data['August']);
            smallestMonthData = weightDataFirebase[7] ?? smallestMonthData;
          }
          if (data.containsKey('September')) {
            weightDataFirebase[8] = toDouble(data['September']);
            smallestMonthData = weightDataFirebase[8] ?? smallestMonthData;
          }
          if (data.containsKey('October')) {
            weightDataFirebase[9] = toDouble(data['October']);
            smallestMonthData = weightDataFirebase[9] ?? smallestMonthData;
          }
          if (data.containsKey('November')) {
            weightDataFirebase[10] = toDouble(data['November']);
            smallestMonthData = weightDataFirebase[10] ?? smallestMonthData;
          }
          if (data.containsKey('December')) {
            weightDataFirebase[11] = toDouble(data['December']);
            smallestMonthData = weightDataFirebase[11] ?? smallestMonthData;
          }
        }
      }

      // Fill remaining months with smallest available month data
      for (int i = 0; i < 12; i++) {
        if (weightDataFirebase[i] != null) {
          weightData.add(weightDataFirebase[i]);
          spots.add(FlSpot(i.toDouble(), weightDataFirebase[i]!));
        }
      }

      weightDiff = ((weightData.last ?? 0.0) - (weightData.isNotEmpty ? weightData[weightData.length - 2] ?? 0.0 : 0.0)).toStringAsFixed(2);

      // Check whether the weight is increasing or decreasing
      if (double.tryParse(weightDiff)! > 0) {
        weightIsPositive = true;
      } else {
        weightIsPositive = false;
      }

      // Check whether the dog is healthy or not (threshold, up&down 1.2kg)
      if ((double.tryParse(weightDiff))! - 1.2 <= 0) {
        healthyLevel = 1;
      } else if ((double.tryParse(weightDiff))! - 2.4 <= 0) {
        healthyLevel = 2;
      } else {
        healthyLevel = 3;
      }

      // Update the state to trigger a re-build of the UI
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching data: $e');
      // Handle error as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weight'),
        backgroundColor: Colors.lightBlue,
        actions: [
          Padding(
            padding: EdgeInsets.all(8),
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(Icons.filter_alt_outlined),
                  Text('Month'),
                ],
              ),
            ),
          )
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 32, 16, 16),
                  child: Column(
                    children: [
                      _buildWeightChart(),
                      SizedBox(height: 16),
                      _buildWeightDetails(),
                      SizedBox(height: 16),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: healthyLevel == 1
                            ? Container(
                                decoration: BoxDecoration(
                                  color: Colors.lightGreen,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: EdgeInsets.all(16.0),
                                child: Center(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Icon(CupertinoIcons.smiley, color: Colors.white),
                                      SizedBox(width: 10),
                                      Text(
                                        'Healthy',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : healthyLevel == 2
                                ? Container(
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 220, 212, 139),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: EdgeInsets.all(16.0),
                                    child: Center(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Icon(Icons.thumb_up, color: Colors.white),
                                          SizedBox(width: 10),
                                          Text(
                                            'Slightly Underweight',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xFFFF7F7F),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: EdgeInsets.all(16.0),
                                    child: Center(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Icon(Icons.thumb_down, color: Colors.white),
                                          SizedBox(width: 10),
                                          Text(
                                            'Underweight',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                      ),
                      SizedBox(height: 16),
                      _buildSuggestionCard(context),
                    ],
                  ),
                ),
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
                spots: spots,
                isCurved: true,
                barWidth: 3,
                color: Colors.blue,
                belowBarData: BarAreaData(
                  show: true,
                  color: Colors.blue.withOpacity(0.3),
                ),
              ),
            ],
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: true),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: true, getTitlesWidget: bottomTitleWidgets),
              ),
            ),
            borderData: FlBorderData(show: true, border: Border.all(color: Colors.blue, width: 1)),
            gridData: FlGridData(show: true),
          ),
        ),
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = Text('Jan', style: style);
        break;
      case 1:
        text = Text('Feb', style: style);
        break;
      case 2:
        text = Text('Mar', style: style);
        break;
      case 3:
        text = Text('Apr', style: style);
        break;
      case 4:
        text = Text('May', style: style);
        break;
      case 5:
        text = Text('Jun', style: style);
        break;
      case 6:
        text = Text('Jul', style: style);
        break;
      case 7:
        text = Text('Aug', style: style);
        break;
      case 8:
        text = Text('Sep', style: style);
        break;
      case 9:
        text = Text('Oct', style: style);
        break;
      case 10:
        text = Text('Nov', style: style);
        break;
      case 11:
        text = Text('Dec', style: style);
        break;
      default:
        text = Text('', style: style);
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget _buildWeightDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Weight Difference: $weightDiff kg',
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 8),
        Text(
          'Trend: ${weightIsPositive ? 'Increasing' : 'Decreasing'}',
          style: TextStyle(fontSize: 16, color: weightIsPositive ? Colors.green : Colors.red),
        ),
      ],
    );
  }

  Widget _buildSuggestionCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Suggestion',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Based on the current weight trend, here are some suggestions for maintaining a healthy weight for your pet...',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> ChatScreen()));
              },
              child: Text('Get More Suggestions'),
            ),
          ],
        ),
      ),
    );
  }
}
