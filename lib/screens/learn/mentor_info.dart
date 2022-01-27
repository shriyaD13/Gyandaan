import 'package:flutter/material.dart';
import 'package:gyandaan2/providers/user.dart';
import 'package:provider/provider.dart';

class MentorInfo extends StatefulWidget {
  const MentorInfo({Key? key}) : super(key: key);
  static const routeName = '/mentor-info';
  @override
  State<MentorInfo> createState() => _MentorInfoState();
}

class _MentorInfoState extends State<MentorInfo> {
  var _mentorData = {
    'course': '',
    'days': [],
    'username': '',
    'email': '',
    'timing': '',
  };
  var _isinit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() async {
    if (_isinit) {
      setState(() {
        _isLoading = true;
      });
      final mentorId = ModalRoute.of(context)!.settings.arguments as String;
      // print(mentorId);

      final mentorResp = await Provider.of<User>(context, listen: false)
          .getMentorInfo(mentorId);
      // print(mentorData);
      _mentorData['course'] = mentorResp['course'];
      _mentorData['days'] = mentorResp['days'];
      _mentorData['username'] = mentorResp['username'];
      _mentorData['email'] = mentorResp['email'];
      _mentorData['timing'] = mentorResp['timing'];
      setState(() {
        _isLoading = false;
      });
      super.didChangeDependencies();
    }
    _isinit = false;
  }

  @override
  Widget build(BuildContext context) {
    String stringOfDays = (_mentorData['days'] as List).join(" ");

    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Student Information'),
      // ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 400,
                    width: double.infinity,
                    child: Image.network(
                      'https://image.freepik.com/free-vector/webinar-concept-illustration_114360-4764.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      children: [
                        Text(
                          '${_mentorData['username']}',
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        Text(
                          '${_mentorData['email']}',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Course: ${_mentorData['course']}'),
                        Text('Preferred Timing: ${_mentorData['timing']}'),
                        Text('Preferred Days: $stringOfDays'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => Navigator.of(context)
      //       .pushNamed(ScheduleClass.routeName, arguments: {
      //     'studId': studData['studId'],
      //     'chosenCourse': studData['chosenCourse']
      //   }),
      //   child: Icon(Icons.video_call),
      //   tooltip: 'Schedule a class',
      // ),
    );
  }
}
