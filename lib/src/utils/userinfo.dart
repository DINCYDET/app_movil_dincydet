import 'package:socket_io_client/socket_io_client.dart' as IO;

class UserArguments {
  final String userid;
  final String userimg;
  final String username;
  dynamic other = '';
  IO.Socket? socket;
  String? token;
  UserArguments(this.userid, this.userimg, this.username, {this.token});
}
