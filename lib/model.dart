import 'dart:convert';

import 'package:flutter/material.dart';

class SURL {
  static String host = 'https://www.iyyq.top/api/s';
  static String login = '$host/login';
  static String register = '$host/register';
  static String edit = '$host/edit';
  static String getCurPlan = '$host/plan/get_cur_plan';

  // action
  static String getActionList = '$host/action/get_action_list';
  static String addUserAction = '$host/action/add_user_action';
  static String updateUserAction = '$host/action/update_user_action';
  static String deleteUserAction = '$host/action/delete_user_action';

  // plan
  static String getPlanList = '$host/plan/get_plan_list';
  static String addPlan = '$host/plan/add_plan';
  static String updatePlan = '$host/plan/update_plan';

  // planGroup
  static String getPlanGroupList = '$host/plan/get_plan_group_list';
  static String addPlanGroup = '$host/plan/add_plan_group';
  static String updatePlanGroup = '$host/plan/update_plan_group';

  // data
  static String getData = '$host/data/get_data';
  static String getDataList = '$host/data/get_data_list';
  static String addData = '$host/data/add_data';

  static String getRunData = '$host/data/get_run_data';
  static String getRunDataList = '$host/data/get_run_data_list';
  static String addRunData = '$host/data/add_run_data';
}

class UserInfoModel with ChangeNotifier {
  Map<String, dynamic> _userInfo = {
    'UserID': '',
    'UserName': '',
    'UserPassword': '',
    'UserAvatarURL': '',
    'UserDetails': '',
    'UserDateOfBirth': '',
    'UserHeight': '',
    'UserWeight': '',
    'UserSex': '',
    'UserAims': '',
  };
  Map<String, dynamic> get userInfo => _userInfo;

  void updateUserInfo(newUserInfoString) {
    // if (newUserInfoString != '' && newUserInfoString != '{}') {
    Map<String, dynamic> newUserInfo = jsonDecode(newUserInfoString);
    // print(newUserInfo);
    _userInfo = newUserInfo;
    notifyListeners();
    // }
  }
}

class ActionModel with ChangeNotifier {
  List<dynamic> _actionList = [];
  List<dynamic> get actionList => _actionList;

  void updateActionList(list) {
    _actionList = list;
    notifyListeners();
  }

  void insertActionList(index, item) {
    _actionList.insert(index, item);
    notifyListeners();
  }

  void replaceActionList(start, end, item) {
    _actionList.replaceRange(start, end, item);
    notifyListeners();
  }

  void deleteActionList(start, end) {
    _actionList.removeRange(start, end);
    notifyListeners();
  }
}

class PlanModel with ChangeNotifier {
  Map<String, dynamic> _curPlan = {};
  Map<String, dynamic> _curPlanGroup = {};
  List<Map<String, dynamic>> _planList = [];
  Map<String, dynamic> get curPlan => _curPlan;
  Map<String, dynamic> get curPlanGroup => _curPlanGroup;
  List<Map<String, dynamic>> get planList => _planList;

  void updateCurplan(plan) {
    var newPlan = jsonDecode(plan);
    _curPlan = newPlan;
    notifyListeners();
  }

  void updateCurplanGroup(planGroup) {
    var newPlanGroup = jsonDecode(planGroup);
    _curPlanGroup = newPlanGroup;
    notifyListeners();
  }

  void updatePlanList(list) {
    var newPlanList = jsonDecode(list);
    _planList = newPlanList;
    notifyListeners();
  }

  void addPlanList(item) {
    // var newPlanList = jsonDecode(item);
    _planList.add(item);
    notifyListeners();
  }
}
