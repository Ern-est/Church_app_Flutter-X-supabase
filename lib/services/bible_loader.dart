import 'dart:convert';
import 'package:flutter/services.dart';

Future<List<dynamic>> loadBibleVersion(String filename) async {
  final data = await rootBundle.loadString('assets/bibles/$filename');
  return json.decode(data) as List<dynamic>;
}
