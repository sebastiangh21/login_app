import 'package:flutter/material.dart';
import 'package:login_app/widget/register_widget.dart';

class SiginPage extends StatelessWidget {
  const SiginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: RegisterWidget(),
        backgroundColor: const Color.fromARGB(255, 13, 51, 48));
  }
}
