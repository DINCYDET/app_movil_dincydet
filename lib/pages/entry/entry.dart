import 'package:app_movil_dincydet/cryptonaval/config/theme.dart';
import 'package:flutter/material.dart';

class EntryPage extends StatefulWidget {
  const EntryPage({super.key});

  @override
  State<EntryPage> createState() => _EntryPageState();
}

class _EntryPageState extends State<EntryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: onTapCryptoNaval,
                      child: Column(
                        children: [
                          const Text(
                            'CryptoNaval',
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 24.0,
                            ),
                          ),
                          Expanded(
                            child: Image.asset('assets/icon.png'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  const Divider(
                    height: 1,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: onTapDincydetSG,
                      child: Column(
                        children: [
                          const Text(
                            'Sistema de Gestion \nde la informacion\nDincydet',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 24.0,
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Expanded(
                            child: Image.asset('assets/logo_dincydet.png'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onTapCryptoNaval() {
    Navigator.pushNamed(context, '/crypto_login');
  }

  void onTapDincydetSG() {
    Navigator.pushNamed(context, '/login');
  }
}
