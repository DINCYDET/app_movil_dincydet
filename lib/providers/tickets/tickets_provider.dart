import 'package:app_movil_dincydet/api/api_tickets.dart';
import 'package:app_movil_dincydet/main.dart';
import 'package:app_movil_dincydet/pages/tickets/ticketdetail.dart';
import 'package:app_movil_dincydet/providers/main/mainticket_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

class TicketsPageProvider extends ChangeNotifier {
  String category = 'out';
  TicketsPageProvider(this.category) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      updateCount();
      updateTickets();
    });
  }

  TextEditingController searchController = TextEditingController();

  TicketsPageProvider.received() {
    category = 'in';
  }

  TicketsPageProvider.sent() {
    category = 'out';
  }

  bool opentickets = true;
  List<dynamic> tcount = [0, 0, 0, 0];

  void createTableProvider() {}

  void onTapNewTicket() async {
    final isReg =
        await Navigator.pushNamed(navigatorKey.currentContext!, '/addticket');
    if (isReg != true) return;

    updateTickets();
    updateCount();
  }

  void onTapOpenClose() {
    opentickets = !opentickets;
    setOpenClose(opentickets);
    updateCount();
  }

  void updateCount() async {
    Map<String, dynamic>? response = await apiTicketsGetCount(
      isIn: category == 'in',
      isOpen: opentickets,
    );
    if (response == null) {
      return;
    }
    tcount = response['count'];
    // (nombre, dni, cargo, photo)
    notifyListeners();
  }

  // Code for table operations
  List<dynamic> tickets = [];

  List<dynamic> get filteredTicketList {
    if (searchController.text.isEmpty) return tickets;
    if (category == 'in') {
      return tickets.where((element) {
        return element['FROMUSER']['FULLNAME']
            .toString()
            .toLowerCase()
            .contains(searchController.text.toLowerCase());
      }).toList();
    }
    return tickets.where((element) {
      return element['TOUSER']['FULLNAME']
          .toString()
          .toLowerCase()
          .contains(searchController.text.toLowerCase());
    }).toList();
  }

  int ttype = 0;

  int status = 0;

  void setOpenClose(bool opentickets) {
    opentickets ? status = 0 : status = 1;
    updateTickets();
  }

  void updateTickets() async {
    final response = await apiTicketsListUser(
      toUser: category == 'in',
      status: status,
      ticktype: ttype,
    );
    if (response == null) return;
    tickets = response;
    notifyListeners();
  }

  void onTapDelete(int index) async {
    final ticketid = tickets[index]['ID'];
    if (category == 'in') {
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        const SnackBar(
          content: Text('Solo puedes eliminar tickets emitidos'),
        ),
      );
      return;
    }
    bool? complete = await QuickAlert.show(
      context: navigatorKey.currentContext!,
      type: QuickAlertType.confirm,
      text: '¿Desea eliminar el ticket?',
      confirmBtnText: 'Si',
      cancelBtnText: 'No',
      barrierDismissible: false,
      confirmBtnColor: Colors.red,
      onConfirmBtnTap: () async {
        Navigator.of(navigatorKey.currentContext!).pop(true);
      },
    );
    if (complete != true) {
      return;
    }
    final dataMap = {'ID': ticketid};
    Map<String, dynamic>? results = await apiTicketsDelete(dataMap);
    if (results == null) {
      return;
    }
    updateTickets();
    updateCount();
  }

  void onTapViewTicket(int index) async {
    Provider.of<MainTicketProvider>(navigatorKey.currentContext!, listen: false)
        .ticketId = tickets[index]['ID'];
    Provider.of<MainTicketProvider>(navigatorKey.currentContext!, listen: false)
        .ticketData = tickets[index];
    bool? closed = await showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) {
        return TicketsViewDialog(
          ticketdata: tickets[index],
          isEmitted: category == 'out',
        );
      },
    );
    if (closed == true) {
      updateTickets();
      updateCount();
    }
  }

  void onTapChangeType(int value) {
    ttype = value;
    updateTickets();
  }

  void onChangeSearch(String value) {
    notifyListeners();
  }
}
