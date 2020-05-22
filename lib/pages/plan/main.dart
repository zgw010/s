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
  bool planCompleted = false;

  getCurPlan() async {
    try {
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // var userInfoString = prefs.getString('userInfo');
      // if (userInfoString == '') return;
      // Map<String, dynamic> userInfo = jsonDecode(userInfoString);
      Map<String, dynamic> userInfo = context.read<UserInfoModel>().userInfo;
      // print({
      //   'getCurPlan',
      //   userInfo
      // });
      // if (userInfo == null || userInfo['UserName'] == '') {
      //   return;
      // }
      var response = await http.get(
        "${SURL.getCurPlan}?userID=${userInfo['UserID'] ?? ''}",
      );
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['status'] != 0) {
          context.read<PlanModel>().updatePlanState(body['status']);
          return;
        }
        if (body['planGroupData']['PlanCompletedTime'] ==
            new DateFormat('yyyy-MM-dd').format(new DateTime.now())) {
          context.read<PlanModel>().updatePlanState(10003);
        } else {
          context.read<PlanModel>().updatePlanState(body['status']);
          context
              .read<PlanModel>()
              .updateCurPlanDetails(jsonDecode(body['data']['PlanDetails']));
          context.read<PlanModel>().updateCurPlan(body['data']);
          context
              .read<PlanModel>()
              .updateCurPlanGroup(body['planGroupData']);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  updatePlanGroupStep() async {
    try {
      var response = await http.post("${SURL.updatePlanGroup}", body: {
        'planGroupID': context.read<PlanModel>().curPlanGroup['PlanGroupID'],
        'updateType': 'complete',
      });

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['status'] == 0) {
        } else {}
      } else {}
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
      response = await http.post("${SURL.addData}", body: {
        'userID': userInfo['UserID'],
        'dataName': context.read<PlanModel>().curPlan['PlanName'],
        'dataTime': new DateFormat('yyyy-MM-dd').format(new DateTime.now()),
        'dataDetails': jsonEncode(context.read<PlanModel>().curPlanDetails),
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
    // print('initState');
    getCurPlan();
  }

  @override
  void didUpdateWidget(var oldWidget) {
    super.didUpdateWidget(oldWidget);
    // print('didUpdateWidget');
    getCurPlan();
  }

  @override
  Widget build(BuildContext context) {
    String planName = context.watch<PlanModel>().curPlan['PlanName'];
    String planGroupName =
        context.watch<PlanModel>().curPlanGroup['PlanGroupName'];
    int state = context.watch<PlanModel>().planState;
    var curPlanDetails = context.watch<PlanModel>().curPlanDetails;
    var list = <Widget>[];
    print({
      'cur plan build',
      planName,
      planGroupName,
      state,
      curPlanDetails,
    });
    for (int i = 0; i < curPlanDetails.length; i++) {
      var actionData = curPlanDetails[i];
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
                  for (var curPlanDetailsi = 0;
                      curPlanDetailsi < curPlanDetails.length;
                      curPlanDetailsi++) {
                    if (curPlanDetailsi != i &&
                        curPlanDetails[curPlanDetailsi]['ActionCompleted'] ==
                            false) {
                      complete = false;
                    }
                  }
                  if (complete) {
                    updatePlanGroupStep();
                    addData();
                  }

                  setState(() {
                    planCompleted = complete;
                    curPlanDetails[i]['ActionCompleted'] = true;
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
              state == 0
                  ? RichText(
                      text: new TextSpan(
                        text: '当前正在进行 ',
                        style: new TextStyle(
                            inherit: true, fontSize: 16.0, color: Colors.black),
                        children: <TextSpan>[
                          new TextSpan(
                              text: '$planGroupName',
                              style:
                                  new TextStyle(color: Colors.blueAccent[400])),
                          new TextSpan(text: ' 计划组 '),
                          new TextSpan(
                              text: '$planName',
                              style: new TextStyle(
                                  fontWeight: FontWeight.w200,
                                  color: Colors.blueAccent[400])),
                          new TextSpan(text: ' 计划'),
                        ],
                      ),
                    )
                  : SizedBox(),
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
                              Text('未制定当前计划组')
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
