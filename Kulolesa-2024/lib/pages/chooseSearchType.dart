import 'package:flutter/material.dart';

class ChooseTypeSearch extends StatefulWidget {
  const ChooseTypeSearch({super.key});

  @override
  State<ChooseTypeSearch> createState() => _ChooseTypeSearchState();
}

class _ChooseTypeSearchState extends State<ChooseTypeSearch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Text("Pesquisar "),
    ));
  }
}
