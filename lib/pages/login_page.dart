import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../backend/firebase.dart';
import '../backend/health.dart';
import '../style.dart';
import 'Tutorials/home_page.dart';
import 'complete_profile_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
  const LoginPage({super.key});
  // static const String routeName = '/login';
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
    EdgeInsetsDirectional detectKeyboard() {
      if (MediaQuery.of(context).viewInsets.bottom != 0.0) {
        // Keyboard is visible.
        return const EdgeInsetsDirectional.fromSTEB(0, 40, 0, 0);
      } else {
        // Keyboard is not visible.
        return const EdgeInsetsDirectional.fromSTEB(0, 160, 0, 0);
      }
    }

    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Style.primaryBackground,
        body: SafeArea(
            child: Padding(
                padding: detectKeyboard(),
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
                              text: 'Sign in',
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
                        SingleChildScrollView(
                            child: Login()), // Wrapped in SingleChildScrollView
                        SingleChildScrollView(child: Register()),
                      ],
                    ),
                  ),
                ]))));
  }
}

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool passwordVisible = true;
  String? errorMessage = '';

  // Function to show a loading dialog
  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // User must not close the dialog manually
      builder: (BuildContext context) {
        return const Dialog(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text("Signing in..."),
              ],
            ),
          ),
        );
      },
    );
  }

  // Function to sign in with email and password
  Future<void> signInWithEmailAndPassword() async {
    try {
      // Show loading dialog
      showLoadingDialog(context);
      await FirebaseService().signInWithEmailAndPassword(
          _emailController.text, _passwordController.text);
      // If sign-in is successful, navigator.pop can be called to dismiss the dialog.
      Navigator.pop(context);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomePageTutorial(),
        ),
      );
    } on FirebaseAuthException {
      // Dismiss the loading dialog if sign-in fails
      Navigator.pop(context);
      setState(() {
        errorMessage = 'Wrong email or password';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(20, 16, 20, 0),
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _emailController,
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
                    fillColor: const Color(0xFFE1E3E9)),
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
                  fillColor: const Color(0xFFE1E3E9),
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
              _error(),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
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
                      signInWithEmailAndPassword(); // This already handles showing and hiding the dialog
                    }
                  },
                  child: Text(
                    'Sign in',
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
              ),
            ],
          ),
        ));
  }

  // Function to display error message
  Widget _error() {
    return Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 8),
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
}

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool passwordVisible = true;
  String? errorMessage = '';
  bool error = false;

  // Function to show a loading dialog
  void showRegisterLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // User must not close the dialog manually
      builder: (BuildContext context) {
        return const Dialog(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text("Signing up..."),
              ],
            ),
          ),
        );
      },
    );
  }

  // Function to create a user with email and password
  Future<void> createUserWithEmailAndPassword() async {
    try {
      showRegisterLoadingDialog(context);
      await FirebaseService().createUserWithEmailAndPassword(
          _emailController.text, _passwordController.text);
      Navigator.pop(context); // Dismiss the loading dialog
      // Navigate to CompleteProfilePage
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const CompleteProfilePage(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      // Dismiss the loading dialog if registration fails
      Navigator.pop(context);
      print(e.message);
      setState(() {
        errorMessage = e.message;
      });
    }
  }

// Function to display error message
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
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(20, 16, 20, 0),
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _emailController,
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
                  fillColor: const Color(0xFFE1E3E9)),
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
                fillColor: const Color(0xFFE1E3E9),
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
                fillColor: const Color(0xFFE1E3E9),
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
            _error(),
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
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await createUserWithEmailAndPassword();
                    errorMessage == '' ? error = false : error = true;
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
