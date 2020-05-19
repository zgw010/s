import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../model.dart';
import 'data_details.dart';

class Data extends StatefulWidget {
  Data({Key key}) : super(key: key);

  @override
  _DataState createState() => _DataState();
}

class _DataState extends State<Data> {
  List<dynamic> dataList = [];
  String startTime = new DateFormat('yyyy-MM-dd').format(new DateTime.now());
  String endTime = new DateFormat('yyyy-MM-dd').format(new DateTime.now());

  getData() async {
    try {
      var response;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userInfoString = prefs.getString('userInfo');
      Map<String, dynamic> userInfo = jsonDecode(userInfoString);
      response = await http.get("${SURL.getDataList}?userID=${userInfo['UserID']}");
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['status'] == 0) {
          setState(() {
            dataList = body['data'];
          });
        } else {}
      } else {}
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    var dataListWidget = <Widget>[];
    for (var i = 0; i < dataList.length; i++) {
      var data = dataList[i];
      dataListWidget.add(Container(
          margin: EdgeInsets.only(top: 5.0), //容器外填充
          // border
          child: Row(children: [
            Container(
              width: 200,
              child: Text('${data['DataTime']} ${data['DataName']}'),
            ),
            FlatButton(
              textColor: Colors.blueAccent[400],
              child: Text('查看详细数据',
                  style: TextStyle(
                    color: Colors.blueAccent[400],
                    fontSize: 12.0,
                    // fontWeight: FontWeight.w400,
                    // decoration: TextDecoration.none,
                  )),
              onPressed: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => DataDetailsPage()),
                );
              },
            )
          ])));
    }
    return Container(
      margin: EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0), //容器外填充
      child: Column(
        children: <Widget>[
          Center(
              child: Container(
            width: 240,
            child: Row(
              children: <Widget>[
                RaisedButton(
                  child: Text('选择开始时间'),
                  onPressed: () async {
                    var result = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030));
                    print('$result');
                    if (result != null) {
                      setState(() {
                        startTime = result.toString().split(' ')[0];
                      });
                    }
                  },
                ),
                Text(' '),
                RaisedButton(
                  child: Text('选择结束时间'),
                  onPressed: () async {
                    var result = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030));
                    print('$result');
                    if (result != null) {
                      setState(() {
                        endTime = result.toString().split(' ')[0];
                      });
                    }
                  },
                ),
              ],
            ),
          )),
          Text('当前显示 $startTime 至 $endTime 期间的数据'),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: dataListWidget,
            ),
          ),
        ],
      ),
    );
  }
}
