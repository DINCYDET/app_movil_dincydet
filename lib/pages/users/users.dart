import 'dart:math';

import 'package:app_movil_dincydet/main.dart';
import 'package:app_movil_dincydet/pages/home/myscaffold.dart';
import 'package:app_movil_dincydet/pages/users/userstable.dart';
import 'package:app_movil_dincydet/providers/users/users_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UsersProvider>(
      create: (context) => UsersProvider(),
      child: Consumer<UsersProvider>(builder: (context, provider, child) {
        return MyScaffold(
          title: 'Usuarios',
          section: DrawerSection.users,
          fab: FloatingActionButton.extended(
            backgroundColor: const Color(0xFF081929),
            onPressed: provider.onTapNewUser,
            label: const Row(
              children: [
                Icon(Icons.add),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Crear usuario',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          body: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: max(800, widthDevice-40),
                child: const UsersTable(),),
            ),
          ),
        );
      }),
    );
  }
}
