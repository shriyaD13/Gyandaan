import 'package:flutter/material.dart';
import 'package:gyandaan2/screens/auth_screen.dart';
import 'package:gyandaan2/screens/dashboard.dart';
import 'package:gyandaan2/screens/tab_screen.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  var _isLoading = false;

  final _passwordController = TextEditingController();

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
      await Provider.of<Auth>(context, listen: false)
          .signIn(_authData['email'], _authData['password']);
      Navigator.of(context).pushReplacementNamed(TabScreen.routeName);

      setState(() {
        _isLoading = false;
      });
    }

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
          bottom: MediaQuery.of(context).viewInsets.bottom + 10,
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 50.0, top: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Welcome Back!",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 50),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'E-Mail',
                            icon: Icon(Icons.mail),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value!.isEmpty || !value.contains('@')) {
                              return 'Invalid email!';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _authData['email'] = value!;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Password',
                            icon: Icon(Icons.vpn_key),
                          ),
                          obscureText: true,
                          controller: _passwordController,
                          validator: (value) {
                            if (value!.isEmpty || value.length < 5) {
                              return 'Password is too short!';
                            }
                          },
                          onSaved: (value) {
                            _authData['password'] = value!;
                          },
                        ),
                        SizedBox(
                          height: 60,
                        ),
                        if (_isLoading)
                          CircularProgressIndicator()
                        else
                          SizedBox(
                            width: deviceSize.width * (4 / 5),
                            height: 50,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 40.0),
                              child: ElevatedButton(
                                child: Text('Sign in'),
                                onPressed: _submit,
                                style: ElevatedButton.styleFrom(
                                    shape: StadiumBorder()),
                              ),
                            ),
                          ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          '"The best way to find yourself \nis to lose yourself in the service of others."',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontStyle: FontStyle.italic, color: Colors.grey),
                        ),
                        Text(
                          '                                                       - Mahatma Gandhi',
                          style: TextStyle(
                              fontStyle: FontStyle.italic, color: Colors.grey),
                        )
                      ],
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

  // print(_authData['password']);
}
