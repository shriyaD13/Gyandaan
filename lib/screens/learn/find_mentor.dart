import 'package:flutter/material.dart';
import 'package:gyandaan2/providers/courses.dart';
import 'package:gyandaan2/providers/user.dart';
import 'package:provider/provider.dart';
import 'package:weekday_selector/weekday_selector.dart';

class FindMentor extends StatefulWidget {
  const FindMentor({Key? key}) : super(key: key);
  static const routeName = '/schedule-classes';

  @override
  State<FindMentor> createState() => _FindMentorState();
}

class _FindMentorState extends State<FindMentor> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  var _isInit = true;
  var _initLoader = false;
  String? _chosenCourse;
  String? _chosenTiming;
  var _isLoading = false;
  List<dynamic> _listOfCourses = [];
  List<String?> _listOfTimimgs = [
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

  List<dynamic> _chosenDays = [];
  List<String> toDay = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];
  final _values = List.filled(7, false);

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _initLoader = true;
      });
      await Provider.of<Courses>(context).fetchCourses().then((_) {
        setState(() {
          _listOfCourses =
              Provider.of<Courses>(context, listen: false).listOfCourses;
          _initLoader = false;
          print(_listOfCourses);
        });
      });
      super.didChangeDependencies();
    }
    _isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    void _submit() async {
      if (!_formKey.currentState!.validate()) {
        // Invalid!
        return;
      }
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      int idx = 0;
      // print(_values);
      _values.forEach((day) {
        if (day) _chosenDays.add(toDay[idx]);
        idx++;
      });
      // print(_chosenDays);
      await Provider.of<User>(context, listen: false)
          .findMentor(_chosenCourse, _chosenTiming, _chosenDays);
      Navigator.of(context).pop();
      setState(() {
        _isLoading = false;
      });
    }

    return Scaffold(
      body: _initLoader
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 30),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'Find a mentor',
                          style: TextStyle(
                              fontSize: 28, color: Colors.indigo.shade900),
                        ),
                      ),
                    ),

                    Center(
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 8.0,
                        child: Container(
                          // height: 320,
                          // constraints: BoxConstraints(minHeight: 320),
                          width: deviceSize.width * 0.75,
                          padding: EdgeInsets.all(16.0),
                          child: Form(
                            key: _formKey,
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Please choose a course'),
                                        DropdownButtonFormField<String>(
                                          validator: (value) => value == null
                                              ? 'Field required'
                                              : null,
                                          hint: Text('Course'),
                                          items: _listOfCourses
                                              .map((dynamic value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                          onChanged: (newValue) {
                                            setState(() {
                                              _chosenCourse = newValue;
                                            });
                                          },
                                          value: _chosenCourse,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            'Please choose your preferred time'),
                                        DropdownButtonFormField<String>(
                                          validator: (value) => value == null
                                              ? 'Field required'
                                              : null,
                                          hint: Text('Timing'),
                                          items: _listOfTimimgs
                                              .map((dynamic value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                          onChanged: (newValue) {
                                            setState(() {
                                              _chosenTiming = newValue;
                                            });
                                          },
                                          value: _chosenTiming,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            'Please choose your preferred days for classes'),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        WeekdaySelector(
                                          onChanged: (int day) {
                                            setState(() {
                                              print(day);
                                              final index = day % 7;
                                              _values[index] = !_values[index];
                                            });
                                          },
                                          values: _values,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  if (_isLoading)
                                    Column(
                                      children: [
                                        Text('Finding a mentor ...'),
                                        Center(
                                            child: CircularProgressIndicator())
                                      ],
                                    )
                                  else
                                    Center(
                                      child: RaisedButton(
                                        child: Text('Done'),
                                        onPressed: _submit,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 30.0, vertical: 8.0),
                                        color: Theme.of(context).primaryColor,
                                        textColor: Theme.of(context)
                                            .primaryTextTheme
                                            .button!
                                            .color,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
