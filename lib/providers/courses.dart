import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class Courses with ChangeNotifier {
  List<dynamic> _courses = [];

  List<dynamic> get courses {
    return _courses;
  }

  List<dynamic> get listOfCourses {
    final list = [];
    courses.forEach((element) {
      list.add(element['courseName']);
    });
    return list;
  }

  Future<void> fetchCourses() async {
    const url = 'https://morning-scrubland-18150.herokuapp.com/courses';
    final resp = await http.get(Uri.parse(url));
    final respData = json.decode(resp.body);
    print(respData);

    _courses = respData;
  }
}
