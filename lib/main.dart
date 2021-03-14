import 'package:clubHouseLite/constants/Constantcolors.dart';
import 'package:clubHouseLite/home_pages/feed_and_msg_controller.dart';
import 'package:clubHouseLite/services/app_theme.dart';
import 'package:clubHouseLite/sign_in_pages/landing_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppTheme>(create: (context) => AppTheme()),
        ChangeNotifierProvider<FNMPageViewController>(
            create: (context) => FNMPageViewController())
      ],
      child: MaterialApp(
        home: LandingPage(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          accentColor: ConstantColors.blueColor,
          fontFamily: "Poppins",
          canvasColor: Colors.transparent,
        ),
      ),
    );
  }
}
