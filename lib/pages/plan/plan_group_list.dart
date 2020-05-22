import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:s/pages/plan/plan_list.dart';
import 'package:s/pages/plan/update_plan_group.dart';
import '../../model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'action_list.dart';

class PlanGroupListPage extends StatefulWidget {
  PlanGroupListPage({Key key}) : super(key: key);
  @override
  _PlanGroupListPageState createState() => _PlanGroupListPageState();
}

class _PlanGroupListPageState extends State<PlanGroupListPage> {
  getPlanGroupList() async {
    try {
      var response;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userInfoString = prefs.getString('userInfo');
      if (userInfoString == '') return;
      Map<String, dynamic> userInfo = jsonDecode(userInfoString);
      response = await http.get(
        "${SURL.getPlanGroupList}?userID=${userInfo['UserID'] ?? ''}",
      );
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['status'] == 0) {
          context.read<PlanModel>().updatePlanGroupList(body['data']);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  updatePlanGroupID(planGroup) async {
    try {
      var response;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userInfoString = prefs.getString('userInfo');
      if (userInfoString == '') return;
      Map<String, dynamic> userInfo = jsonDecode(userInfoString);
      response = await http.post(SURL.updatePlanGroupID, body: {
        'userID': userInfo['UserID'],
        'userPlanGroupID': planGroup['PlanGroupID'],
      });
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['status'] == 0) {
          showDialog(
            // 传入 context
            context: context,
            // 构建 Dialog 的视图
            builder: (_) => Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    color: Colors.white,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 18),
                          child: Text('操作成功',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                  decoration: TextDecoration.none)),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 16),
                          child: Text('当前使用的计划组为 ${planGroup['PlanGroupName']}',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                  decoration: TextDecoration.none)),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 14, bottom: 18),
                          child: FlatButton(
                              onPressed: () {
                                Navigator.pop(_);
                              },
                              child: Text('确定',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.blueAccent,
                                      decoration: TextDecoration.none))),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );

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
              context.read<PlanModel>().updateCurPlanDetails(
                  jsonDecode(body['data']['PlanDetails']));
              context.read<PlanModel>().updateCurPlan(body['data']);
              context
                  .read<PlanModel>()
                  .updateCurPlanGroup(body['planGroupData']);
            }
          }
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getPlanGroupList();
  }

  @override
  Widget build(BuildContext context) {
    var planGroupList = context.watch<PlanModel>().planGroupList;
    var planGroupListWidget = <Widget>[];
    for (int i = 0; i < planGroupList.length; i++) {
      planGroupListWidget.add(Container(
          height: 50,
          child: Center(
            child: Row(children: <Widget>[
              Expanded(
                  child: Container(
                      width: 210,
                      child: Text(planGroupList[i]['PlanGroupName']))),
              FlatButton(
                child: Text(
                  '查看',
                  style: TextStyle(
                    color: Colors.blueAccent[400],
                    // fontSize: 16.0,
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => UpdatePlanGroupPage(
                              type: 'edit',
                              planGroupInfo: planGroupList[i],
                              index: i,
                            )),
                  );
                },
              ),
              FlatButton(
                // textColor: Colors.red,
                child: Text(
                  '使用',
                  style: TextStyle(
                    color: Colors.blueAccent[400],
                    // fontSize: 16.0,
                  ),
                ),
                onPressed: () {
                  updatePlanGroupID(planGroupList[i]);
                },
              ),
            ]),
          )));
    }
    return Scaffold(
      appBar: AppBar(title: Text("计划组列表")),
      body: Container(
          margin: EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0), //容器外填充
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  // padding: const EdgeInsets.all(4),
                  children: planGroupListWidget,
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
                    child: Text('新建计划组'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => UpdatePlanGroupPage(
                                  type: 'create',
                                )),
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
