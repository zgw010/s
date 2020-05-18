import 'package:flutter/material.dart';
import 'register.dart';
import 'package:provider/provider.dart';
import '../../model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  saveUserInfo(userInfo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userInfo', userInfo);
    context.read<UserInfoModel>().updateUserInfo(userInfo);
  }

  login(ctx, userName, password) async {
    var response;
    try {
      response = await http.post(SURL.login,
          body: {'userName': userName, 'userPassword': password});
    } catch (e) {}
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      // print('body');
      // print(body);
      if (body['status'] == 0) {
        saveUserInfo(body['userInfo']);
        Navigator.pop(
          context,
        );
      } else if (body['status'] == 1) {
        Scaffold.of(ctx).showSnackBar(SnackBar(
          content: Text('登录失败'),
          action: SnackBarAction(
            label: '知道了',
            onPressed: () {
              Scaffold.of(ctx).removeCurrentSnackBar();
            },
          ),
        ));
      }
    } else {
      Scaffold.of(ctx).showSnackBar(SnackBar(
        content: Text('网络异常'),
        action: SnackBarAction(
          label: '知道了',
          onPressed: () {
            Scaffold.of(ctx).removeCurrentSnackBar();
          },
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Builder(
      builder: (ctx) => (ListView(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        children: <Widget>[
          SizedBox(height: 80.0),
          Column(
            children: <Widget>[
              // Image.asset('assets/diamond.png'),
              Icon(Icons.fitness_center),
              SizedBox(height: 16.0),
              Text('S'),
            ],
          ),
          SizedBox(height: 120.0),
          TextField(
            controller: _usernameController,
            decoration: InputDecoration(
              filled: true,
              labelText: 'Username',
            ),
          ),
          SizedBox(height: 12.0),
          TextField(
            controller: _passwordController,
            decoration: InputDecoration(
              filled: true,
              labelText: 'Password',
            ),
            obscureText: true,
          ),
          ButtonBar(
            children: <Widget>[
              FlatButton(
                textColor: Colors.red,
                child: Text('取消'),
                onPressed: () {
                  _usernameController.clear();
                  _passwordController.clear();
                  // final localUserID =
                  //     context.read<UserInfoModel>().userInfo['UserID'];
                  // if (localUserID != '' && localUserID != null) {
                    Navigator.pop(context);
                  // }
                },
              ),
              FlatButton(
                child: Text('注册'),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    new MaterialPageRoute(builder: (context) => Register()),
                  );
                },
              ),
              FlatButton(
                child: Text('登录'),
                onPressed: () {
                  login(
                      ctx, _usernameController.text, _passwordController.text);
                },
              ),
            ],
          ),
        ],
      )),
    ));
  }
}
