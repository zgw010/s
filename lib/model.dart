import 'dart:convert';

import 'package:flutter/material.dart';

class SURL {
  static String host = 'https://www.iyyq.top/api/s';

  // user
  static String login = '$host/login';
  static String register = '$host/register';
  static String edit = '$host/edit';
  static String getCurPlan = '$host/plan/get_cur_plan';
  static String updatePlanGroupID = '$host/user/update_plan_group_id';

  // action
  static String getActionList = '$host/action/get_action_list';
  static String addUserAction = '$host/action/add_user_action';
  static String updateUserAction = '$host/action/update_user_action';
  static String deleteUserAction = '$host/action/delete_user_action';

  // plan
  static String getPlanList = '$host/plan/get_plan_list';
  static String addPlan = '$host/plan/add_plan';
  static String updatePlan = '$host/plan/update_plan';
  static String deletePlan = '$host/plan/delete_plan';

  // planGroup
  static String getPlanGroupList = '$host/plan/get_plan_group_list';
  static String addPlanGroup = '$host/plan/add_plan_group';
  static String updatePlanGroup = '$host/plan/update_plan_group';
  static String deletePlanGroup = '$host/plan/delete_plan_group';

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

  void updateUserInfo(newUserInfo) {
    _userInfo = newUserInfo;
    notifyListeners();
  }
}

class ActionModel with ChangeNotifier {
  List<dynamic> _actionList = [];
  List<dynamic> get actionList => _actionList;

  void updateActionList(list) {
    _actionList = list;
    notifyListeners();
  }

  void insertAction(index, item) {
    _actionList.insert(index, item);
    notifyListeners();
  }

  void replaceAction(start, end, item) {
    _actionList.replaceRange(start, end, item);
    notifyListeners();
  }

  void deleteAction(start, end) {
    _actionList.removeRange(start, end);
    notifyListeners();
  }
}

class PlanModel with ChangeNotifier {
  int _planState = 1;
  Map _curPlan = {};
  Map _curPlanGroup = {};
  int get planState => _planState;
  Map get curPlan => _curPlan;
  Map get curPlanGroup => _curPlanGroup;

  List<dynamic> _curPlanDetails = [];
  List<dynamic> get curPlanDetails => _curPlanDetails;

  List<dynamic> _planList = [];
  List<dynamic> get planList => _planList;

  List<dynamic> _planGroupList = [];
  List<dynamic> get planGroupList => _planGroupList;

  void updatePlanState(state) {
    _planState = state;
    notifyListeners();
  }

  void updateCurPlan(data) {
    _curPlan = data;
    notifyListeners();
  }

  void updateCurPlanGroup(data) {
    _curPlanGroup = data;
    notifyListeners();
  }

  void updateCurPlanDetails(list) {
    _curPlanDetails = list;
    notifyListeners();
  }

  void updatePlanList(list) {
    _planList = list;
    notifyListeners();
  }

  void insertPlan(index, item) {
    _planList.insert(index, item);
    notifyListeners();
  }

  void replacePlan(start, end, item) {
    _planList.replaceRange(start, end, item);
    notifyListeners();
  }

  void deletePlan(start, end) {
    _planList.removeRange(start, end);
    notifyListeners();
  }

  void updatePlanGroupList(list) {
    _planGroupList = list;
    notifyListeners();
  }

  void insertPlanGroup(index, item) {
    _planGroupList.insert(index, item);
    notifyListeners();
  }

  void replacePlanGroup(start, end, item) {
    _planGroupList.replaceRange(start, end, item);
    notifyListeners();
  }

  void deletePlanGroup(start, end) {
    _planGroupList.removeRange(start, end);
    notifyListeners();
  }
}
