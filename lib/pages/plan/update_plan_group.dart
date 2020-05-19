import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../model.dart';
import 'package:provider/provider.dart';

class UpdatePlanGroupPage extends StatefulWidget {
  UpdatePlanGroupPage({Key key, this.type = 'create', this.planGroupInfo})
      : super(key: key);
  final type;
  final planGroupInfo;
  @override
  _UpdatePlanGroupPageState createState() => _UpdatePlanGroupPageState();
}

class _UpdatePlanGroupPageState extends State<UpdatePlanGroupPage> {
  String dropdownValue = '';
  final _planNameController = TextEditingController();
  var planGroupDetailsList = [];
  List<Map<String, dynamic>> planList;

  getPlanList() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userInfoString = prefs.getString('userInfo');
      Map<String, dynamic> userInfo = jsonDecode(userInfoString);
      var response = await http.get(
        "${SURL.getPlanList}?userID=${userInfo['UserID'] ?? ''}",
      );
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['status'] == 0) {
          var data = body['data'];
          var newPlanList = <Map<String, dynamic>>[];
          for (var i = 0; i < data.length; i++) {
            newPlanList.add({
              'PlanID': data[i]['PlanID'],
              'PlanName': data[i]['PlanName'],
            });
          }
          setState(() {
            dropdownValue = '${data[0]['PlanID']}|${data[0]['PlanName']}';
            planList = newPlanList;
          });
        }
      }
    } catch (e) {}
  }

  addPlan() {
    List<String> dropdownValueArr = dropdownValue.split('|');
    setState(() {
      planGroupDetailsList.add({
        'PlanID': dropdownValueArr[0],
        'PlanName': dropdownValueArr[1],
      });
    });
  }

  updatePlan() async {
    try {
      var response;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userInfoString = prefs.getString('userInfo');
      Map<String, dynamic> userInfo = jsonDecode(userInfoString);
      if (this.widget.type == 'create') {
        response = await http.post("${SURL.addPlanGroup}", body: {
          'userID': userInfo['UserID'],
          'planGroupName': _planNameController.text,
          'planGroupDetails': jsonEncode(planGroupDetailsList),
        });
      } else if (this.widget.type == 'edit') {
        response = await http.post("${SURL.updatePlanGroup}", body: {
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
    getPlanList();
    if (widget.type == 'edit') {
      var planGroupInfo = widget.planGroupInfo;
      _planNameController.text = planGroupInfo['PlanGroupName'];
      // print(planGroupInfo);
      // print(planGroupInfo['PlanGroupDetails']);
      // print(planGroupInfo.runtimeType.toString());
      planGroupDetailsList = jsonDecode(planGroupInfo['PlanGroupDetails']);
    }
  }

  @override
  Widget build(BuildContext context) {
    var planGroupDetails = <Widget>[];
    for (int i = 0; i < planGroupDetailsList.length; i++) {
      Map<String, dynamic> plan = planGroupDetailsList[i];
      planGroupDetails.add(Container(
          height: 50,
          child: Center(
            child: Row(children: <Widget>[
              Container(width: 210, child: Text(plan['PlanName'].toString())),
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
                      planGroupDetailsList.removeAt(i);
                    });
                  }),
            ]),
          )));
    }
    var showAddPlanDetailDialog = () => showDialog(
        context: context,
        builder: (_) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
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
                    addPlan();
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
                              child: Text('选择计划')),
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
                              setState(() {
                                dropdownValue = newValue;
                              });
                            },
                            items: planList.map<DropdownMenuItem<String>>(
                                (Map<String, dynamic> value) {
                              return DropdownMenuItem<String>(
                                value:
                                    '${value['PlanID']}|${value['PlanName']}',
                                child: Text(value['PlanName']),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        });
    return Scaffold(
      appBar: AppBar(
          title: Text('${this.widget.type == 'create' ? '新建计划组' : '编辑计划组'}')),
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
                            '计划组名称：',
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
                            '计划组内容：',
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
                          child: Text('增加一个计划'),
                          onPressed: () {
                            showAddPlanDetailDialog();
                          },
                        ),
                      ],
                    ),
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.all(8),
                        children: planGroupDetails,
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
