import 'package:app_movil_dincydet/cryptonaval/pages/dashboard/dashboard_cryptonaval.dart';
import 'package:app_movil_dincydet/cryptonaval/pages/login/login.dart';
import 'package:app_movil_dincydet/cryptonaval/pages/my_rooms/message_rooms_list.dart';
import 'package:app_movil_dincydet/cryptonaval/pages/rooms/users.dart';
import 'package:app_movil_dincydet/cryptonaval/pages/settings/settings.dart';
import 'package:app_movil_dincydet/cryptonaval/providers/mainprovider.dart';
import 'package:app_movil_dincydet/fb/fb_push.dart';

import 'package:app_movil_dincydet/pages/budget/budget.dart';
import 'package:app_movil_dincydet/pages/budget/budget_new.dart';
import 'package:app_movil_dincydet/pages/control/controlpanel.dart';
import 'package:app_movil_dincydet/pages/documents/documents.dart';
import 'package:app_movil_dincydet/pages/entry/entry.dart';
import 'package:app_movil_dincydet/pages/home/assistancedetail.dart';
import 'package:app_movil_dincydet/pages/home/dashboard.dart';
import 'package:app_movil_dincydet/pages/inventory/inventory.dart';
import 'package:app_movil_dincydet/pages/login/login.dart';
import 'package:app_movil_dincydet/pages/manage_docs/doc_asign.dart';
import 'package:app_movil_dincydet/pages/manage_docs/doc_received.dart';
import 'package:app_movil_dincydet/pages/manage_docs/doc_transmitted.dart';
import 'package:app_movil_dincydet/pages/personal/personal.dart';
import 'package:app_movil_dincydet/pages/projects/editproject.dart';
import 'package:app_movil_dincydet/pages/projects/newproject.dart';
import 'package:app_movil_dincydet/pages/projects/projectdetail.dart';
import 'package:app_movil_dincydet/pages/projects/projects.dart';
import 'package:app_movil_dincydet/pages/stats/stats_user.dart';
import 'package:app_movil_dincydet/pages/stats/statsdashboard.dart';
import 'package:app_movil_dincydet/pages/tickets/newticket.dart';
import 'package:app_movil_dincydet/pages/update/update_screen.dart';
import 'package:app_movil_dincydet/pages/users/newuser.dart';
import 'package:app_movil_dincydet/pages/users/users.dart';
import 'package:app_movil_dincydet/pages/users/userview.dart';
import 'package:app_movil_dincydet/previews/preview_img.dart';
import 'package:app_movil_dincydet/previews/preview_pdf.dart';
import 'package:app_movil_dincydet/providers/main/main_provider.dart';
import 'package:app_movil_dincydet/providers/main/mainproject_provider.dart';
import 'package:app_movil_dincydet/providers/main/mainticket_provider.dart';
import 'package:app_movil_dincydet/providers/main/mainuser_provider.dart';
import 'package:app_movil_dincydet/src/utils/qrcodes.dart';

import 'package:app_movil_dincydet/pages/tickets/ticketslist.dart';
import 'package:camera/camera.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  await registerFirebase();
  // Channels

  createNotificationChannel(alertChannel);
  createNotificationChannel(alertIncendio);
  createNotificationChannel(alertSimulacro);
  createNotificationChannel(alertTerremoto);
  createNotificationChannel(ticketChannel);
  createNotificationChannel(callChannel);
  FCM().setNotifications();
  print(qrLocations());

  // Obtain a list of the available cameras on the device.
  cameras = await availableCameras();

  runApp(const MyApp());
}

late List<CameraDescription> cameras;

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
double widthDevice = MediaQuery.of(navigatorKey.currentContext!).size.width;
double heightDevice = MediaQuery.of(navigatorKey.currentContext!).size.height;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
          create: (context) => MainProvider(),
          lazy: false,
        ),
        Provider(create: (context) => MainUserProvider()),
        Provider(create: (context) => MainProjectProvider()),
        Provider(create: (context) => MainTicketProvider()),
        ChangeNotifierProvider(create: (context) => CryptoMainProvider()),
      ],
      child: MaterialApp(
        title: 'App Gestion Dincydet',
        debugShowCheckedModeBanner: false,
        scrollBehavior: CustomScrollBehavior(),
        navigatorKey: navigatorKey,
        theme: ThemeData(
          useMaterial3: false,
          // colorSchemeSeed: const Color(0xff6750a4),
          // useMaterial3: true,
          // Set default font family
          // fontFamily: 'Roboto',
        ),
        initialRoute: '/',
        //home: const MyHomePage(title: 'Flutter Demo Home Page'),
        routes: {
          '/': (context) => const EntryPage(),
          // Sistema de gestion
          '/login': (context) => const Login(),
          '/home': (context) => const Dashboard(),
          '/update': (context) => const UpdateScreen(),
          // Users page
          '/myuserpage': (context) => const UserView(isMe: true),
          '/edituserpage': (context) => const UserView(isEdit: true),
          '/userspage': (context) => const UsersPage(),
          '/newuserpage': (context) => const NuevoUsuario(),
          '/userviewpage': (context) => const UserView(),
          //Projects page
          '/projects': (context) => const Proyectos(),
          '/projectdetail': (context) => const ProjectDetail(),
          '/newprojectpage': (context) => const NewProjectPage(),
          // Tickets page
          '/addticket': (context) => const RegisterTicketView(),

          '/ticketsinpage': (context) => const TicketsPage(ticketsin: true),
          '/ticketsoutpage': (context) => const TicketsPage(ticketsin: false),

          '/previewimg': (context) => const Previewimg(),
          '/previewpdf': (context) => const Previewpdf(),
          // '/inventory': (context) => const InventoryPage(),
          '/editproject': (context) => const EditProject(),
          // Assitance page
          '/assistancepage': (context) => const AssistancePage(),
          // Statistics page
          '/statsadminpage': (context) => const StatsDashboardPage(),
          '/statsuserpage': (context) => const StatsUserPage(),
          // Documents page
          '/documentspage': (context) => const DocumentsPage(),
          // Budget page
          '/budgetpage': (context) => const BudgetPage(),
          '/budgetnewpage': (context) => const BudgetNewPage(),
          // Personal page
          '/personalpage': (context) => const PersonalPage(),
          // Inventory page
          '/inventorypage': (context) => const InventoryPage(),
          // Document management page
          '/docsreceivedpage': (context) => const DocumentReceivedPage(),
          '/docstransmittedpage': (context) => const DocumentTransmittedPage(),
          '/docsassignedpage': (context) => const DocumentAssignPage(),
          // Tablero de control
          '/controlpanel': (context) => const ControlPanelPage(),

          // Cryptonaval pages
          '/crypto_login': (context) => const CryptoLoginPage(),
          '/crypto_dashboard': (context) => const DashboardCryptoPage(),
          '/settings': (context) => const SettingsPage(),
          '/messages': (context) => const MessageRoomsListPage(),
          '/users_list': (context) => const ContactsPage(),
        },
      ),
    );
  }
}

class CustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      };
}
