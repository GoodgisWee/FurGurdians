import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EnvironmentScreen extends StatefulWidget{
  @override
  _EnvironmentScreenState createState() => _EnvironmentScreenState();
}

class _EnvironmentScreenState extends State<EnvironmentScreen> {

    bool food_refill = false;
    bool water_refill = false;
    double temperature = 0.0;
    double humidity = 0.0;
    bool temperature_show = true;
    bool oncoolingFan = false;
    bool isLoading = true;
    Timestamp? timestamp;
FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  void initState(){
    super.initState();
    getData();
  }

  Future<void> getData() async{
    DocumentSnapshot documentSnapshot = await firebaseFirestore.collection('FoodRefill').doc('1').get();
    if(documentSnapshot.exists){
      Map<String,dynamic>? data = documentSnapshot.data() as Map<String, dynamic>;
      
      if (data != null && data['need_to_refill'] == 'Y') {
        food_refill = true;
      } else {
        food_refill = false;
      }
      
  }

  DocumentSnapshot documentSnapshot2 = await firebaseFirestore.collection('WaterRefill').doc('1').get();
    if(documentSnapshot2.exists){
      Map<String,dynamic>? data2 = documentSnapshot2.data() as Map<String, dynamic>;
      
      if (data2 != null && data2['need_to_refill'] == 'Y') {
        water_refill = true;
      } else {
        water_refill = false;
      }
    }

    DocumentSnapshot documentSnapshot3 = await firebaseFirestore.collection('AirData').doc('1').get();
    if(documentSnapshot3.exists){
      Map<String,dynamic>? data3 = documentSnapshot3.data() as Map<String, dynamic>;
      temperature = data3['air_temperature'].toDouble();
      humidity = data3['air_humidity'].toDouble();
      temperature_show = true;
      if(temperature >35 || humidity > 80){
        oncoolingFan = true;
      }

    }

    setState(() {
      isLoading= false;
    });
  }

  @override
  Widget build (BuildContext context){

    return Scaffold(
      appBar: AppBar(
        title: Text('Environment'),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  Text('13/12/2023'),
                ],
              ),
            ),
          ),
        ],
      ),
      body: isLoading
      ? Center(child:CircularProgressIndicator())
      : SingleChildScrollView( // Make the body scrollable
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (food_refill)
              _buildDataCard(
                title: 'Food',
                value: 'Need to refill soon',
                description: 'Omg, your pet is very hungry...',
                status: 'Hungry',
                statusColor: Color(0xFFB8860B),
                icon: Icons.restaurant,
                iconColor: Colors.orange,
              )
            else
              _buildDataCard(
                title: 'Food',
                value: 'Your pet is full',
                description: 'Congrats! your dog had finished its meal today...',
                status: 'Good',
                statusColor: Colors.green,
                icon: Icons.restaurant,
                iconColor: Colors.orange,
              ),
            if (water_refill)
              _buildDataCard(
                title: 'Water',
                value: 'Need to refill soon',
                description: 'Your pet is consuming slightly less water today...',
                status: 'Less',
                statusColor: Color(0xFFB8860B),
                icon: Icons.water,
                iconColor: Colors.blue,
              )
            else
              _buildDataCard(
                title: 'Water',
                value: 'Done refill',
                description: 'Your pet is consuming enough water for today...',
                status: 'Good',
                statusColor: Colors.green,
                icon: Icons.water,
                iconColor: Colors.blue,
              ),
            if (temperature_show)
              _buildTemperatureHumidityCard()
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildDataCard({
    required String title,
    required String value,
    required String description,
    required String status,
    required Color statusColor,
    required IconData icon,
    required Color iconColor,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: <Widget>[
                Icon(icon, color: iconColor),
                SizedBox(width: 10),
                Text(title, style: TextStyle(fontSize: 18)),
              ],
            ),
            SizedBox(height: 8),
            Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Row(
              children: <Widget>[
                Expanded(child: Text(description)),
                Container(
                  height: 55,
                  width: 80,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: statusColor,
                  ),
                  child: Center(
                    child: Text(
                      status,
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTemperatureHumidityCard() {
    return Card(
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
                  children: [
                    Row(
                      children: <Widget>[
                        Icon(CupertinoIcons.thermometer, color: Colors.lightBlue),
                        Text('Temperature', style: TextStyle(fontSize: 18)),
                      ],
                    ),
                    Text('${temperature.toString()} C', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  ],
                ),
                Container(
                  height: 55,
                  width: 1, // Vertical line width
                  color: Colors.grey, // Vertical line color
                  margin: EdgeInsets.symmetric(horizontal: 10), // Space around the line
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: <Widget>[
                        Icon(CupertinoIcons.drop, color: Colors.lightBlue),
                        Text('Humidity', style: TextStyle(fontSize: 18)),
                      ],
                    ),
                    Text('${humidity.toString()}%', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8),
            Text('Oops, today seems a bit hot for your pet...'),
            SizedBox(height: 8),
            Row(
              children: [
                  Text('Cooling Fan:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(width: 10), // Add some spacing between the texts
                  Text(
                    oncoolingFan ? 'ON' : 'OFF', 
                    style: TextStyle(
                      fontSize: 24, 
                      fontWeight: FontWeight.bold, 
                      color: oncoolingFan ? Colors.green : Colors.orange
                    ),
                  ),
                  Spacer(), 
              ],
            ),
          ],
        ),
      ),
    );
  }
}