import 'package:bitirme_proje/screens/home_page.dart';
import 'package:bitirme_proje/screens/my_library_page.dart';
import 'package:bitirme_proje/screens/my_profil_page.dart';
import 'package:flutter/material.dart';

import 'tab_item.dart';

class TabNavigatorRoutes {
  static const String home = '/HomePage';
  static const String library = '/MyLibraryPage';
  static const String profil = '/MyProfilPage';
}

class TabNavigator extends StatelessWidget {
  TabNavigator({required this.navigatorKey, required this.tabItem});
  GlobalKey<NavigatorState>? navigatorKey = GlobalKey<NavigatorState>();
  final TabItem tabItem;

  Map<String, WidgetBuilder> _routeBuilders(
    BuildContext context,
  ) {
    return {
      TabNavigatorRoutes.home: (context) => HomePage(),
      TabNavigatorRoutes.library: (context) => MyLibraryPage(),
      TabNavigatorRoutes.profil: (context) => MyProfilPage()
    };
  }

  @override
  Widget build(BuildContext context) {
    final routeBuilders = _routeBuilders(context);
    return Navigator(
      key: navigatorKey,
      initialRoute: TabNavigatorRoutes.home,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
          builder: (context) => routeBuilders[routeSettings.name!]!(context),
        );
      },
    );
  }
}
