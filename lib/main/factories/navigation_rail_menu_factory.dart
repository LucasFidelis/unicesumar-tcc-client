import 'package:app/application/controllers/dashboard_controller.dart';
import 'package:app/main/factories/http_client_factory.dart';
import 'package:app/pages/navigation_rail_menu.dart';
import 'package:app/pages/dashboard/dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:app/main/config.dart' as Config;

Widget makeNavigationRailMenu() => NavigationRailMenu();

DashboardController makeDashboardController() => DashboardController(
      httpClient: makeHttpClient(),
      baseUrl: Config.baseUrl,
    );
Widget makeDashboardPage() => DashboardPage(controller: makeDashboardController());
