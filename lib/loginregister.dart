import 'package:dev_app/_core/mycolors.dart';
import 'package:dev_app/_core/snackbar.dart';
import 'package:dev_app/components/decoration_auth.dart';
import 'package:dev_app/services/authentication_service_final.dart';
import 'package:flutter/material.dart';

class LoginRegister extends StatefulWidget {
  const LoginRegister({super.key});

  @override
  State<LoginRegister> createState() => _LoginRegisterState();
}

final TextEditingController _firstNameCtlr = TextEditingController();
final TextEditingController _emailCtlr = TextEditingController();
final TextEditingController _passwordCtlr = TextEditingController();

AuthenticationService _authService = AuthenticationService();

class _LoginRegisterState extends State<LoginRegister> {
  bool wantLogin = true;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.purple,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 251, 131, 45),
                  Color.fromARGB(255, 254, 249, 97),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 32),
                      Visibility(
                        visible: !wantLogin,
                        child: Column(
                          children: [
                            const SizedBox(height: 32),
                            TextFormField(
                              controller: _firstNameCtlr,
                              decoration:
                                  getAuthenticationInputDecoration("Nome"),
                              validator: (String? value) {
                                if (value == null) {
                                  return "O nome não pode estar em branco";
                                }
                                if (value.length < 3) {
                                  return "Nome muito curto";
                                }
                                if (value.contains(" ")) {
                                  return "Digite apenas o primeiro nome";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                      TextFormField(
                        controller: _emailCtlr,
                        decoration: getAuthenticationInputDecoration("E-mail"),
                        validator: (String? value) {
                          if (value == null) {
                            return "E-mail não pode estar em branco";
                          }
                          if (value.length < 5) {
                            return "E-mail invalido";
                          }
                          if (!value.contains("@")) {
                            return "O e-mail invalido";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),
                      TextFormField(
                        controller: _passwordCtlr,
                        decoration: getAuthenticationInputDecoration("Senha"),
                        obscureText: true,
                        validator: (String? value) {
                          if (value == null) {
                            return "A senha não pode estar em branco";
                          }
                          if (value.length < 3) {
                            return "A senha é muito curta";
                          }
                          return null;
                        },
                      ),
                      Column(
                        children: [
                          const SizedBox(height: 32),
                          ElevatedButton(
                            onPressed: () {
                              MainButtonClicked();
                            },
                            child: Text((wantLogin) ? "Entrar" : "Cadastrar"),
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
                      Switch(
                        value: !wantLogin,
                        onChanged: (value) {
                          // Use o setState para atualizar o estado do switch e da interface
                          setState(() {
                            wantLogin = !wantLogin;
                          });
                        },
                        // Você pode personalizar a cor do switch quando ele está ativo ou inativo
                        activeColor: Colors.blue,
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Já possuo uma conta",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Cadastrar novo usuario",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  MainButtonClicked() {
    String firstName = _firstNameCtlr.text;
    String email = _emailCtlr.text;
    String password = _passwordCtlr.text;

    if (_formKey.currentState!.validate()) {
      if (wantLogin) {
        _authService.userLogin(email: email, password: password).then(
          (String? erro) {
            if (erro != null) {
              showSnackBar(context: context, text: erro, BuildContext: null);
            }
          },
        );
      } else {
        _authService
            .userRegister(
                firstName: firstName, email: email, password: password)
            .then(
          (String? error) {
            if (error != null) {
              showSnackBar(context: context, text: error, BuildContext: null);
            }
          },
        );
      }
    } else {}
  }
}
