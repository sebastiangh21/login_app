import 'package:flutter/material.dart';
import 'package:login_app/widget/titulo_widget.dart';
import '../services/services_ingreso.dart';
import 'form_widget.dart';
import 'package:toast/toast.dart';

class RegisterWidget extends StatelessWidget {
  RegisterWidget({super.key});

  final TextEditingController userController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final colorLetras = const Color.fromARGB(255, 102, 206, 105);

  @override
  Widget build(BuildContext context) {
    final ingresoServices = IngresoServices();
    ToastContext().init(context);
    return SafeArea(
      child: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const TituloWidget(mensaje: "Registrate"),
              const SizedBox(
                height: 40,
              ),
              FormWidget(label: "Username", controllerText: userController),
              FormWidget(
                  label: "Password",
                  controllerText: passController,
                  obscure: true),
              FormWidget(
                  label: "Email",
                  controllerText: emailController,
                  textType: TextInputType.emailAddress),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black),
                        onPressed: () async {
                          if (await ingresoServices.register(
                              userController.text,
                              passController.text,
                              emailController.text)) {
                            Navigator.pushNamed(context, "otp", arguments: [
                              userController.text,
                              emailController.text
                            ]);
                          } else {
                            Toast.show(
                              "Error al registrarse",
                              duration: Toast.lengthShort,
                            );
                          }
                        },
                        child: Text(
                          "Registrarse",
                          style: TextStyle(color: colorLetras),
                        ))),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Ya tienes cuenta?",
                    style: TextStyle(color: colorLetras),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(
                          color: Colors.lightGreen,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
