import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:s/pages/plan/action_list.dart';
import 'package:s/pages/plan/plan_group_list.dart';
import 'package:s/pages/plan/plan_list.dart';
import 'package:s/pages/plan/update_plan_group.dart';
import '../../model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Plan extends StatefulWidget {
  Plan({Key key}) : super(key: key);
  @override
  _PlanState createState() => _PlanState();
}

class _PlanState extends State<Plan> {
  var curPlanList = [];
  bool planCompleted = false;
  int state = 0;
  String planGroupName = '';
  String planName = '';
  getCurPlan() async {
    try {
      var response;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userInfoString = prefs.getString('userInfo');
      if (userInfoString == '') return;
      Map<String, dynamic> userInfo = jsonDecode(userInfoString);
      response = await http.get(
        "${SURL.getCurPlan}?userID=${userInfo['UserID'] ?? ''}",
      );
      if (response.statusCode == 200) {
        // print(response.body.runtimeType.toString());
        final body = jsonDecode(response.body);
        if (body['planGroupData']['PlanCompletedTime'] ==
            new DateFormat('yyyy-MM-dd').format(new DateTime.now())) {
          setState(() {
            state = 10001;
            planGroupName = body['planGroupData']['PlanGroupName'];
            planName = body['data']['PlanName'];
          });
        } else {
          setState(() {
            state = body['status'];
            curPlanList = jsonDecode(body['data']['PlanDetails']);
            planGroupName = body['planGroupData']['PlanGroupName'];
            planName = body['data']['PlanName'];
          });
        }
      }
    } catch (e) {
      print(e);
    }
  }

  updatePlanGroupStep() async {
    try {
      var response;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userInfoString = prefs.getString('userInfo');
      if (userInfoString == '') return;
      Map<String, dynamic> userInfo = jsonDecode(userInfoString);
      // print({
      //   'planGroupID': userInfo['UserPlanGroupID'],
      //   'updateType': 'complete',
      // });
      response = await http.post("${SURL.updatePlanGroup}", body: {
        'planGroupID': userInfo['UserPlanGroupID'],
        'updateType': 'complete',
      });

      // if (response.statusCode == 200) {
      //   final body = jsonDecode(response.body);
      //   if (body['status'] == 0) {
      //     Navigator.pop(
      //       context,
      //     );
      //   } else {}
      // } else {}
    } catch (e) {
      print(e);
    }
  }

  addData() async {
    try {
      var response;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userInfoString = prefs.getString('userInfo');
      if (userInfoString == '') return;
      Map<String, dynamic> userInfo = jsonDecode(userInfoString);
      // curPlanList
      response = await http.post("${SURL.addData}", body: {
        'userID': userInfo['UserID'],
        'dataName': planName,
        'dataTime': new DateFormat('yyyy-MM-dd').format(new DateTime.now()),
        'dataDetails': jsonEncode(curPlanList),
      });

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['status'] == 0) {
          Navigator.pop(
            context,
          );
        } else {}
      } else {}
    } catch (e) {
      print(e);
    }
  }

  void initState() {
    super.initState();
    getCurPlan();
  }

  @override
  Widget build(BuildContext context) {
    var list = <Widget>[];
    for (int i = 0; i < curPlanList.length; i++) {
      var actionData = curPlanList[i];
      list.add(Container(
          height: 50,
          child: Center(
            child: Row(children: <Widget>[
              Expanded(
                  child: Text(actionData['ActionName'].toString() +
                      actionData['ActionGroupsNum'].toString() +
                      'x' +
                      actionData['ActionTimes'].toString())),
              Switch(
                value: actionData['ActionCompleted'], //当前状态，必填
                onChanged: (value) {
                  bool complete = true;
                  for (var curPlanListi = 0;
                      curPlanListi < curPlanList.length;
                      curPlanListi++) {
                    if (curPlanListi != i &&
                        curPlanList[curPlanListi]['ActionCompleted'] == false) {
                      complete = false;
                    }
                  }
                  if (complete) {
                    updatePlanGroupStep();
                    addData();
                  }

                  setState(() {
                    planCompleted = complete;
                    curPlanList[i]['ActionCompleted'] = true;
                  });
                },
              ),
            ]),
          )));
    }
    return Scaffold(
      body: Container(
          margin: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0), //容器外填充
          child: Column(
            children: <Widget>[
              RichText(
                text: new TextSpan(
                  text: '当前正在进行 ',
                  style: new TextStyle(
                      inherit: true, fontSize: 14.0, color: Colors.black),
                  children: <TextSpan>[
                    new TextSpan(
                        text: '$planGroupName',
                        style: new TextStyle(color: Colors.blueAccent[400])),
                    new TextSpan(text: ' 计划组 '),
                    new TextSpan(
                        text: '$planName',
                        style: new TextStyle(
                            fontWeight: FontWeight.w200,
                            color: Colors.blueAccent[400])),
                    new TextSpan(text: ' 计划'),
                  ],
                ),
              ),
              state == 0 && !planCompleted
                  ? Expanded(
                      child: ListView(
                        // padding: const EdgeInsets.all(8),
                        children: list,
                      ),
                    )
                  : Expanded(child: SizedBox()),
              state == 10001 || planCompleted
                  ? Expanded(
                      child: Container(
                        // margin: EdgeInsets.only(top: 10),
                        child: Center(
                          child: Column(
                            children: <Widget>[
                              Icon(Icons.done_all),
                              Text('今日计划已完成')
                            ],
                          ),
                        ),
                      ),
                    )
                  : SizedBox(),
              state == 10002
                  ? Expanded(
                      child: Container(
                        // margin: EdgeInsets.only(top: 10),
                        child: Center(
                          child: Column(
                            children: <Widget>[
                              Icon(Icons.error_outline),
                              Text('当前没有计划组')
                            ],
                          ),
                        ),
                      ),
                    )
                  : SizedBox(),
              state == 10003
                  ? Expanded(
                      child: Container(
                        // margin: EdgeInsets.only(top: 10),
                        child: Center(
                          child: Column(
                            children: <Widget>[
                              Icon(Icons.done_all),
                              Text('今日计划已完成')
                            ],
                          ),
                        ),
                      ),
                    )
                  : SizedBox(),
              ButtonBar(
                children: <Widget>[
                  FlatButton(
                    // textColor: Colors.red,
                    child: Text('动作列表'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => ActionListPage()),
                      );
                    },
                  ),
                  FlatButton(
                    // textColor: Colors.red,
                    child: Text('计划列表'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => PlanListPage()),
                      );
                    },
                  ),
                  FlatButton(
                    child: Text('计划组列表'),
                    onPressed: () {
                      Navigator.push(
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
