import 'package:flutter/material.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:flutter/cupertino.dart';

void main() => runApp(EnvironmentScreen());

class EnvironmentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PetsDataScreen(),
    );
  }
}

class PetsDataScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Environment'),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white, 
              borderRadius: BorderRadius.circular(10)), 
              child: Row(children: [
                Text('13/12/2023'),
              ],),)
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
              _buildDataCard(
                title: 'Food already dispense',
                value: '1/2 times today',
                description: 'Congrats! your dog had finished its first meal today...',
                status: 'Good',
                statusColor: Colors.green,
                icon: Icons.restaurant,
                iconColor: Colors.orange,
              ),
            _buildDataCard(
              title: 'Water dispense today',
              value: '60 ml',
              description: 'Your pet is consuming slightly less water today...',
              status: 'Slightly Less',
              statusColor: Color(0xFFB8860B),
              icon: Icons.water,
              iconColor: Colors.blue,
            ),
            _buildTemperatureHumidityCard(),
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
            Row(children: <Widget>[
              Icon(icon, color:iconColor),
              SizedBox(width: 10),
               Text(title, style: TextStyle(fontSize: 18)),
            ],),
            SizedBox(height: 8),
            Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Row(
              children: <Widget>[
              Expanded(child: Text(description),), 
              Container(
                height: 55,
                width: 80,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: statusColor),
                  child: Center(child:Text(status, style: TextStyle(color: Colors.white), textAlign: TextAlign.center,)) ,)
              
            ],)
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
                    Row(children: <Widget>[
                      Icon(
                        CupertinoIcons.thermometer, 
                        color: Colors.lightBlue),
                      Text('Temperature', style: TextStyle(fontSize: 18)),
                    ],),
                    Text('33.0C', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
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
                    Row(children: <Widget>[
                      Icon(
                        CupertinoIcons.drop, 
                        color: Colors.lightBlue),
                      Text('Humidity', style: TextStyle(fontSize: 18)),
                    ],),
                    Text('55%', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
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
    Text('ON', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green)),
    Spacer(), // Pushes the button to the far right
    ElevatedButton(
      onPressed: () {},
      child: Text('Turn Off',  style: TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red, // Background color of the button
      ),
    ),
  ],
),

          ],
        ),
      ),
    );
  }
}
