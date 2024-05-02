import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../style.dart';
import '../../widget_tree.dart';
import 'calendar_page.dart';

class HomePageTutorial extends StatelessWidget {
  const HomePageTutorial({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Style.secondaryBackground,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          // This is the height of AppBar.
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            // Change this value to adjust the padding
            child: AppBar(
              surfaceTintColor: Colors.transparent,
              automaticallyImplyLeading: false,
              backgroundColor: Style.secondaryBackground,
              title: Text(
                'Home Page',
                style: GoogleFonts.outfit(
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 32,
                    color: Colors.black,
                  ),
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const WidgetTree(),
                      ),
                    );
                  },
                ),
              ],
              flexibleSpace: Container(
                height: 20.0,
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 00),
            child: Column(children: [
              const Image(image: AssetImage('assets/images/Homepage.png')),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Material(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(16)),
                          elevation: 2,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: Style.accent3,
                              foregroundColor: Style.tertiaryText,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 20.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => const WidgetTree(),
                                ),
                              );
                            },
                            child: Text(
                              'Close',
                              style: GoogleFonts.outfit(
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                  color: Style.accent2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Material(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(16)),
                          elevation: 2,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: Style.primaryColor,
                              // foregroundColor: Style.primaryColor,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 20.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const CalendarPageTutorial()),
                              );
                            },
                            child: Text(
                              'Next',
                              style: GoogleFonts.outfit(
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                  color: Style.tertiaryText,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ));
  }
}
