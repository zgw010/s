import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../model.dart';
import 'data_details.dart';
import 'run_data_details.dart';

class RunDataPage extends StatefulWidget {
  RunDataPage({Key key}) : super(key: key);

  @override
  _RunDataPageState createState() => _RunDataPageState();
}

class _RunDataPageState extends State<RunDataPage> {
  List<dynamic> dataList = [];
  TextEditingController _startTimeController = TextEditingController(
      text: new DateFormat('yyyy-MM-dd').format(new DateTime.now()));
  TextEditingController _endTimeController = TextEditingController(
      text: new DateFormat('yyyy-MM-dd').format(new DateTime.now()));

  getRunData(startTime, endTime) async {
    try {
      var response;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userInfoString = prefs.getString('userInfo');
      Map<String, dynamic> userInfo = jsonDecode(userInfoString);
      response = await http.get(
          "${SURL.getRunDataList}?userID=${userInfo['UserID']}&startTime=$startTime&endTime=$endTime");
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

    getRunData(_startTimeController.text, _endTimeController.text);
  }

  @override
  Widget build(BuildContext context) {
    var dataListWidget = <Widget>[];
    print(dataList);
    for (var i = 0; i < dataList.length; i++) {
      var data = dataList[i];

      var startTime = DateTime.parse(data['StartTime']);
      var endTime = DateTime.parse(data['EndTime']);
      var difference = endTime.difference(startTime);
      dataListWidget.add(Container(
          margin: EdgeInsets.only(top: 5.0), //容器外填充
          // border
          child: Row(children: [
            Expanded(
                child: Container(
              width: 200,
              child: Text(
                  '${difference.inSeconds} min ${int.parse(data['Distance']) / 1000} km'),
            )),
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
                      builder: (context) => RunDataDetailsPage(data: data)),
                );
              },
            )
          ])));
    }
    return Scaffold(
        appBar: AppBar(title: Text("跑步数据")),
        body: Container(
          margin: EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0), //容器外填充
          child: Column(
            children: <Widget>[
              Center(
                  child: Container(
                width: 240,
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: TextField(
                      readOnly: true,
                      controller: _startTimeController,
                      onTap: () async {
                        var result = await showDatePicker(
                            context: context,
                            initialDate:
                                DateTime.parse(_startTimeController.text),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2030));
                        print('$result');
                        if (result != null) {
                          setState(() {
                            _startTimeController.text =
                                result.toString().split(' ')[0];
                          });
                          getRunData(result.toString().split(' ')[0],
                              _endTimeController.text);
                        }
                      },
                      decoration: InputDecoration(
                        labelText: '开始时间',
                        border: InputBorder.none,
                        filled: true,
                      ),
                    )),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: TextField(
                      readOnly: true,
                      controller: _endTimeController,
                      decoration: InputDecoration(
                        labelText: '结束时间',
                        border: InputBorder.none,
                        filled: true,
                      ),
                      onTap: () async {
                        var result = await showDatePicker(
                            context: context,
                            initialDate:
                                DateTime.parse(_endTimeController.text),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2030));
                        print('$result');
                        if (result != null) {
                          getRunData(_startTimeController.text,
                              result.toString().split(' ')[0]);
                          setState(() {
                            _endTimeController.text =
                                result.toString().split(' ')[0];
                          });
                        }
                      },
                    )),
                  ],
                ),
              )),
              // Text('当前显示 $startTime 至 $endTime 期间的数据'),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(8),
                  children: dataListWidget,
                ),
              ),
            ],
          ),
        ));
  }
}
