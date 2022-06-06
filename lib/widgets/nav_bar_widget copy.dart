import 'package:bitirme_proje/screens/categories_page.dart';
import 'package:bitirme_proje/screens/contact_us_page.dart';
import 'package:bitirme_proje/screens/home_page.dart';
import 'package:bitirme_proje/screens/my_library_page.dart';
import 'package:bitirme_proje/screens/my_profil_page.dart';
import 'package:bitirme_proje/screens/users.page.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import '../providers/firebase_auth_providers.dart';
import '../screens/add_book_page.dart';
import '../screens/books_detail.page.dart';
import '../screens/edit_book_page.dart';
import '../screens/login_page.dart';
import '../screens/search_page.dart';
import '../screens/sign_up_page.dart';
import '../screens/users_rating_all_books_page.dart';

class NavBarWidgetcopy extends ConsumerStatefulWidget {
  String? bookID;
  NavBarWidgetcopy({Key? key, this.bookID}) : super(key: key);

  @override
  _NavBarWidgetState createState() => _NavBarWidgetState();
}

class _NavBarWidgetState extends ConsumerState<NavBarWidgetcopy> {
  late List<Widget> screensWithLogin = [];
  late List<Widget> screensWithLogout = [];
  late HomePage homePage;
  late MyLibraryPage myLibraryPage;
  late LoginPage loginPage;
  late UsersPage usersPage;
  late MyProfilPage myProfilPage;
  late CategoriesPage categoriesPage;
  int currentIndex = 0;

  final PersistentTabController _controller = PersistentTabController();

  @override
  void initState() {
    super.initState();
    homePage = HomePage();
    myLibraryPage = MyLibraryPage();
    myProfilPage = MyProfilPage();
    loginPage = LoginPage();
    usersPage = UsersPage();
    categoriesPage = CategoriesPage(bookID: widget.bookID);
    screensWithLogin = [homePage, myLibraryPage, categoriesPage, usersPage];
    screensWithLogout = [homePage, loginPage];
  }

  @override
  Widget build(BuildContext context) {
    final _auth = ref.watch(firebaseAuthServiceProvider);
    if (_auth.getCurrentUser() == null || _auth.getCurrentUser() != null) {
      setState(() {});
    }
    return PersistentTabView(
      context,
      controller: _controller,

      screens:
          _auth.getCurrentUser() == null ? screensWithLogout : screensWithLogin,
      items: _auth.getCurrentUser() == null
          ? _navBarsItemsWithLogout()
          : _navBarsItemsWithLogin(),
      confineInSafeArea: true,
      backgroundColor: Colors.white, // Default is Colors.white.
      handleAndroidBackButtonPress: true, // Default is true.
      resizeToAvoidBottomInset:
          true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
      stateManagement: true, // Default is true.
      hideNavigationBarWhenKeyboardShows:
          true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: ItemAnimationProperties(
        // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),

      navBarStyle:
          NavBarStyle.style4, // Choose the nav bar style with this property.
    );
  }

  List<PersistentBottomNavBarItem> _navBarsItemsWithLogin() {
    return [
      PersistentBottomNavBarItem(
        title: "Kütüphane",
        textStyle: TextStyle(color: Colors.white),
        activeColorPrimary: Colors.redAccent,
        inactiveColorPrimary: Colors.red,
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case '/HomePage':
                return CupertinoPageRoute(builder: (_) => HomePage());
              case '/LoginPage':
                return CupertinoPageRoute(builder: (_) => LoginPage());
              case '/MyLibraryPage':
                return CupertinoPageRoute(builder: (_) => MyLibraryPage());
              case '/MyProfilPage':
                return CupertinoPageRoute(builder: (_) => MyProfilPage());
              case '/ContactUsPage':
                return CupertinoPageRoute(builder: (_) => ContactUsPage());
              case '/BooksDetailPage':
                return CupertinoPageRoute(builder: (_) => BooksDetailPage());

              case '/SearchPage':
                return CupertinoPageRoute(builder: (_) => SearchPage());

              case '/UsersRatingAllBooksPage':
                return CupertinoPageRoute(
                    builder: (_) => UsersRatingAllBooksPage());
            }
          },
        ),
        icon: Icon(Icons.home),
      ),
      PersistentBottomNavBarItem(
        title: "Kütüphane Dünyası",
        textStyle: TextStyle(color: Colors.white),
        activeColorPrimary: Colors.redAccent,
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case '/HomePage':
                return CupertinoPageRoute(builder: (_) => HomePage());

              case '/MyLibraryPage':
                return CupertinoPageRoute(builder: (_) => MyLibraryPage());
              case '/MyProfilPage':
                return CupertinoPageRoute(builder: (_) => MyProfilPage());
              case '/AddBookPage':
                return CupertinoPageRoute(builder: (_) => AddBookPage());
              case '/ContactUsPage':
                return CupertinoPageRoute(builder: (_) => ContactUsPage());

              case '/LoginPage':
                return CupertinoPageRoute(builder: (_) => LoginPage());
              case '/EditBookPage':
                return CupertinoPageRoute(
                    builder: (_) => EditBookPage(
                          context: context,
                        ));

              case '/CategoryPage':
                return CupertinoPageRoute(
                    builder: (_) => CategoriesPage(
                          bookID: widget.bookID,
                        ));
            }
          },
        ),
        icon: Icon(Icons.local_library),
      ),
      PersistentBottomNavBarItem(
          title: "Kategoriler",
          textStyle: TextStyle(color: Colors.white),
          activeColorPrimary: Colors.redAccent,
          routeAndNavigatorSettings: RouteAndNavigatorSettings(
            onGenerateRoute: (settings) {
              switch (settings.name) {
                case '/CategoryPage':
                  return CupertinoPageRoute(
                      builder: (_) => CategoriesPage(
                            bookID: widget.bookID,
                          ));

                case '/MyLibraryPage':
                  return CupertinoPageRoute(builder: (_) => MyLibraryPage());
                case '/ContactUsPage':
                  return CupertinoPageRoute(builder: (_) => ContactUsPage());
                case '/MyProfilPage':
                  return CupertinoPageRoute(builder: (_) => MyProfilPage());
              }
            },
          ),
          icon: Icon(Icons.category),
          inactiveColorPrimary: Colors.red),
      PersistentBottomNavBarItem(
          title: "Kullanıcılar",
          textStyle: TextStyle(color: Colors.white),
          activeColorPrimary: Colors.redAccent,
          routeAndNavigatorSettings: RouteAndNavigatorSettings(
            onGenerateRoute: (settings) {
              switch (settings.name) {
                case '/HomePage':
                  return CupertinoPageRoute(builder: (_) => HomePage());

                case '/MyLibraryPage':
                  return CupertinoPageRoute(builder: (_) => MyLibraryPage());
                case '/MyProfilPage':
                  return CupertinoPageRoute(builder: (_) => MyProfilPage());
                case '/ContactUsPage':
                  return CupertinoPageRoute(builder: (_) => ContactUsPage());

                case '/UsersPage':
                  return CupertinoPageRoute(builder: (_) => UsersPage());

                case '/CategoryPage':
                  return CupertinoPageRoute(builder: (_) => CategoriesPage());
              }
            },
          ),
          icon: Icon(Icons.supervisor_account),
          inactiveColorPrimary: Colors.red),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItemsWithLogout() {
    return [
      PersistentBottomNavBarItem(
        title: "Kütüphane",
        textStyle: TextStyle(color: Colors.white),
        activeColorPrimary: Colors.redAccent,
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case '/HomePage':
                return CupertinoPageRoute(builder: (_) => HomePage());
              case '/LoginPage':
                return CupertinoPageRoute(builder: (_) => LoginPage());
              case '/MyLibraryPage':
                return CupertinoPageRoute(builder: (_) => MyLibraryPage());
              case '/SearchPage':
                return CupertinoPageRoute(builder: (_) => SearchPage());

              case '/BooksDetailPage':
                return CupertinoPageRoute(builder: (_) => BooksDetailPage());
              default:
                return CupertinoPageRoute(builder: (_) => HomePage());
            }
          },
        ),
        icon: Icon(Icons.home),
        inactiveColorPrimary: (Colors.red),
      ),
      PersistentBottomNavBarItem(
        title: "Giriş Yap",
        textStyle: TextStyle(color: Colors.white),
        activeColorPrimary: Colors.redAccent,
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case '/LoginPage':
                return CupertinoPageRoute(builder: (_) => LoginPage());
              case '/ContactUsPage':
                return CupertinoPageRoute(builder: (_) => ContactUsPage());

              case '/SignUpPage':
                return CupertinoPageRoute(builder: (_) => SignUpPage());

              case '/HomePage':
                return CupertinoPageRoute(builder: (_) => HomePage());
              default:
                return CupertinoPageRoute(builder: (_) => HomePage());
            }
          },
        ),
        icon: Icon(Icons.login),
        inactiveColorPrimary: (Colors.red),
      ),
    ];
  }
}
