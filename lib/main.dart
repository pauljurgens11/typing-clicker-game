import 'package:flutter/material.dart';
import 'package:typing_game_frontend/text_to_type.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(flex: 1, child: Container(color: Colors.red)),
            const Flexible(
              flex: 2,
              child: Center(
                child: TextToType(),
              ),
            ),
            Flexible(
                flex: 1,
                child: Container(
                  color: Colors.green,
                )),
          ],
        ),
      ),
    );
  }
}
