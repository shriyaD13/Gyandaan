import 'package:flutter/material.dart';
import 'package:gyandaan2/providers/user.dart';
import 'package:gyandaan2/screens/dashboard.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ScheduleClass extends StatefulWidget {
  // const ScheduleClass({ Key? key }) : super(key: key);

  static const routeName = '/schedule-class';

  @override
  _ScheduleClassState createState() => _ScheduleClassState();
}

class _ScheduleClassState extends State<ScheduleClass> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  TimeOfDay timeOfMeet = TimeOfDay.now();
  DateTime dateOfMeet = DateTime.now();
  String meetLink = '';
  var _isLoading = false;

  TextEditingController? textControllerDate;
  TextEditingController? textControllerTime;
  TextEditingController? textControllerMeetLink;

  void initState() {
    textControllerDate = TextEditingController();
    textControllerTime = TextEditingController();
    textControllerMeetLink = TextEditingController();
    super.initState();
  }

  _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dateOfMeet,
      firstDate: DateTime(2021),
      lastDate: DateTime(2050),
    );

    if (picked != null && picked != dateOfMeet) {
      setState(() {
        dateOfMeet = picked;
        print(textControllerDate);
        textControllerDate!.text = DateFormat.yMMMMd().format(dateOfMeet);
      });
      // print(dateOfMeet);
    }
  }

  _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: timeOfMeet,
    );
    if (picked != null && picked != timeOfMeet) {
      setState(() {
        timeOfMeet = picked;
        textControllerTime!.text = timeOfMeet.format(context);
      });
    } else {
      setState(() {
        textControllerTime!.text = timeOfMeet.format(context);
      });
    }
    // print(timeOfMeet);
  }

  _scheduleClass(String studId, String chosenCourse) {
    setState(() {
      _isLoading = true;
    });
    if (textControllerDate!.text.isEmpty ||
        textControllerDate!.text.isEmpty ||
        textControllerMeetLink!.text == '') return;

    meetLink = textControllerMeetLink!.text;

    if (!meetLink.startsWith('meet.google.com/')) return;
    print(studId);
    Provider.of<User>(context, listen: false)
        .scheduleClass(studId, dateOfMeet, timeOfMeet, meetLink, chosenCourse)
        .then((value) {
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    });
  }

  _generateMeetLink() async {
    const url = 'https://meet.google.com/';
    if (!await launch(
      url,
      forceSafariVC: false,
      forceWebView: false,
    )) print('errrrrr');
  }

  @override
  Widget build(BuildContext context) {
    final studData =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    print(studData);

    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Schedule a class'),
      // ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 80),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'Schedule a Class',
                        style: TextStyle(
                            fontSize: 28, color: Colors.indigo.shade900),
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        'Please schedule a class according to the student and your time preferences',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Container(
                    constraints: BoxConstraints(minHeight: 260),
                    width: deviceSize.width,
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.calendar_today_outlined),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Date'),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  TextField(
                                    readOnly: true,
                                    controller: textControllerDate,
                                    onTap: _selectDate,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(6.0)),
                                      ),
                                      contentPadding: EdgeInsets.only(
                                        left: 16,
                                        bottom: 16,
                                        top: 16,
                                        right: 16,
                                      ),
                                      hintText: 'Date of class',
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.watch_later_outlined),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Time'),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  TextField(
                                    readOnly: true,
                                    controller: textControllerTime,
                                    onTap: _selectTime,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(6.0)),
                                      ),
                                      contentPadding: EdgeInsets.only(
                                        left: 16,
                                        bottom: 16,
                                        top: 16,
                                        right: 16,
                                      ),
                                      hintText: 'Time of the class',
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.link),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('Google Meet link'),
                                          SizedBox(
                                            height: 4,
                                          ),
                                          Text(
                                            'Please create a google meet link and share it here',
                                            style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                      IconButton(
                                        iconSize: 30,
                                        splashColor: Colors.blue.shade200,
                                        highlightColor: Colors.blue.shade200,
                                        icon: Icon(Icons.video_call_rounded),
                                        onPressed: _generateMeetLink,
                                        tooltip: 'Generate a link',
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  TextField(
                                    controller: textControllerMeetLink,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(6.0)),
                                      ),
                                      contentPadding: EdgeInsets.only(
                                        left: 16,
                                        bottom: 16,
                                        top: 16,
                                        right: 16,
                                      ),
                                      hintText: 'G-Meet link',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          child: Text('Done'),
                          onPressed: () => _scheduleClass(
                              studData['studId'], studData['chosenCourse']),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
