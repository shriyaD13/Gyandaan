import 'package:flutter/material.dart';
import 'package:gyandaan2/providers/user.dart';
import 'package:gyandaan2/screens/teach/schedule_class.dart';
import 'package:provider/provider.dart';
import 'package:progress_indicators/progress_indicators.dart';

class RequestsScreen extends StatefulWidget {
  static const routeName = 'requests';
  final List<dynamic> studentsList;

  RequestsScreen(this.studentsList);

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  var _isloading = false;
  var _isInit = true;

  @override
  void didChangeDependencies() {
    setState(() {
      _isloading = true;
    });
    if (widget.studentsList.isEmpty) {
      setState(() {
        _isloading = false;
      });
    } else {
      int i = 0;
      widget.studentsList.forEach((student) {
        print(student['studId']);
        Provider.of<User>(context)
            .getStudentInfo(student['studId'])
            .then((data) {
          print(data);
          widget.studentsList[i]['email'] = data['email'];
          widget.studentsList[i]['username'] = data['username'];
          // print(widget.studentsList);
          i++;
          if (i == widget.studentsList.length)
            setState(() {
              _isloading = false;
            });
        });
      });
      super.didChangeDependencies();
    }
  }


  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;


  
    return Scaffold(
        body: _isloading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : widget.studentsList.isEmpty
                ? Center(
                    child: Text('No requests yet'),
                  )
                : requestScreenWidget(widget: widget));
  }
}

class requestScreenWidget extends StatelessWidget {
  const requestScreenWidget({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final RequestsScreen widget;

  @override
  Widget build(BuildContext context) {

    Future<dynamic> _getStudData(String id) async {
    final data = await Provider.of<User>(context).getStudentInfo(id);
    return {
      'username': data['username'].toString(),
      'email': data['email'].toString(),
    };
  }
  
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(top: 20),
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              // margin: EdgeInsets.only(top: 20),
              child: Text(
                'Requests',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 50),
              child: Column(
                children: [
                  ...widget.studentsList.map((studData) {
                    return Container(
                      width: double.infinity,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 8.0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      child: Icon(Icons.face),
                                      backgroundColor: Colors.blue.shade100,
                                    ),
                                    FutureBuilder(
                                      future: _getStudData(studData['studId']),
                                      builder: (ctx, snapShot) => snapShot
                                                  .connectionState ==
                                              ConnectionState.waiting
                                          ? Center(
                                              child:
                                                  JumpingDotsProgressIndicator(
                                                fontSize: 10.0,
                                              ),
                                            )
                                          : Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      child: Text(
                                                        (snapShot.data as Map)['username'],
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ),
                                                    Text(
                                                      ' ${(snapShot.data as Map)['email']}',
                                                      style: TextStyle(
                                                          color: Colors.grey),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                    ),

                                    IconButton(
                                      icon: Icon(
                                        Icons.video_call_rounded,
                                        size: 25,
                                        color: Colors.blueAccent,
                                      ),
                                      onPressed: () => Navigator.of(context)
                                          .pushNamed(ScheduleClass.routeName,
                                              arguments: {
                                            'studId': studData['studId'],
                                            'chosenCourse':
                                                studData['chosenCourse']
                                          }),
                                    )
                                    // Container(
                                    //   height: 40,
                                    //   width: 40,
                                    //   child: FloatingActionButton(
                                    //     onPressed: () {},
                                    //     child: Icon(Icons
                                    //         .video_call_outlined),
                                    //   ),
                                    // )
                                  ],
                                ),
                              ),
                              Divider(),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.menu_book_rounded,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(studData['chosenCourse']),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.watch_later_outlined,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(studData['chosenTiming']),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.calendar_today_rounded,
                                      size: 20,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                          studData['chosenDays'].join(", ")),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  })
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ListView.builder(
//                                 itemBuilder: (ctx, i) => Card(
//                                   child: ListTile(
//                                     leading: Icon(Icons.person),
//                                     title:
//                                         Text(widget._studentsData[i]['username']),
//                                     subtitle: Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         Text(widget._studentsData[i]['email']),
//                                         Text(
//                                             'course: ${widget.studentsList[i]['chosenCourse']}'),
//                                       ],
//                                     ),
//                                     trailing: IconButton(
//                                       onPressed: () {},
//                                       icon: Icon(Icons.message),
//                                     ),
//                                     onTap: () => Navigator.of(context).pushNamed(
//                                         StudentInfo.routeName,
//                                         arguments: {
//                                           'studId': widget.studentsList[i]
//                                               ['studId'],
//                                           'name': widget._studentsData[i]
//                                               ['username'],
//                                           'email': widget._studentsData[i]['email'],
//                                           'chosenCourse': widget.studentsList[i]
//                                               ['chosenCourse'],
//                                           'chosenDays': widget.studentsList[i]
//                                               ['chosenDays'],
//                                           'chosenTiming': widget.studentsList[i]
//                                               ['chosenTiming'],
//                                         }),
//                                   ),
//                                 ),
//                                 itemCount: widget.studentsList.length,
//                               ),
