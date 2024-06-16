import 'package:app/application/token_manager.dart';
import 'package:app/main/factories/canais_venda_page_factory.dart';
import 'package:app/main/factories/navigation_rail_menu_factory.dart';
import 'package:app/main/factories/pedidos_page_factory.dart';
import 'package:app/main/factories/separadores_page_factory.dart';
import 'package:app/main/factories/usuarios_page_factory.dart';
import 'package:app/pages/add_canais_venda.dart';
import 'package:app/pages/canais_venda.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavigationRailMenu extends StatefulWidget {
  NavigationRailMenu({super.key});

  @override
  _NavigationRailMenu createState() => _NavigationRailMenu();
}

class _NavigationRailMenu extends State<NavigationRailMenu> {
  String currentRole = 'separador';
  int _selectedIndex = 0;
  final tokenManager = TokenManager();

  @override
  void initState() {
    super.initState();
    getRole();
  }

  Future<void> getRole() async {
    final role = await tokenManager.getRole() ?? 'separador';
    setState(() {
      currentRole = role;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.all,
            destinations: [
              const NavigationRailDestination(
                icon: Icon(Icons.assessment_outlined),
                selectedIcon: Icon(Icons.assessment),
                label: Text('Dashboard'),
              ),
              NavigationRailDestination(
                disabled: currentRole == 'separador' ? true : false,
                icon: Icon(Icons.view_in_ar_outlined),
                selectedIcon: Icon(Icons.view_in_ar),
                label: Text('Pedidos'),
              ),
              NavigationRailDestination(
                disabled: currentRole == 'separador' ? true : false,
                icon: Icon(Icons.label_outline),
                selectedIcon: Icon(Icons.label),
                label: Text('Canais'),
              ),
              NavigationRailDestination(
                disabled: currentRole == 'separador' ? true : false,
                icon: Icon(Icons.groups_outlined),
                selectedIcon: Icon(Icons.groups),
                label: Text('Separadores'),
              ),
              NavigationRailDestination(
                disabled: currentRole == 'separador' ? true : false,
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person),
                label: Text('Usuários'),
              ),
            ],
            trailing: Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: IconButton(
                    icon: const Icon(Icons.logout_outlined),
                    onPressed: () {
                      Get.offAllNamed('/');
                    },
                  ),
                ),
              ),
            ),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          ContentSpace(_selectedIndex),
        ],
      ),
    );
  }
}

class ContentSpace extends StatelessWidget {
  final int _selectedIndex;

  ContentSpace(this._selectedIndex);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
        child: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: _getPage(_selectedIndex),
        ),
      ),
    );
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return makeDashboardPage();
      case 1:
        return makePedidosPage();
      case 2:
        return makePageCanaisVenda();
      case 3:
        return makeSeparadoresPage();
      case 4:
        return makeUsuariosPage();
      default:
        return makePageCanaisVenda();
    }
  }
}
