import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Import intl package for date formatting

class EventPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: EventsPage(),
    );
  }
}

class EventsPage extends StatefulWidget {
  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> eventData = [];
  List<EventCard> filteredEvents = [];
  bool isLoading = true;

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    try {
      QuerySnapshot querySnapshot =
          await firebaseFirestore.collection('Event').get();

      // Clear eventData to avoid duplicates on subsequent calls
      eventData.clear();

      // Iterate through each document and add its data to eventData list
      querySnapshot.docs.forEach((doc) {
        eventData.add(doc.data() as Map<String, dynamic>);
      });

      // Populate filteredEvents with EventCard widgets based on fetched data
      setState(() {
        filteredEvents = eventData.map((event) => EventCard(
          date: event['date'] != null ? _formatDate(event['date']) : '',
          title: event['title'] ?? '',
          location: event['location'] ?? '',
          imageUrl: event['imageUrl'] ?? '',
        )).toList();
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching data: $e');
      // Handle error as needed
    }
  }

  String _formatDate(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('EEE, MMM d • h:mm a').format(dateTime);
  }

  void filterEvents(String query) {
    List<EventCard> filteredList = filteredEvents.where((event) {
      return event.title.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredEvents = filteredList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Event Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: EventSearchDelegate(filteredEvents),
              );
            },
          ),
        ],
      ),
      body: isLoading
      ? Center(child: CircularProgressIndicator()) 
      : ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: filteredEvents.length,
        itemBuilder: (context, index) {
          return filteredEvents[index];
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final String date;
  final String title;
  final String location;
  final String imageUrl;

  EventCard({
    required this.date,
    required this.title,
    required this.location,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: ListTile(
        contentPadding: EdgeInsets.all(8),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: 80,
            height: 190,
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text(
          title,
          style: TextStyle(fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              date,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              location,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class EventSearchDelegate extends SearchDelegate<String> {
  final List<EventCard> events;

  EventSearchDelegate(this.events);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<EventCard> searchResults = events.where((event) {
      return event.title.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        return searchResults[index];
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<EventCard> suggestionList = query.isEmpty
        ? events
        : events.where((event) {
            return event.title.toLowerCase().contains(query.toLowerCase());
          }).toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestionList[index].title),
          onTap: () {
            query = suggestionList[index].title;
            showResults(context);
          },
        );
      },
    );
  }
}
