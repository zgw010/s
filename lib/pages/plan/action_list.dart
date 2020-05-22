import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:s/pages/plan/plan_group_list.dart';
import 'package:s/pages/plan/plan_list.dart';
import 'package:s/pages/plan/update_action.dart';
import '../../model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'action_details.dart';

class ActionListPage extends StatefulWidget {
  ActionListPage({Key key}) : super(key: key);
  @override
  _ActionListPageState createState() => _ActionListPageState();
}

class _ActionListPageState extends State<ActionListPage> {
  var actionTypeMap = {
    'all': '所有动作',
    'user': '用户自定义动作',
    'base': '基础动作',
  };
  var dropdownValue = 'all';
  // var list = [];
  // var state;
  getActionList(actionType) async {
    var response;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userInfoString = prefs.getString('userInfo');
      if (userInfoString == '') return;
      Map<String, dynamic> userInfo = jsonDecode(userInfoString);
      response = await http.get(
        "${SURL.getActionList}?userID=${userInfo['UserID'] ?? ''}&actionType=$actionType",
      );

      if (response.statusCode == 200) {
        // print(response.body.runtimeType.toString());
        final body = jsonDecode(response.body);
        // print(body);
        // print("${SURL.getActionList}?userID=${userInfo['UserID'] ?? ''}&actionType=$dropdownValue");
        // setState(() {
        //   state = body['status'];
        // });
        if (body['status'] == 0) {
          List<dynamic> data = body['data'];
          // setState(() {
          //   list = data;
          // });
          context.read<ActionModel>().updateActionList(data);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getActionList(dropdownValue);
  }

  @override
  Widget build(BuildContext context) {
    var list = context.watch<ActionModel>().actionList;
    var actionListWidget = <Widget>[];
    for (int i = 0; i < list.length; i++) {
      // print(list[i]['ActionName']);
      if (list[i]['ActionType'] == 'base-times' ||
          list[i]['ActionType'] == 'base-time' ||
          list[i]['ActionType'] == 'base-onlytime') {
        actionListWidget.add(new Container(
            height: 50,
            child: Center(
              child: Row(children: <Widget>[
                Expanded(
                    child: Container(
                        width: 210, child: Text(list[i]['ActionName']))),
                FlatButton(
                  // textColor: Colors.red,
                  child: Text(
                    '查看',
                    style: TextStyle(
                      color: Colors.blueAccent[400],
                      fontSize: 12.0,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) =>
                              ActionDetailsPage(actionData: list[i])),
                    );
                  },
                ),
              ]),
            )));
      } else {
        actionListWidget.add(Container(
          height: 50,
          child: Row(children: <Widget>[
            Expanded(
                child:
                    Container(width: 210, child: Text(list[i]['ActionName']))),
            FlatButton(
              // textColor: Colors.red,
              child: Text(
                '修改',
                style: TextStyle(
                  color: Colors.blueAccent[400],
                  fontSize: 12.0,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => UpdateActionPage(
                          type: 'edit', actionInfo: list[i], index: i)),
                );
              },
            ),
          ]),
        ));
      }
    }
    return Scaffold(
      appBar: AppBar(title: Text("动作列表")),
      body: Container(
          margin: EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0), //容器外填充
          child: Column(
            children: <Widget>[
              // Text('当前正在进行 $planGroupName 计划组 $planName 计划'),
              Center(
                child: DropdownButton<String>(
                  value: dropdownValue,
                  // icon: Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(color: Colors.black),
                  underline: Container(
                    height: 1,
                    color: Colors.black,
                  ),
                  onChanged: (String newValue) {
                    setState(() {
                      dropdownValue = newValue;
                    });
                    getActionList(newValue);
                  },
                  items: <String>['all', 'user', 'base']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(actionTypeMap[value]),
                    );
                  }).toList(),
                ),
              ),
              Expanded(
                child: ListView(
                  // padding: const EdgeInsets.all(4),
                  children: actionListWidget,
                ),
              ),

              ButtonBar(
                children: <Widget>[
                  FlatButton(
                    // textColor: Colors.red,
                    child: Text('新建动作'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => UpdateActionPage(
                                  type: 'create',
                                )),
                      );
                    },
                  ),
                  FlatButton(
                    // textColor: Colors.red,
                    child: Text('计划列表'),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => PlanListPage()),
                      );
                    },
                  ),
                  FlatButton(
                    child: Text('计划组列表'),
                    onPressed: () {
                      // print('object');
                      Navigator.pushReplacement(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => PlanGroupListPage()),
                      );
                    },
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
