import 'package:app_movil_dincydet/providers/login/login_provider.dart';
import 'package:app_movil_dincydet/src/utils/mycolors.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final usercontroller = TextEditingController();

  final passcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginProvider>(
      create: (context) => LoginProvider(),
      child: Consumer<LoginProvider>(builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              // Expanded(
              //   child: Image.asset(
              //     'assets/login_img.jpg',
              //     fit: BoxFit.cover,
              //   ),
              // ),
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    color: MC_darkblue,
                    alignment: Alignment.center,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "SISTEMA DE GESTIÓN\nI+D",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: MC_darkyellow,
                                fontSize: 36,
                                fontFamily: 'Baloo'),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              const Spacer(),
                              Expanded(
                                flex: 3,
                                child: AspectRatio(
                                  aspectRatio: 1.0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(36),
                                      image: const DecorationImage(
                                        image: AssetImage(
                                          'assets/logo_dincydet.png',
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const Spacer(),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              const Spacer(),
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "USUARIO",
                                      style: TextStyle(
                                        color: MC_darkyellow,
                                        fontFamily: 'Baloo',
                                        fontSize: 24,
                                      ),
                                    ),
                                    Theme(
                                      data: Theme.of(context).copyWith(
                                        colorScheme:
                                            ThemeData().colorScheme.copyWith(
                                                  primary: MC_darkyellow,
                                                ),
                                      ),
                                      child: TextField(
                                        controller: usercontroller,
                                        style: const TextStyle(fontSize: 18),
                                        cursorColor: MC_darkyellow,
                                        decoration: InputDecoration(
                                          hintText: 'Usuario',
                                          //labelText: 'Usuario',
                                          prefixIcon: const Icon(Icons.person),
                                          filled: true,
                                          fillColor: Colors.white,
                                          isDense: true,
                                          errorText:
                                              provider.usernameController.error,
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              20.0,
                                            ),
                                          ),
                                        ),
                                        onChanged: (value) {
                                          provider.changeUser(value);
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    const Text(
                                      "CONTRASEÑA",
                                      style: TextStyle(
                                        color: MC_darkyellow,
                                        fontFamily: 'Baloo',
                                        fontSize: 24,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Theme(
                                      data: Theme.of(context).copyWith(
                                        colorScheme:
                                            ThemeData().colorScheme.copyWith(
                                                  primary: MC_darkyellow,
                                                ),
                                      ),
                                      child: TextField(
                                        controller: passcontroller,
                                        obscureText: !provider.visibility,
                                        cursorColor: MC_darkyellow,
                                        onChanged: (value) {
                                          provider.changePass(value);
                                        },
                                        style: const TextStyle(fontSize: 18),
                                        decoration: InputDecoration(
                                          hintText: 'Contraseña',
                                          //labelText: 'Password',
                                          errorText:
                                              provider.passwordController.error,
                                          filled: true,
                                          isDense: true,
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              20.0,
                                            ),
                                          ),

                                          prefixIcon: const Icon(Icons.lock),
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              provider.visibility
                                                  ? Icons.visibility
                                                  : Icons
                                                      .visibility_off_outlined,
                                            ),
                                            onPressed: () {
                                              provider.onTapEye();
                                            },
                                          ),
                                          fillColor: Colors.white,
                                        ),
                                        onSubmitted: (value) {
                                          provider.onTapLogin();
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                            ],
                          ),
                          const SizedBox(
                            height: 35,
                          ),
                          TextButton(
                            onPressed: provider.onTapLogin,
                            child: Container(
                              width: 180,
                              height: 50,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: MC_darkyellow2,
                                boxShadow: const [
                                  BoxShadow(
                                      color: Colors.black,
                                      blurRadius: 8,
                                      offset: Offset(0, 0))
                                ],
                              ),
                              child: const Text(
                                "INGRESAR",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Baloo',
                                  fontSize: 28,
                                ),
                              ),
                            ),
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
      }),
    );
  }
}
