import 'package:asthsist_plus/pages/act_info.dart';
import 'package:asthsist_plus/pages/chart_page.dart';
import 'package:asthsist_plus/pages/pef_info.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'bar_page.dart';
import '../style.dart';

class HealthInfoPage extends StatefulWidget {
  const HealthInfoPage({super.key});

  @override
  State<HealthInfoPage> createState() => _CalendarState();
}

class _CalendarState extends State<HealthInfoPage>
    with TickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _initTabController();
  }

  _initTabController() async {
    await Future.delayed(Duration.zero);
    setState(() {
      _tabController = TabController(length: 6, vsync: this);
    });
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: DefaultTabController(
            // Added
            length: 6, // Added
            initialIndex: 0, //Added
            child: Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  surfaceTintColor: Colors.transparent,
                  title: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                      child: Text(
                        'Health Info',
                        style: GoogleFonts.outfit(
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 32,
                            color: Colors.black,
                          ),
                        ),
                      )),
                  backgroundColor: Style.primaryBackground,
                ),
                backgroundColor: Style.primaryBackground,
                body: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
                    child: Column(children: [
                      Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                10, 0, 10, 0),
                            child: Material(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                elevation: 1,
                                child: Container(
                                    height: kToolbarHeight - 10.0,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE1E3E9),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: TabBar(
                                      controller: _tabController,
                                      indicatorSize: TabBarIndicatorSize.tab,
                                      indicator: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          color: Style.secondaryBackground),
                                      dividerColor: Colors.transparent,
                                      labelColor: Style.accent4,
                                      labelPadding: const EdgeInsets.only(),
                                      unselectedLabelColor: Style.accent2,
                                      tabs: const <Widget>[
                                        Tab(
                                          icon: Icon(
                                            Icons.favorite_border_outlined,
                                            color: Style.heartrate,
                                          ),
                                        ),
                                        Tab(
                                          icon: Icon(Icons.medication_outlined,
                                              color: Style.medication),
                                        ),
                                        Tab(
                                          icon: Icon(
                                              Icons.health_and_safety_outlined,
                                              color: Style.pef),
                                        ),
                                        Tab(
                                          icon: Icon(
                                              Icons.heart_broken_outlined,
                                              color: Style.primaryColor),
                                        ),
                                        Tab(
                                          icon: Icon(Icons.inventory_outlined,
                                              color: Style.act),
                                        ),
                                        Tab(
                                          icon: Icon(
                                              Icons.directions_walk_outlined,
                                              color: Style.warning),
                                        ),
                                      ],
                                    ))),
                          )),
                      Flexible(
                        child: TabBarView(
                          controller: _tabController,
                          children: const <Widget>[
                            NestedTabBar('Heart rates'),
                            BarPage(category: 'Medications'),
                            PeakFlowInfoPage(showBackButton: false),
                            BarPage(category: 'Attacks'),
                            ControlTestInfoPage(showBackButton: false),
                            BarPage(category: 'Steps'),
                          ],
                        ),
                      ),
                    ])))));
  }
}

class NestedTabBar extends StatefulWidget {
  const NestedTabBar(this.outerTab, {super.key});

  final String outerTab;

  @override
  State<NestedTabBar> createState() => _NestedTabBarState();
}

class _NestedTabBarState extends State<NestedTabBar>
    with TickerProviderStateMixin {
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

  // This function will return the appropriate chart based on the outer tab
  tabHandler(String outerTab) {
    switch (outerTab) {
      case 'Heart rates':
        return [
          const HeartRateChart(fetchType: 'day'),
          const HeartRateChart(fetchType: 'week'),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                    child: Text(
                      widget.outerTab,
                      style: GoogleFonts.outfit(
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 24,
                          color: Style.primaryText,
                        ),
                      ),
                    ),
                  ),
                  Material(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      elevation: 1,
                      child: Container(
                          height: kToolbarHeight - 8.0,
                          decoration: BoxDecoration(
                            color: Style.secondaryBackground,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: TabBar.secondary(
                            controller: _tabController,
                            indicatorSize: TabBarIndicatorSize.tab,
                            indicator: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Style.primaryColor),
                            dividerColor: Colors.transparent,
                            overlayColor:
                                MaterialStateProperty.all(Colors.transparent),
                            labelColor: Style.accent4,
                            labelPadding: const EdgeInsets.only(),
                            unselectedLabelColor: Style.accent2,
                            tabs: const <Widget>[
                              Tab(text: 'D'),
                              Tab(text: 'W'),
                            ],
                          ))),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                  controller: _tabController,
                  children: tabHandler(widget.outerTab)),
            ),
          ],
        ));
  }
}
