import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../model.dart';
import 'package:provider/provider.dart';

class UpdatePlanPage extends StatefulWidget {
  UpdatePlanPage({Key key, this.type = 'create', this.planInfo})
      : super(key: key);
  final type;
  final planInfo;
  @override
  _UpdatePlanPageState createState() => _UpdatePlanPageState();
}

class _UpdatePlanPageState extends State<UpdatePlanPage> {
  String dropdownValue = '1|base-times';
  final _planNameController = TextEditingController();
  final _actionTimesController = TextEditingController();
  final _actionGroupNumController = TextEditingController();
  final _actionTimeController = TextEditingController();
  final _actionDistanceController = TextEditingController();
  var planDetailsList = [];
  String actionType = '';
  List<Map<String, dynamic>> actionList;

  getActionList() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userInfoString = prefs.getString('userInfo');
      Map<String, dynamic> userInfo = jsonDecode(userInfoString);
      var response = await http.get(
        "${SURL.getActionList}?userID=${userInfo['UserID'] ?? ''}&actionType=all",
      );
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['status'] == 0) {
          var data = body['data'];
          var newActionList = <Map<String, dynamic>>[];
          for (var i = 0; i < data.length; i++) {
            newActionList.add({
              'ActionID': data[i]['ActionID'],
              'ActionName': data[i]['ActionName'],
              'ActionType': data[i]['ActionType'],
            });
          }
          setState(() {
            dropdownValue =
                '${data[0]['ActionID']}|${data[0]['ActionType']}|${data[0]['ActionName']}';
            // actionList = data;newActionList
            actionList = newActionList;
            actionType = '${data[0]['ActionType'].split('-')[1]}';
          });
        }
      }
    } catch (e) {}
  }

  addAction() {
    List<String> dropdownValueArr = dropdownValue.split('|');
    setState(() {
      planDetailsList.add({
        'ActionID': dropdownValueArr[0],
        'ActionName': dropdownValueArr[2],
        'ActionType': actionType,
        'ActionTimes': _actionTimesController.text ?? '',
        'ActionGroupsNum': _actionGroupNumController.text ?? '',
        'ActionTime': _actionTimeController.text ?? '',
        'ActionDistance': _actionDistanceController.text ?? '',
        'ActionCompleted': false,
      });
      // dropdownValue = '';
      _actionTimesController.text = '';
      _actionGroupNumController.text = '';
      _actionTimeController.text = '';
      _actionDistanceController.text = '';
      // actionType = '';
    });
  }

  updatePlan() async {
    try {
      var response;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userInfoString = prefs.getString('userInfo');
      Map<String, dynamic> userInfo = jsonDecode(userInfoString);
      if (this.widget.type == 'create') {
        response = await http.post("${SURL.addPlan}", body: {
          'userID': userInfo['UserID'],
          'planName': _planNameController.text,
          'planDetails': jsonEncode(planDetailsList),
        });
      } else if (this.widget.type == 'edit') {
        response = await http.post("${SURL.updatePlan}", body: {
          'userID': userInfo['UserID'],
          // 'planID': userInfo['UserID'],
        });
      }

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['status'] == 0) {
          Navigator.pop(
            context,
          );
        } else {}
      } else {
        // Scaffold.of(ctx).showSnackBar(SnackBar(
        //     content: Text('网络错误'),
        //     action: SnackBarAction(
        //       label: '知道了',
        //       onPressed: () {
        //         Scaffold.of(ctx).removeCurrentSnackBar();
        //       },
        //     )));
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getActionList();
    if (widget.type == 'edit') {
      var planInfo = widget.planInfo;
      _planNameController.text = planInfo['PlanName'];
      print(jsonDecode(planInfo['PlanDetails']));
      planDetailsList = jsonDecode(planInfo['PlanDetails']);
    }
  }

  @override
  Widget build(BuildContext context) {
    var planDetails = <Widget>[];
    for (int i = 0; i < planDetailsList.length; i++) {
      Map<String, dynamic> actionDetails = planDetailsList[i];
      if (actionDetails['ActionType'] == 'times') {
        planDetails.add(Container(
            height: 50,
            child: Center(
              child: Row(children: <Widget>[
                Container(
                    width: 210,
                    child: Text(planDetailsList[i]['ActionName'].toString() +
                        ' ' +
                        planDetailsList[i]['ActionGroupsNum'].toString() +
                        'x' +
                        planDetailsList[i]['ActionTimes'].toString())),
                FlatButton(
                    // textColor: Colors.red,
                    child: Text(
                      '删除',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12.0,
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        planDetailsList.removeAt(i);
                      });
                    }),
              ]),
            )));
      } else if (actionDetails['ActionType'] == 'onlytime') {
        planDetails.add(Container(
            height: 50,
            child: Center(
              child: Row(children: <Widget>[
                Container(
                    width: 210,
                    child: Text(planDetailsList[i]['ActionName'].toString() +
                        ' ' +
                        planDetailsList[i]['ActionTime'].toString() +
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
                  onPressed: () {
                    setState(() {
                      planDetailsList.removeAt(i);
                    });
                  },
                ),
              ]),
            )));
      } else if (actionDetails['ActionType'] == 'time') {
        planDetails.add(Container(
            height: 50,
            child: Center(
              child: Row(children: <Widget>[
                Container(
                    width: 210,
                    child: Text(planDetailsList[i]['ActionName'].toString() +
                        ' ' +
                        planDetailsList[i]['ActionDistance'].toString() +
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
                  onPressed: () {
                    setState(() {
                      planDetailsList.removeAt(i);
                    });
                  },
                ),
              ]),
            )));
      }
    }
    var showAddPlanDetailDialog = () => showDialog(
        // 传入 context
        context: context,
        // 构建 Dialog 的视图
        builder: (_) {
          // var dropdownValueTmp = dropdownValue;
          // var actionTypeTmp = actionType;
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text('添加动作'),
              scrollable: true,
              actions: <Widget>[
                FlatButton(
                  textColor: Colors.red,
                  child: Text('取消'),
                  onPressed: () {
                    Navigator.pop(_);
                  },
                ),
                FlatButton(
                  child: Text('确认'),
                  onPressed: () {
                    addAction();
                    Navigator.pop(_);
                  },
                ),
              ],
              content: Container(
                // padding: EdgeInsets.all(16),
                // height: 200,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      color: Colors.white,
                      child: Row(
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.only(right: 30),
                              width: 100,
                              child: Text('选择动作')),
                          DropdownButton<String>(
                            value: dropdownValue,
                            // icon: Icon(Icons.arrow_downward),
                            // hint: Text('请选择'),
                            iconSize: 24,
                            elevation: 6,
                            style: TextStyle(color: Colors.black),
                            underline: Container(
                              height: 1,
                              color: Colors.black,
                            ),
                            onChanged: (String newValue) {
                              var newValueArr = newValue.split('|');
                              setState(() {
                                dropdownValue = newValue;
                                // dropdownValueTmp = newValue;
                                actionType = newValueArr[1].split('-')[1];
                                // actionTypeTmp = newValueArr[1];
                              });
                            },
                            items: actionList.map<DropdownMenuItem<String>>(
                                (Map<String, dynamic> value) {
                              return DropdownMenuItem<String>(
                                value:
                                    '${value['ActionID']}|${value['ActionType']}|${value['ActionName']}',
                                child: Text(value['ActionName']),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                    actionType == 'times'
                        ? Container(
                            margin: EdgeInsets.only(top: 20),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Container(
                                      width: 100,
                                      child: Text(
                                        '组数（组）：',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w400,
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: TextField(
                                        controller: _actionGroupNumController,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          filled: true,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  height: 5.0,
                                  child: Text(''),
                                ),
                                Row(
                                  children: <Widget>[
                                    Container(
                                      width: 100,
                                      child: Text(
                                        '次数（次）：',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w400,
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: TextField(
                                        controller: _actionTimesController,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          filled: true,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        : SizedBox(),
                    actionType == 'onlytime'
                        ? Container(
                            margin: EdgeInsets.only(top: 20),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: 100,
                                  child: Text(
                                    '时间（分钟）：',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w400,
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: _actionTimeController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      filled: true,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : SizedBox(),
                    actionType == 'time'
                        ? Container(
                            margin: EdgeInsets.only(top: 20),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Container(
                                      width: 100,
                                      child: Text(
                                        '时间（分钟）：',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w400,
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: TextField(
                                        controller: _actionTimeController,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          filled: true,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  height: 5.0,
                                  child: Text(''),
                                ),
                                Row(
                                  children: <Widget>[
                                    Container(
                                      width: 100,
                                      child: Text(
                                        '距离（米）：',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w400,
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: TextField(
                                        controller: _actionDistanceController,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          filled: true,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        : SizedBox(),
                  ],
                ),
              ),
            );
          });
        });
    return Scaffold(
      appBar: AppBar(
          title: Text('${this.widget.type == 'create' ? '新建计划' : '编辑计划'}')),
      body: Container(
          margin: EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0), //容器外填充
          child: Column(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          width: 100,
                          child: Text(
                            '计划名称：',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _planNameController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              filled: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          width: 100,
                          child: Text(
                            '计划内容：',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                        FlatButton(
                          textColor: Colors.blue,
                          child: Text('增加一个动作'),
                          onPressed: () {
                            showAddPlanDetailDialog();
                          },
                        ),
                      ],
                    ),
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.all(8),
                        children: planDetails,
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
                    onPressed: () {
                      updatePlan();
                    },
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
