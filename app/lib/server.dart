import 'dart:convert';

import 'package:get_server/get_server.dart';

import 'utils.dart';

void main() async {
  final server = GetServer(port: 4040);
  server.ws('/ws', (ws) {
    ws.onMessage((data) => ws.sendToAll(data));
  });
  server.ws(
    '/ws',
    (ws) {
      ws.onMessage((data) => ws.sendToAll(data));
      ws.onOpen((ws) => print('${ws.id} connected!'));
      ws.onClose((ws) => print('${ws.socket.id} disconnected!'));
    },
  );
}
