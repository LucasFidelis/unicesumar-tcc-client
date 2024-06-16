import 'package:app/application/controllers/login_controller.dart';
import 'package:app/main/factories/http_client_factory.dart';
import 'package:app/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:app/main/config.dart' as Config;

LoginController makeLoginController() => LoginController(
      httpClient: makeHttpClient(),
      baseUrl: Config.baseUrl,
    );

Widget makeLoginPage() => LoginPage(loginController: makeLoginController());
