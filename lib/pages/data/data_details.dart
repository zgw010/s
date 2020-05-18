import 'package:flutter/material.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'dart:convert';

// import 'package:flutter/foundation.dart';
class DataDetails extends StatefulWidget {
  DataDetails({Key key}) : super(key: key);

  @override
  _DataDetailsState createState() => _DataDetailsState();
}

class _DataDetailsState extends State<DataDetails> {
  // var _list = <Widget>[];

  var startTime = '2020-4-1', endTime = '2020-5-1';
  @override
  Widget build(BuildContext context) {
    var list = [
      {
        "actionID": "1",
        "actionName": "深蹲",
        "actionType": "base-times",
        "actionGroupsNum": 6,
        "actionTimes": 10,
        "actionTime": 10,
        "actionDistance": 10,
        "actionDetails": "",
        "actionImgURL": "",
        "actionVideoURL": "",
        "actionMoreURL": "",
        "actionCompleted": false
      },
      {
        "actionID": "2",
        "actionName": "硬拉",
        "actionType": "base-times",
        "actionGroupsNum": 6,
        "actionTimes": 10,
        "actionTime": 10,
        "actionDistance": 10.00,
        "actionDetails": "",
        "actionImgURL": "",
        "actionVideoURL": "",
        "actionMoreURL": "",
        "actionCompleted": false
      },
      {
        "actionID": "3",
        "actionName": "卧推",
        "actionType": "base-times",
        "actionGroupsNum": 6,
        "actionTimes": 10,
        "actionTime": 10,
        "actionDistance": 10.00,
        "actionDetails": "",
        "actionImgURL": "",
        "actionVideoURL": "",
        "actionMoreURL": "",
        "actionCompleted": false
      },
      {
        "actionID": "4",
        "actionName": "跑步",
        "actionType": "base-time",
        "actionGroupsNum": 6,
        "actionTimes": 10,
        "actionTime": 10,
        "actionDistance": 10,
        "actionDetails": "",
        "actionImgURL": "",
        "actionVideoURL": "",
        "actionMoreURL": "",
        "actionCompleted": false
      },
      {
        "actionID": "4",
        "actionName": "平板支撑",
        "actionType": "base-onlytime",
        "actionGroupsNum": 6,
        "actionTimes": 10,
        "actionTime": 10,
        "actionDistance": 10.00,
        "actionDetails": "",
        "actionImgURL": "",
        "actionVideoURL": "",
        "actionMoreURL": "",
        "actionCompleted": false
      }
    ];
    var _list = <Widget>[];
    for (int i = 0; i < list.length; i++) {
      // print(list[i]);
      if (list[i]['actionType'] == 'base-times') {
        _list.add(new Container(
            height: 50,
            child: Center(
              child: Row(children: <Widget>[
                Expanded(
                    child: Text(list[i]['actionName'].toString() +
                        ' ' +
                        list[i]['actionGroupsNum'].toString() +
                        'x' +
                        list[i]['actionTimes'].toString())),
              ]),
            )));
      } else if (list[i]['actionType'] == 'base-time') {
        _list.add(Container(
            height: 50,
            child: Center(
              child: Row(children: <Widget>[
                Container(
                    width: 200,
                    child: Text(list[i]['actionName'].toString() +
                        ' ' +
                        list[i]['actionTimes'].toString() +
                        '分钟 ' +
                        list[i]['actionDistance'].toString() +
                        '米')),
                FlatButton(
                  // textColor: Colors.red,
                  child: Text(
                    '查看详情',
                    style: TextStyle(
                      color: Colors.blueAccent[400],
                      fontSize: 12.0,
                      // fontWeight: FontWeight.w400,
                      // decoration: TextDecoration.none,
                    ),
                  ),
                  // onPressed: () {},
                ),
              ]),
            )));
      } else if (list[i]['actionType'] == 'base-onlytime') {
        _list.add(new Container(
            height: 50,
            child: Center(
              child: Row(children: <Widget>[
                Expanded(
                    child: Text(list[i]['actionName'].toString() +
                        ' ' +
                        list[i]['actionTimes'].toString() +
                        ' 分钟')),
              ]),
            )));
      }
    }
    return Container(
      margin: EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0), //容器外填充
      child: Column(
        children: [
          Text('$startTime 完成的计划详情'),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: _list,
            ),
          ),
        ],
      ),
    );
  }
}
