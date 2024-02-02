import 'package:app_movil_dincydet/cryptonaval/pages/my_rooms/message_rooms_list.dart';
import 'package:app_movil_dincydet/cryptonaval/pages/rooms/public_rooms.dart';
import 'package:app_movil_dincydet/cryptonaval/pages/rooms/users.dart';
import 'package:flutter/cupertino.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const [
          BottomNavigationBarItem(
            label: 'Mis Chats',
            icon: Icon(CupertinoIcons.chat_bubble_2_fill),
          ),
          BottomNavigationBarItem(
            label: 'Usuarios',
            icon: Icon(CupertinoIcons.person_2_fill),
          ),
          BottomNavigationBarItem(
            label: 'Grupos publicos',
            icon: Icon(CupertinoIcons.group_solid),
          ),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return CupertinoTabView(
              builder: (context) {
                return const MessageRoomsListPage();
              },
            );
          case 1:
            return CupertinoTabView(
              builder: (context) {
                return const ContactsPage();
              },
            );
          case 2:
            return CupertinoTabView(
              builder: (context) {
                return const PublicRoomsPage();
              },
            );
          default:
            return CupertinoTabView(
              builder: (context) {
                return const Placeholder();
              },
            );
        }
      },
    );
  }
}
