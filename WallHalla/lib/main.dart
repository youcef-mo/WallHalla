import 'package:flutter/material.dart';
import 'package:wallhalla/theme/themes.dart';
import "screens/home.dart";

void main() => runApp(
      MaterialApp(
        builder: (context, child) {
          return ThemeModeManager(
              defaultThemeMode: ThemeMode.light,
              builder: (themeMode) {
                return MaterialApp(
                    title: 'WallHalla',
                    themeMode: themeMode,
                    theme: ThemeData.light(),
                    darkTheme: ThemeData.dark(),
                    home: Example());
              });
        },
      ),
    );

class Example extends StatefulWidget {
  @override
  _ExampleState createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) {
        return ThemeModeManager(
          defaultThemeMode: ThemeMode.light,
          builder: (themeMode) {
            return MaterialApp(
              themeMode: themeMode,
              theme: ThemeData.light(),
              darkTheme: ThemeData.dark(),
              home: Scaffold(
                body: Center(
                  child: Home(),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget brandName() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          "Wall",
          style: TextStyle(color: Colors.black87, fontFamily: 'Nexa'),
        ),
        Text(
          "Halla",
          style: TextStyle(color: Colors.blue, fontFamily: 'Nexa'),
        )
      ],
    );
  }
}
