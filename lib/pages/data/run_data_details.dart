import 'package:flutter/material.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../model.dart';

// import 'package:flutter/foundation.dart';
class RunDataDetailsPage extends StatefulWidget {
  RunDataDetailsPage({Key key, this.data}) : super(key: key);
  final data;
  @override
  _RunDataDetailsPageState createState() => _RunDataDetailsPageState();
}

class _RunDataDetailsPageState extends State<RunDataDetailsPage> {
  @override
  Widget build(BuildContext context) {
    var data = widget.data;
    DateTime startTime = DateTime.parse(data['StartTime']);
    DateTime endTime = DateTime.parse(data['EndTime']);
    Duration difference = endTime.difference(startTime);
    return Scaffold(
        appBar: AppBar(title: Text("跑步数据详情")),
        body: Container(
          margin: EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0), //容器外填充
          child: ListView(
            children: <Widget>[
              // Image(
              //     image: NetworkImage(
              //         'https://s1.ax1x.com/2020/05/14/Y0uHtU.jpg')),
              Container(
                margin:
                    EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0), //容器外填充
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 80,
                      child: Text(
                        '开始时间：',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                    Text(
                      data['StartTime'],
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin:
                    EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0), //容器外填充
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 80,
                      child: Text(
                        '持续时间：',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                    Text(
                      '${difference.inSeconds} 分钟',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin:
                    EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0), //容器外填充
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 80,
                      child: Text(
                        '运动距离：',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                    Text(
                      '${int.parse(data['Distance']) / 1000} 千米',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin:
                    EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0), //容器外填充
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 80,
                      child: Text(
                        '最快速度：',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                    Text(
                      '${data['MaxSpeed']} 米/秒',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin:
                    EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0), //容器外填充
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 80,
                      child: Text(
                        '平均速度：',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                    Text(
                      '${data['AverageSpeed']} 米/秒',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin:
                    EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0), //容器外填充
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 80,
                      child: Text(
                        '消耗热量：',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                    Text(
                      '${data['Calories']} kcal',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
