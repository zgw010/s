import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../model.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Register extends StatefulWidget {
  Register({Key key, this.type = 'register'}) : super(key: key);
  final type;
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String userSex = '男';
  final _usernameController = TextEditingController();
  final _userPasswordController = TextEditingController();
  final _userAgeController = TextEditingController();
  final _userHeightController = TextEditingController();
  final _userWeightController = TextEditingController();
  final _userDetailsController = TextEditingController();
  saveUserInfo(userInfo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userInfo', userInfo);
    context.read<UserInfoModel>().updateUserInfo(userInfo);
  }

  @override
  void initState() {
    super.initState();
    if (this.widget.type == 'edit') {
      Map<String, dynamic> userInfo = context.read<UserInfoModel>().userInfo;
      userSex = userInfo['UserSex'] ?? '';
      _usernameController.text = userInfo['UserName'] ?? '';
      _userPasswordController.text = userInfo['UserPassword'] ?? '';
      _userAgeController.text = userInfo['UserAge'] ?? '';
      _userHeightController.text = userInfo['UserHeight'] ?? '';
      _userWeightController.text = userInfo['UserWeight'] ?? '';
      _userDetailsController.text = userInfo['UserDetails'] ?? '';
    }
  }

  register(ctx) async {
    var response;
    try {
      if (this.widget.type == 'edit') {
        response = await http.post(SURL.edit, body: {
          'userID': context.read<UserInfoModel>().userInfo['UserID'],
          'userName': _usernameController.text,
          'userPassword': _userPasswordController.text,
          'userDetails': _userDetailsController.text,
          'userDateOfBirth': _userAgeController.text,
          'userHeight': _userHeightController.text,
          'userWeight': _userWeightController.text,
          'userSex': userSex,
          'userAims': '',
        });
      } else {
        response = await http.post(SURL.register, body: {
          'userName': _usernameController.text,
          'userPassword': _userPasswordController.text,
          'userDetails': _userDetailsController.text,
          'userDateOfBirth': _userAgeController.text,
          'userHeight': _userHeightController.text,
          'userWeight': _userWeightController.text,
          'userSex': userSex,
          'userAims': '',
        });
      }
    } catch (e) {}
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      if (body['status'] == 0) {
        saveUserInfo(body['userInfo']);
        Navigator.pop(
          context,
        );
      } else if (body['status'] == 1) {
        Scaffold.of(ctx).showSnackBar(SnackBar(
          content: Text('${this.widget.type == 'edit' ? "更新失败" : "注册失败"}'),
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
        appBar: AppBar(title: Text('注册')),
        body: Builder(
            builder: (ctx) => Container(
                  margin: EdgeInsets.only(
                      top: 80.0, left: 20.0, right: 20.0), //容器外填充
                  child: ListView(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 20.0), //容器外填充
                        child: Text(
                          '${this.widget.type == 'edit' ? "更新资料" : "注册"}',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                            height: 1.0,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                      Row(
                        // height: 20;
                        children: <Widget>[
                          Container(
                              width: 80,
                              child: Text(
                                '用户名：',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  height: 1.0,
                                  fontWeight: FontWeight.w400,
                                  // decoration: TextDecoration.none,
                                ),
                              )),
                          Expanded(
                              child: TextField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              filled: true,
                            ),
                          )),
                        ],
                      ),
                      Container(
                        height: 5.0,
                        child: Text(''),
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                              width: 80,
                              child: Text(
                                '密码',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  height: 1.0,
                                  fontWeight: FontWeight.w400,
                                  decoration: TextDecoration.none,
                                ),
                              )),
                          Expanded(
                              child: TextField(
                            controller: _userPasswordController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              filled: true,
                            ),
                            obscureText: true,
                          )),
                        ],
                      ),
                      Container(
                        height: 5.0,
                        child: Text(''),
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                              width: 80,
                              child: Text(
                                '生日：',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400,
                                  decoration: TextDecoration.none,
                                ),
                              )),
                          Expanded(
                              child: TextField(
                            controller: _userAgeController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              filled: true,
                            ),
                          )),
                        ],
                      ),
                      Container(
                        height: 5.0,
                        child: Text(''),
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                              width: 80,
                              child: Text(
                                '身高：(cm)',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400,
                                  decoration: TextDecoration.none,
                                ),
                              )),
                          Expanded(
                              child: TextField(
                            controller: _userHeightController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              filled: true,
                            ),
                          )),
                        ],
                      ),
                      Container(
                        height: 5.0,
                        child: Text(''),
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            width: 80,
                            child: Text(
                              '体重：(kg)',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                          Expanded(
                              child: TextField(
                            controller: _userWeightController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              filled: true,
                            ),
                          )),
                        ],
                      ),
                      Container(
                        height: 5.0,
                        child: Text(''),
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            width: 80,
                            child: Text(
                              '性别：',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                          Container(
                              child: DropdownButton<String>(
                            value: userSex,
                            icon: Icon(Icons.arrow_downward),
                            iconSize: 24,
                            elevation: 16,
                            style: TextStyle(color: Colors.black),
                            underline: Container(
                              height: 2,
                              color: Colors.black,
                            ),
                            onChanged: (String newValue) {
                              setState(() {
                                userSex = newValue;
                              });
                            },
                            items: <String>['男', '女']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          )),
                        ],
                      ),
                      Container(
                        height: 5.0,
                        child: Text(''),
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            width: 80,
                            child: Text(
                              '个人简介：',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                          Expanded(
                              child: TextField(
                            controller: _userDetailsController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              filled: true,
                            ),
                          )),
                        ],
                      ),
                      ButtonBar(
                        children: <Widget>[
                          FlatButton(
                            textColor: Colors.red,
                            child: Text('取消'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          FlatButton(
                            child: Text(
                                '${this.widget.type == 'edit' ? "更新" : "注册"}'),
                            onPressed: () {
                              register(ctx);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                )));
  }
}
