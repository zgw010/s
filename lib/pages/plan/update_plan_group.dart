import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class UpdatePlanGroup extends StatefulWidget {
  UpdatePlanGroup({Key key}) : super(key: key);
  @override
  _UpdatePlanGroupState createState() => _UpdatePlanGroupState();
}

class _UpdatePlanGroupState extends State<UpdatePlanGroup> {
  var dropdownValue = '按次计数';
  @override
  Widget build(BuildContext context) {
    var list = [
      {
        "actionID": 1,
        "actionName": "腿",
        "actionType": "base-times",
        "actionGroupsNum": 4,
        "actionTimes": 10
      },
      {
        "actionID": 2,
        "actionName": "有氧",
        "actionType": "base-times",
        "actionGroupsNum": 4,
        "actionTimes": 10
      },
      {
        "actionID": 3,
        "actionName": "肩背",
        "actionType": "base-times",
        "actionGroupsNum": 4,
        "actionTimes": 10
      },
      {
        "actionID": 4,
        "actionName": "计划4",
        "actionType": "base-time",
        "actionTime": 30,
        "actionDistance": 5000
      },
      {
        "actionID": 5,
        "actionName": "计划5",
        "actionType": "base-onlytime",
        "actionTime": 3
      },
      {
        "actionID": 6,
        "actionName": "计划6",
        "actionType": "base-times",
        "actionGroupsNum": 4,
        "actionTimes": 10
      },
      {
        "actionID": 7,
        "actionName": "计划7",
        "actionType": "user-times",
        "actionGroupsNum": 4,
        "actionTimes": 10
      },
      {"actionID": 8, "actionName": "zgw-倒立", "actionType": "user-onlytime"}
    ];
    var _list = <Widget>[];
    for (int i = 0; i < list.length; i++) {
      if (true) {
        _list.add(new Container(
            height: 50,
            child: Center(
              child: Row(children: <Widget>[
                Container(
                    width: 210,
                    child: Text(list[i]['actionName'].toString())),
                FlatButton(
                  // textColor: Colors.red,
                  child: Text(
                    '删除',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 12.0,
                    ),
                  ),
                  // onPressed: () {},
                ),
              ]),
            )));
      } else if (list[i]['actionType'].toString().indexOf('onlytime') != -1) {
        _list.add(Container(
            height: 50,
            child: Center(
              child: Row(children: <Widget>[
                Container(
                    width: 210,
                    child: Text(list[i]['actionName'].toString() +
                        list[i]['actionTime'].toString() +
                        '分钟')),
                FlatButton(
                  // textColor: Colors.red,
                  child: Text(
                    '删除',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 12.0,
                    ),
                  ),
                  // onPressed: () {},
                ),
              ]),
            )));
      } else if (list[i]['actionType'].toString().indexOf('time') != -1) {
        _list.add(Container(
            height: 50,
            child: Center(
              child: Row(children: <Widget>[
                Container(
                    width: 210,
                    child: Text(list[i]['actionName'].toString() +
                        list[i]['actionDistance'].toString() +
                        '米')),
                FlatButton(
                  // textColor: Colors.red,
                  child: Text(
                    '删除',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 12.0,
                    ),
                  ),
                  // onPressed: () {},
                ),
              ]),
            )));
      }
    }
    return Scaffold(
      body: Container(
          margin: EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0), //容器外填充
          child: Column(
            children: <Widget>[
              // Text('当前正在进行 $planGroupName 计划组 $planName 计划'),
              Center(
                child: Text('编辑计划组'),
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          width: 100,
                          child: Text(
                            '计划组名称：',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                        Expanded(child: TextField()),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          width: 100,
                          child: Text(
                            '计划组内容：',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                        FlatButton(
                          textColor: Colors.blue,
                          child: Text('增加一个计划'),
                          onPressed: () {},
                        ),
                      ],
                    ),
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.all(8),
                        children: _list,
                      ),
                    ),
                  ],
                ),
              ),

              ButtonBar(
                children: <Widget>[
                  FlatButton(
                    textColor: Colors.red,
                    child: Text('取消'),
                    onPressed: () {},
                  ),
                  FlatButton(
                    textColor: Colors.red,
                    child: Text('删除'),
                    onPressed: () {},
                  ),
                  FlatButton(
                    child: Text('确定'),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
