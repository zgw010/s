import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import './pages/plan/main.dart';
import './pages/plan/action_list.dart';
import './pages/plan/action_details.dart';
import './pages/plan/update_action.dart';
import './pages/plan/plan_list.dart';
import './pages/plan/update_plan.dart';
import './pages/plan/plan_group_list.dart';
import './pages/plan/update_plan_group.dart';
import './pages/data/main.dart';
import './pages/data/run_data.dart';
import './pages/data/data_details.dart';
import './pages/user/main.dart';
import './pages/user/login.dart';
import './model.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  // final userID = UserIDModel();
  runApp(MultiProvider(
    providers: [
      // Provider.value(value: counter),
      ChangeNotifierProvider(create: (_) => UserInfoModel()),
      ChangeNotifierProvider(create: (_) => ActionModel()),
      ChangeNotifierProvider(create: (_) => PlanModel()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  _getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userInfo = prefs.getString('userInfo');
    // prefs.setString('userInfo','');
    // print(userInfo);
    if (userInfo == '' || userInfo == null) {
      Navigator.push(
        context,
        new MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } else {
      context.read<UserInfoModel>().updateUserInfo(userInfo);
    }
  }

  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _getUserInfo();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var planDetails =
        '[\n  {\n    \"actionID\": \"1\",\n    \"actionName\": \"深蹲\",\n    \"actionType\": \"base\",\n    \"actionGroupsNum\": 6,\n    \"actionTimes\": 10,\n    \"actionTime\": 10,\n    \"actionDistance\": 10.00,\n    \"actionDetails\": \"\",\n    \"actionImgURL\": \"\",\n    \"actionVideoURL\": \"\",\n    \"actionMoreURL\": \"\",\n    \"actionCompleted\": false\n  },\n  {\n    \"actionID\": \"2\",\n    \"actionName\": \"硬拉\",\n    \"actionType\": \"base\",\n    \"actionGroupsNum\": 6,\n    \"actionTimes\": 10,\n    \"actionDetails\": \"\",\n    \"actionImgURL\": \"\",\n    \"actionVideoURL\": \"\",\n    \"actionMoreURL\": \"\",\n    \"actionCompleted\": false\n  },\n  {\n    \"actionID\": \"3\",\n    \"actionName\": \"卧推\",\n    \"actionType\": \"base\",\n    \"actionGroupsNum\": 6,\n    \"actionTimes\": 10,\n    \"actionDetails\": \"\",\n    \"actionImgURL\": \"\",\n    \"actionVideoURL\": \"\",\n    \"actionMoreURL\": \"\",\n    \"actionCompleted\": false\n  }\n]';
    var list = jsonDecode(planDetails);
    var selectMap = {};
    for (int i = 0; i < list.length; i++) {
      selectMap[list[i]['actionID']] = list[i]['actionCompleted'];
    }
    return Scaffold(
      appBar: AppBar(title: Text("S")),
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: <Widget>[
            Container(
              child: Plan(),
              // child: Plan(selectMap: selectMap),
            ),
            Container(
              child: DataPage(),
            ),
            Container(
              child: UserInfoPage(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          _pageController.jumpToPage(index);
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(title: Text('plan'), icon: Icon(Icons.view_day)),
          BottomNavyBarItem(title: Text('data'), icon: Icon(Icons.date_range)),
          BottomNavyBarItem(title: Text('user'), icon: Icon(Icons.settings)),
        ],
      ),
    );
  }
}
