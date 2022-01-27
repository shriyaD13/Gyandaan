import 'package:flutter/material.dart';
import 'package:gyandaan2/providers/user.dart';
import 'package:gyandaan2/screens/learn/mentor_info.dart';
import 'package:provider/provider.dart';

class MentorList extends StatefulWidget {
  final List<dynamic> mentorList;
  List<dynamic> _mentorData = [];

  MentorList(this.mentorList);

  @override
  State<MentorList> createState() => _MentorListState();
}

class _MentorListState extends State<MentorList> {
  var _isInit = true;
  var _isloading = false;

  @override
  void didChangeDependencies() {
    setState(() {
      _isloading = true;
    });
    int i = 0;
    widget.mentorList.forEach((mentorId) {
      print(mentorId);
      Provider.of<User>(context).getMentorInfo(mentorId).then((data) {
        print(data);
        widget._mentorData.add(data);
        print(widget._mentorData);
        i++;
        if (i == widget.mentorList.length)
          setState(() {
            _isloading = false;
          });
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: _isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(top: 20),
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      // margin: EdgeInsets.only(top: 20),
                      child: Text(
                        'Mentors',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w300),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: deviceSize.height / 4,
                      child: ListView.builder(
                        itemBuilder: (ctx, i) => Card(
                          child: ListTile(
                            onTap: () => Navigator.of(context).pushNamed(
                                MentorInfo.routeName,
                                arguments: widget.mentorList[i]),
                            leading: Icon(Icons.person),
                            title: Text(widget._mentorData[i]['username']),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget._mentorData[i]['email']),
                                Text(
                                    'course: ${widget._mentorData[i]['course']}'),
                              ],
                            ),
                            trailing: IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.message),
                            ),
                          ),
                        ),
                        itemCount: widget.mentorList.length,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
