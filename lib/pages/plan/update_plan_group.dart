import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../model.dart';
import 'package:provider/provider.dart';

class UpdatePlanGroupPage extends StatefulWidget {
  UpdatePlanGroupPage(
      {Key key, this.type = 'create', this.planGroupInfo, this.index})
      : super(key: key);
  String type;
  int index;
  final planGroupInfo;
  @override
  _UpdatePlanGroupPageState createState() => _UpdatePlanGroupPageState();
}

class _UpdatePlanGroupPageState extends State<UpdatePlanGroupPage> {
  String dropdownValue = '';
  final _planGroupNameController = TextEditingController();
  var planGroupDetailsList = [];
  List<Map<String, dynamic>> planList;

  getPlanList() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userInfoString = prefs.getString('userInfo');
      if (userInfoString == '') return;
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
    } catch (e) {
      print(e);
    }
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
      String type = widget.type;
      int index = widget.index;
      var planGroupInfo = widget.planGroupInfo;
      var response;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userInfoString = prefs.getString('userInfo');
      if (userInfoString == '') return;
      Map<String, dynamic> userInfo = jsonDecode(userInfoString);
      if (type == 'create') {
        response = await http.post("${SURL.addPlanGroup}", body: {
          'userID': userInfo['UserID'],
          'planName': _planGroupNameController.text,
          'planDetails': jsonEncode(planGroupDetailsList),
        });
      } else if (type == 'edit') {
        response = await http.post("${SURL.updatePlanGroup}", body: {
          'planID': planGroupInfo['PlanID'],
          'planName': _planGroupNameController.text,
          'planDetails': jsonEncode(planGroupDetailsList),
        });
      }

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['status'] == 0) {
          if (type == 'create') {
            context.read<PlanModel>().insertPlan(0, body['data']);
          } else if (type == 'edit') {
            context
                .read<PlanModel>()
                .replacePlan(index, index + 1, [body['data']]);
          }
          Navigator.pop(
            context,
          );
        } else {}
      } else {}
    } catch (e) {
      print(e);
    }
  }

  deletePlan() async {
    try {
      int index = widget.index;
      var planInfo = widget.planGroupInfo;
      var response = await http.post("${SURL.deletePlan}", body: {
        'planID': planInfo['PlanID'],
      });
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['status'] == 0) {
          context.read<PlanModel>().deletePlan(index, index + 1);
          Navigator.pop(
            context,
          );
        } else {}
      } else {}
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
      _planGroupNameController.text = planGroupInfo['PlanGroupName'];
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
              Expanded(
                  child: Container(
                      width: 210, child: Text(plan['PlanName'].toString()))),
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
                            controller: _planGroupNameController,
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
