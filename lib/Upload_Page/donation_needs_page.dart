import 'package:flutter/material.dart';
import 'ngo_upload_page.dart';
import '../components/bottom_nav_bar.dart';
import '../components/top_nav_bar.dart';

class DonationNeedsPage extends StatefulWidget {
  const DonationNeedsPage({Key? key}) : super(key: key);

  @override
  State<DonationNeedsPage> createState() => _DonationNeedsPageState();
}

class _DonationNeedsPageState extends State<DonationNeedsPage> {
  Map<String, bool> donationNeeds = {
    'Money': false,
    'Clothes': false,
    'Articles': false,
    'Food': false,
  };

  // Simple icons for each donation type
  final Map<String, IconData> donationIcons = {
    'Money': Icons.attach_money,
    'Clothes': Icons.checkroom,
    'Articles': Icons.category,
    'Food': Icons.restaurant,
  };

  // Controllers for the text fields
  final TextEditingController preferredDaysController = TextEditingController();
  final TextEditingController preferredTimingsController = TextEditingController();

  // Item-specific controllers
  final TextEditingController upiController = TextEditingController();
  final TextEditingController clothingTypesController = TextEditingController();
  final TextEditingController articleTypesController = TextEditingController();
  final TextEditingController foodTypesController = TextEditingController();

  @override
  void dispose() {
    preferredDaysController.dispose();
    preferredTimingsController.dispose();
    upiController.dispose();
    clothingTypesController.dispose();
    articleTypesController.dispose();
    foodTypesController.dispose();
    super.dispose();
  }

  // Updated validation method with new requirements
  bool validateForm() {
    // Check if any donation type is selected
    bool anySelected = donationNeeds.values.any((selected) => selected);

    // If nothing is selected, allow saving without validation
    if (!anySelected) {
      return true;
    }

    // If any item is selected, preferred days and timings become mandatory
    if (preferredDaysController.text.trim().isEmpty) {
      _showValidationError("Please enter preferred days for your donation");
      return false;
    }

    if (preferredTimingsController.text.trim().isEmpty) {
      _showValidationError("Please enter preferred timings for your donation");
      return false;
    }

    // Item-specific field validation
    if (donationNeeds['Money'] == true && upiController.text.trim().isEmpty) {
      _showValidationError("Please enter UPI ID for money donations");
      return false;
    }

    if (donationNeeds['Clothes'] == true && clothingTypesController.text.trim().isEmpty) {
      _showValidationError("Please enter clothing types needed");
      return false;
    }

    if (donationNeeds['Articles'] == true && articleTypesController.text.trim().isEmpty) {
      _showValidationError("Please enter article types needed");
      return false;
    }

    if (donationNeeds['Food'] == true && foodTypesController.text.trim().isEmpty) {
      _showValidationError("Please enter food types needed");
      return false;
    }

    return true;
  }

  void _showValidationError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Check if any item is selected to update UI cues
    bool anySelected = donationNeeds.values.any((selected) => selected);

    return Scaffold(
      backgroundColor: const Color(0xFF002B5B),
      appBar: TopNavBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            const SizedBox(height: 16),
            const Center(
              child: Text(
                'Donation Needs',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Center(
              child: Text(
                'Select the particular item(s) needed by your NGO',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),

            // Common donation schedule fields
            _buildCommonScheduleFields(anySelected),
            const SizedBox(height: 16),

            // Scrollable List for donation types
            Expanded(
              child: ListView.builder(
                itemCount: donationNeeds.entries.length,
                itemBuilder: (context, index) {
                  final entry = donationNeeds.entries.elementAt(index);
                  final key = entry.key;
                  final value = entry.value;

                  return Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              donationNeeds[key] = !value;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: value
                                  ? const Color(0xFFF5F6F8)
                                  : const Color(0xFFE0E5EC),
                              boxShadow: value
                                  ? [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                )
                              ]
                                  : null,
                            ),
                            child: Row(
                              children: [
                                Checkbox(
                                  value: value,
                                  onChanged: (val) {
                                    setState(() {
                                      donationNeeds[key] = val!;
                                    });
                                  },
                                  side: BorderSide(
                                    color: value
                                        ? const Color(0xFF0D3C73)
                                        : Colors.grey,
                                    width: 2,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  activeColor: const Color(0xFF0D3C73),
                                  checkColor: Colors.white,
                                ),
                                Icon(
                                  donationIcons[key],
                                  color: value
                                      ? const Color(0xFF0D3C73)
                                      : Colors.grey.shade600,
                                  size: 22,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    key,
                                    style: TextStyle(
                                      color: value
                                          ? const Color(0xFF0D3C73)
                                          : Colors.grey.shade700,
                                      fontWeight: value ? FontWeight.w600 : FontWeight.w500,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                if (value)
                                  Padding(
                                    padding: const EdgeInsets.only(right: 12.0),
                                    child: Icon(
                                      Icons.check_circle,
                                      color: const Color(0xFF0D3C73),
                                      size: 18,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Dynamic form fields based on checkbox selection
                      if (value) _buildDynamicFields(key),
                    ],
                  );
                },
              ),
            ),

            // Save Button
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 10, bottom: 16),
              child: ElevatedButton(
                onPressed: () {
                  if (validateForm()) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UploadPage()),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFAFAF0),
                  foregroundColor: const Color(0xFF0D3C73),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                ),
                child: const Text(
                  "Save Selection",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(selectedIndex: 2),
    );
  }

  // Common fields for all donation types - now with conditional required marker
  Widget _buildCommonScheduleFields(bool fieldsRequired) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "General Donation Schedule",
                style: TextStyle(
                  color: const Color(0xFF0D3C73),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (fieldsRequired)
                Text(
                  " *",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
          if (fieldsRequired)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                "Required when items are selected",
                style: TextStyle(
                  color: Colors.red.shade700,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: preferredDaysController,
                  labelText: 'Preferred Days',
                  hintText: 'e.g., Mon-Fri, Weekends',
                  required: fieldsRequired,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  controller: preferredTimingsController,
                  labelText: 'Preferred Timings',
                  hintText: 'e.g., 9 AM - 5 PM',
                  required: fieldsRequired,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper method to build dynamic fields based on donation type
  Widget _buildDynamicFields(String donationType) {
    switch (donationType) {
      case 'Money':
        return _buildFormFieldsContainer([
          _buildTextField(
            controller: upiController,
            labelText: 'UPI ID',
            hintText: 'Enter your UPI ID',
            required: true,
          ),
        ]);
      case 'Clothes':
        return _buildFormFieldsContainer([
          _buildTextField(
            controller: clothingTypesController,
            labelText: 'Clothing Types',
            hintText: 'Enter clothing types needed',
            required: true,
          ),
        ]);
      case 'Articles':
        return _buildFormFieldsContainer([
          _buildTextField(
            controller: articleTypesController,
            labelText: 'Article Types',
            hintText: 'Enter article types needed',
            required: true,
          ),
        ]);
      case 'Food':
        return _buildFormFieldsContainer([
          _buildTextField(
            controller: foodTypesController,
            labelText: 'Food Types',
            hintText: 'Enter food types needed',
            required: true,
          ),
        ]);
      default:
        return const SizedBox.shrink();
    }
  }

  // Helper method to create a container for form fields
  Widget _buildFormFieldsContainer(List<Widget> fields) {
    return Container(
      margin: const EdgeInsets.only(left: 40, right: 0, bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 3,
            offset: const Offset(0, 1),
          )
        ],
      ),
      child: Column(
        children: fields.map((field) {
          int index = fields.indexOf(field);
          return Padding(
            padding: EdgeInsets.only(bottom: index < fields.length - 1 ? 10 : 0),
            child: field,
          );
        }).toList(),
      ),
    );
  }

  // Helper method to create consistent text fields
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    bool required = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 4),
          child: Row(
            children: [
              Text(
                labelText,
                style: TextStyle(
                  color: const Color(0xFF0D3C73),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (required)
                Text(
                  '*',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),
        Container(
          height: 46,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: required ? Colors.grey.shade400 : Colors.grey.shade300,
              width: required ? 1.5 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 2,
                offset: const Offset(0, 1),
              )
            ],
          ),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 14,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}