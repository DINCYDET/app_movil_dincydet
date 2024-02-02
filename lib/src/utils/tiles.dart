import 'package:app_movil_dincydet/src/utils/userinfo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_randomcolor/flutter_randomcolor.dart' as rcolor;

class TicketTile extends StatelessWidget {
  const TicketTile({
    super.key,
    required this.name,
    required this.ttype,
    required this.shortname,
    required this.args,
  });

  final String name;
  final String ttype;
  final String shortname;
  final UserArguments args;

  @override
  Widget build(BuildContext context) {
    final options = rcolor.Options(
      format: rcolor.Format.hex,
      luminosity: rcolor.Luminosity.dark,
    );
    final String colorstring = rcolor.RandomColor.getColor(options);
    final int colorval = int.parse("FF${colorstring.substring(1)}", radix: 16);
    return ListTile(
      title: Text(name),
      subtitle: Text(
        ttype,
        style: const TextStyle(color: Colors.grey),
      ),
      leading: CircleAvatar(
        backgroundColor: Color(colorval),
        child: Text(
          shortname,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      trailing: IconButton(
        onPressed: () {
          Navigator.pushNamed(context, '/ticketdetail', arguments: args);
        },
        icon: const Icon(
          Icons.open_in_full,
          color: Colors.grey,
        ),
      ),
    );
  }
}
