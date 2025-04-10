import 'package:flutter/material.dart';
import 'package:ngobeacon/components/top_nav_bar.dart';
import 'package:ngobeacon/components/bottom_nav_bar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class CreateEventScreen extends StatefulWidget {
  final String ngoId;

  const CreateEventScreen({super.key, required this.ngoId});

  @override
  _CreateEventScreenState createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _supabase = Supabase.instance.client;
  bool _isLoading = false;

  // Controllers for form fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _venueController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _organizerController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController(); // Added description controller

  // Date and time values
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void dispose() {
    _nameController.dispose();
    _venueController.dispose();
    _durationController.dispose();
    _contactController.dispose();
    _organizerController.dispose();
    _descriptionController.dispose(); // Added description disposal
    super.dispose();
  }

  // Convert TimeOfDay to String in format HH:MM:SS
  String _timeOfDayToString(TimeOfDay timeOfDay) {
    final hours = timeOfDay.hour.toString().padLeft(2, '0');
    final minutes = timeOfDay.minute.toString().padLeft(2, '0');
    return '$hours:$minutes:00';
  }

  // Parse duration string into consistent format
  String _parseDuration(String durationText) {
    int hours = 0;
    int minutes = 0;

    // Simple parsing - handles formats like "2 hours 30 minutes" or "2 hrs 30 mins" or "2.5"
    if (durationText.contains('hour') || durationText.contains('hr')) {
      final parts = durationText.split(' ');
      for (int i = 0; i < parts.length; i++) {
        if (parts[i].isNotEmpty && int.tryParse(parts[i]) != null) {
          if (i + 1 < parts.length &&
              (parts[i + 1].contains('hour') || parts[i + 1].contains('hr'))) {
            hours = int.parse(parts[i]);
          } else if (i + 1 < parts.length && parts[i + 1].contains('min')) {
            minutes = int.parse(parts[i]);
          }
        }
      }
    } else {
      // If just a number, assume it's hours
      final numericValue = double.tryParse(durationText);
      if (numericValue != null) {
        hours = numericValue.floor();
        minutes = ((numericValue - hours) * 60).round();
      }
    }

    return '$hours hours $minutes minutes';
  }

  Future<void> _uploadEvent() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select date and time'))
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

      // Parse duration to consistent format
      final formattedDuration = _parseDuration(_durationController.text);

      // Check if an event with the same name and date already exists for this NGO
      final existingEvents = await _supabase
          .from('events')
          .select()
          .eq('ngo_id', widget.ngoId)
          .eq('event_name', _nameController.text)
          .eq('date', formattedDate);

      if (existingEvents.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('An event with this name and date already exists'))
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Create event data map
      final eventData = {
        'event_name': _nameController.text,
        'venue': _venueController.text,
        'date': formattedDate,
        'time': formattedTime,
        'estimated_duration': formattedDuration,
        'contact_no': _contactController.text,
        'organiser_name': _organizerController.text,
        'description': _descriptionController.text, // Added description field
        'ngo_id': widget.ngoId,
      };

      // Insert into Supabase events table
      await _supabase.from('events').insert(eventData);

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Event Uploaded Successfully!'))
      );

      // Clear form
      _clearForm();

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

  // New method to clear the form
  void _clearForm() {
    _nameController.clear();
    _venueController.clear();
    _durationController.clear();
    _contactController.clear();
    _organizerController.clear();
    _descriptionController.clear(); // Clear description
    setState(() {
      _selectedDate = null;
      _selectedTime = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF002B5B),
      appBar: TopNavBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Create New Event",
                  style: TextStyle(
                    color: Color(0xFFFAFAF0),
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                _buildTextField('Name of the Event', _nameController),
                _buildTextField('Venue', _venueController),

                // Date picker
                _buildDatePicker(),

                // Time picker
                _buildTimePicker(),

                _buildTextField(
                  'Estimated Duration (e.g., 2 hours 30 minutes)',
                  _durationController,
                ),

                // Description field - added as a multiline text field
                _buildTextField(
                  'Description',
                  _descriptionController,
                  maxLines: 4,
                  hint: 'Enter event description',
                ),

                _buildTextField(
                  'Contact Number',
                  _contactController,
                  keyboardType: TextInputType.phone,
                ),
                _buildTextField('Organizer Name', _organizerController),

                SizedBox(height: 20),
                _buildUploadButton(),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }

  // Extracted the date picker to a separate method
  Widget _buildDatePicker() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Date',
            style: TextStyle(
              color: Color(0xFFFAFAF0),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          InkWell(
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: _selectedDate ?? DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(Duration(days: 365)),
              );
              if (picked != null) {
                setState(() {
                  _selectedDate = picked;
                });
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedDate == null
                        ? 'Select Date'
                        : DateFormat('yyyy-MM-dd').format(_selectedDate!),
                    style: TextStyle(color: Colors.black),
                  ),
                  Icon(Icons.calendar_today, color: Colors.black54),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Extracted the time picker to a separate method
  Widget _buildTimePicker() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Time',
            style: TextStyle(
              color: Color(0xFFFAFAF0),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
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
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedTime == null
                        ? 'Select Time'
                        : _selectedTime!.format(context),
                    style: TextStyle(color: Colors.black),
                  ),
                  Icon(Icons.access_time, color: Colors.black54),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Extracted the upload button to a separate method
  Widget _buildUploadButton() {
    return Center(
      child: _isLoading
          ? CircularProgressIndicator(color: Color(0xFFFAFAF0))
          : ElevatedButton(
        onPressed: _uploadEvent,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFFAFAF0),
          foregroundColor: Colors.blue.shade900,
          padding: EdgeInsets.symmetric(
            horizontal: 32,
            vertical: 16,
          ),
          textStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        child: Text('Upload Event'),
      ),
    );
  }

  // Enhanced text field widget with optional parameters
  Widget _buildTextField(
      String label,
      TextEditingController controller, {
        TextInputType keyboardType = TextInputType.text,
        int maxLines = 1,
        String? hint,
      }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Color(0xFFFAFAF0),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[200],
              hintText: hint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            validator: (value) => value!.isEmpty ? 'Please enter $label' : null,
          ),
        ],
      ),
    );
  }
}