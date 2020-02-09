import 'package:flutter/material.dart';
import 'SocketUtil.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class SocketDemo extends StatefulWidget {
  //
  SocketDemo() : super();

  final String title = "AppState Demo";

  @override
  SocketDemoState createState() => SocketDemoState();
}

class SocketDemoState extends State<SocketDemo> with WidgetsBindingObserver {
  //

  WebSocketChannel channel;

  String _status;
  SocketUtil _socketUtil;

  List<String> _messages;
  TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _connectSocketChannel();
    _textEditingController = TextEditingController();
    _status = "";
    _messages = List<String>();
    _socketUtil = SocketUtil();
  }

  _connectSocketChannel() {
    channel = IOWebSocketChannel.connect('ws://echo.websocket.org');
  }

  void _sendMessage() {
    if (_textEditingController.text.isNotEmpty) {
      channel.sink.add(_textEditingController.text);
    }
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _textEditingController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(
                      5.0,
                    ),
                  ),
                ),
                filled: true,
                fillColor: Colors.white60,
                contentPadding: EdgeInsets.all(15.0),
                hintText: 'Filter by name or email',
              ),
            ),
            StreamBuilder(
              stream: channel.stream,
              builder: (context, snapshot) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: Text(snapshot.hasData ? '${snapshot.data}' : ''),
                );
              },
            ),
            OutlineButton(
              child: Text("Send Message"),
              onPressed: () {
                // _socketUtil
                //     .sendMessage(_textEditingController.text, connectListener,
                //         messageListener)
                //     .then((connected) {
                //   if (connected) {
                //     _socketUtil.closeSocket();
                //   }
                // });
                _sendMessage();
              },
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(_status),
            SizedBox(
              height: 20.0,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: null == _messages ? 0 : _messages.length,
                itemBuilder: (BuildContext context, int index) {
                  return Text(
                    _messages[index],
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void messageListener(String message) {
    setState(() {
      _messages.add(message);
    });
  }

  void connectListener(bool connected) {
    setState(() {
      _status = "Status: " + (connected ? "Connected" : "Failed to Connect");
    });
  }
}
