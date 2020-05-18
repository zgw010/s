import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:s/pages/plan/action_list.dart';
import 'package:s/pages/plan/plan_list.dart';
import '../../model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Plan extends StatefulWidget {
  Plan({Key key}) : super(key: key);
  @override
  _PlanState createState() => _PlanState();
}

class _PlanState extends State<Plan> {
  var plan = {};
  var curPlanData = <Widget>[];
  var state = 0;
  getCurPlan() async {
    var response;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userInfoString = prefs.getString('userInfo');
      Map<String, dynamic> userInfo = jsonDecode(userInfoString);
      response = await http.get(
        "${SURL.getCurPlan}?userID=${userInfo['UserID'] ?? ''}",
      );
    } catch (e) {
      print(e);
    }
    if (response.statusCode == 200) {
      // print(response.body.runtimeType.toString());
      final body = jsonDecode(response.body);
      var newCurPlanData = <Widget>[];
      if (body['status'] == 0) {
        final data = body['data'];
        final list = jsonDecode(data['PlanDetails']);
        for (int i = 0; i < list.length; i++) {
          newCurPlanData.add(new Container(
              height: 50,
              child: Center(
                child: Row(children: <Widget>[
                  Expanded(
                      child: Text(list[i]['actionName'].toString() +
                          list[i]['actionGroupsNum'].toString() +
                          'x' +
                          list[i]['actionTimes'].toString())),
                  Switch(
                    value: list[i]['actionCompleted'], //当前状态，必填
                    onChanged: (value) {
                      setState(() {
                        // selectMap[list[i]['actionID']] = value;
                        // print(selectMap[list[i]['actionID']]);
                        // print(selectMap);
                      });
                    },
                  ),
                ]),
              )));
        }
      }
      setState(() {
        state = body['status'];
        curPlanData = newCurPlanData;
      });
    }
  }

  void initState() {
    super.initState();
    getCurPlan();
  }

  @override
  Widget build(BuildContext context) {
    var planGroupName = '力量举训练';
    var planName = '腿';

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
              state == 0
                  ? Expanded(
                      child: ListView(
                        // padding: const EdgeInsets.all(8),
                        children: curPlanData,
                      ),
                    )
                  : Expanded(child: SizedBox()),
              state == 10001
                  ? Expanded(
                      child: Container(
                        margin: EdgeInsets.only(top: 160),
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
                        // margin: EdgeInsets.only(top: 160),
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
                        // margin: EdgeInsets.only(top: 160),
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
                      // Navigator.push(
                      //     context,
                      //     new MaterialPageRoute(
                      //         builder: (context) => LoginPage()),
                      //   );
                    },
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
