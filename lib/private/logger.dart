// I got this from my personal package, localpkg, and modified it around flutter_native_ui

import 'dart:convert';
import 'package:flutter/foundation.dart';

void print(dynamic input, {String? code, bool bold = false, String? color}) {
  _handle(input, "log", code, color, bold);
}

void warn(dynamic input, {String? code, bool bold = false, String? color = "\x1B[33m"}) {
  _handle(input, "warning", code, color, bold);
}

void _handle(dynamic input, String type, String? code, String? color, bool bold) {
  if (!kDebugMode) {
    return;
  }
  input = _encodeInput(input);
  String colorCode = "";
  if (color != null) {
    if (_validColor(color)) {
      colorCode = color;
    } else {
      throw Exception("Invalid ANSI color code: $color");
    }
  }
  String abbr = (type == "log" ? "log" : (type == "warning" ? "warn" : (type == "error" ? "err" : (type == "stack" ? "stack" : "null"))));
  String output = _getOutput(input, type.toUpperCase(), abbr.toUpperCase(), code);
  List<String> lines = output.split('\n');
  for (String line in lines) {
    debugPrint("${bold ? "\x1b[1m]" : ""}$colorCode$line\x1B[0m");
  }
}

String _getOutput(dynamic input, String type, String abbr, String? code) {
  return "$abbr: flutter_native_ui ${type.toLowerCase()}: $input${code != null ? " (code $code)" : ""}";
}

String _encodeInput(dynamic input) {
  if (input is Map) {
    input = jsonEncode(input);
  }
  return input;
}

bool _validColor(String input) {
  final ansiColorPattern = RegExp(r'^\x1B\[\d+(;\d+)*m$');
  return ansiColorPattern.hasMatch(input);
}