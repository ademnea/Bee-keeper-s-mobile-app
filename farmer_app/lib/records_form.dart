import 'package:flutter/material.dart';

class RecordsForm extends StatefulWidget {
  const RecordsForm({super.key});

  @override
  State<RecordsForm> createState() => _RecordsFormState();
}

class _RecordsFormState extends State<RecordsForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _beekeeperNameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _apiaryLocationController = TextEditingController();
  final TextEditingController _weatherConditionsController = TextEditingController();

  final TextEditingController _hiveIdController = TextEditingController();
  final TextEditingController _hiveTypeController = TextEditingController();
  final TextEditingController _hiveConditionController = TextEditingController();
  final TextEditingController _queenPresenceController = TextEditingController();
  final TextEditingController _queenCellsPresentController = TextEditingController();
  final TextEditingController _broodPatternController = TextEditingController();
  final TextEditingController _eggsLarvaePresentController = TextEditingController();
  final TextEditingController _honeyStoresController = TextEditingController();
  final TextEditingController _pollenStoresController = TextEditingController();

  final TextEditingController _beePopulationController = TextEditingController();
  final TextEditingController _aggressivenessController = TextEditingController();
  final TextEditingController _diseasesObservedController = TextEditingController();
  final TextEditingController _diseasesSpecifyController = TextEditingController();
  final TextEditingController _beetlesPresentController = TextEditingController();
  final TextEditingController _otherPestsPresentController = TextEditingController();

  final TextEditingController _framesCheckedController = TextEditingController();
  final TextEditingController _framesReplacedController = TextEditingController();
  final TextEditingController _hiveCleanedController = TextEditingController();
  final TextEditingController _supersAddedRemovedController = TextEditingController();
  final TextEditingController _otherActionsTakenController = TextEditingController();

  final TextEditingController _generalCommentsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beekeeping Records Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                  'General Information',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _beekeeperNameController,
                  decoration: const InputDecoration(
                    labelText: 'Beekeeper Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _dateController,
                  decoration: const InputDecoration(
                    labelText: 'Date',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _apiaryLocationController,
                  decoration: const InputDecoration(
                    labelText: 'Apiary Location',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _weatherConditionsController,
                  decoration: const InputDecoration(
                    labelText: 'Weather Conditions',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),

                const Text(
                  '1. Hive Information',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _hiveIdController,
                  decoration: const InputDecoration(
                    labelText: '1.1. Hive ID (QR Code/Unique Identifier)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _hiveTypeController,
                  decoration: const InputDecoration(
                    labelText: '1.2. Type of Hive (Langstroth, Top Bar, etc.)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _hiveConditionController,
                  decoration: const InputDecoration(
                    labelText: '1.3. Hive Condition (Good/Fair/Poor)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _queenPresenceController,
                  decoration: const InputDecoration(
                    labelText: '1.4. Presence of Queen? (Yes/No)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _queenCellsPresentController,
                  decoration: const InputDecoration(
                    labelText: '1.5. Queen Cells Present? (Yes/No)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _broodPatternController,
                  decoration: const InputDecoration(
                    labelText: '1.6. Brood Pattern (Good/Irregular)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _eggsLarvaePresentController,
                  decoration: const InputDecoration(
                    labelText: '1.7. Eggs & Larvae Present? (Yes/No)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _honeyStoresController,
                  decoration: const InputDecoration(
                    labelText: '1.8. Honey Stores (Low/Medium/Full)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _pollenStoresController,
                  decoration: const InputDecoration(
                    labelText: '1.9. Pollen Stores (Low/Medium/Full)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),

                const Text(
                  '2. Colony Health & Activity',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _beePopulationController,
                  decoration: const InputDecoration(
                    labelText: '2.1. Bee Population (Strong/Moderate/Weak)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _aggressivenessController,
                  decoration: const InputDecoration(
                    labelText: '2.2. Aggressiveness of Bees (Calm/Moderate/Aggressive)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _diseasesObservedController,
                  decoration: const InputDecoration(
                    labelText: '2.3. Diseases or Pests Observed? (Yes/No)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _diseasesSpecifyController,
                  decoration: const InputDecoration(
                    labelText: '2.3.1. If Yes, specify:',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _beetlesPresentController,
                  decoration: const InputDecoration(
                    labelText: '2.4. Presence of Beetles? (Yes/No)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _otherPestsPresentController,
                  decoration: const InputDecoration(
                    labelText: '2.5. Presence of Other Pests (Ants, Varroa mites, etc.)? (Yes/No)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),

                const Text(
                  '3. Maintenance & Actions Taken',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _framesCheckedController,
                  decoration: const InputDecoration(
                    labelText: '3.1. Frames Checked (Number)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _framesReplacedController,
                  decoration: const InputDecoration(
                    labelText: '3.2. Any Frames Replaced? (Yes/No)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _hiveCleanedController,
                  decoration: const InputDecoration(
                    labelText: '3.3. Hive Cleaned? (Yes/No)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _supersAddedRemovedController,
                  decoration: const InputDecoration(
                    labelText: '3.4. Supers Added or Removed? (Yes/No)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _otherActionsTakenController,
                  decoration: const InputDecoration(
                    labelText: '3.5. Any Other Actions Taken:',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),

                const Text(
                  '4. General Comments & Recommendations',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  maxLines: 5,
                  controller: _generalCommentsController,
                  decoration: const InputDecoration(
                    labelText: 'General Comments & Recommendations',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Handle form submission here
                      print('Form submitted successfully');
                      // Example: Save data to database or API
                    }
                  },
                  child: const Text('Submit Form'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
