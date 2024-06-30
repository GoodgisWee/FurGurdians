import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fur_guardian/EnvironmentData.dart';
import 'package:fur_guardian/WeightTracking.dart';
import 'package:fur_guardian/chat.dart';
import 'package:fur_guardian/community.dart';
import 'package:intl/intl.dart';

void main() => runApp(PetsProfileApp());

class PetsProfileApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PetsProfileScreen(),
    );
  }
}

class PetsProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pet’s Data',),
        backgroundColor: Colors.lightBlue,
        leading: Builder(
          builder: (BuildContext context){
            return IconButton(
              icon: Icon( Icons.menu),
              onPressed: (){
                Scaffold.of(context).openDrawer();
              }
        );}),      
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CurrentDateWidget(),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 100, // Adjust height as needed
              child: DrawerHeader(
                margin: EdgeInsets.zero, // Remove default margin
                padding: EdgeInsets.zero, // Remove default padding
                child: Text("Welcome", style: TextStyle(fontSize: 24)),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),
            ),
            ListTile(
              title: Text('Environment Page'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => EnvironmentScreen()));
              },
            ),
            ListTile(
              title: Text('Community Page'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => CommunityPage()));
              },
            ),
            ListTile(
              title: Text('Live CCTV'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen()));
              },
            ),
            ListTile(
              title: Text('Mr Paw'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen()));
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildProfileHeader(),
            SizedBox(height:20),
            _buildMetricCard(
              title: 'Weight',
              value: '13.20kg',
              description: 'The weight is increasing by 1.20kg from the last weeks...',
              trendColor: Colors.blue,
              isIncreasing: true,
              pastData: [12, 11, 13.2],
              color: Colors.blue,
              context: context
            ),
            _buildMetricCard(
              title: 'Length',
              value: '60cm',
              description: 'It maintains the same from the last 3 weeks...',
              trendColor: Colors.red,
              isIncreasing: false,
              pastData: [50, 60, 60],
              color: Colors.green,
              context: context
            ),
            _buildMetricCard(
              title: 'Height',
              value: '40cm',
              description: 'The height keeps on rising from the last 3 weeks...',
              trendColor: Colors.green,
              isIncreasing: true,
              pastData: [35, 34, 40],
              color: Colors.orange,
              context: context
            ),
            _buildAbnormalBehaviorCard(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 40,
          //backgroundImage: AssetImage('assets/duck.png')
          backgroundImage: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSgDFp3dmPTGj1xOEuSlAt-ilTfBOmYfth5hQ&s'),
        ),
        SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Adrian', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text('(Female)', style: TextStyle(fontSize: 14, color: Colors.grey)),
            Text('Age: 1.3 y/o'),
            Text('Breed: Golden Retriever'),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String description,
    required Color trendColor,
    required bool isIncreasing,
    required List<double> pastData,
    required Color color,
    required BuildContext context
  }) {
    return  GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> WeightTrackingScreen()));
      },
      child: Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[ 
                    Text(title, style: TextStyle(fontSize: 18)),
                    SizedBox(height: 8),
                    Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  ]),
                  Align(
                    alignment: Alignment.centerRight, 
                    child: LineChartWidget(pastData[0], pastData[1], pastData[2], color),
                  ),
                  SizedBox(width: 1),
              ],
            ),
            SizedBox(height: 8),
            Text(description),
          ],
        ),
      ),
      )
    );
  }


  Widget _buildAbnormalBehaviorCard() {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
             Text('Abnormal Behavior History', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            AbnormalBehaviorWidget('11/12/2024', 'The dog has leftover 50g of food during dinner...'),
            AbnormalBehaviorWidget('08/11/2024', 'The dog has slept for 8 hours when you are not at home...'),
            AbnormalBehaviorWidget('02/11/2024', 'The dog has leftover...', isLast: true),
          ],
        ),
      ),
    );
  }

  Widget AbnormalBehaviorWidget(String date, String description, {bool isLast = false}){
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(date, style: TextStyle(decoration: TextDecoration.underline)),
          SizedBox(height: 4),
          Text(description),
          if(! isLast) SizedBox(height: 8),
          if(! isLast) Divider(height: 1, thickness: 0, color: Colors.grey),
          if(! isLast) SizedBox(height: 8),
      ]));
  }

  Widget CurrentDateWidget(){
    DateTime now = DateTime.now();

    String formattedDate = DateFormat('dd-MM-yyyy').format(now);

    return Text(formattedDate);
  }

  Widget LineChartWidget(double first, double second, double third, Color color){
    return Padding(
      padding: EdgeInsets.all(16), 
      child: Container(
        width: 100,
        height: 50,
        child: LineChart(
          LineChartData(
            lineBarsData: [
              LineChartBarData(
                spots: [
                  FlSpot(0,first),
                  FlSpot(1,second),
                  FlSpot(2,third),
                ],
                isCurved: false,
                colors: [color],
                dotData: FlDotData(show: false),
                belowBarData: BarAreaData(show: false),
                barWidth: 2,
                isStrokeCapRound: true,
              )
            ],
            titlesData: FlTitlesData(show: false,),
            gridData: FlGridData(show: false),
            borderData: FlBorderData(
              show: false,
            )
          )
        ),
      ));
  }
}




