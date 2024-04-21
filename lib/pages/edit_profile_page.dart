import 'package:asthsist_plus/pages/home_page.dart';
import 'package:asthsist_plus/pages/navigation_bar.dart';
import 'package:asthsist_plus/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../backend/firebase.dart';
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

  final String showDate;

  DOBInputField({
    Key? key,
    required this.dobController,
    required this.label,
    required this.showDate,
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
        fillColor: Style.accent4,
      ),
      readOnly: true, // Prevent manual editing
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.parse(showDate),
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



class _EditProfilePageState extends State<EditProfilePage> {


  String _gender = 'Male';
  bool _isSmoker = false;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _peakFlowController = TextEditingController();
  final TextEditingController _maxHRController = TextEditingController();

  Future<Map<String, dynamic>> getUserDetails() async {
    final userDetails = await FirebaseService().getUserDetails();
    return userDetails;
  }


@override
  void initState() {
    super.initState();
    getUserDetails().then((userData) {
      _firstNameController.text = userData['firstname'];
      _lastNameController.text = userData['lastname'];
      _dobController.text = userData['dob'];
      _weightController.text = userData['weight'];
      _heightController.text = userData['height'];
      _peakFlowController.text = userData['bestpef'];
      _maxHRController.text = userData['maxHR'];
      print(userData['dob']);
      setState(() {
        _gender = userData['gender'];
        _isSmoker = userData['smoker'];// Set _gender to the user's current gender
      });
    });
  }
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
              showDate: _dobController.text,
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
              decoration: _inputDecoration(
                'Personal best Peak Flow', 'Please enter a valid number',
                Icons.fitness_center
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
            ElevatedButton(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  'Save Change',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.deepPurple, shape: StadiumBorder(),
                minimumSize: Size(double.infinity, 50), // Set a larger height
              ),
              onPressed: () {
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
                            FirebaseService().updateUserDetails(
                              firstname: _firstNameController.text,
                              lastname: _lastNameController.text,
                              dob: _dobController.text,
                              gender: _gender,  // Assuming the gender is not changed
                              weight: _weightController.text,
                              height: _heightController.text,
                              bestpef: _peakFlowController.text,
                              smoker: _isSmoker,
                              maxHR: _maxHRController.text,

                            );
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text("Profile updated successfully!"),
                            ));
                            Navigator.pop(context);
                            Navigator.pop(context);
                            // Implement your edit profile functionality here
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, String hint, IconData? icon) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: GoogleFonts.outfit(
        textStyle: const TextStyle(
          fontWeight: FontWeight.normal,
          color: Style.accent2,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: Colors.transparent),
      ),
      filled: true,
      fillColor: Style.accent4,
      prefixIcon: icon != null ? Icon(icon) : null,
    );
  }

  InputDecoration _inputDecorationWithSuffix(String label, String hint, IconData? prefixIcon, IconData suffixIcon) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: GoogleFonts.outfit(
        textStyle: const TextStyle(
          fontWeight: FontWeight.normal,
          color: Style.accent2,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: Colors.transparent),
      ),
      filled: true,
      fillColor: Style.accent4,
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