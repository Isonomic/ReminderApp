import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'src/global_blocs/app_bloc.dart';
import 'src/global_blocs/auth/auth.dart';
import 'src/global_blocs/theme_changer.dart';
import 'src/root_page.dart';

void main() => runApp(WaterReminderApp());

final lightTheme = ThemeData.light().copyWith(
  primaryColor: Colors.white,
  accentColor: Colors.blue,
  primaryIconTheme: IconThemeData(color: Colors.black),
);

final darkTheme = ThemeData.dark().copyWith(
  primaryColor: Colors.white,
  accentColor: Colors.blue,
  primaryIconTheme: IconThemeData(color: Colors.white),
);

class WaterReminderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<Auth>(
          builder: (_) => Auth(),
        ),
        Provider<AppBloc>(
          builder: (_) => AppBloc(),
          dispose: (_, appBloc) => appBloc.dispose(),
        ),
        ChangeNotifierProvider<ThemeChanger>(
          builder: (_) => ThemeChanger(),
        ),
      ],
      child: MaterialAppWithTheme(),
    );
  }
}

class MaterialAppWithTheme extends StatelessWidget {
  const MaterialAppWithTheme({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeChanger = Provider.of<ThemeChanger>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Water Reminder',
      theme: themeChanger.theme,
      home: RootPage(),
    );
  }
}
