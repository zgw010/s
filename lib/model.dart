import 'dart:convert';

import 'package:flutter/material.dart';

// import 'package:flutter/foundation.dart';
// class Counter with ChangeNotifier, DiagnosticableTreeMixin {
class UserIDModel with ChangeNotifier {
  String _localUserID = '';
  String get localUserID => _localUserID;

  void updateLocalUserID(newLocalUserID) {
    _localUserID = newLocalUserID;
    notifyListeners();
  }
}

class SURL {
  static String host = 'http://47.100.43.162:8080';
  static String login = '$host/login';
  static String register = '$host/register';
  static String edit = '$host/edit';
  static String getCurPlan = '$host/plan/get_cur_plan';
  static String getActionList = '$host/action/get_action_list';
  static String addUserAction = '$host/action/add_user_action';
  static String updateUserAction = '$host/action/update_user_action';

  static String getPlanList = '$host/plan/get_plan_list';
  static String addPlan = '$host/plan/add_plan';
  static String updatePlan = '$host/plan/update_plan';
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
    Map<String, dynamic> newUserInfo = jsonDecode(newUserInfoString);
    print(newUserInfo);
    _userInfo = newUserInfo;
    notifyListeners();
  }
}

class PlanModel with ChangeNotifier {
  var _curPlan = {};
  Map<String, dynamic> get curPlan => _curPlan;

  void updateCurplan(newCurplan) {
    var newPlan = jsonDecode(newCurplan);
    print(newPlan);
    _curPlan = newPlan;
    notifyListeners();
  }
}

class ActionModel with ChangeNotifier {
  List<Map<String, dynamic>> _actionList;
  List<Map<String, dynamic>> get actionList => _actionList;

  void updateActionList(newActionList) {
    _actionList = jsonDecode(newActionList);
    notifyListeners();
  }
}
