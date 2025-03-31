import 'package:flutter/material.dart';

class RecordsForm extends StatefulWidget {
  final String apiaryLocation;
  final String hiveId;
  final String farmName; 

  const RecordsForm({
    super.key, 
    required this.apiaryLocation,
    required this.hiveId,
    required this.farmName, 
  });

  @override
  State<RecordsForm> createState() => _RecordsFormState();
}

class _RecordsFormState extends State<RecordsForm> {
  final _formKey = GlobalKey<FormState>();
  final DateTime _inspectionDate = DateTime.now();
  
  // Section 1: General Information
  final TextEditingController _beekeeperNameController = TextEditingController();
  final TextEditingController _weatherConditionsController = TextEditingController();
  final TextEditingController _apiaryLocationController = TextEditingController();
  final TextEditingController _hiveIdController = TextEditingController();

  // Section 2: Hive Information
  final TextEditingController _hiveTypeController = TextEditingController();
  final TextEditingController _hiveConditionController = TextEditingController();
  final TextEditingController _queenPresenceController = TextEditingController();
  final TextEditingController _queenCellsController = TextEditingController();
  final TextEditingController _broodPatternController = TextEditingController();
  final TextEditingController _eggsLarvaeController = TextEditingController();
  final TextEditingController _honeyStoresController = TextEditingController();
  final TextEditingController _pollenStoresController = TextEditingController();

  // Section 3: Colony Health
  final TextEditingController _beePopulationController = TextEditingController();
  final TextEditingController _aggressivenessController = TextEditingController();
  final TextEditingController _diseasesObservedController = TextEditingController();
  final TextEditingController _diseasesSpecifyController = TextEditingController();
  final TextEditingController _pestsPresentController = TextEditingController();

  // Section 4: Maintenance
  final TextEditingController _framesCheckedController = TextEditingController();
  final TextEditingController _framesReplacedController = TextEditingController();
  final TextEditingController _hiveCleanedController = TextEditingController();
  final TextEditingController _supersChangedController = TextEditingController();
  final TextEditingController _otherActionsController = TextEditingController();

  // Section 5: Comments
  final TextEditingController _commentsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Pre-fill the location and hive ID
    _apiaryLocationController.text = widget.apiaryLocation;
    _hiveIdController.text = widget.hiveId;


  }

  @override
  void dispose() {
    // Dispose all controllers
    _beekeeperNameController.dispose();
    _weatherConditionsController.dispose();
    _apiaryLocationController.dispose();
    _hiveIdController.dispose();
    _hiveTypeController.dispose();
    _hiveConditionController.dispose();
    _queenPresenceController.dispose();
    _queenCellsController.dispose();
    _broodPatternController.dispose();
    _eggsLarvaeController.dispose();
    _honeyStoresController.dispose();
    _pollenStoresController.dispose();
    _beePopulationController.dispose();
    _aggressivenessController.dispose();
    _diseasesObservedController.dispose();
    _diseasesSpecifyController.dispose();
    _pestsPresentController.dispose();
    _framesCheckedController.dispose();
    _framesReplacedController.dispose();
    _hiveCleanedController.dispose();
    _supersChangedController.dispose();
    _otherActionsController.dispose();
    _commentsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hive Inspection Record'),
        backgroundColor: Colors.orange[700],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader('1. General Information'),
              _buildReadOnlyField('Inspection Date', _formatDate(_inspectionDate)),
              _buildTextField('Beekeeper Name', _beekeeperNameController),
              _buildTextField('Weather Conditions', _weatherConditionsController),
              _buildReadOnlyField('Apiary Location', _apiaryLocationController.text),
              _buildReadOnlyField('Hive ID', _hiveIdController.text),
              const SizedBox(height: 24),

              _buildSectionHeader('2. Hive Information'),
              _buildTextField('Type of Hive', _hiveTypeController, hint: 'e.g., Langstroth, Top Bar'),
              _buildDropdownField('Hive Condition', _hiveConditionController, 
                ['Good', 'Fair', 'Poor']),
              _buildYesNoField('Presence of Queen?', _queenPresenceController),
              _buildYesNoField('Queen Cells Present?', _queenCellsController),
              _buildDropdownField('Brood Pattern', _broodPatternController, 
                ['Good', 'Irregular', 'Spotty', 'None']),
              _buildYesNoField('Eggs & Larvae Present?', _eggsLarvaeController),
              _buildDropdownField('Honey Stores', _honeyStoresController, 
                ['Low', 'Medium', 'Full']),
              _buildDropdownField('Pollen Stores', _pollenStoresController, 
                ['Low', 'Medium', 'Full']),
              const SizedBox(height: 24),

              _buildSectionHeader('3. Colony Health'),
              _buildDropdownField('Bee Population', _beePopulationController, 
                ['Strong', 'Moderate', 'Weak']),
              _buildDropdownField('Aggressiveness', _aggressivenessController, 
                ['Calm', 'Moderate', 'Aggressive']),
              _buildYesNoField('Diseases or Pests Observed?', _diseasesObservedController),
              if (_diseasesObservedController.text == 'Yes')
                _buildTextField('Specify Diseases/Pests', _diseasesSpecifyController),
              _buildTextField('Other Pests Present', _pestsPresentController, 
                hint: 'e.g., Varroa mites, Small Hive Beetles'),
              const SizedBox(height: 24),

              _buildSectionHeader('4. Maintenance Actions'),
              _buildNumberField('Frames Checked', _framesCheckedController),
              _buildYesNoField('Frames Replaced?', _framesReplacedController),
              _buildYesNoField('Hive Cleaned?', _hiveCleanedController),
              _buildYesNoField('Supers Added/Removed?', _supersChangedController),
              _buildTextField('Other Actions Taken', _otherActionsController),
              const SizedBox(height: 24),

              _buildSectionHeader('5. Comments & Recommendations'),
              _buildLargeTextField('General Comments', _commentsController),
              const SizedBox(height: 32),

              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange[700],
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: _submitForm,
                  child: const Text(
                    'SUBMIT INSPECTION',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.brown,
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {String? hint}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: Colors.grey[100],
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        initialValue: value,
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: Colors.grey[200],
        ),
      ),
    );
  }

  Widget _buildDropdownField(String label, TextEditingController controller, List<String> items) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: Colors.grey[100],
        ),
        items: items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (value) {
          controller.text = value ?? '';
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildYesNoField(String label, TextEditingController controller) {
    return _buildDropdownField(label, controller, ['Yes', 'No']);
  }

  Widget _buildNumberField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: Colors.grey[100],
        ),
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          if (int.tryParse(value) == null) {
            return 'Please enter a valid number';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildLargeTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        controller: controller,
        maxLines: 4,
        decoration: InputDecoration(
          labelText: label,
          alignLabelWithHint: true,
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: Colors.grey[100],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Form is valid, proceed with submission
      _showSubmissionDialog();
    }
  }

  void _showSubmissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Submit Inspection?'),
        content: const Text('Are you sure you want to submit this hive inspection record?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange[700],
            ),
            onPressed: () {
              Navigator.pop(context);
              _saveInspectionData();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Inspection submitted successfully!')),
              );
              Navigator.pop(context); // Return to previous screen
            },
            child: const Text('SUBMIT'),
          ),
        ],
      ),
    );
  }

  void _saveInspectionData() {
    // Here you would typically save to database or API
    // For now, we'll just print the data
    final inspectionData = {
      'date': _formatDate(_inspectionDate),
      'beekeeper': _beekeeperNameController.text,
      'location': _apiaryLocationController.text,
      'hiveId': _hiveIdController.text,
      // Add all other fields...
    };
    print('Inspection Data: $inspectionData');
  }
}