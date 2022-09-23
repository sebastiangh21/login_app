import 'package:flutter/material.dart';
import 'package:login_app/widget/titulo_widget.dart';
import '../services/services_ingreso.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:toast/toast.dart';

class OTPWidget extends StatelessWidget {
  const OTPWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ingresoServices = IngresoServices();
    ToastContext().init(context);
    final List<String> args =
        ModalRoute.of(context)?.settings.arguments as List<String>;
    return SafeArea(
      child: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const TituloWidget(mensaje: "Ingresa el codigo"),
              Text(
                "El codigo fue enviado al correo: ${args[1]}",
                textAlign: TextAlign.center,
                style:
                    const TextStyle(color: Color.fromARGB(255, 102, 206, 105)),
              ),
              const SizedBox(
                height: 40,
              ),
              OTPTextField(
                length: 6,
                width: MediaQuery.of(context).size.width,
                fieldWidth: 40,
                style: const TextStyle(fontSize: 17),
                textFieldAlignment: MainAxisAlignment.spaceEvenly,
                fieldStyle: FieldStyle.box,
                onCompleted: (pin) async {
                  print("Completed: $pin");
                  if (await ingresoServices.otp(pin, args[0])) {
                    Navigator.pushNamed(context, "login");
                  } else {
                    Toast.show(
                      "Error con el codigo",
                      duration: Toast.lengthShort,
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
