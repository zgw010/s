import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:s/pages/plan/update_action.dart';
import '../../model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateActionPage extends StatefulWidget {
  UpdateActionPage({Key key, this.type = 'create', this.actionInfo})
      : super(key: key);
  final type;
  final actionInfo;
  @override
  _UpdateActionPageState createState() => _UpdateActionPageState();
}

class _UpdateActionPageState extends State<UpdateActionPage> {
  final actionTypeMap = {
    'user-times': '按次计数',
    'user-time': '按时间和距离计数',
    'user-onlytime': '仅按时间计数',
  };
  var _actionType = 'user-times';
  final _actionNameController = TextEditingController();
  final _actionDetailsController = TextEditingController();
  addAction(ctx) async {
    try {
      var response;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userInfoString = prefs.getString('userInfo');
      Map<String, dynamic> userInfo = jsonDecode(userInfoString);
      if (this.widget.type == 'create') {
        response = await http.post("${SURL.addUserAction}", body: {
          'userID': userInfo['UserID'],
          'actionName': _actionNameController.text,
          'actionDetails': _actionDetailsController.text,
          'actionType': _actionType,
        });
      } else if (this.widget.type == 'edit') {
        response = await http.post("${SURL.updateUserAction}", body: {
          'userID': userInfo['UserID'],
          'actionID': this.widget.actionInfo['ActionID'],
          'actionName': _actionNameController.text,
          'actionDetails': _actionDetailsController.text,
          'actionType': _actionType,
        });
      }

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['status'] == 0) {
          Navigator.pop(
            context,
          );
        } else {
          Scaffold.of(ctx).showSnackBar(SnackBar(
              content: Text('失败'),
              action: SnackBarAction(
                label: '知道了',
                onPressed: () {
                  Scaffold.of(ctx).removeCurrentSnackBar();
                },
              )));
        }
      } else {
        Scaffold.of(ctx).showSnackBar(SnackBar(
            content: Text('网络错误'),
            action: SnackBarAction(
              label: '知道了',
              onPressed: () {
                Scaffold.of(ctx).removeCurrentSnackBar();
              },
            )));
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    if (this.widget.type == 'edit') {
      var actionInfo = this.widget.actionInfo;
      print(actionInfo);
      _actionNameController.text = actionInfo['ActionName'] ?? '';
      _actionDetailsController.text = actionInfo['ActionDetails'] ?? '';
      _actionType = actionInfo['ActionType'] ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('${widget.type == 'create' ? '新建动作' : '修改动作'}'),
        ),
        body: Builder(
          builder: (ctx) => Container(
              margin:
                  EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0), //容器外填充
              child: Column(
                children: <Widget>[
                  // Text('当前正在进行 $planGroupName 计划组 $planName 计划'),
                  // Container(
                  //   margin: EdgeInsets.only(top: 20.0, bottom: 20.0), //容器外填充
                  //   child: Text(
                  //     '新建动作',
                  //     style: TextStyle(
                  //       color: Colors.black,
                  //       fontSize: 20.0,
                  //       height: 1.0,
                  //       decoration: TextDecoration.none,
                  //     ),
                  //   ),
                  // ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              width: 80,
                              child: Text(
                                '动作名称：',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ),
                            Expanded(
                                child: TextField(
                              controller: _actionNameController,
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
                                '动作类型',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ),
                            DropdownButton<String>(
                              value: _actionType,
                              icon: Icon(Icons.arrow_downward),
                              iconSize: 16,
                              elevation: 16,
                              style: TextStyle(
                                color: Colors.black,
                                decoration: TextDecoration.none,
                              ),
                              // underline: Container(
                              //   height: 1,
                              //   color: Colors.black,
                              // ),
                              onChanged: (String newValue) {
                                setState(() {
                                  _actionType = newValue;
                                });
                              },
                              items: <String>[
                                'user-times',
                                'user-time',
                                'user-onlytime'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(actionTypeMap[value]),
                                );
                              }).toList(),
                            ),
                            // ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              width: 80,
                              child: Text(
                                '动作描述：',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ),
                            Expanded(
                                child: TextField(
                              controller: _actionDetailsController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                filled: true,
                              ),
                            )),
                          ],
                        ),
                      ],
                    ),
                  ),

                  ButtonBar(
                    children: <Widget>[
                      // FlatButton(
                      //   // textColor: Colors.red,
                      //   child: Text('新建动作'),
                      //   onPressed: () {},
                      // ),
                      FlatButton(
                        textColor: Colors.red,
                        child: Text('取消'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      FlatButton(
                        child: Text('新建'),
                        onPressed: () {
                          addAction(ctx);
                        },
                      ),
                    ],
                  ),
                ],
              )),
        ));
  }
}
