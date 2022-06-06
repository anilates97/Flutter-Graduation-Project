import 'package:bitirme_proje/screens/add_book_page.dart';
import 'package:bitirme_proje/screens/contact_us_page.dart';
import 'package:bitirme_proje/screens/home_page.dart';
import 'package:bitirme_proje/screens/login_page.dart';
import 'package:bitirme_proje/screens/my_profil_page.dart';
import 'package:bitirme_proje/screens/sign_up_page.dart';

import 'package:bitirme_proje/themes/themes.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:splash_screen_view/SplashScreenView.dart';

import 'providers/application_providers.dart';
import 'screens/books_detail.page.dart';
import 'screens/categories_page.dart';
import 'screens/edit_book_page.dart';
import 'screens/my_library_page.dart';
import 'screens/users.page.dart';

import 'screens/users_rating_all_books_page.dart';

import 'screens/search_page.dart';
import 'widgets/nav_bar_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    await Firebase.initializeApp();
  } else {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyAgUhHU8wSJgO5MVNy95tMT07NEjzMOfz0',
        appId: '1:448618578101:web:0b650370bb29e29cac3efc',
        messagingSenderId: '448618578101',
        projectId: 'react-native-firebase-testing',
        authDomain: 'react-native-firebase-testing.firebaseapp.com',
        databaseURL: 'https://react-native-firebase-testing.firebaseio.com',
        storageBucket: 'react-native-firebase-testing.appspot.com',
        measurementId: 'G-F79DJ0VFGS',
      ),
    );
  }
  // ignore: prefer_const_constructors
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final themeMode = ref.watch(changeThemeProvider);
    print("BUILD ÇALIŞTIIIIIIIIIIIIIIIIIIIIIIII");
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
            onGenerateRoute: (settings) {
              switch (settings.name) {
                case '/HomePage':
                  return CupertinoPageRoute(builder: (_) => HomePage());
                case '/LoginPage':
                  return CupertinoPageRoute(builder: (_) => LoginPage());
                case '/SignUpPage':
                  return CupertinoPageRoute(builder: (_) => SignUpPage());
                case '/MyLibraryPage':
                  return CupertinoPageRoute(builder: (_) => MyLibraryPage());
                case '/MyProfilPage':
                  return CupertinoPageRoute(builder: (_) => MyProfilPage());
                case '/BooksDetailPage':
                  return CupertinoPageRoute(builder: (_) => BooksDetailPage());
                case '/AddBookPage':
                  return CupertinoPageRoute(builder: (_) => AddBookPage());
                case '/ContactUsPage':
                  return CupertinoPageRoute(builder: (_) => ContactUsPage());
                case '/NavBarWidget':
                  return CupertinoPageRoute(builder: (_) => NavBarWidget());

                case '/SearchPage':
                  return CupertinoPageRoute(builder: (_) => SearchPage());

                case '/UsersPage':
                  return CupertinoPageRoute(builder: (_) => UsersPage());

                case '/CategoriesPage':
                  return CupertinoPageRoute(builder: (_) => CategoriesPage());

                case '/EditBookPage':
                  return CupertinoPageRoute(
                      builder: (_) => EditBookPage(
                            context: context,
                          ));

                case '/UsersRatingAllBooksPage':
                  return CupertinoPageRoute(
                      builder: (_) => UsersRatingAllBooksPage());
              }
            },
            /* routes: {
            '/HomePage': (context) => HomePage(),
            '/LoginPage': (context) => LoginPage(),
            '/SignUpPage': (context) => SignUpPage(),
            '/MyLibraryPage': (context) => MyLibraryPage(),
            '/MyProfilPage': (context) => MyProfilPage(),
            '/BooksDetailPage': (context) => BooksDetailPage(),
            '/AddBookPage': (context) => AddBookPage(),
            '/EditBookPage': (context) => EditBookPage(
                  context: context,
                )
          }, */
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: AppTheme.lightTheme,
            themeMode: themeMode,
            darkTheme: AppTheme.darkTheme,
            home: SplashScreenView(
              colors: [Colors.red, Colors.black, Colors.white],
              imageSrc: "assets/images/splashBook.png",
              backgroundColor: Colors.white,
              duration: 2000,
              navigateRoute: NavBarWidget(),
            ));
      },
    );
  }
}
