// import 'package:asthsist_plus/firebase_options.dart';
// import 'package:asthsist_plus/pages/home_page.dart';
// import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart';
// import 'package:asthsist_plus/pages/login_page.dart';
// import 'package:asthsist_plus/backend/firebase.dart';
//
// class MockFirebaseService extends Mock implements FirebaseService {}
//
// //
// void main(){
//
//   group('Login Page Tests', () {
//     testWidgets('Login success scenario', (WidgetTester tester) async {
//       // Mock a user
//       final mockUser = MockUser(
//         isAnonymous: false,
//         email: 'test@example.com',
//         // Adjusted parameter based on firebase_auth_mocks documentation or version
//       );
//
//       // Create a mock Firebase Auth instance
//       final mockFirebaseAuth = MockFirebaseAuth(mockUser: mockUser);
//
//       // Build our app and trigger a frame with LoginPage
//       await tester.pumpWidget(MaterialApp(
//         home: LoginPage(), // Make sure LoginPage is set to use the mockFirebaseAuth
//       ));
//
//       // Enter valid email and password
//       await tester.enterText(find.byKey(Key('emailAddress')), 'test@example.com');
//       await tester.enterText(find.byKey(Key('password')), 'password');
//
//       // Tap the sign in button
//       await tester.tap(find.byKey(Key('signIn')));
//       await tester.pumpAndSettle(); // Wait for potential navigation and animations
//
//       // Assertion: Check if HomePage is now being displayed
//       expect(find.byType(HomePage), findsOneWidget);
//
//       // Add more assertions as needed based on your app's flow and expected outcomes
//     });
//   });
//   // group('test test', (){
//   //
//   //   late MockFirebaseService mockFirebaseService;
//   //
//   //   setUp(() {
//   //     mockFirebaseService = MockFirebaseService();
//   //     // Setup mock methods and responses
//   //     when(mockFirebaseService.getUserName()).thenAnswer((_) async => 'Tony');
//   //   });
//   //
//   //   test('Login failure displays error message', () async {
//   //     await FirebaseService().signInWithEmailAndPassword('user6@gmail.com','User1234');
//   //
//   //     String userName = await FirebaseService().getUserName();
//   //     expect(userName, 'Tony');
//   //   });
//   // });
//
//   // group('Login Page Tests', () {
//   //
//   //   final MockFirebaseService mockFirebaseService = MockFirebaseService();
//   //
//   //
//   //   testWidgets('Login failure displays error message', (WidgetTester tester) async {
//   //     // await Firebase.initializeApp(
//   //     //   options: DefaultFirebaseOptions.currentPlatform,
//   //     // );
//   //     // await FirebaseService().signInWithEmailAndPassword('user6@gmail.com','User1234').then((value){});
//   //
//   //     // when(mockFirebaseAuth.signInWithEmailAndPassword(email: 'user6@gmail.com',password: 'User1234'))
//   //     //     .thenAnswer((realInvocation) => throw FirebaseAuthException(message: 'Wrong email or password', code: ''));
//   //     // Ensure the LoginPage is using the MockFirebaseService
//   //     // You might need to adjust how the service is provided to the LoginPage based on your state management solution
//   //
//   //     // Pump the LoginPage widget into the widget tree
//   //     await tester.pumpWidget(MaterialApp(home: Scaffold(body: Login())));
//   //
//   //     // // Enter an email and password that will result in a login failure
//   //     final Finder emailField = find.byKey(const Key('loginEmail'));
//   //     await tester.enterText(emailField, 'loginEmail');
//   //     //
//   //     final Finder passwordField = find.byKey(const Key('loginPassword'));
//   //     await tester.enterText(passwordField, 'loginPassword');
//   //     //
//   //     // // Tap the sign-in button
//   //     await tester.tap(find.byKey(const Key('signIn')));
//   //     await tester.pumpAndSettle(); // Wait for all animations and futures to complete
//   //
//   //     // Check for the error message
//   //     // // verify(mockFirebaseService.signInWithEmailAndPassword('loginEmail', 'loginPassword')).called(1);
//   //     // expect({
//   //     //   await FirebaseService().getUserName()
//   //     // },'Tony');
//   //     expect(mockFirebaseService.signInWithEmailAndPassword('email', 'password'), 'Wrong email or password');
//   //   });
//   // });
//
//   // group('Firebase Authentication Tests', () {
//   //   late FirebaseService service;
//   //   late MockFirebaseAuth mockFirebaseAuth;
//   //
//   //   testWidgets('Sign-in failure shows error message', (WidgetTester tester) async {
//   //     // Build the LoginPage widget
//   //     await tester.pumpWidget(MaterialApp(home: LoginPage()));
//   //
//   //     // Enter an email and password
//   //     await tester.enterText(find.widgetWithText(TextFormField, 'Email Address'), 'test@failure.com');
//   //     await tester.enterText(find.widgetWithText(TextFormField, 'Password'), 'wrongPassword');
//   //
//   //     // Tap the sign-in button
//   //     await tester.tap(find.widgetWithText(ElevatedButton, 'Sign in'));
//   //     await tester.pump(); // Trigger a frame
//   //
//   //     // Assuming the errorMessage is set and displayed upon failure,
//   //     // we check for the error message widget's presence in the UI.
//   //     expect(find.text('Wrong email or password'), findsOneWidget);
//   //   });
//   // });
//
//   //overall in LoginPage.dart
//   group('LoginPage Widget Tests', () {
//     testWidgets('Tab switch updates UI', (WidgetTester tester) async {
//       // Create the widget by pumping LoginPage into the tester
//       await tester.pumpWidget(MaterialApp(home: LoginPage()));
//
//       // Initial state should show the "Sign in" tab
//       expect(find.text('Sign in'), findsWidgets);
//       expect(find.text('Register'), findsOneWidget);
//
//       // Verify that the "Sign in" content is displayed
//       expect(find.byType(Login), findsOneWidget);
//
//       // Tap on the "Register" tab to switch tabs
//       await tester.tap(find.text('Register'));
//       await tester.pumpAndSettle(); // Wait for animations to settle
//
//       // Verify that the "Register" content is displayed
//       expect(find.byType(Register), findsOneWidget);
//     });
//   });
//
//   group('Sign in Widget Tests', () {
//
//     testWidgets('Empty email and password shows error message', (WidgetTester tester) async {
//       await tester.pumpWidget(MaterialApp(home: Scaffold(body: Login())));
//
//       // Find the sign-in button and tap it
//       final signInButton = find.byKey(Key("signIn"));
//       await tester.tap(signInButton);
//
//       // Rebuild the widget with the new state
//       await tester.pump();
//
//       // Check for error messages
//       expect(find.text('Please enter your email'), findsOneWidget);
//       expect(find.text('Please enter your password'), findsOneWidget);
//     });
//
//     testWidgets('checks if login form fields and button are present', (WidgetTester tester) async {
//       await tester.pumpWidget(MaterialApp(home: Scaffold(body: Login())));
//
//       // Check for the presence of email and password fields and the login button
//       expect(find.widgetWithText(TextFormField, 'Email Address'), findsOneWidget);
//       expect(find.widgetWithText(TextFormField, 'Password'), findsOneWidget);
//       expect(find.widgetWithText(ElevatedButton, 'Sign in'), findsOneWidget);
//     });
//   });
//
//   group('Register Widget Tests', () {
//     // Test to check if the Register widget shows the necessary form fields and button
//     testWidgets('checks if register form fields and button are present', (WidgetTester tester) async {
//       await tester.pumpWidget(MaterialApp(home: Scaffold(body: Register())));
//
//       // Verify the presence of email, password, and confirm password fields, and the register button
//       expect(find.widgetWithText(TextFormField, 'Email Address'), findsOneWidget);
//       expect(find.widgetWithText(TextFormField, 'Password'), findsOneWidget);
//       expect(find.widgetWithText(TextFormField, 'Confirm Password'), findsOneWidget);
//       expect(find.widgetWithText(ElevatedButton, 'Register'), findsOneWidget);
//     });
//
//     testWidgets('Displays error message for empty email and password fields in Registration', (WidgetTester tester) async {
//       await tester.pumpWidget(MaterialApp(home: Scaffold(body: Register())));
//
//       // Find the sign-in button and tap it
//       final registerButton = find.widgetWithText(ElevatedButton, 'Register');
//       await tester.tap(registerButton);
//
//       // Rebuild the widget with the new state
//       await tester.pump();
//
//       // Check for error messages
//       expect(find.text('Please enter your email'), findsOneWidget);
//       expect(find.text('Please enter your password'), findsOneWidget);
//     });
//
//     testWidgets('Password must be at least 8 characters long validation', (WidgetTester tester) async {
//       // Pump the Register widget into the widget tester
//       await tester.pumpWidget(MaterialApp(home: Scaffold(body: Register())));
//
//       // Find the password TextFormField
//       final Finder passwordField = find.widgetWithText(TextFormField, 'Password');
//
//       // Enter a short password into the password field
//       await tester.enterText(passwordField, '1234567');
//
//       // Attempt to submit the form by tapping the register button
//       // Assuming the register button is an ElevatedButton with the text 'Register'
//       await tester.tap(find.widgetWithText(ElevatedButton, 'Register'));
//
//       // Rebuild the widget to reflect changes and show validation messages
//       await tester.pump();
//
//       // Verify that the validation message is displayed
//       expect(find.text('Password must be at least 8 characters long'), findsOneWidget);
//     });
//
//     testWidgets('Mismatched passwords show error', (WidgetTester tester) async {
//       await tester.pumpWidget(MaterialApp(home: Scaffold(body: Register())));
//
//       final Finder confirm_password = find.widgetWithText(TextFormField, 'Confirm Password');
//       final Finder password = find.widgetWithText(TextFormField, 'Password');
//
//       // Enter mismatching password and confirm password
//       await tester.enterText(password, 'password123');
//       await tester.enterText(confirm_password, 'password432');
//
//       // Attempt to register
//       await tester.tap(find.widgetWithText(ElevatedButton, 'Register'));
//       await tester.pump(); // Rebuild the widget with the validation error
//
//       // Check for error message
//       expect(find.text('Passwords do not match'), findsOneWidget);
//     });
//   });
// }
//
//
//
