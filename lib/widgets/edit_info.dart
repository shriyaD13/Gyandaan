import 'package:flutter/material.dart';
import 'package:gyandaan2/providers/courses.dart';
import 'package:gyandaan2/providers/user.dart';
import 'package:provider/provider.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:weekday_selector/weekday_selector.dart';

class EditInfo extends StatefulWidget {
  final fieldChanged;
  final oldValue;

  EditInfo(this.fieldChanged, this.oldValue);

  @override
  _EditInfoState createState() => _EditInfoState();
}

class _EditInfoState extends State<EditInfo> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  var newVal;
  var _isLoading = false;
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
          // print(_listOfCourses);
        });
      });
      super.didChangeDependencies();
    }
    _isInit = false;
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    // print(newVal);
    if(widget.fieldChanged == 'days') {
      int idx = 0;
      _values.forEach((day) {
        if (day) _chosenDays.add(toDay[idx]);
        idx++;
      });
      newVal = _chosenDays;
    }
    Provider.of<User>(context, listen: false)
        .updateUserDetails(widget.fieldChanged, newVal)
        .then((value) {
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(25.0),
            topRight: const Radius.circular(25.0),
          ),
        ),
        padding: EdgeInsets.only(
          top: 10,
          left: 10,
          right: 10,
          bottom: MediaQuery.of(context).viewInsets.bottom + 10,
        ),
        child: _isLoading
            ? Center(
                child: JumpingDotsProgressIndicator(
                  fontSize: 10.0,
                ),
              )
            : Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      if (widget.fieldChanged == 'username' ||
                          widget.fieldChanged == 'email')
                        Expanded(
                          child: TextFormField(
                            initialValue: widget.oldValue,
                            decoration: InputDecoration(
                              labelText: widget.fieldChanged,
                              icon: Icon(Icons.edit),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a valid ${widget.fieldChanged}';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              newVal = value;
                            },
                          ),
                        ),
                      if (widget.fieldChanged == 'course')
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Course'),
                              DropdownButtonFormField<String>(
                                validator: (value) =>
                                    value == null ? 'Field required' : null,
                                hint: Text('${widget.oldValue}'),
                                items: _listOfCourses.map((dynamic value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    newVal = newValue;
                                  });
                                },
                                value: newVal,
                              ),
                            ],
                          ),
                        ),
                      if (widget.fieldChanged == 'timing')
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Timing'),
                              DropdownButtonFormField<String>(
                                validator: (value) =>
                                    value == null ? 'Field required' : null,
                                hint: Text('${widget.oldValue}'),
                                items: _listOfTimimgs.map((dynamic value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    newVal = newValue;
                                  });
                                },
                                value: newVal,
                              ),
                            ],
                          ),
                        ),
                      if (widget.fieldChanged == 'days')
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'Preferred Days'),
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
                      IconButton(
                        onPressed: _submit,
                        icon: Icon(
                          Icons.check,
                          color: Colors.green,
                        ),
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
