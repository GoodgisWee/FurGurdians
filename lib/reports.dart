import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> _messageHandler(RemoteMessage message) async {
  print('background message ${message.notification!.body}');
}

Future<void> _checkFirestoreConnection(FirebaseFirestore firestore) async {
  try {
    await firestore.collection('daily_reports').doc('ztKx5htDpswrHpirgcsN').get();
    print("Firestore connection successful!");
  } catch (e) {
    print("Error connecting to Firestore: $e");
  }
}

class ReportsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Daily Reports')),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('daily_reports').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No reports available.'));
          }

          var reports = snapshot.data!.docs;

          return ListView.builder(
            itemCount: reports.length,
            itemBuilder: (context, index) {
              var report = reports[index];
              var date = report['date'];
              var reportText = report['report'] ?? '';

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: ListTile(
                  title: Text(
                    'Report on $date',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    reportText.length > 50 ? '${reportText.substring(0, 50)}...' : reportText,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReportDetailPage(report: report),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ReportDetailPage extends StatelessWidget {
  final DocumentSnapshot report;

  ReportDetailPage({required this.report});

  List<TextSpan> _highlightText(String text) {
    final boldWords = ['Weekly Reports:', 'Water Consumption:', 'Food Consumption:', 'Weekly Report: Dog Health Analysis ', 'Weight', 'Summary', 'Recommendations:', 'Important Note:'];
    final spans = <TextSpan>[];
    int start = 0;

    for (final word in boldWords) {
      final index = text.indexOf(word, start);
      if (index >= 0) {
        if (index > start) {
          spans.add(TextSpan(text: text.substring(start, index)));
        }
        spans.add(TextSpan(text: word, style: TextStyle(fontWeight: FontWeight.bold)));
        start = index + word.length;
      }
    }

    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start)));
    }

    return spans;
  }

  @override
  Widget build(BuildContext context) {
    var date = report['date'];
    var reportText = report['report'] ?? '';

    return Scaffold(
      appBar: AppBar(title: Text('Report on $date')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Date: $date',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            RichText(
              text: TextSpan(
                style: TextStyle(color: Colors.black, fontSize: 16),
                children: _highlightText(reportText),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
