import 'package:flutter/material.dart';

class Configuration extends StatefulWidget {
  const Configuration({super.key});

  @override
  State<StatefulWidget> createState() => _ConfigState();
}

class _ConfigState extends State<StatefulWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: const <Widget>[
          Text("Primeira opção"),
          Text("Segunda opção")
        ],
      ),
    );
  }
}
