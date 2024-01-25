import 'package:asthsist_plus/pages/home_page.dart';
import 'package:asthsist_plus/pages/navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../style.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
  const EditProfilePage({Key? key}) : super(key: key);
  // static const String routeName = '/edit-profile';
}

class DOBInputField extends StatelessWidget {
  final TextEditingController dobController;
  final String label;
  final IconData icon;

  DOBInputField({
    Key? key,
    required this.dobController,
    required this.label,
    this.icon = Icons.calendar_today, // Default icon if one is not provided
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: dobController,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      readOnly: true, // Prevent manual editing
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (pickedDate != null) {
          String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
          dobController.text = formattedDate; // Use formatted date
        }
      },
    );
  }
}

void _showSaveConfirmationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: Text('Confirm'),
        content: Text('Are you sure you want to save the changes?'),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(dialogContext).pop(); // Dismiss the dialog
            },
          ),
          TextButton(
            child: Text('Save'),
            onPressed: () {
              //save logic
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => NavigationBarApp()));
              // Implement your edit profile functionality here
            },
          ),
        ],
      );
    },
  );
}

class _EditProfilePageState extends State<EditProfilePage> {
  String _gender = 'Male';
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _peakFlowController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: Text('Edit Profile'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            SizedBox(height: 40),
            TextFormField(
              controller: _firstNameController,
              decoration: _inputDecoration(
                'Firstname', 'Please enter a valid name',
                Icons.person
              ),
            ),
            SizedBox(height: 15.0),
            TextFormField(
              controller: _lastNameController,
              decoration: _inputDecoration(
                'Lastname', 'Please enter a valid name',
                Icons.person_outline
              ),
            ),
            SizedBox(height: 15.0),
            DOBInputField(
              dobController: _dobController,
              label: 'Date of Birth',
            ),
            SizedBox(height: 15.0),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    controller: _weightController,
                    decoration: _inputDecoration(
                      'Weight', 'Weight in kg',
                      null
                    ),
                  ),
                ),
                SizedBox(width: 15.0),
                Expanded(
                  child: TextFormField(
                    controller: _heightController,
                    decoration: _inputDecoration(
                      'Height', 'Height in cm',
                      null
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.0),
            TextFormField(
              controller: _peakFlowController,
              decoration: _inputDecorationWithSuffix(
                'Personal best Peak Flow', 'Please enter a valid number',
                Icons.fitness_center, Icons.help_outline
              ),
            ),
            SizedBox(height: 24.0),
            _genderRadio(),
            SizedBox(height: 24.0),
            ElevatedButton(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  'Save Change',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              style: ElevatedButton.styleFrom(
                shape: StadiumBorder(),
                primary: Colors.deepPurple,
                onPrimary: Colors.white,
                minimumSize: Size(double.infinity, 50), // Set a larger height
              ),
              onPressed: () {
                _showSaveConfirmationDialog(context);
                // Implement save logic
              },
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, String hint, IconData? icon) {
    return InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.0),
        borderSide: BorderSide.none,
      ),
      labelText: label,
      hintText: hint,
      floatingLabelStyle: const TextStyle(
        height: 4,
        color: Colors.grey,
      ),
      filled: true,
      fillColor: Colors.grey[200],
      prefixIcon: icon != null ? Icon(icon) : null,
    );
  }

  InputDecoration _inputDecorationWithSuffix(String label, String hint, IconData? prefixIcon, IconData suffixIcon) {
    return InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.0),
        borderSide: BorderSide.none,
      ),
      labelText: label,
      hintText: hint,
      floatingLabelStyle: const TextStyle(
        height: 4,
        color: Colors.grey,
      ),
      filled: true,
      fillColor: Colors.grey[200],
      prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
      suffixIcon: Icon(suffixIcon),
    );
  }

  Widget _genderRadio() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Radio(
          value: 'Male',
          groupValue: _gender,
          onChanged: (String? value) {
            setState(() {
              _gender = value!;
            });
          },
        ),
        Text('Male'),
        Radio(
          value: 'Female',
          groupValue: _gender,
          onChanged: (String? value) {
            setState(() {
              _gender = value!;
            });
          },
        ),
        Text('Female'),
      ],
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dobController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _peakFlowController.dispose();
    super.dispose();
  }
}