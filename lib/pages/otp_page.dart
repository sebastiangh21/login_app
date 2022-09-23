import 'package:flutter/material.dart';
import '../widget/otp_widget.dart';

class OtpPage extends StatelessWidget {
  const OtpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: OTPWidget(), backgroundColor: Color.fromARGB(255, 13, 51, 48));
  }
}
