import 'package:asthsist_plus/pages/home_page.dart';
import 'package:asthsist_plus/pages/navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../backend/firebase.dart';
import '../style.dart';
import '../widget_tree.dart';

class CompleteProfilePage extends StatefulWidget {
  @override
  _CompleteProfilePageState createState() => _CompleteProfilePageState();
  const CompleteProfilePage({Key? key}) : super(key: key);
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



class _CompleteProfilePageState extends State<CompleteProfilePage> {
  String _gender = 'Male';
  bool _isSmoker = false;
  String? errorMessage = '';
  bool error = false;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _peakFlowController = TextEditingController();
  final TextEditingController _maxHRController = TextEditingController();

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
              onPressed: () async {
                await completeUserProfile();
                // Implement your edit profile functionality here
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> completeUserProfile() async {
    try {
      await FirebaseService().addUserDetails(
          firstname: _firstNameController.text,
          lastname: _lastNameController.text,
          dob: _dobController.text,
          gender: _gender,
          weight: _weightController.text,
          height: _heightController.text,
          bestpef: _peakFlowController.text,
          smoker: _isSmoker,
          maxHR: _maxHRController.text,
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => WidgetTree(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      print(e.message);
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Widget _error() {
    return Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
        child: Text(
          errorMessage!,
          style: GoogleFonts.outfit(
            textStyle: const TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 18,
              color: Colors.red,
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Text('Complete Profile'),
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
            SizedBox(height: 15.0),
            TextFormField(

              controller: _maxHRController,
              decoration: _inputDecoration(
                  'Max heart rate(optional)', 'bpm',
                  Icons.monitor_heart
              ),
            ),
            SizedBox(height: 24.0),
            _genderRadio(),
            SizedBox(height: 24.0),
            _smokerCheckbox(),
            SizedBox(height: 24.0),
            _error(),
            SizedBox(height: 24.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.deepPurple, shape: const StadiumBorder(),
                minimumSize: const Size(double.infinity, 50), // Set a larger height
              ),
              onPressed: () async {
                  final navigator = Navigator.of(context);
                  final buildContext = context;
                  _showSaveConfirmationDialog(context);
                  errorMessage == '' ? error = false : error = true;
                // Implement save logic
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  'Save Change',
                  style: TextStyle(fontSize: 20),
                ),
              ),
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

  Widget _smokerCheckbox(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Checkbox(
          value: _isSmoker,
          onChanged: (bool? newValue) {
            setState(() {
              _isSmoker = newValue ?? false;
            });
          },
        ),
        Text('Are you a smoker?'),
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