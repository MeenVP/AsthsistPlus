// import 'package:asthsist_plus/backend/firebase.dart';
// import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:asthsist_plus/pages/home_page.dart';
// import 'package:mockito/mockito.dart';
// import 'package:provider/provider.dart';
//
//
// // import 'home_widget_test.mocks.dart';
//
// // Create a Mock class for your FirebaseService using mockito
// class MockFirebaseService extends Mock implements FirebaseService {}
//
// void main() {
//   late MockFirebaseService mockFirebaseService;
//   late MockFirebaseAuth mockFirebaseAuth;
//
//   setUpAll(() async {
//     TestWidgetsFlutterBinding.ensureInitialized();
//     await Firebase.initializeApp();
//   });
//
//   setUp(() {
//     mockFirebaseService = MockFirebaseService();
//     mockFirebaseAuth = MockFirebaseAuth();
//
//     // Create an instance of MockUser
//     MockUser mockUser = MockUser();
//
//     // Setup FirebaseAuth to return the MockUser upon auth state changes
//     when(mockFirebaseAuth.authStateChanges()).thenAnswer(
//           (_) => Stream.fromIterable([mockUser]),
//     );
//
//     // Mock other methods as needed
//   });
//
//   // Initialize the widget test environment.
//   testWidgets('HomePage UI Test', (WidgetTester tester) async {
//     // Build our app and trigger a frame.
//     await tester.pumpWidget(MaterialApp(home: HomePage()));
//
//     // Verify that certain UI elements are present.
//     // For instance, checking for the presence of specific text.
//     expect(find.text('Welcome Back'), findsOneWidget);
//     expect(find.byType(ElevatedButton), findsWidgets);
//   });
// }
