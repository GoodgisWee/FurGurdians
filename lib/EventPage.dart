import 'package:flutter/material.dart';

class EventsPage extends StatefulWidget {
  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  List<EventCard> events = [
    EventCard(
      date: 'Wed, Jun 28 • 5:30 PM',
      title: 'BBQ night with your dearest',
      location: 'Radius Gallery • Santa Cruz, CA',
      imageUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQHhdkXNb9Hgn97SAMdMvLhTS11ZPVEWKTETptr-bdQg3zBmBvgvOVtt53L7vMfq-Lq0Hc&usqp=CAU',
    ),
    EventCard(
      date: 'Sat, May 1 • 7:00 PM',
      title: 'Music Night with your furry kids',
      location: 'Lot 13 • Oakland, CA',
      imageUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQQI9t71LHq1eC0YrxZ_gtqQxYjVOPwF5g4Uw&s',
    ),
    EventCard(
      date: 'Sat, Apr 24 • 1:30 PM',
      title: 'Furry Kid’s Interaction Day',
      location: '53 Bush St • San Francisco, CA',
      imageUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTfF1bma5LhEbNBa3Dq7LJNYwhU02rsyFOc-w&s',
    ),
  ];

  List<EventCard> filteredEvents = [];

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    filteredEvents = events;
    super.initState();
  }

  void filterEvents(String query) {
    List<EventCard> filteredList = events.where((event) {
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
        title: Text('Events'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: EventSearchDelegate(events),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
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
        contentPadding: EdgeInsets.all(8), // Added padding for ListTile content
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: 80,
            height: 190,
            child: Image.network(
              imageUrl,
              fit: BoxFit.fill, // Use BoxFit.cover to ensure the image covers the entire container
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
            SizedBox(height: 16), // Reduced SizedBox height for tighter spacing
            Text(location),
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
    // Actions for AppBar (e.g., clear query or submit search)
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
    // Leading icon on the left of the AppBar (e.g., back arrow)
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Show results based on the search query
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
    // Show suggestions as the user types
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
