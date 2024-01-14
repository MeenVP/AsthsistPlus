import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../style.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
  const LoginPage({Key? key}) : super(key: key);
  static const String routeName = '/login';
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Style.primaryBackground,
        body: SafeArea(
            child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 160, 0, 0),
                  child: Column(mainAxisSize: MainAxisSize.max, children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Align(
                          alignment: const AlignmentDirectional(0, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Align(
                                alignment: const AlignmentDirectional(0, 1),
                                child: Text(
                                  'Asthsist',
                                  style: GoogleFonts.outfit(
                                    textStyle: const TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 48,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: const AlignmentDirectional(0, 1),
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 32),
                                  child: Text(
                                    '+',
                                    style: GoogleFonts.outfit(
                                      textStyle: const TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 48,
                                        color: Style.primaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(64, 32, 64, 0),
                        child: Column(children: [
                          TabBar(
                            controller: _tabController,
                            indicatorPadding: const EdgeInsets.all(0.0),
                            indicatorWeight: 4.0,
                            indicatorSize: TabBarIndicatorSize.tab,
                            indicator: const ShapeDecoration(
                                shape: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Style.tertiaryColor,
                                  width: 2,
                                  style: BorderStyle.solid),
                            )),
                            dividerColor: Colors.transparent,
                            labelColor: Style.tertiaryColor,
                            labelStyle: GoogleFonts.outfit(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 21,
                                color: Style.tertiaryColor,
                              ),
                            ),
                            unselectedLabelStyle: GoogleFonts.outfit(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 18,
                                color: Style.accent2,
                              ),
                            ),
                            tabs: const <Widget>[
                              Tab(
                                text: 'Login',
                              ),
                              Tab(
                                text: 'Register',
                              ),
                            ],
                          )
                        ])),
                    Flexible(
                      child: TabBarView(
                        controller: _tabController,
                        children: const <Widget>[
                          SingleChildScrollView(child: Login()), // Wrapped in SingleChildScrollView
                          SingleChildScrollView(child: Register()),
                        ],
                      ),
                    ),
                  ]
                )
            )
        )
    );
  }
}

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  bool passwordVisible = true;

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(20, 16, 20, 0),
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Email Address',
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
                    fillColor: Color(0xFFE1E3E9)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _passwordController,
                obscureText: passwordVisible,
                decoration: InputDecoration(
                  labelText: 'Password',
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
                  fillColor: Color(0xFFE1E3E9),
                  suffixIcon: IconButton(
                    icon: Icon(passwordVisible
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      setState(
                            () {
                          passwordVisible = !passwordVisible;
                        },
                      );
                    },
                  ),
                ),
                // obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Style.tertiaryText,
                    backgroundColor: Style.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    minimumSize: const Size(double.infinity, 60),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Process data.
                    }
                  },
                  child: Text(
                    'Login',
                    style: GoogleFonts.outfit(
                      textStyle: GoogleFonts.outfit(
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 18,
                          color: Style.secondaryBackground,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool passwordVisible = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(20, 16, 20, 0),
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                  labelText: 'Email Address',
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
                  fillColor: Color(0xFFE1E3E9)),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _passwordController,
              obscureText: passwordVisible,
              decoration: InputDecoration(
                labelText: 'Password',
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
                fillColor: Color(0xFFE1E3E9),
                suffixIcon: IconButton(
                  icon: Icon(passwordVisible
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: () {
                    setState(
                          () {
                        passwordVisible = !passwordVisible;
                      },
                    );
                  },
                ),
              ),
              // obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                if (value.length < 8) {
                  return 'Password must be at least 8 characters long';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: passwordVisible,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
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
                fillColor: Color(0xFFE1E3E9),
                suffixIcon: IconButton(
                  icon: Icon(passwordVisible
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: () {
                    setState(
                          () {
                        passwordVisible = !passwordVisible;
                      },
                    );
                  },
                ),
              ),
              // obscureText: true,
              validator: (value) {
                if (value != _passwordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Style.tertiaryText,
                  backgroundColor: Style.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  minimumSize: const Size(double.infinity, 60),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Process data.
                  }
                },
                child: Text(
                  'Register',
                  style: GoogleFonts.outfit(
                    textStyle: GoogleFonts.outfit(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 18,
                        color: Style.secondaryBackground,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}


/*@override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
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
                  _gender = value ?? _gender;
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
                  _gender = value ?? _gender;
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
}*/
