import 'dart:convert';

import 'package:flutter/services.dart';

mixin DataService {
  Future<List<String>> getVideoUrls() async {
    final result = await rootBundle.loadString('assets/json/data.json');

    return (jsonDecode(result) as List<dynamic>)
        .map((e) => e.toString())
        .toList();
  }
}
