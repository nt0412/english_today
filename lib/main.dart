import 'dart:io';
import 'package:Learn_English_Today/app_theme.dart';
import 'package:Learn_English_Today/packages/quote/quote.dart';
import 'package:Learn_English_Today/quoctes_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'introduction_animation/introduction_animation_screen.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Learn_English_Today/bloc/home_screen/favorite_button/favorite_bloc.dart';
import 'package:Learn_English_Today/bloc/home_screen/home_bloc.dart';
import 'package:Learn_English_Today/bloc/home_screen/load_quote_button/quote_button_bloc.dart';
import 'package:Learn_English_Today/bloc/network_connectivity/network_connectivity_bloc.dart';
import 'package:Learn_English_Today/bloc/simple_bloc_observer.dart';
import 'package:Learn_English_Today/data/repository/quote_repository.dart';
import 'package:Learn_English_Today/ui/home/home.dart';
import 'package:Learn_English_Today/ui/saved_quotes/saved_quotes_screen.dart';
import 'package:Learn_English_Today/ui/splash/splash_screen.dart';
import 'package:Learn_English_Today/utils/constants/theme_const.dart';
import 'package:Learn_English_Today/utils/constants/ui_const.dart';

import 'bloc/initialization/initialization_bloc.dart';
import 'bloc/saved_quotes_screen/saved_quote_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Initialize Bloc Observer
  Bloc.observer = SimpleBlocObserver();

  WidgetsFlutterBinding.ensureInitialized();
  await Quotes().getAll();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((_) => runApp(Quoctespage()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness:
          !kIsWeb && Platform.isAndroid ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return MaterialApp(
      title: 'Learn English Today',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        platform: TargetPlatform.iOS,
      ),
      home: IntroductionAnimationScreen(),
    );
  }
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}
