import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class User with ChangeNotifier {
  final String? uid;
  String? _username;
  String? _type;
  String? _email;
  List<dynamic> _mentors = [];
  List<dynamic> _students = [];
  List<dynamic> _upcomingClasses = [];
  String? _course = '';
  String? _timing;
  List<dynamic> _days = [];

  String? get username {
    return _username;
  }

  String? get type {
    return _type;
  }

  String? get email {
    return _email;
  }

  List<dynamic> get mentors {
    return _mentors;
  }

  List<dynamic> get students {
    return _students;
  }

  List<dynamic> get upcommingClasses {
    return _upcomingClasses;
  }

  String? get course {
    return _course;
  }

  String? get timing {
    return _timing;
  }

  List<dynamic> get days {
    return _days;
  }

  User(
    this.uid,
    this._username,
    this._type,
    this._email,
    this._mentors,
    this._students,
    this._upcomingClasses,
    this._course,
    this._timing,
    this._days,
  );

  Future<void> fetchUserDetails() async {
    // print(uid);

    final typeConv = _type == 'Learn' ? 'students' : 'mentors';
    var url =
        'https://morning-scrubland-18150.herokuapp.com/updateUpcomingClassesList/$uid?type=$typeConv';
    await http.get(Uri.parse(url));

    url = 'https://morning-scrubland-18150.herokuapp.com/getUserInfo/$uid';
    final resp = await http.get(Uri.parse(url));
    // print(resp.body);
    final respData = json.decode(resp.body);
    // print(respData);
    _username = respData['username'];
    _type = respData['type'];
    _email = respData['email'];
    if (respData['mentors'] != null)
      _mentors = respData['mentors'];
    else
      _mentors = [];
    if (respData['students'] != null)
      _students = respData['students'];
    else
      _students = [];
    if (respData['timing'] != null)
      _timing = respData['timing'];
    else
      _timing = '';
    if (respData['course'] != null)
      _course = respData['course'];
    else
      _course = '';
    if (respData['days'] != null)
      _days = respData['days'];
    else
      _days = [];
    _upcomingClasses = respData['upcomingClasses'];
    notifyListeners();
  }

  Future<void> addCourseAndTime(
      String? course, String? timing, List<dynamic> days) async {
    final url =
        'https://morning-scrubland-18150.herokuapp.com/addCourseAndTime/$uid';

    await http.post(
      Uri.parse(url),
      body: json.encode({
        'course': course,
        'timing': timing,
        'days': days,
      }),
      headers: {"Content-Type": "application/json"},
    );
    _course = course;
    _timing = timing;
    _days = days;
    notifyListeners();
  }

  String? getTimeSlot(String? timing) {
    const listOfTimimgs = [
      '9 am to 10 am',
      '10 am to 11 am',
      '11 am to 12 pm',
      '12 pm to 1pm',
      '1 pm to 2 pm',
      '2 pm to 3 pm',
      '3 pm to 4 pm',
      '4 pm to 5 pm',
      '5 pm to 6 pm',
      '6 pm to 7 pm',
      '7 pm to 8 pm',
      '8 pm to 9 pm',
      '9 pm to 10 pm',
    ];
    final idx = listOfTimimgs.indexWhere((element) => element == timing);
    if (idx >= 0 && idx <= 2) return 'Morning (9-12)';
    if (idx >= 3 && idx <= 5) return 'Afternoon (12-3)';
    if (idx >= 6 && idx <= 9) return 'Evening (3-7)';
    if (idx >= 10 && idx <= 12) return 'Night (7-10)';
  }

  Future<void> findMentor(String? chosenCourse, String? chosenTiming,
      List<dynamic> chosenDays) async {
    final url = 'https://morning-scrubland-18150.herokuapp.com/findMentor/$uid';
    try {
      await http.post(
        Uri.parse(url),
        body: json.encode({
          'chosenCourse': chosenCourse,
          'chosenTiming': chosenTiming,
          'chosenTimeSlot': getTimeSlot(chosenTiming),
          'chosenDays': chosenDays,
        }),
        headers: {"Content-Type": "application/json"},
      );
      fetchUserDetails();
    } catch (err) {
      print(err);
    }
  }

  Future<dynamic> getMentorInfo(String id) async {
    final url = 'https://morning-scrubland-18150.herokuapp.com/mentorInfo/$id';
    final resp = await http.get(Uri.parse(url));
    final mentorData = json.decode(resp.body);
    // print(mentorData);
    return mentorData;
  }

  Future<dynamic> getStudentInfo(String id) async {
    final url = 'https://morning-scrubland-18150.herokuapp.com/studentInfo/$id';
    final resp = await http.get(Uri.parse(url));
    final studData = json.decode(resp.body);
    // print(studData);
    return studData;
  }

  Future<void> scheduleClass(String studId, DateTime dateOfMeet,
      TimeOfDay timeOfMeet, String meetLink, String course) async {
    final url =
        'https://morning-scrubland-18150.herokuapp.com/scheduleClass/$uid';
    try {
      await http.post(
        Uri.parse(url),
        body: json.encode({
          'studId': studId,
          'dateOfMeet': dateOfMeet.toIso8601String(),
          'timeOfMeet': timeOfMeet.toString().substring(10, 15),
          'meetLink': meetLink,
          'course': course,
        }),
        headers: {"Content-Type": "application/json"},
      );
      fetchUserDetails();
    } catch (err) {
      print(err);
    }
  }

  Future<void> updateUserDetails(String fieldChanged, dynamic newValue) async {
    final url = 'https://morning-scrubland-18150.herokuapp.com/updateInfo/$uid';
    try {
      final resp = await http.post(Uri.parse(url),
          body: json.encode({
            'keyWord': type == 'Learn' ? 'students' : 'mentors',
            'fieldChanged': fieldChanged,
            'newValue': newValue,
          }),
          headers: {"Content-Type": "application/json"});
      // final respData = json.decode(resp.body);
      // print(respData);
      
    fetchUserDetails();
    } catch (err) {
      print(err);
    }
  }
}
