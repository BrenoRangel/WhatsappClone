import 'dart:convert';

import 'package:filas/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:separated_column/separated_column.dart';

import 'main.dart';
import 'theming.dart';
import 'utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final nameInput = TextEditingController();
  final chatInput = TextEditingController();
  final textInput = TextEditingController();
  final scrollController = ScrollController();

  List<Widget> widgets = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECE5DD),
      appBar: AppBar(
        backgroundColor: const Color(0xFF128c7e),
        title: Row(
          children: [
            const Text(
              'Nome: ',
            ),
            Expanded(
              child: TextField(
                controller: nameInput,
              ),
            ),
          ],
        ),
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
            repeat: ImageRepeat.noRepeat,
            image: AssetImage('assets/wp.png'),
            centerSlice: Rect.largest,
            fit: BoxFit.contain,
          ),
        ),
        child: StreamBuilder(
          stream: socket.stream,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              var data = jsonDecode(snapshot.data);

              if (data is List) {
                data.forEach(consumeMessage);
              } else {
                consumeMessage(data);
              }
            }
            WidgetsBinding.instance.addPostFrameCallback((d) {
              scrollController.jumpTo(scrollController.position.maxScrollExtent);
            });
            return SingleChildScrollView(
              controller: scrollController,
              child: SeparatedColumn(
                includeOuterSeparators: true,
                separatorBuilder: (context, index) => gap,
                children: widgets,
              ),
            );
          },
        ),
      ),
      /*
      floatingActionButton: FloatingActionButton(
        onPressed: trySendMessage,
        child: const Icon(Icons.send),
      ),
      */
      bottomNavigationBar: BottomAppBar(
        height: kToolbarHeight,
        padding: padding,
        child: TextField(
          controller: textInput,
          decoration: const InputDecoration(
            contentPadding: padding,
          ),
          onSubmitted: (a) {
            trySendMessage();
          },
        ),
      ),
    );
  }

  void trySendMessage() {
    if (!validate()) return;
    socket.sink.add(
      jsonEncode(
        {
          "name": nameInput.text.trim(),
          "message": textInput.text.trim()
        },
      ),
    );
    textInput.clear();
  }

  @override
  void dispose() {
    socket.sink.close();
    nameInput.dispose();
    chatInput.dispose();
    textInput.dispose();
    super.dispose();
  }

  bool validate() {
    if (nameInput.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).colorScheme.error,
          content: const Text("Preencha o nome!"),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return false;
    } else if (textInput.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).colorScheme.error,
          content: const Text("Preencha a mensagem!"),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return false;
    }
    return true;
  }

  void consumeMessage(obj) {
    if (obj['name'] == nameInput.text.trim()) {
      widgets.add(
        ChatBubble(
          alignment: Alignment.centerLeft,
          clipper: ChatBubbleClipper2(type: BubbleType.receiverBubble),
          backGroundColor: Colors.white,
          child: Text(obj['message']),
        ),
      );
    } else {
      widgets.add(
        ChatBubble(
          alignment: Alignment.centerRight,
          clipper: ChatBubbleClipper2(type: BubbleType.sendBubble),
          backGroundColor: const Color(0xFFDCF8C6),
          child: Text(obj['message']),
        ),
      );
    }
  }
}
