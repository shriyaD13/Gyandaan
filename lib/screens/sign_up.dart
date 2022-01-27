import 'package:flutter/material.dart';
import 'package:gyandaan2/screens/dashboard.dart';

import 'package:provider/provider.dart';

import '../providers/auth.dart';
import 'tab_screen.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = '/sign-up';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  Map<String, String> _authData = {
    'name': '',
    'email': '',
    'password': '',
  };

  String? _type;
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
      // print(_authData['password']);
      await Provider.of<Auth>(context, listen: false).signUp(
          _authData['name'], _authData['email'], _authData['password'], _type);
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
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Sign Up",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
              Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 50),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Username',icon: Icon(Icons.person),),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a username!';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _authData['name'] = value!;
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'E-Mail',icon: Icon(Icons.email),),
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
                        TextFormField(
                            decoration:
                                InputDecoration(labelText: 'Confirm Password',icon: Icon(Icons.lock),),
                            obscureText: true,
                            validator: (value) {
                              if (value != _passwordController.text) {
                                return 'Passwords do not match!';
                              }
                            }),
                        SizedBox(
                          height: 20,
                        ),
                        DropdownButtonFormField<String>(
                          validator: (value) =>
                              value == null ? 'Field required' : null,
                          hint: Text('What are you here for?'),
                          items: <String>['Learn', 'Teach'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _type = newValue;
                            });
                          },
                          value: _type,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        if (_isLoading)
                          Center(child: CircularProgressIndicator())
                        else
                          SizedBox(
                            width: deviceSize.width * (4 / 5),
                            height: 50,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 40.0),
                              child: ElevatedButton(
                                child: Text('Sign up'),
                                onPressed: _submit,
                                style: ElevatedButton.styleFrom(
                                    shape: StadiumBorder()),
                              ),
                            ),
                          ),
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
}
