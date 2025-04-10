import 'package:flutter/material.dart';
import 'package:ngobeacon/Upload_Page/Current_Events/edit_current_event.dart';
import 'package:ngobeacon/components/bottom_nav_bar.dart';
import 'package:ngobeacon/components/top_nav_bar.dart';
import 'package:ngobeacon/ngo_item.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class Current_event_list extends StatefulWidget {
  const Current_event_list({super.key});

  @override
  State<Current_event_list> createState() => _Current_event_listState();
}

class _Current_event_listState extends State<Current_event_list> {
  final SupabaseClient _supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _events = [];
  bool _isLoading = true;
  String? _errorMessage;
  String? _ngoId;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // First get the NGO ID for current user
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      final ngoProfile = await _supabase
          .from('ngo_profile')
          .select('ngo_id')
          .eq('authid', userId)
          .maybeSingle();

      if (ngoProfile == null) throw Exception('NGO profile not found');

      _ngoId = ngoProfile['ngo_id'] as String;

      // Then fetch events for this NGO
      final response = await _supabase
          .from('events')
          .select('*')
          .eq('ngo_id', _ngoId!)
          .order('date', ascending: true);

      setState(() {
        _events = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load events: ${e.toString()}';
      });
      debugPrint('Error loading events: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavBar(),
      bottomNavigationBar: const BottomNavBar(selectedIndex: 2),
      backgroundColor: const Color(0xFF002B5B),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Current Events",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildEventList(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadEvents,
        backgroundColor: Colors.white,
        child: const Icon(Icons.refresh, color: Color(0xFF002B5B)),
      ),
    );
  }

  Widget _buildEventList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Text(
          _errorMessage!,
          style: const TextStyle(color: Colors.white),
        ),
      );
    }

    if (_events.isEmpty) {
      return const Center(
        child: Text(
          'No events found',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return Expanded(
      child: ListView.builder(
        itemCount: _events.length,
        itemBuilder: (context, index) {
          final event = _events[index];
          return Column(
            children: [
              NGOItem(
                name: event['event_name'] ?? 'Unnamed Event',
                logo: "assets/Icons/sowing-seeds.png",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditCurrentEvent(
                        eventId: event['id'].toString(),
                        eventData: event,
                        ngoId: _ngoId!,
                      ),
                    ),
                  ).then((_) => _loadEvents());
                },
              ),
              // Add event details below the NGOItem
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _buildEventDate(event),
                      style: const TextStyle(color: Colors.white70),
                    ),
                    Text(
                      'Venue: ${event['venue'] ?? 'Not specified'}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    // Display description if available
                    if (event['description'] != null && event['description'].toString().isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          'Description: ${_truncateDescription(event['description'])}',
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Helper method to truncate long descriptions
  String _truncateDescription(String description) {
    const maxLength = 100;
    if (description.length <= maxLength) {
      return description;
    }
    return '${description.substring(0, maxLength)}...';
  }

  String _buildEventDate(Map<String, dynamic> event) {
    final date = event['date'] != null
        ? DateFormat('MMM d, yyyy').format(DateTime.parse(event['date']))
        : 'No date specified';
    final time = event['time'] != null
        ? DateFormat('h:mm a').format(DateTime.parse('1970-01-01 ${event['time']}'))
        : 'No time specified';

    return '$date at $time';
  }
}