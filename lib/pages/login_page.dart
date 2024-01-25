import 'package:asthsist_plus/pages/navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../backend/firebase.dart';
import '../style.dart';
import 'complete_profile_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
  const LoginPage({Key? key}) : super(key: key);
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
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool passwordVisible = true;
  String? errorMessage = '';

  Future<void> signInWithEmailAndPassword() async {
    try {
      await FirebaseService().signInWithEmailAndPassword(
          _emailController.text, _passwordController.text);
    } on FirebaseAuthException catch (e) {
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
                  onPressed: () {
                    signInWithEmailAndPassword();
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
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Style.tertiaryText,
                    backgroundColor: Style.secondaryBackground,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    minimumSize: const Size(double.infinity, 60),
                  ),
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.g_mobiledata, color: Style.primaryText),
                      Text(
                        'Sign in with Google',
                        style: GoogleFonts.outfit(
                          textStyle: GoogleFonts.outfit(
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 18,
                              color: Style.primaryText,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
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
}

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

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

  Future<void> createUserWithEmailAndPassword() async {
    try {
      await FirebaseService().createUserWithEmailAndPassword(
          _emailController.text, _passwordController.text);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => CompleteProfilePage(),
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
                    final navigator = Navigator.of(context);
                    final buildContext = context;
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
