import 'package:flutter/material.dart';
import 'package:ngobeacon/components/top_nav_bar.dart';
import 'package:ngobeacon/components/bottom_nav_bar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class EditCurrentEvent extends StatefulWidget {
  final String eventId;
  final Map<String, dynamic> eventData;
  final String ngoId;

  const EditCurrentEvent({
    super.key,
    required this.eventId,
    required this.eventData,
    required this.ngoId,
  });

  @override
  State<EditCurrentEvent> createState() => _EditCurrentEventState();
}

class _EditCurrentEventState extends State<EditCurrentEvent> {
  final _formKey = GlobalKey<FormState>();
  final SupabaseClient _supabase = Supabase.instance.client;
  bool _isLoading = false;

  // Controllers for form fields
  late TextEditingController _nameController;
  late TextEditingController _venueController;
  late TextEditingController _durationController;
  late TextEditingController _contactController;
  late TextEditingController _organizerController;
  late TextEditingController _descriptionController;

  // Date and time values
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    // Initialize controllers with existing data
    _nameController = TextEditingController(text: widget.eventData['event_name']);
    _venueController = TextEditingController(text: widget.eventData['venue']);
    _durationController = TextEditingController(text: widget.eventData['estimated_duration']);
    _contactController = TextEditingController(text: widget.eventData['contact_no']);
    _organizerController = TextEditingController(text: widget.eventData['organiser_name']);
    _descriptionController = TextEditingController(text: widget.eventData['description'] ?? '');

    // Set date and time if available
    if (widget.eventData['date'] != null) {
      _selectedDate = DateTime.parse(widget.eventData['date']);
    }

    if (widget.eventData['time'] != null) {
      final timeString = widget.eventData['time'];
      final parts = timeString.split(':');
      if (parts.length >= 2) {
        _selectedTime = TimeOfDay(
          hour: int.parse(parts[0]),
          minute: int.parse(parts[1]),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _venueController.dispose();
    _durationController.dispose();
    _contactController.dispose();
    _organizerController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // Convert TimeOfDay to String in format HH:MM:SS
  String _timeOfDayToString(TimeOfDay timeOfDay) {
    final hours = timeOfDay.hour.toString().padLeft(2, '0');
    final minutes = timeOfDay.minute.toString().padLeft(2, '0');
    return '$hours:$minutes:00';
  }

  Future<void> _updateEvent() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select date and time'))
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Format date for PostgreSQL (YYYY-MM-DD)
      final formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate!);

      // Format time for PostgreSQL (HH:MM:SS)
      final formattedTime = _timeOfDayToString(_selectedTime!);

      // Create updated event data map
      final eventData = {
        'event_name': _nameController.text,
        'venue': _venueController.text,
        'date': formattedDate,
        'time': formattedTime,
        'estimated_duration': _durationController.text,
        'contact_no': _contactController.text,
        'organiser_name': _organizerController.text,
        'description': _descriptionController.text,
        // Keep the NGO ID the same
        'ngo_id': widget.ngoId,
      };

      // Update in Supabase events table
      await _supabase
          .from('events')
          .update(eventData)
          .eq('id', widget.eventId);

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Event Updated Successfully!'))
      );

      // Go back to the events list
      Navigator.pop(context);

    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${error.toString()}'))
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteEvent() async {
    // Show confirmation dialog
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to delete this event? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (shouldDelete != true) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Delete from Supabase events table
      await _supabase
          .from('events')
          .delete()
          .eq('id', widget.eventId);

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Event Deleted Successfully!'))
      );

      // Go back to the events list
      Navigator.pop(context);

    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${error.toString()}'))
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavBar(),
      bottomNavigationBar: const BottomNavBar(selectedIndex: 2),
      backgroundColor: const Color(0xFF002B5B),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Edit the Event",
                style: TextStyle(
                  color: Color(0xFFFAFAF0),
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 16),
              _buildTextField("Name of the Event", _nameController),
              _buildTextField("Venue", _venueController),

              // Date picker
              _buildDatePicker(),

              // Time picker
              _buildTimePicker(),

              _buildTextField("Estimated Duration", _durationController),

              // Description field with multiple lines
              _buildTextField(
                "Description",
                _descriptionController,
                maxLines: 4,
              ),

              _buildTextField("Contact Number", _contactController),
              _buildTextField("Organizer Name", _organizerController),

              const SizedBox(height: 20),

              // Update and Delete buttons
              _buildButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: _isLoading ? null : _updateEvent,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.blue[900],
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: _isLoading
              ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
              : const Text(
            "Update Event",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _deleteEvent,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: const Text(
            "Delete Event",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Date", style: TextStyle(fontSize: 16, color: Colors.white)),
          const SizedBox(height: 5),
          InkWell(
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: _selectedDate ?? DateTime.now(),
                firstDate: DateTime.now().subtract(const Duration(days: 365)),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (picked != null) {
                setState(() {
                  _selectedDate = picked;
                });
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedDate == null
                        ? 'Select Date'
                        : DateFormat('yyyy-MM-dd').format(_selectedDate!),
                    style: const TextStyle(color: Colors.black),
                  ),
                  const Icon(Icons.calendar_today, color: Colors.black54),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimePicker() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Time", style: TextStyle(fontSize: 16, color: Colors.white)),
          const SizedBox(height: 5),
          InkWell(
            onTap: () async {
              final TimeOfDay? picked = await showTimePicker(
                context: context,
                initialTime: _selectedTime ?? TimeOfDay.now(),
              );
              if (picked != null) {
                setState(() {
                  _selectedTime = picked;
                });
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedTime == null
                        ? 'Select Time'
                        : _selectedTime!.format(context),
                    style: const TextStyle(color: Colors.black),
                  ),
                  const Icon(Icons.access_time, color: Colors.black54),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 16, color: Colors.white)),
          const SizedBox(height: 5),
          TextFormField(
            controller: controller,
            maxLines: maxLines,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter $label';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}