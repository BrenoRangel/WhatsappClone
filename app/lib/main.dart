import 'package:device_frame/device_frame.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'home_page.dart';
import 'theming.dart';

void main() {
  //await runServer();
  socket = WebSocketChannel.connect(Uri.parse('ws://localhost:4040/ws'));
  runApp(const AppFilas());
}

late WebSocketChannel socket;

class AppFilas extends StatelessWidget {
  const AppFilas({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Padding(
        padding: padding,
        child: DeviceFrame(
          device: Devices.ios.iPhoneSE,
          screen: Builder(
            builder: (context) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.25),
                child: MaterialApp(
                  title: 'Filas',
                  useInheritedMediaQuery: true,
                  debugShowCheckedModeBanner: false,
                  theme: theme,
                  home: const HomePage(),
                ),
              );
            }
          ),
        ),
      ),
    );
  }
}
