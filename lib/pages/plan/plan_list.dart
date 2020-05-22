import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:s/pages/plan/plan_details.dart';
import 'package:s/pages/plan/plan_group_list.dart';
import 'package:s/pages/plan/update_action.dart';
import 'package:s/pages/plan/update_plan.dart';
import '../../model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'action_details.dart';
import 'action_list.dart';

class PlanListPage extends StatefulWidget {
  PlanListPage({Key key}) : super(key: key);
  @override
  _PlanListPageState createState() => _PlanListPageState();
}

class _PlanListPageState extends State<PlanListPage> {
  var actionTypeMap = {
    'all': '所有动作',
    'user': '用户自定义动作',
    'base': '基础动作',
  };
  var dropdownValue = 'all';
  var planList = <Widget>[];
  getPlanList(actionType) async {
    var response;
    var state;
    var newPlanList = <Widget>[];
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userInfoString = prefs.getString('userInfo');
      if (userInfoString == '') return;
      Map<String, dynamic> userInfo = jsonDecode(userInfoString);
      response = await http.get(
        "${SURL.getPlanList}?userID=${userInfo['UserID'] ?? ''}",
      );
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        // print(body);
        // setState(() {
        //   state = body['status'];
        // });
        if (body['status'] == 0) {
          var list = body['data'];
          // List<Map<String, dynamic>> list = data;

          for (int i = 0; i < list.length; i++) {
            newPlanList.add(new Container(
                height: 50,
                child: Center(
                  child: Row(children: <Widget>[
                    Expanded(
                      child: Container(
                          width: 210, child: Text(list[i]['PlanName'])),
                    ),
                    FlatButton(
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
                              builder: (context) => UpdatePlanPage(
                                    type: 'edit',
                                    planInfo: list[i],
                                  )),
                        );
                      },
                    ),
                  ]),
                )));
          }
          setState(() {
            planList = newPlanList;
          });
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getPlanList(dropdownValue);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("计划列表")),
      body: Container(
          margin: EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0), //容器外填充
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  // padding: const EdgeInsets.all(4),
                  children: planList,
                ),
              ),
              ButtonBar(
                children: <Widget>[
                  FlatButton(
                    child: Text('动作列表'),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => ActionListPage()),
                      );
                    },
                  ),
                  FlatButton(
                    child: Text('新建计划'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => UpdatePlanPage(
                                  type: 'create',
                                )),
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
