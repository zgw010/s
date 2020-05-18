import 'package:flutter/material.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;

class RunData extends StatefulWidget {
  RunData({Key key}) : super(key: key);

  @override
  _RunDataState createState() => _RunDataState();
}

class _RunDataState extends State<RunData> {
  var _list = <Widget>[];

  var startTime = '2020-4-1', endTime = '2020-5-1';
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0), //容器外填充
      child: Column(
        children: <Widget>[
          // Center(
          //   child: Text('fdsfs'),
          // ),
          Text('当前显示 $startTime 跑步数据'),
          Image(
              image: NetworkImage('https://s1.ax1x.com/2020/05/14/Y0uHtU.jpg')),
          Container(
            margin: EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0), //容器外填充
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
                  '2020-05-14 09:19:00',
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
            margin: EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0), //容器外填充
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
                  '0.49分钟',
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
            margin: EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0), //容器外填充
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
                  '47米',
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
            margin: EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0), //容器外填充
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
                  '4.41米/秒',
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
            margin: EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0), //容器外填充
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
                  '1.57米/秒',
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
            margin: EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0), //容器外填充
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
                  '3.90kcal',
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
    );
  }
}
