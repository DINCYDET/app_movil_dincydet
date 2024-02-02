import 'package:app_movil_dincydet/cryptonaval/config/theme.dart';
import 'package:app_movil_dincydet/cryptonaval/providers/mainprovider.dart';
import 'package:app_movil_dincydet/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:matrix/matrix.dart';
import 'package:provider/provider.dart';

class CryptoLoginPage extends StatefulWidget {
  const CryptoLoginPage({super.key});

  @override
  State<CryptoLoginPage> createState() => _CryptoLoginPageState();
}

class _CryptoLoginPageState extends State<CryptoLoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final client = Provider.of<CryptoMainProvider>(navigatorKey.currentContext!,
          listen: false)
      .client;
  bool isObscure = true;
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemBackground,
      child: SafeArea(
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: ListView(
              children: [
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'CryptoNaval',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                    decoration: TextDecoration.none,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                SizedBox(
                  width: clampDouble(
                    MediaQuery.of(context).size.width * 0.6,
                    180,
                    300,
                  ),
                  child: Image.asset('assets/icon.png'),
                ),
                const SizedBox(
                  height: 40,
                ),
                SizedBox(
                  width: clampDouble(
                    MediaQuery.of(context).size.width * 0.6,
                    200,
                    300,
                  ),
                  child: Column(
                    children: [
                      CupertinoTextField(
                        controller: usernameController,
                        placeholder: 'Username',
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CupertinoTextField(
                        controller: passwordController,
                        placeholder: 'Password',
                        obscureText: isObscure,
                        onSubmitted: (value) => _onTapLogin(),
                        suffix: CupertinoButton(
                          minSize: 12,
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          onPressed: () {
                            setState(() {
                              isObscure = !isObscure;
                            });
                          },
                          child: Icon(
                            isObscure
                                ? CupertinoIcons.eye_slash
                                : CupertinoIcons.eye,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: clampDouble(
                    MediaQuery.of(context).size.width * 0.6,
                    200,
                    300,
                  ),
                  child: CupertinoButton(
                    color: AppColors.primaryColor,
                    onPressed: _onTapLogin,
                    child: const Text('Login'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _tryLastLogin() async {
    final client =
        Provider.of<CryptoMainProvider>(context, listen: false).client;
    final storage =
        Provider.of<CryptoMainProvider>(context, listen: false).storage;
    final bearerToken = await storage.read(key: 'bearerToken');
    final identifier = await storage.read(key: 'identifier');
    if (bearerToken == null || identifier == null) return;
    LoginResponse? status;
    try {
      status = await client.login(
        LoginType.mLoginToken,
        identifier: AuthenticationUserIdentifier(user: identifier),
      );
    } on MatrixException {
      print('Exception');
      return;
    }
  }

  void _onTapLogin() {
    final mainProvider =
        Provider.of<CryptoMainProvider>(context, listen: false);
    mainProvider.loginClient(
      usernameController.text,
      passwordController.text,
    );
  }
}
