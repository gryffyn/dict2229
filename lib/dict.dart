/*
 * Copyright (c) gryffyn 2021.
 * Licensed under the MIT license. See LICENSE file in the project root for details.
 */

import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'dart:typed_data';

class Dict {
  Dict();

  Dict.newDict(String address, int port) {
    this._address = address;
    this._port = port;
  }

  String? _address;
  int? _port; // default port 2628
  Map? databases;

  Future<String> info() async {
    var resp = "";
    late Socket _socket;
    await Socket.connect(_address, _port!).then((Socket sock) {
      _socket = sock;
    }).then((_) {
      _socket.write('SHOW SERVER \r\n QUIT\r\n');
      return _socket.flush();
    }).then((_) {
      return _socket.toList();
    }).then((data) {
      var bytes = Uint8List.fromList(data.expand((x) => x).toList());
      resp = utf8.decode(bytes).replaceAll("\r", "");
    });
    _socket.close();
    return resp;
  }

  Future<Map> getDatabases() async {
    var resp = "";
    late Socket _socket;
    await Socket.connect(_address, _port!).then((Socket sock) {
      _socket = sock;
    }).then((_) {
      _socket.write('SHOW DATABASES\r\n QUIT\r\n');
      ;
      return _socket.toList();
    }).then((data) {
      var bytes = Uint8List.fromList(data.expand((x) => x).toList());
      resp = utf8.decode(bytes).replaceAll("\r", "").trim();
    });
    _socket.close();
    LineSplitter ls = new LineSplitter();
    List<String> splitOut = ls.convert(stripHeaders(resp));
    var dicts = new Map();
    for (int i = 1; i < splitOut.length; i++) {
      if (splitOut[i] == ".") {
        break;
      }
      var dict = splitOut[i].indexOf(" ");
      List parts = [
        splitOut[i].substring(0, dict).trim(),
        splitOut[i].substring(dict + 1).trim()
      ];
      dicts[parts[0]] = parts[1];
    }
    return dicts;
  }

  Future<List<Definition>> define(String word, [String database = '*']) async {
    var resp = "";
    late Socket _socket;
    late var defs;
    await Socket.connect(_address, _port!).then((Socket sock) {
      _socket = sock;
    }).then((_) {
      _socket.write('DEFINE $database $word \r\n QUIT\r\n');
      return _socket.flush();
    }).then((_) {
      return _socket.toList();
    }).then((data) {
      var bytes = Uint8List.fromList(data.expand((x) => x).toList());
      resp = utf8.decode(bytes).replaceAll("\r", "");
      defs = splitDefinitions(resp);
    });
    _socket.close();
    return defs;
  }

  Future<List<Match>> match(String word,
      [String strategy = '.', String database = '*']) async {
    var resp = "";
    late Socket _socket;
    late List<Match> matches;
    await Socket.connect(_address, _port!).then((Socket sock) {
      _socket = sock;
    }).then((_) {
      _socket.write('MATCH $database $strategy $word \r\n QUIT\r\n');
      return _socket.flush();
    }).then((_) {
      return _socket.toList();
    }).then((data) {
      var bytes = Uint8List.fromList(data.expand((x) => x).toList());
      resp = utf8.decode(bytes).replaceAll("\r", "");
      matches = splitMatches(resp);
    });
    _socket.close();
    return matches;
  }

  Future<Map> getStrategies() async {
    var resp = "";
    late Socket _socket;
    await Socket.connect(_address, _port!).then((Socket sock) {
      _socket = sock;
    }).then((_) {
      _socket.write('SHOW STRATEGIES\r\n QUIT\r\n');
      return _socket.toList();
    }).then((data) {
      var bytes = Uint8List.fromList(data.expand((x) => x).toList());
      resp = utf8.decode(bytes).replaceAll("\r", "");
    });
    _socket.close();
    LineSplitter ls = new LineSplitter();
    List<String> splitOut = ls.convert(stripHeaders(resp));
    var strats = new Map();
    for (int i = 1; i < splitOut.length; i++) {
      if (splitOut[i] == ".") {
        break;
      }
      var strat = splitOut[i].indexOf(" ");
      List parts = [
        splitOut[i].substring(0, strat).trim(),
        splitOut[i].substring(strat + 1).trim()
      ];
      strats[parts[0]] = parts[1];
    }
    return strats;
  }
}

class DefException implements Exception {
  String errMsg() => 'No definitions found.';
}

class Definition {
  late int numDefinitions = 0;
  late String title = "";
  late String sourceName = "";
  late String sourceDesc = "";
  late String body = "";

  void getNumDefinitions(String def) {
    var lines = def.split("\n");
    numDefinitions = int.tryParse(RegExp(r'^150\s(\d+)\s').firstMatch(lines[0])!.group(1)!)!;
  }

  void processDefinition(String def) {
    var lines = def.split("\n");
    var sourceRe;
    switch (int.tryParse(lines[0].substring(0,3))) {
      case 552: {
        throw new DefException();
      }

      case 150: {
        numDefinitions = int.tryParse(lines[0].substring(0,3))!;
        sourceRe = RegExp(r'^151\s\"([\s\w]+)\"\s(\S+)\s\"(.+)\"').firstMatch(lines[1])!;
        title = lines.elementAt(2);
        sourceName = sourceRe.group(2)!;
        sourceDesc = sourceRe.group(3)!;
        body = lines.sublist(3).join("\n");
        if (body.length >= 2 && body.substring(body.length-2, body.length) == "\n.") {
          body = body.substring(0, body.length-2);
        }
      }
      break;

      case 151: {
        sourceRe = RegExp(r'^151\s\"([\s\w]+)\"\s(\S+)\s\"(.+)\"').firstMatch(lines[0])!;
        title = lines.elementAt(1);
        sourceName = sourceRe.group(2)!;
        sourceDesc = sourceRe.group(3)!;
        body = lines.sublist(2).join("\n");
        if (body.length >= 2 && body.substring(body.length-2, body.length) == "\n.") {
          body = body.substring(0, body.length-2);
        }
      }
      break;
    }
  }
}

String stripHeaders(String str) {
  var lines = str.split("\n");
  return lines.sublist(1, lines.length-3).join("\n");
}

List<Definition> splitDefinitions(String str) {
  var lines = stripHeaders(str).split("\n.\n");
  List<Definition>? defs = [];
  var firstline = lines[0];
  var numofDefs = 0;
  Definition numDef = new Definition();
  if (firstline.trim() != "") {
    numDef.getNumDefinitions(firstline);
    numofDefs = numDef.numDefinitions;
  }
  numDef.title = "$numofDefs definitions found.";
  defs.add(numDef);
  for (var line in lines) {
    if (line.trim() != "") {
      Definition def = new Definition();
      def.processDefinition(line);

      defs.add(def);
    }
  }
  return defs;
}

class Match {
  late int numMatch = 0;
  late String matchName = "";
  late String sourceName = "";

  void processMatch(String def) {
    if (def != "" && def != ".") {
      var regex = RegExp(r'^(\S*)\s\"(\S*)\"').firstMatch(def)!;
      sourceName = regex.group(1)!;
      matchName = regex.group(2)!;
    }
  }
}

List<Match> splitMatches(String str) {
  var lines = stripHeaders(str).split("\n");
  List<Match>? matches = [];
  Match firstMatch = new Match();
  var numMatches = 0;
  if (lines[0] != "") {
    numMatches = int.tryParse(RegExp(r'^152\s(\d+)\s').firstMatch(lines[0])!.group(1)!)!;
  }
  firstMatch.sourceName = "$numMatches matches found.";
  matches.add(firstMatch);

  for (var line in lines.sublist(1)) {
    if (line.trim() != "") {
      Match match = new Match();
      match.processMatch(line);
      matches.add(match);
    }
  }
  return matches;
}