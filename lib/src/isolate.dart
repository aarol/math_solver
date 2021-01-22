import 'dart:async';
import 'dart:collection';
import 'dart:isolate';

import 'package:math_solver/src/bigint.dart';

import 'enum.dart';

Future<BigInt> runIsolate(ListQueue<Obj> input) async {
  var completer = Completer<BigInt>();
  var receivePort = ReceivePort();
  var isolate = await Isolate.spawn(runSolve, receivePort.sendPort);
  receivePort.listen((data) {
    if (data is SendPort) {
      data.send(input);
    } else {
      isolate.kill();
      completer.complete(data);
    }
  });
  return completer.future;
}

void runSolve(SendPort sendPort) {
  var isolatePort = ReceivePort();
  sendPort.send(isolatePort.sendPort);
  isolatePort.listen((data) async {
    var res = await solvewithBigInt(data);
    sendPort.send(res);
  });
}
