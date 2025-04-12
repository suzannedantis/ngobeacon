import 'package:flutter/material.dart';

class CurrentEventsPage extends StatelessWidget {
  final List<Event> currentEvents = [
    Event(
      title: "Tree Plantation Drive",
      date: "2025-04-10",
      location: "Navi Mumbai",
      description: "Join us to plant 100+ trees across various sectors.",
    ),
    Event(
      title: "Blood Donation Camp",
      date: "2025-04-15",
      location: "Thane Hospital",
      description: "Help save lives by donating blood. Refreshments provided.",
    ),
    Event(
      title: "Beach Cleanup",
      date: "2025-04-20",
      location: "Juhu Beach",
      description: "Let's clean our coastline! Gloves and bags will be provided.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Current Events'),
        backgroundColor: Colors.blue[900],
      ),
      backgroundColor: Colors.white,
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: currentEvents.length,
        itemBuilder: (context, index) {
          return EventCard(event: currentEvents[index]);
        },
      ),
    );
  }
}

class Event {
  final String title;
  final String date;
  final String location;
  final String description;

  Event({
    required this.title,
    required this.date,
    required this.location,
    required this.description,
  });
}

class EventCard extends StatelessWidget {
  final Event event;

  const EventCard({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.blue[900]),
                const SizedBox(width: 6),
                Text(event.date),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.blue[900]),
                const SizedBox(width: 6),
                Text(event.location),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              event.description,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
