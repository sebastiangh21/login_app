import 'package:flutter/material.dart';

import '../widget/login_widget.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: LoginWidget(),
        backgroundColor: const Color.fromARGB(255, 13, 51, 48));
  }
}
