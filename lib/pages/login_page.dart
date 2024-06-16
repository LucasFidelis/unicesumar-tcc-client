import 'package:app/application/controllers/login_controller.dart';
import 'package:app/pages/mixins/ui_error_manager.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget with UIErrorManager {
  final LoginController loginController;

  LoginPage({Key? key, required this.loginController}) : super(key: key);

  @override
  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final usuarioInputController = TextEditingController();
  final senhaInputController = TextEditingController();
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          widget.handleMainError(context, widget.loginController.uiErrorStream);
          return Center(
            child: SizedBox(
              width: 320,
              height: 225,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Gestor de Pedidos',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: usuarioInputController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            labelText: 'Usuário',
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(bottom: 10)),
                        TextFormField(
                          controller: senhaInputController,
                          decoration: InputDecoration(
                            labelText: 'Senha',
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                              icon: Icon(
                                _passwordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: !_passwordVisible,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 25.0),
                          child: SizedBox(
                            width: double.infinity,
                            height: 45,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent[200]),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  final String usuario = usuarioInputController.text;
                                  final String senha = senhaInputController.text;
                                  await widget.loginController.logar(usuario, senha);
                                }
                              },
                              child: const Text(
                                'ENTRAR',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
