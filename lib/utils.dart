import 'package:dict2229/dict.dart';

String parenthesize(String input) {
  var out = input;
  if (!input.startsWith("\"")) {
    out = "\"" + out;
  }
  if (!input.endsWith("\"")) {
    out += "\"";
  }
  return out;
}

String stripCode(String input) {
  return input.substring(4);
}

String stripParen(String input) {
  return input.trim().substring(1,input.length-1);
}

String? parse151(String input) {
  var regex = RegExp(r'^\d{3}\s".+"\s.+\s"(.*)"');
  // 151 "vms" wikt-en-all "wikt-en-ALL-2018-05-15"
  var match = regex.firstMatch(input);
  return match!.group(1);
}