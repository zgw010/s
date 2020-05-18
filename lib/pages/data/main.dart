import 'package:flutter/material.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;

class Data extends StatefulWidget {
  Data({Key key}) : super(key: key);

  @override
  _DataState createState() => _DataState();
}

class _DataState extends State<Data> {
  var _list = <Widget>[];

  var startTime = '2020-4-1', endTime = '2020-5-1';
  @override
  Widget build(BuildContext context) {
    for (var i = 1; i < 30; i++) {
      _list.add(Container(
          margin: EdgeInsets.only(top: 5.0), //容器外填充
          // border
          child: Row(children: [
            Container(
              width: 200,
              child: Text('2020-4-$i 计划${i % 3 + 1}'),
            ),
            FlatButton(
              textColor: Colors.blueAccent[400],
              child: Text(
                '查看详细数据',
                style: TextStyle(
                  color: Colors.blueAccent[400],
                  fontSize: 12.0,
                  // fontWeight: FontWeight.w400,
                  // decoration: TextDecoration.none,
                ),
              ),
            )
          ])));
    }
    return Container(
      margin: EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0), //容器外填充
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
                        lastDate: DateTime(2021));
                    print('$result');
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
                        lastDate: DateTime(2021));
                    print('$result');
                  },
                ),
              ],
            ),
          )),
          Text('当前显示 $startTime 至 $endTime 期间的数据'),
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
