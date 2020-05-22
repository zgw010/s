import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
      planGroupListWidget.add(new Container(
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
                    fontSize: 12.0,
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => UpdatePlanGroupPage(
                              type: 'edit',
                              planGroupInfo: planGroupList[i],
                            )),
                  );
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
