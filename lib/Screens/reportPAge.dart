import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:test_rait_new/Screens/ChatPage.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref("reports");
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  String? _selectedIncidentType;
  double _severity = 1;
  double? _latitude;
  double? _longitude;

  final List<String> _incidentTypes = [
    'Harassment',
    'Stalking',
    'Domestic Violence',
    'Assault',
    'Kidnapping',
    'Cyberbullying',
    'Eve Teasing',
    'Mugging',
    'Human Trafficking',
    'Others'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Incident'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                _buildIncidentTypeDropdown(),
                _buildSeveritySlider(),
                _buildLocationSearchField(),
                _buildTextField(_descriptionController, 'Description'),
                _buildDateField(),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitReport,
                  child: const Text('Submit Report'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIncidentTypeDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: _selectedIncidentType,
        items: _incidentTypes.map((type) {
          return DropdownMenuItem(value: type, child: Text(type));
        }).toList(),
        onChanged: (value) {
          setState(() {
            _selectedIncidentType = value;
          });
        },
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Incident Type',
        ),
        validator: (value) => value == null ? 'Please select an incident type' : null,
      ),
    );
  }

  Widget _buildSeveritySlider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Severity'),
          Slider(
            value: _severity,
            min: 1,
            max: 5,
            divisions: 4,
            label: _severity.round().toString(),
            onChanged: (value) {
              setState(() {
                _severity = value;
              });
            },
          ),
        ],
      ),
    );
  }
  Widget _buildTextField(TextEditingController controller, String label, {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: label,
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
  Widget _buildLocationSearchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: _locationController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Location',
        ),
        onTap: () async {
          // Implement location search logic here
          // For example, using Google Places API or any geocoding service
          // For simplicity, using a static method to demonstrate
          await _searchLocation();
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a location';
          }
          return null;
        },
      ),
    );
  }

  Future<void> _searchLocation() async {
    String location = _locationController.text;
    if (location.isNotEmpty) {
      List<Location> locations = await locationFromAddress(location);
      if (locations.isNotEmpty) {
        setState(() {
          _latitude = locations.first.latitude;
          _longitude = locations.first.longitude;
        });
      }
    }
  }

  Widget _buildDateField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: _dateController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Date',
        ),
        onTap: () async {
          FocusScope.of(context).requestFocus(FocusNode());
          DateTime? date = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
          );
          if (date != null) {
            _dateController.text = date.toLocal().toString().split(' ')[0];
          }
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select a date';
          }
          return null;
        },
      ),
    );
  }

  void _submitReport() {
    if (_formKey.currentState!.validate()) {
      final reportData = {
        'incidentType': _selectedIncidentType,
        'severity': _severity,
        'location': _locationController.text,
        'latitude': _latitude,
        'longitude': _longitude,
        'description': _descriptionController.text,
        'date': _dateController.text,
      };

      _databaseRef.push().set(reportData).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Report submitted successfully!')),
        );
        _formKey.currentState!.reset();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) =>  ChatPage()),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit report: $error')),
        );
      });
    }
  }

  @override
  void dispose() {
    _locationController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    super.dispose();
  }
}
