import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ecomm_app/LocaleString.dart';
import 'package:flutter_ecomm_app/screens/stores.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'components/settings.dart';
import 'firebase_options.dart';
import '/screens/checkout.dart';
import '/screens/home.dart';
import '/screens/login.dart';
import '/screens/profile.dart';
import '/utils/application_state.dart';
import '/utils/custom_theme.dart';
import 'models/locale.dart';
import 'screens/contact.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

int? isviewed;

void main() async {
  await initHiveForFlutter(); // for cache

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  // Firebase setup
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SharedPreferences prefs = await SharedPreferences.getInstance();
  isviewed = prefs.getInt('onBoard');

  // Stripe setup
  final String response =
      await rootBundle.loadString("assets/config/stripe.json");
  final data = await json.decode(response);
  Stripe.publishableKey = data["publishableKey"];

  runApp(ChangeNotifierProvider(
    create: (context) => ApplicationState(),
    builder: (context, _) => Consumer<ApplicationState>(
      builder: (context, applicationState, _) {
        Widget child;
        switch (applicationState.loginState) {
          case ApplicationLoginState.loggetOut:
            child = LoginScreen();
            break;
          case ApplicationLoginState.loggedIn:
            child = MyApp();
            break;
          default:
            child = LoginScreen();
        }

        return GetMaterialApp(
            translations: LocaleString(),
            locale: Locale('en', 'US'),
            debugShowCheckedModeBanner: false,
            theme: CustomTheme.getTheme(),
            home: child);
      },
    ),
  ));
}

String page1 = 'home'.tr;
String page2 = 'myprofile'.tr;
String page3 = 'checkout'.tr;
String page4 = 'contactus'.tr;
String page5 = 'ourlocations'.tr;
String page6 = 'logout'.tr;

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Widget _page1 = const HomeScreen();
  late Widget _page2 = const ProfileScreen();
  late Widget _page3 = const CheckoutScreen();
  late Widget _page4 = const ContactScreen();
  late Widget _page5 = const StoresScreen();
  late List<Widget> _pages = [_page1, _page2, _page3, _page4, _page5];

  late int _currentIndex = 0;
  late Widget _currentPage = _page1;

  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = Image.asset(
    'assets/images/Wilsonart.png',
    fit: BoxFit.contain,
    height: 100,
  );

  final List locale = [
    {'name': 'English', 'locale': Locale('en', 'US')},
    {'name': 'Español', 'locale': Locale('es', 'US')},
    {'name': '中國人', 'locale': Locale('zh', 'CN')},
  ];

  updateLanguage(Locale locale) {
    Get.back();
    Get.updateLocale(locale);
  }

  buildLanguageDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
            title: Text('Choose Your Language'),
            content: Container(
              width: double.maxFinite,
              child: ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        child: Text(locale[index]['name']),
                        onTap: () {
                          print(locale[index]['name']);
                          updateLanguage(locale[index]['locale']);
                        },
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider(
                      color: Colors.red,
                    );
                  },
                  itemCount: locale.length),
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();

    _page1 = const HomeScreen();
    _page2 = const ProfileScreen();
    _page3 = const CheckoutScreen();
    _page4 = const ContactScreen();
    _page5 = const StoresScreen();

    _pages = [_page1, _page2, _page3, _page4, _page5];

    _currentIndex = 0;
    _currentPage = _page1;
  }

  void changeTab(int index) {
    setState(() {
      if (index == 5) {
        Provider.of<ApplicationState>(context, listen: false).signOut();
      }
      _currentIndex = index;
      _currentPage = _pages[index];
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: customSearchBar,
          actions: <Widget>[
            IconButton(
              //iconSize: 50,
              //color: Colors.blue,
              onPressed: () {
                buildLanguageDialog(context);
              },
              icon: Icon(
                Icons.translate_rounded,
              ),
            ),
            IconButton(
              icon: customIcon,
              tooltip: 'Search Icon',
              onPressed: () {
                setState(() {
                  if (customIcon.icon == Icons.search) {
                    // Perform set of instructions.
                    customIcon = const Icon(Icons.cancel);
                    customSearchBar = const ListTile(
                      leading: Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 28,
                      ),
                      title: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search here...',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                          ),
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    );
                  } else {
                    customIcon = const Icon(Icons.search);
                    customSearchBar = Image.asset(
                      'assets/images/Wilsonart.png',
                      fit: BoxFit.contain,
                      height: 100,
                    );
                  }
                });
              },
            ), //IconButton
          ], //<Widget>[]
        ),
        drawer: Drawer(
          child: Container(
            margin: const EdgeInsets.only(top: 20.0),
            child: Column(
              children: <Widget>[
                DrawerHeader(
                  decoration: const BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                  child: Image.asset(
                    'assets/images/Wilsonart.png',
                    fit: BoxFit.contain,
                    height: 100,
                  ),
                ),
                navigationItemListTitle('home'.tr, 0),
                navigationItemListTitle('myprofile'.tr, 1),
                navigationItemListTitle('checkout'.tr, 2),
                navigationItemListTitle('contactus'.tr, 3),
                navigationItemListTitle('ourlocations'.tr, 4),
                navigationItemListTitle('logout'.tr, 5),
              ],
            ),
          ),
        ),
        body: _currentPage,
        bottomNavigationBar: BottomNavigationBar(
            onTap: (index) => changeTab(index),
            selectedItemColor: Color.fromARGB(190, 222, 7, 7),
            unselectedItemColor: Colors.black,
            currentIndex: _currentIndex,
            items: [
              BottomNavigationBarItem(label: 'home'.tr, icon: Icon(Icons.home)),
              BottomNavigationBarItem(
                  label: 'myprofile'.tr, icon: Icon(Icons.person)),
              BottomNavigationBarItem(
                  label: 'checkout'.tr, icon: Icon(Icons.shopping_cart)),
              BottomNavigationBarItem(
                  label: 'contactus'.tr, icon: Icon(Icons.contact_mail)),
              BottomNavigationBarItem(
                  label: 'ourlocations'.tr, icon: Icon(Icons.location_on)),
            ]),
      ),
    );
  }

  Widget navigationItemListTitle(String title, int index) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
            color: Color.fromARGB(255, 3, 3, 55), fontSize: 22.0),
      ),
      onTap: () {
        Navigator.pop(context);
        changeTab(index);
      },
    );
  }
}

class Page1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const HomeScreen();
  }
}

class Page2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const ProfileScreen();
  }
}

class Page3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const CheckoutScreen();
  }
}

class Page4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const ContactScreen();
  }
}

class Page5 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const StoresScreen();
  }
}
