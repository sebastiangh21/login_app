import 'package:flutter/material.dart';
import 'package:login_app/services/services_ingreso.dart';
import 'package:login_app/user_preferences/user_preferences.dart';
import 'package:login_app/widget/form_widget.dart';
import 'package:toast/toast.dart';

class LoginWidget extends StatelessWidget {
  LoginWidget({super.key});

  final TextEditingController userController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final ingresoServices = IngresoServices();
  final prefs = PreferenciasUsuario();
  final colorLetras = const Color.fromARGB(255, 102, 206, 105);

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    print("Primero: ${prefs.token}");
    return SafeArea(
      child: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Image(
                image: AssetImage("assets/logo.png"),
                width: 250,
              ),
              FormWidget(label: "Username", controllerText: userController),
              FormWidget(
                  label: "Password",
                  controllerText: passController,
                  obscure: true),
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
                          if (await ingresoServices.login(
                              userController.text, passController.text)) {
                            Navigator.pushNamed(context, "map");
                          } else {
                            Toast.show(
                              "Error al iniciar seccion",
                              duration: Toast.lengthShort,
                            );
                          }
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(color: colorLetras, fontSize: 18),
                        ))),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "No tienes cuenta?",
                    style: TextStyle(color: colorLetras),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "register");
                    },
                    child: Text(
                      "Registrate",
                      style: TextStyle(
                          color: colorLetras,
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
