import 'package:flutter/material.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../model.dart';

// import 'package:flutter/foundation.dart';
class DataDetailsPage extends StatefulWidget {
  DataDetailsPage({Key key}) : super(key: key);

  @override
  _DataDetailsPageState createState() => _DataDetailsPageState();
}

class _DataDetailsPageState extends State<DataDetailsPage> {
  var dataList = [];
  getData() async {
    try {
      var response;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userInfoString = prefs.getString('userInfo');
      Map<String, dynamic> userInfo = jsonDecode(userInfoString);
      response = await http.get(
        "${SURL.getData}?userID=${userInfo['UserID'] ?? ''}",
      );
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        print(jsonDecode(body['data']['DataDetails']));
        setState(() {
          dataList = jsonDecode(body['data']['DataDetails']);
        });
      }
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
    for (int i = 0; i < dataList.length; i++) {
      if (dataList[i]['ActionType'] == 'times') {
        dataListWidget.add(new Container(
            height: 50,
            child: Center(
              child: Row(children: <Widget>[
                Expanded(
                    child: Text(dataList[i]['ActionName'].toString() +
                        ' ' +
                        dataList[i]['ActionGroupsNum'].toString() +
                        'x' +
                        dataList[i]['ActionTimes'].toString())),
              ]),
            )));
      } else if (dataList[i]['ActionType'] == 'time') {
        dataListWidget.add(Container(
            height: 50,
            child: Center(
              child: Row(children: <Widget>[
                Container(
                    width: 200,
                    child: Text(dataList[i]['ActionName'].toString() +
                        ' ' +
                        dataList[i]['ActionTimes'].toString() +
                        '分钟 ' +
                        dataList[i]['ActionDistance'].toString() +
                        '米')),
                // dataList[i]['ActionID'] == '4'
                //     ? FlatButton(
                //         // textColor: Colors.red,
                //         child: Text(
                //           '查看详情',
                //           style: TextStyle(
                //             color: Colors.blueAccent[400],
                //             fontSize: 12.0,
                //             // fontWeight: FontWeight.w400,
                //             // decoration: TextDecoration.none,
                //           ),
                //         ),
                //         // onPressed: () {},
                //       )
                //     : SizedBox()
              ]),
            )));
      } else if (dataList[i]['ActionType'] == 'onlytime') {
        dataListWidget.add(new Container(
            height: 50,
            child: Center(
              child: Row(children: <Widget>[
                Expanded(
                    child: Text(dataList[i]['ActionName'].toString() +
                        ' ' +
                        dataList[i]['ActionTimes'].toString() +
                        ' 分钟')),
              ]),
            )));
      }
    }
    return Scaffold(
        appBar: AppBar(title: Text("完成的计划详情")),
        body: Container(
          margin: EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0), //容器外填充
          child: Column(
            children: [
              // Text(' 完成的计划详情'),
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
