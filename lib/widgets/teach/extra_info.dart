import 'package:flutter/material.dart';
import 'package:gyandaan2/providers/courses.dart';
import 'package:gyandaan2/providers/user.dart';
import 'package:provider/provider.dart';
import 'package:weekday_selector/weekday_selector.dart';

class ExtraInfo extends StatefulWidget {
  const ExtraInfo({Key? key}) : super(key: key);

  @override
  _ExtraInfoState createState() => _ExtraInfoState();
}

class _ExtraInfoState extends State<ExtraInfo> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  String? _course;
  String? _timing;
  // List<dynamic> _days = ['Monday'];
  List<dynamic> _listOfCourses = [];
  List<String?> _listOfTimimgs = [
    'Morning (9-12)',
    'Afternoon (12-3)',
    'Evening (3-7)',
    'Night (7-10)',
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
  var _isLoading = false;
  var _initLoader = false;
  var _isInit = true;

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
      print(_course);
      print(_timing);
      print(_values);
      int idx = 0;
      _values.forEach((day) {
        if (day) _chosenDays.add(toDay[idx]);
        idx++;
      });
      
      await Provider.of<User>(context, listen: false)
          .addCourseAndTime(_course, _timing, _chosenDays);
      setState(() {
        _isLoading = false;
      });
    }

    return SingleChildScrollView(
      child: Center(
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                          child: Text(
                        'Let\'s get started!',
                        style: TextStyle(fontSize: 25),
                      )),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Please choose a course for teaching'),
                          DropdownButtonFormField<String>(
                            validator: (value) =>
                                value == null ? 'Field required' : null,
                            hint: Text('Course'),
                            items: _listOfCourses.map((dynamic value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                _course = newValue;
                              });
                            },
                            value: _course,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Please choose your preferred time'),
                          DropdownButtonFormField<String>(
                            validator: (value) =>
                                value == null ? 'Field required' : null,
                            hint: Text('Timing'),
                            items: _listOfTimimgs.map((dynamic value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                _timing = newValue;
                              });
                            },
                            value: _timing,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Please choose your preferred days for classes'),
                          SizedBox(
                            height: 10,
                          ),
                          WeekdaySelector(
                            onChanged: (int day) {
                              setState(() {
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
                      Center(child: CircularProgressIndicator())
                    else
                      Center(
                        child: RaisedButton(
                          child: Text('Done'),
                          onPressed: _submit,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 8.0),
                          color: Theme.of(context).primaryColor,
                          textColor:
                              Theme.of(context).primaryTextTheme.button!.color,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
