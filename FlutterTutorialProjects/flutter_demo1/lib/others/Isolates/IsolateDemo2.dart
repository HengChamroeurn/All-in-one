import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:isolate';

class PerformancePage extends StatefulWidget {
  final String title = "Isolates Demo";

  @override
  _PerformancePageState createState() => _PerformancePageState();
}

class _PerformancePageState extends State<PerformancePage> {
  //
  Isolate _isolate;
  bool _running = false;
  bool _paused = false;
  String _message = '';
  String _threadStatus = '';
  ReceivePort _receivePort;
  Capability capability;

  void _start() async {
    if (_running) {
      return;
    }
    setState(() {
      _running = true;
      _message = 'Starting...';
      _threadStatus = 'Running...';
    });
    _receivePort = ReceivePort();
    ThreadParams threadParams = new ThreadParams(10, _receivePort.sendPort);
    _isolate = await Isolate.spawn(_isolateHandler, threadParams);
    _receivePort.listen(_handleMessage, onDone: () {
      print("done!");
      setState(() {
        _threadStatus = 'Stopped';
      });
    });
  }

  static void _isolateHandler(ThreadParams threadParams) async {
    heavyOperation(threadParams);
  }

  static void heavyOperation(ThreadParams threadParams) async {
    int count = 10000;
    while (true) {
      int sum = 0;
      for (int i = 0; i < count; i++) {
        sum += await computeSum(1000);
      }
      count += 10;
      threadParams.sendPort.send((sum * threadParams.val).toString());
    }
  }

  static Future<int> computeSum(int num) {
    Random random = Random();
    return Future(() {
      int sum = 0;
      for (int i = 0; i < num; i++) {
        sum += random.nextInt(100);
      }
      return sum;
    });
  }

  void _handleMessage(dynamic data) {
    print('RECEIVED: ' + data);
    setState(() {
      _message = data;
    });
  }

  void _pause() {
    if (null != _isolate) {
      _paused ? _isolate.resume(capability) : capability = _isolate.pause();
      setState(() {
        _paused = !_paused;
        _threadStatus = _paused ? 'Paused' : 'Resumed';
      });
    }
  }

  void _stop() {
    if (null != _isolate) {
      setState(() {
        _running = false;
      });
      _receivePort.close();
      _isolate.kill(priority: Isolate.immediate);
      _isolate = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
        ),
        body: new Container(
          padding: EdgeInsets.all(20.0),
          alignment: Alignment.center,
          child: new Column(
            children: <Widget>[
              !_running
                  ? OutlineButton(
                      child: Text('Start Isolate'),
                      onPressed: () {
                        _start();
                      },
                    )
                  : SizedBox(),
              _running
                  ? OutlineButton(
                      child: Text(_paused ? 'Resume' : 'Pause'),
                      onPressed: () {
                        _pause();
                      },
                    )
                  : SizedBox(),
              _running
                  ? OutlineButton(
                      child: Text('Stop Isolate'),
                      onPressed: () {
                        _stop();
                      },
                    )
                  : SizedBox(),
              SizedBox(
                height: 20.0,
              ),
              new Text(
                _threadStatus,
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              new Text(
                _message,
                style: TextStyle(
                  fontSize: 40.0,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ));
  }
}

class ThreadParams {
  ThreadParams(this.val, this.sendPort);
  int val;
  SendPort sendPort;
}
