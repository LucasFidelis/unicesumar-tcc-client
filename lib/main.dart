import 'package:app/main/factories/criar_pedido_page_factory.dart';
import 'package:app/main/factories/navigation_rail_menu_factory.dart';
import 'package:app/main/factories/editar_pedido_page_factory.dart';
import 'package:app/main/factories/login_page_factory.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final routeObserver = Get.put<RouteObserver>(RouteObserver<PageRoute>());

    return GetMaterialApp(
      title: 'Gestor de pedidos',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      navigatorObservers: [routeObserver],
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: makeLoginPage),
        GetPage(name: '/dashboard', page: makeNavigationRailMenu),
        GetPage(name: '/pedido/novo', page: makeCriarPedidoPage),
        GetPage(name: '/pedido/editar/:id', page: makeEditarPedidoPage),
      ],
    );
  }
}
