import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _showLogin = true; // Toggle between login and register

  void _toggleForm() {
    setState(() {
      _showLogin = !_showLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Asthsist+',
                style: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      if (!_showLogin) _toggleForm();
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 18,
                        color: _showLogin ? Colors.tealAccent[400] : Colors.deepPurple,
                        fontWeight: _showLogin ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      if (_showLogin) _toggleForm();
                    },
                    child: Text(
                      'Register',
                      style: TextStyle(
                        fontSize: 18,
                        color: _showLogin ? Colors.deepPurple : Colors.tealAccent[400],
                        fontWeight: !_showLogin ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
              if (_showLogin) ...[
                _buildLogin(),
              ] else ...[
                _buildRegister(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogin() {
    return Column(
      children: <Widget>[
        SizedBox(height: 40),
        TextFormField(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide.none,
            ),
            labelText: 'Email Address',
            hintText: 'Enter your email...',
            floatingLabelStyle: const TextStyle(
              height: 4,
              color: Colors.grey,
            ),
            filled: true,
            fillColor: Colors.grey[200],
            prefixIcon: const Icon(Icons.person),
          ),
        ),
        SizedBox(height: 15.0),
        TextFormField(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide.none,
            ),
            labelText: 'Password',
            hintText: 'Enter your password...',
            floatingLabelStyle: const TextStyle(
              height: 4,
              color: Colors.grey,
            ),
            filled: true,
            fillColor: Colors.grey[200],
            prefixIcon: const Icon(Icons.lock),
          ),
        ),
        SizedBox(height: 24.0),
        ElevatedButton(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              'Login',
              style: TextStyle(fontSize: 15),
            ),
          ),
          style: ElevatedButton.styleFrom(
            shape: StadiumBorder(),
            primary: Colors.deepPurple,
            onPrimary: Colors.white,
            minimumSize: Size(double.infinity, 26), // <-- match parent width and fixed height
          ),
          onPressed: () {
            // Implement login logic
          },
        ),
        TextButton(
            child: Text(
              'Forgot Password',
          ),
          onPressed: () {
            // Implement login logic
          },
        ),
        SizedBox(height: 16.0),
        Divider(),
        SizedBox(height: 16.0),
//               // ElevatedButton.icon(
//               //   // icon: Image.asset('assets/google_logo.png', height: 18.0),
//               //   label: Text('Sign in with Google'),
//               //   onPressed: () {
//               //     // Implement Google sign-in logic
//               //   },
//               //   style: ElevatedButton.styleFrom(
//               //     primary: Colors.white, // Background color
//               //     onPrimary: Colors.black, // Text Color
//               //   ),
//               // ),
//               // SizedBox(height: 8.0),
//               // ElevatedButton.icon(
//               //   icon: Icon(Icons.apple, size: 18.0),
//               //   label: Text('Sign in with Apple'),
//               //   onPressed: () {
//               //     // Implement Apple sign-in logic
//               //   },
//               //   style: ElevatedButton.styleFrom(
//               //     primary: Colors.black, // Background color
//               //     onPrimary: Colors.white, // Text Color
//               //   ),
//               // ),
      ],
    );
  }

  Widget _buildRegister() {
    String _gender = 'Male';
    return Column(
      children: <Widget>[
        SizedBox(height: 40),
        TextFormField(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide.none,
            ),
            labelText: 'Firstname',
            hintText: 'Please enter a valid name',
            floatingLabelStyle: const TextStyle(
              height: 4,
              color: Colors.grey,
            ),
            filled: true,
            fillColor: Colors.grey[200],
            prefixIcon: const Icon(Icons.person),
          ),
        ),
        SizedBox(height: 15.0),
        TextFormField(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide.none,
            ),
            labelText: 'Lastname',
            hintText: 'Please enter a valid name',
            floatingLabelStyle: const TextStyle(
              height: 4,
              color: Colors.grey,
            ),
            filled: true,
            fillColor: Colors.grey[200],
            prefixIcon: const Icon(Icons.person_outline),
          ),
        ),
        SizedBox(height: 15.0),
        TextFormField(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide.none,
            ),
            labelText: 'Date of Birth',
            hintText: 'Please select a valid date',
            floatingLabelStyle: const TextStyle(
              height: 4,
              color: Colors.grey,
            ),
            filled: true,
            fillColor: Colors.grey[200],
            prefixIcon: const Icon(Icons.calendar_today),
          ),
        ),
        SizedBox(height: 15.0),
        Row(
          children: <Widget>[
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide.none,
                  ),
                  labelText: 'Weight',
                  hintText: 'Weight in kg',
                  floatingLabelStyle: const TextStyle(
                    height: 4,
                    color: Colors.grey,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
            ),
            SizedBox(width: 15.0),
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide.none,
                  ),
                  labelText: 'Height',
                  hintText: 'Height in cm',
                  floatingLabelStyle: const TextStyle(
                    height: 4,
                    color: Colors.grey,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 15.0),
        TextFormField(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide.none,
            ),
            labelText: 'Personal best Peak Flow',
            hintText: 'Please enter a valid number',
            floatingLabelStyle: const TextStyle(
              height: 4,
              color: Colors.grey,
            ),
            filled: true,
            fillColor: Colors.grey[200],
            prefixIcon: const Icon(Icons.fitness_center),
            suffixIcon: const Icon(Icons.help_outline),
          ),
        ),
        SizedBox(height: 24.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Radio(
              value: 'Male',
              groupValue: 'Gender',
              onChanged: (String? value) {
                setState(() {
                  _gender = value ?? _gender;;
                });
                // Handle radio value changed
              },
            ),
            Text('Male'),
            Radio(
              value: 'Female',
              groupValue: 'Gender',
              onChanged: (String? value) {
                setState(() {
                  _gender = value ?? _gender;;
                });
                // Handle radio value changed
              },
            ),
            Text('Female'),
          ],
        ),
        SizedBox(height: 24.0),
        ElevatedButton(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              'Complete Profile',
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
            // Implement register logic
          },
        ),
      ],
    );
  }
}
