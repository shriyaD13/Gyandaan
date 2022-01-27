import 'package:flutter/material.dart';
import 'package:gyandaan2/providers/user.dart';
import 'package:gyandaan2/screens/learn/mentor_info.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:progress_indicators/progress_indicators.dart';

class UpcomingClasses extends StatefulWidget {
  // const upcomingClasses({ Key? key }) : super(key: key);
  final List<dynamic> classes;
  final bool isMentor;

  UpcomingClasses(this.classes, this.isMentor);

  @override
  State<UpcomingClasses> createState() => _UpcomingClassesState();
}

class _UpcomingClassesState extends State<UpcomingClasses> {
  String formatTimeOfDay(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm(); //"6:00 AM"
    return format.format(dt);
  }

  // var _isLoading = true;

  @override
  Widget build(BuildContext context) {
    final partner = widget.isMentor ? 'Student' : 'Mentor';
    final idKeyWord = widget.isMentor ? 'studId' : 'mentorId';
    final deviceSize = MediaQuery.of(context).size;

    Future<String> _getPartnerName(String id) async {
      // setState(() {
      //   _isLoading = true;
      // });
      final partnerData = widget.isMentor
          ? await Provider.of<User>(context, listen: false).getStudentInfo(id)
          : await Provider.of<User>(context, listen: false).getMentorInfo(id);
      // setState(() {
      //   _isLoading = false;
      // });
      // print(partnerData['username'].toString());
      return partnerData['username'].toString();
    }

    return Column(
      children: [
        ...widget.classes.map((singleClass) {
          return Container(
            width: deviceSize.width,
            height: 210,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 8.0,
              child: Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.all(20),
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${singleClass['course']} class',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            FutureBuilder(
                              builder: (ctx, snapshot) => snapshot
                                          .connectionState ==
                                      ConnectionState.waiting
                                  ? Center(
                                      child: JumpingDotsProgressIndicator(
                                        fontSize: 10.0,
                                      ),
                                    )
                                  : Row(
                                      children: [
                                        Text(
                                          ' $partner',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        if (widget.isMentor)
                                          Text(
                                            ' ${snapshot.data}',
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.blue,
                                            ),
                                          )
                                        else
                                          GestureDetector(
                                            onTap: () => Navigator.of(context)
                                                .pushNamed(MentorInfo.routeName,
                                                    arguments:
                                                        singleClass[idKeyWord]),
                                            child: Text(
                                              ' ${snapshot.data}',
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.blue,
                                              ),
                                            ),
                                          )
                                      ],
                                    ),
                              future: _getPartnerName(singleClass[idKeyWord]),
                            )
                          ],
                        ),
                        Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextButton(
                              onPressed: () async {
                                if (!await launch(
                                  'https://${singleClass['link']}',
                                  forceSafariVC: false,
                                  forceWebView: false,
                                )) print('errrrrr 2');
                              },
                              child: Text(
                                'Join',
                              ),
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Icon(Icons.watch_later_outlined),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              '${DateFormat.yMMMMd().format(DateTime.parse(singleClass['date']))} at ${formatTimeOfDay(TimeOfDay(hour: int.parse(singleClass['time'].split(":")[0]), minute: int.parse(singleClass['time'].split(":")[1])))}'),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.link),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            singleClass['link'],
                            style: TextStyle(
                                fontSize: 15, fontStyle: FontStyle.italic),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList()
      ],
    );
  }
}
